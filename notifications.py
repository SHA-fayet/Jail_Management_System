# app/routes/notifications.py
from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify
from app import mysql
from .auth import login_required, admin_required
import MySQLdb.cursors
from datetime import datetime 

notifications_bp = Blueprint('notifications', __name__)

@notifications_bp.route('/notifications')
@login_required
def view_notifications():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT * FROM notifications ORDER BY created_at DESC")
    notifications = cur.fetchall()
    cur.close()
    return render_template('notifications.html', notifications=notifications)

@notifications_bp.route('/add_notification', methods=['POST'])
@admin_required
def add_notification():
    message = request.form['message']
    target = request.form.get('target_audience', 'staff')
    user_id = session.get('user_id')
    
    cur = mysql.connection.cursor()
    cur.execute(
        "INSERT INTO notifications (message, target_audience, user_id) VALUES (%s, %s, %s)",
        (message, target, user_id)
    )
    mysql.connection.commit()
    cur.close()
    
    flash('Notification created successfully!', 'success')
    return redirect(url_for('notifications.view_notifications'))

@notifications_bp.route('/delete_notification/<int:id>', methods=['POST'])
@admin_required
def delete_notification(id):
    try:
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM notifications WHERE id = %s", (id,))
        mysql.connection.commit()
        cur.close()
        return jsonify({'message': 'Notification deleted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ==============================================================================
# == API ROUTES FOR NOTIFICATION BELL AND PUBLIC HEADLINES =====================
# ==============================================================================

@notifications_bp.route('/api/notifications/unread')
@login_required
def get_unread_notifications():
    """ API endpoint to fetch unread STAFF notifications for the bell. """
    try:
        current_user_id = session.get('user_id')
        current_user_role = session.get('role')
        
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # ** FIX: Differentiate query based on user role **
        if current_user_role == 'admin':
            # Admin sees visit requests (user_id is NULL) and notifications from other users.
            sql_query = """
                SELECT n.* FROM notifications n
                LEFT JOIN notification_read_status rs ON n.id = rs.notification_id AND rs.user_id = %s
                WHERE n.target_audience = 'staff' 
                AND rs.id IS NULL 
                AND (n.user_id IS NULL OR n.user_id != %s)
                ORDER BY n.created_at DESC
            """
            cur.execute(sql_query, (current_user_id, current_user_id))
        else:
            # Jailer sees all staff notifications they haven't read.
            sql_query = """
                SELECT n.* FROM notifications n
                LEFT JOIN notification_read_status rs ON n.id = rs.notification_id AND rs.user_id = %s
                WHERE n.target_audience = 'staff' AND rs.id IS NULL
                ORDER BY n.created_at DESC
            """
            cur.execute(sql_query, (current_user_id,))

        unread_notifications = cur.fetchall()
        cur.close()

        for notification in unread_notifications:
            if isinstance(notification.get('created_at'), datetime):
                notification['created_at'] = notification['created_at'].isoformat()

        return jsonify(unread_notifications)
    except Exception as e:
        print(f"API NOTIFICATION ERROR: {e}")
        return jsonify({"error": "A database error occurred on the server."}), 500

@notifications_bp.route('/api/notifications/mark_read', methods=['POST'])
@login_required
def mark_notifications_as_read():
    """
    Marks notifications as read for the current user by inserting records
    into the new tracking table.
    """
    try:
        current_user_id = session.get('user_id')
        current_user_role = session.get('role')
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # First, get all unread notification IDs for this user based on their role
        if current_user_role == 'admin':
            sql_query = """
                SELECT n.id 
                FROM notifications n
                LEFT JOIN notification_read_status rs ON n.id = rs.notification_id AND rs.user_id = %s
                WHERE n.target_audience = 'staff' 
                AND rs.id IS NULL
                AND (n.user_id IS NULL OR n.user_id != %s)
            """
            cur.execute(sql_query, (current_user_id, current_user_id))
        else:
            sql_query = """
                SELECT n.id 
                FROM notifications n
                LEFT JOIN notification_read_status rs ON n.id = rs.notification_id AND rs.user_id = %s
                WHERE n.target_audience = 'staff' AND rs.id IS NULL
            """
            cur.execute(sql_query, (current_user_id,))
        
        unread_ids = [row['id'] for row in cur.fetchall()]

        if unread_ids:
            values_to_insert = [(current_user_id, notif_id) for notif_id in unread_ids]
            cur.executemany(
                "INSERT INTO notification_read_status (user_id, notification_id) VALUES (%s, %s)",
                values_to_insert
            )
            mysql.connection.commit()

        cur.close()
        return jsonify({'message': 'Notifications marked as read'}), 200
    except Exception as e:
        print(f"API MARK READ ERROR: {e}")
        return jsonify({'error': str(e)}), 500

@notifications_bp.route('/api/notifications/public')
def get_public_notifications():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT * FROM notifications WHERE target_audience = 'visitor' ORDER BY created_at DESC LIMIT 5")
    public_notifications = cur.fetchall()
    cur.close()

    for notification in public_notifications:
        if isinstance(notification.get('created_at'), datetime):
            notification['created_at'] = notification['created_at'].isoformat()
            
    return jsonify(public_notifications)
