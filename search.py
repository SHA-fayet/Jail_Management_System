from flask import Blueprint, render_template, request
from app import mysql
from .auth import login_required
import MySQLdb.cursors

search_bp = Blueprint('search', __name__)

@search_bp.route('/search', methods=['GET'])
@login_required
def search():
    # Get search parameters from the form
    inmate_name = request.args.get('name', '').strip()
    crime = request.args.get('crime', '').strip()
    cell_number = request.args.get('cell_number', '').strip()
    
    results = []
    # Only perform a search if at least one field is filled
    if inmate_name or crime or cell_number:
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Start with a base query
        query = """
            SELECT i.id, i.name, i.crime, i.status, c.cell_number 
            FROM inmates i
            LEFT JOIN cells c ON i.cell_id = c.id
        """
        
        # Dynamically build the WHERE clause based on provided inputs
        conditions = []
        params = []
        
        if inmate_name:
            conditions.append("i.name LIKE %s")
            params.append(f"%{inmate_name}%")
        
        if crime:
            conditions.append("i.crime LIKE %s")
            params.append(f"%{crime}%")
            
        if cell_number:
            conditions.append("c.cell_number LIKE %s")
            params.append(f"%{cell_number}%")

        if conditions:
            query += " WHERE " + " AND ".join(conditions)
        
        query += " ORDER BY i.name"
        
        cur.execute(query, tuple(params))
        results = cur.fetchall()
        cur.close()

    # Pass the search terms back to the template to repopulate the form
    return render_template(
        'search.html', 
        results=results, 
        search_terms={
            'name': inmate_name,
            'crime': crime,
            'cell_number': cell_number
        }
    )
