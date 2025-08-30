from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from app import mysql
from datetime import datetime
from .auth import login_required, admin_required
import MySQLdb.cursors

transfers_bp = Blueprint('transfers', __name__)

@transfers_bp.route('/transfers', methods=['GET', 'POST'])
@admin_required
def view_transfers():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Handle form submission for adding a new transfer
    if request.method == 'POST':
        inmate_id = request.form.get('inmate_id')
        to_cell_id = request.form.get('to_cell_id')
        transfer_date = request.form.get('transfer_date')
        reason = request.form.get('reason', '').strip()

        if not all([inmate_id, to_cell_id, transfer_date, reason]):
            flash("All fields (Inmate, New Cell, Reason, Date) are required.", "danger")
            return redirect(url_for('transfers.view_transfers'))

        # ** FIX: Add proper capacity validation for the destination cell **
        cur.execute("""
            SELECT c.capacity, c.cell_number, COUNT(i.id) as current_occupants
            FROM cells c
            LEFT JOIN inmates i ON c.id = i.cell_id AND i.status = 'Active'
            WHERE c.id = %s
            GROUP BY c.id
        """, (to_cell_id,))
        cell = cur.fetchone()

        if not cell:
             flash("Target cell not found.", "danger")
             return redirect(url_for('transfers.view_transfers'))

        if cell['current_occupants'] >= cell['capacity']:
            flash("Cannot complete transfer. The destination cell is already full.", "danger")
            return redirect(url_for('transfers.view_transfers'))

        # ** FIX: Use a LEFT JOIN to correctly handle unassigned inmates **
        # Get the inmate's current cell information to determine the 'from' cell
        cur.execute("SELECT c.cell_number FROM inmates i LEFT JOIN cells c ON i.cell_id = c.id WHERE i.id = %s", (inmate_id,))
        inmate_info = cur.fetchone()
        from_cell_number = inmate_info['cell_number'] if inmate_info and inmate_info['cell_number'] else 'Reception'
        
        to_cell_number = cell['cell_number'] # We already have this from the capacity check

        # Insert the new transfer record
        cur.execute("""
            INSERT INTO transfers (inmate_id, from_cell, to_cell, transfer_date, reason)
            VALUES (%s, %s, %s, %s, %s)
        """, (inmate_id, from_cell_number, to_cell_number, transfer_date, reason))

        # Update the inmate's current cell in the inmates table
        cur.execute("UPDATE inmates SET cell_id = %s WHERE id = %s", (to_cell_id, inmate_id))
        
        mysql.connection.commit()
        flash("Transfer completed successfully.", "success")
        return redirect(url_for('transfers.view_transfers'))

    # GET request: Fetch data to display the page
    cur.execute("SELECT id, name FROM inmates WHERE status = 'Active'")
    inmates = cur.fetchall()

    cur.execute("SELECT id, cell_number FROM cells")
    cells = cur.fetchall()

    cur.execute("""
        SELECT t.transfer_date, t.reason, t.from_cell, t.to_cell, i.name as inmate_name
        FROM transfers t
        JOIN inmates i ON t.inmate_id = i.id
        ORDER BY t.transfer_date DESC
    """)
    transfers = cur.fetchall()

    cur.close()
    return render_template('transfers.html', inmates=inmates, cells=cells, transfers=transfers)
