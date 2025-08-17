# app/routes/cells.py

from flask import Blueprint, render_template, request, redirect, url_for, flash, session, jsonify
from app import mysql
from .auth import login_required, admin_required
import MySQLdb.cursors

cells_bp = Blueprint('cells', __name__)

@cells_bp.route('/cells')
@login_required
def view_cells():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT c.*, COUNT(i.id) as current_occupants
        FROM cells c
        LEFT JOIN inmates i ON c.id = i.cell_id AND i.status = 'Active'
        GROUP BY c.id
        ORDER BY c.cell_number
    """)
    cells = cur.fetchall()
    cur.close()
    return render_template('cells.html', cells=cells)

@cells_bp.route('/add_cell', methods=['POST'])
@admin_required
def add_cell():
    cell_number = request.form['cell_number']
    capacity = request.form['capacity']

    cur = mysql.connection.cursor()
    cur.execute(
        "INSERT INTO cells (cell_number, capacity) VALUES (%s, %s)",
        (cell_number, capacity)
    )
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Cell added successfully'}), 201

@cells_bp.route('/edit_cell/<int:id>', methods=['POST'])
@admin_required
def edit_cell(id):
    cell_number = request.form['cell_number']
    capacity = request.form['capacity']

    cur = mysql.connection.cursor()
    cur.execute("""
        UPDATE cells 
        SET cell_number=%s, capacity=%s 
        WHERE id=%s
    """, (cell_number, capacity, id))
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Cell updated successfully'}), 200

@cells_bp.route('/delete_cell/<int:id>', methods=['POST'])
@admin_required
def delete_cell(id):
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT COUNT(*) as occupant_count FROM inmates WHERE cell_id = %s AND status = 'Active'", (id,))
    result = cur.fetchone()
    if result and result['occupant_count'] > 0:
        return jsonify({'error': 'Cannot delete a cell that is currently occupied.'}), 400

    cur.execute("DELETE FROM cells WHERE id = %s", (id,))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'Cell deleted successfully'}), 200


@cells_bp.route('/assign_cell', methods=['GET', 'POST'])
@login_required
def assign_cell():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    if request.method == 'POST':
        if session['role'] not in ['admin', 'jailer']:
            return jsonify({"error": "Unauthorized access"}), 403

        inmate_id = request.form['inmate_id']
        cell_id = request.form['cell_id']

        if not inmate_id or not cell_id:
            return jsonify({"error": "Inmate and Cell must be selected."}), 400

        # ** FIX: Correctly check capacity and return JSON **
        try:
            cur.execute("""
                SELECT c.capacity, COUNT(i.id) as current_occupants
                FROM cells c
                LEFT JOIN inmates i ON c.id = i.cell_id AND i.status = 'Active'
                WHERE c.id = %s
                GROUP BY c.id
            """, (cell_id,))
            cell = cur.fetchone()

            if not cell or cell['current_occupants'] >= cell['capacity']:
                return jsonify({"error": "Cannot assign inmate. The selected cell is already full."}), 400

            # If not full, proceed with assignment
            cur.execute("UPDATE inmates SET cell_id=%s WHERE id=%s", (cell_id, inmate_id))
            mysql.connection.commit()
            
            return jsonify({"message": "Cell assigned successfully"})
        except Exception as e:
            mysql.connection.rollback()
            return jsonify({"error": f"A database error occurred: {e}"}), 500
        finally:
            cur.close()

    # GET: Render page with data
    cur.execute("SELECT id, name FROM inmates WHERE cell_id IS NULL AND status = 'Active'")
    unassigned_inmates = cur.fetchall()

    cur.execute("SELECT c.id, c.cell_number, c.capacity, COUNT(i.id) as current_occupants FROM cells c LEFT JOIN inmates i ON c.id = i.cell_id AND i.status = 'Active' GROUP BY c.id HAVING c.capacity > COUNT(i.id)")
    available_cells = cur.fetchall()
    cur.close()

    return render_template('assign_cell.html', unassigned_inmates=unassigned_inmates, available_cells=available_cells)
