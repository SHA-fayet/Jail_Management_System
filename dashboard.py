# app/routes/dashboard.py

from flask import Blueprint, render_template, session, redirect, url_for
from datetime import date
import MySQLdb.cursors

# Import the new Singleton database manager
from app.utils.db_manager import db_manager

dashboard_bp = Blueprint('dashboard', __name__)

def update_released_inmates():
    """
    This function updates the status of inmates whose release date has passed.
    It now uses the connection pool for efficiency.
    """
    conn = None
    try:
        conn = db_manager.get_connection()
        cur = conn.cursor()
        cur.execute("""
            UPDATE inmates 
            SET status = 'Released'
            WHERE status = 'Active' AND release_date < %s
        """, (date.today(),))
        conn.commit()
    except Exception as e:
        print(f"Error in update_released_inmates: {e}")
    finally:
        if conn and conn.is_connected():
            cur.close()
            conn.close()


@dashboard_bp.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('auth.login'))

    role = session.get('role')
    
    conn = None
    try:
        conn = db_manager.get_connection()
        cur = conn.cursor(dictionary=True) # Use the correct dictionary cursor

        update_released_inmates()

        # Common stats
        cur.execute("SELECT COUNT(*) AS count FROM inmates WHERE status = 'Active'")
        active_inmates = cur.fetchone()['count']

        cur.execute("SELECT COUNT(*) AS count FROM inmates WHERE status = 'Released'")
        released_inmates = cur.fetchone()['count']

        cur.execute("SELECT COUNT(*) AS count FROM visitors WHERE visit_date = CURDATE()")
        today_visitors = cur.fetchone()['count']

        cur.execute("""
            SELECT name, release_date 
            FROM inmates 
            WHERE release_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
            AND status = 'Active'
        """)
        upcoming_releases = cur.fetchall()
        
        today = date.today()
        for inmate in upcoming_releases:
            if inmate['release_date']:
                inmate['days_left'] = (inmate['release_date'] - today).days
            else:
                inmate['days_left'] = None

        # --- THIS IS THE CORRECTED LINE ---
        # Changed 'created_at' to 'alert_date' to match your table schema
        cur.execute("SELECT message FROM alerts ORDER BY alert_date DESC LIMIT 5")
        
        recent_alerts_tuples = cur.fetchall()
        recent_alerts = [item['message'] for item in recent_alerts_tuples]
        
        # Chart data logic
        cur.execute("""
            SELECT DATE_FORMAT(admission_date, '%%Y-%%m') AS month, COUNT(*) AS count
            FROM inmates
            WHERE admission_date >= CURDATE() - INTERVAL 12 MONTH
            GROUP BY month
            ORDER BY month ASC
        """)
        chart_data = cur.fetchall()

        chart_labels = [row['month'] for row in chart_data]
        chart_values = [row['count'] for row in chart_data]

    except Exception as e:
        print(f"Dashboard database error: {e}")
        active_inmates, released_inmates, today_visitors = 0, 0, 0
        upcoming_releases, recent_alerts, chart_labels, chart_values = [], [], [], []
    
    finally:
        if conn and conn.is_connected():
            cur.close()
            conn.close()

    return render_template(
        'dashboard.html',
        role=role,
        active_inmates=active_inmates,
        released_inmates=released_inmates,
        today_visitors=today_visitors,
        upcoming_releases=upcoming_releases,
        recent_alerts=recent_alerts,
        chart_labels=chart_labels,
        chart_values=chart_values
    )
