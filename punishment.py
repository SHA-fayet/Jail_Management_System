from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify
from datetime import datetime
from .auth import login_required

# --- MODIFICATION: Import the Singleton db_manager and remove unused imports ---
from app.utils.db_manager import db_manager

punishments_bp = Blueprint('punishments', __name__)

@punishments_bp.route('/punishments')
@login_required
def view_punishments():
    # --- MODIFICATION: Refactored to use the connection pool ---
    conn = None
    try:
        conn = db_manager.get_connection()
        cur = conn.cursor(dictionary=True) # Use dictionary=True for the new connector
        
        cur.execute("""
            SELECT p.id, p.punishment_detail, p.date_given, i.name AS inmate_name, i.id AS inmate_id
            FROM punishments p
            JOIN inmates i ON p.inmate_id = i.id
            ORDER BY p.date_given DESC
        """)
        punishments = cur.fetchall()

        cur.execute("SELECT id, name FROM inmates WHERE status = 'Active'")
        inmates = cur.fetchall()
        
    except Exception as e:
        punishments = []
        inmates = []
        flash(f"Error fetching punishment data: {e}", "danger")
    finally:
        if conn and conn.is_connected():
            cur.close()
            conn.close()

    return render_template('punishments.html', punishments=punishments, inmates=inmates)

@punishments_bp.route('/add_punishment', methods=['POST'])
@login_required
def add_punishment():
    # --- MODIFICATION: Refactored to use the connection pool ---
    conn = None
    try:
        inmate_id = request.form['inmate_id']
        details = request.form['punishment_detail']
        date_given = request.form.get('date_given') or datetime.now().strftime('%Y-%m-%d')

        conn = db_manager.get_connection()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO punishments (inmate_id, punishment_detail, date_given) 
            VALUES (%s, %s, %s)
        """, (inmate_id, details, date_given))
        conn.commit()
        
        return jsonify({"message": "Punishment added successfully"}), 201
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn and conn.is_connected():
            cur.close()
            conn.close()

@punishments_bp.route('/edit_punishment/<int:id>', methods=['POST'])
@login_required
def edit_punishment(id):
    # --- MODIFICATION: Refactored to use the connection pool ---
    conn = None
    try:
        inmate_id = request.form['inmate_id']
        details = request.form['punishment_detail']
        date_given = request.form['date_given']

        conn = db_manager.get_connection()
        cur = conn.cursor()
        cur.execute("""
            UPDATE punishments 
            SET inmate_id=%s, punishment_detail=%s, date_given=%s 
            WHERE id=%s
        """, (inmate_id, details, date_given, id))
        conn.commit()
        
        return jsonify({"message": "Punishment updated successfully"}), 200
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn and conn.is_connected():
            cur.close()
            conn.close()

@punishments_bp.route('/delete_punishment/<int:id>', methods=['POST'])
@login_required
def delete_punishment(id):
    # --- MODIFICATION: Refactored to use the connection pool ---
    conn = None
    try:
        conn = db_manager.get_connection()
        cur = conn.cursor()
        cur.execute("DELETE FROM punishments WHERE id=%s", (id,))
        conn.commit()
        
        return jsonify({"message": "Punishment deleted successfully"}), 200
    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if conn and conn.is_connected():
            cur.close()
            conn.close()


# == NEW FUNCTION FOR TASK 2 ANALYSIS


def analyze_inmate_risk(inmate_ids_to_check):
    """
    Analyzes a list of inmates to identify high-risk individuals based on
    their punishment history. This is the selected code segment for analysis.
    """
    high_risk_inmates = []
    # Note: This function uses a local import to avoid circular dependencies
    # if it were to be called from a different context.
    from app.utils.db_manager import db_manager

    conn = None
    try:
        conn = db_manager.get_connection()
        for inmate_id in inmate_ids_to_check: # << Outer Loop >>
            cur = conn.cursor(dictionary=True)
            cur.execute("SELECT status FROM inmates WHERE id = %s", (inmate_id,))
            inmate = cur.fetchone()

            if not inmate or inmate['status'] != 'Active': # << Branch 1 >>
                cur.close()
                continue # Skip to the next inmate

            cur.execute("SELECT punishment_detail FROM punishments WHERE inmate_id = %s", (inmate_id,))
            punishments = cur.fetchall()
            severe_infraction_count = 0

            for p in punishments: # << Nested Loop >>
                detail = p['punishment_detail'].lower()
                if 'assault' in detail or 'weapon' in detail: # << Branch 2 >>
                    severe_infraction_count += 1
            
            if severe_infraction_count >= 2: # << Branch 3 >>
                high_risk_inmates.append(inmate_id)

            cur.close()
    except Exception as e:
        print(f"Error in risk analysis: {e}")
    finally:
        if conn and conn.is_connected():
            conn.close()

    return high_risk_inmates
