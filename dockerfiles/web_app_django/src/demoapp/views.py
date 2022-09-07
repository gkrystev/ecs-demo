from django.shortcuts import render
import mysql.connector
import sys
import boto3
import os

# Create your views here.

def index(request):

    ENDPOINT=os.environ['RDS_HOST']
    PORT=os.environ['RDS_PORT']
    USER=os.environ['WEB_APP_DB_USERNAME']
    REGION=os.environ['REGION']
    DBNAME=os.environ['WEB_APP_DB_NAME']
    os.environ['LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN'] = '1'
    AWS_GLOBAL_BUNDLE="/etc/ssl/certs/aws-global-bundle.pem"

    client = boto3.client('rds', region_name=REGION)

    token = client.generate_db_auth_token(DBHostname=ENDPOINT, Port=PORT, DBUsername=USER, Region=REGION)

    try:
        conn =  mysql.connector.connect(host=ENDPOINT, user=USER, passwd=token, port=PORT, database=DBNAME, ssl_ca=AWS_GLOBAL_BUNDLE, tls_versions=['TLSv1.1', 'TLSv1.2'])
        cur = conn.cursor()
        cur.execute("""SHOW DATABASES""")
        result = cur.fetchall()
        cur.execute("""SELECT now()""")
        qtime = cur.fetchall()
    except Exception as e:
        result = f"Database connection failed due to {e}"
        qtime = "err"

    context = {
        'result': result,
        'qtime': qtime
    }

    return render(request, 'index.html', context=context)

