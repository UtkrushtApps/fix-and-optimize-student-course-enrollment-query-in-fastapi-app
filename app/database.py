import psycopg2
from psycopg2 import pool

DATABASE_CONFIG = {
    'host': 'db',
    'port': 5432,
    'database': 'utkrusht_students',
    'user': 'utkrusht_user',
    'password': 'Proof123',
}

connection_pool = None

def get_conn():
    global connection_pool
    if connection_pool is None:
        connection_pool = pool.ThreadedConnectionPool(
            1, 10,
            host=DATABASE_CONFIG['host'],
            port=DATABASE_CONFIG['port'],
            database=DATABASE_CONFIG['database'],
            user=DATABASE_CONFIG['user'],
            password=DATABASE_CONFIG['password']
        )
    return connection_pool.getconn()

def release_conn(conn):
    if connection_pool:
        connection_pool.putconn(conn)
