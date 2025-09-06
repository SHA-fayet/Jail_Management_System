# app/utils/db_manager.py

import mysql.connector
from mysql.connector import pooling
import threading
from app.config import Config # Imports your configuration

class DatabaseManager:
    """
    A Singleton class to manage the MySQL database connection pool.
    It reads credentials from the project's Config object.
    """
    _instance = None
    _lock = threading.Lock()

    def __new__(cls):
        # Ensures only one instance is ever created (thread-safe)
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super(DatabaseManager, cls).__new__(cls)
        return cls._instance

    def __init__(self):
        # The 'hasattr' check prevents re-initializing the pool on every call
        if not hasattr(self, 'pool'):
            try:
                self.pool = mysql.connector.pooling.MySQLConnectionPool(
                    pool_name="jms_pool",
                    pool_size=5,
                    host=Config.MYSQL_HOST,
                    user=Config.MYSQL_USER,
                    password=Config.MYSQL_PASSWORD,
                    database=Config.MYSQL_DB
                )
                print("✅ Database connection pool created successfully.")
            except mysql.connector.Error as err:
                print(f"❌ Error creating connection pool: {err}")
                self.pool = None

    def get_connection(self):
        """Gets a connection from the pool."""
        if self.pool:
            return self.pool.get_connection()
        raise ConnectionError("Database connection pool is not available.")

# Global access point to the Singleton instance
db_manager = DatabaseManager()
