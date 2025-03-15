from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.http.operators.http import SimpleHttpOperator
from airflow.operators.bash_operator import BashOperator # type: ignore
from airflow.utils.dates import days_ago
import json
import requests
import time
from datetime import timedelta

# Airbyte Cloud API credentials
AIRBYTE_API_URL = "https://api.airbyte.com/v1/jobs"
AIRBYTE_CONNECTION_ID = "daf75902-6755-4265-8911-7072c0b7bdb9"
AIRBYTE_TOKEN_URL = "https://api.airbyte.com/v1/applications/token"
AIRBYTE_CLIENT_ID = "8f887b14-11a9-4de6-8475-d9f021f38319"
AIRBYTE_CLIENT_SECRET = "6qnM9b8ru4i4WdsNWLoiiYfeU7h7m9zx"


# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def get_token(**context):
    url = f"{AIRBYTE_TOKEN_URL}"

    payload = {
        "client_id": f"{AIRBYTE_CLIENT_ID}",
        "client_secret": f"{AIRBYTE_CLIENT_SECRET}",
        "grant-type": "client_credentials"
    }

    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }

    print(f"Sending request to: {url}")
    print(f"Payload: {payload}")

    response = requests.post(url, json=payload, headers=headers)

    print(response.text)

    if response.status_code == 200:
        sync_job = response.json()
        token_id = sync_job.get('access_token')
        print(f"Sync token initiated with ID: {token_id}")

        # Push token_id to XCom
        context['ti'].xcom_push(key='token_id', value=token_id)

        return token_id
    else:
        print(f"Failed to trigger sync: {response.status_code}")
        print(f"Response: {response.text}")
        raise Exception("Failed to get Airbyte Token")


def trigger_sync(**context):
    token_id = context['ti'].xcom_pull(task_ids='get_token_airbyte')

    """Trigger a sync job for a specific connection in Airbyte Cloud"""
    url = f"{AIRBYTE_API_URL}"
    payload = {
        "jobType": "sync",
        "connectionId": f"{AIRBYTE_CONNECTION_ID}"
    }

    print(f"Sending request to: {url}")
    print(f"Payload: {payload}")
    
    """Getting headers with authentication for the Airbyte API"""
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {token_id}"
    }

    response = requests.post(url, json=payload, headers=headers)

    print(f"Response status: {response.status_code}")
    print(f"Response body: {response.text}")
    
    if response.status_code == 200:
        sync_job = response.json()
        job_id = sync_job.get('jobId')
        print(f"Sync job initiated with ID: {job_id}")

        # Push job_id to XCom
        context['ti'].xcom_push(key='job_id', value=job_id)

        return job_id
    else:
        print(f"Failed to trigger sync: {response.status_code}")
        print(f"Response: {response.text}")
        raise Exception("Failed to trigger Airbyte sync")

def check_sync_status(**context):
    token_id = context['ti'].xcom_pull(task_ids='get_token_airbyte')
    """Check the status of a sync job"""
    job_id = context['ti'].xcom_pull(task_ids='trigger_airbyte_sync')
    print(f"job_id: {job_id}")
    url = f"{AIRBYTE_API_URL}/{job_id}"  # Update URL with job_id
    print(f"url: {url}")
    headers = {
        "accept": "application/json",
        "authorization": f"Bearer {token_id}"
    }
    
    # Poll for job status
    while True:
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            status = response.json().get('status')
            if status in ['succeeded', 'failed', 'cancelled']:
                print(f"Job completed with status: {status}")
                if status == 'failed':
                    raise Exception("Airbyte sync job failed")
                return status
            else:
                print(f"Job status: {status}. Waiting...")
                time.sleep(30)  # Wait for 30 seconds before checking again
        else:
            print(f"Failed to check status: {response.status_code}")
            print(f"Response: {response.text}")
            raise Exception("Failed to check Airbyte sync status")

# Create the DAG
dag = DAG(
    'airbyte_cloud_sync',
    default_args=default_args,
    description='Trigger and monitor Airbyte Cloud sync',
    schedule_interval=timedelta(days=1),
    start_date=days_ago(1),
    tags=['airbyte'],
)

# get token Airbyte 
trigger_get_token = PythonOperator(
    task_id='get_token_airbyte',
    python_callable=get_token,
    dag=dag,
)

# Task to trigger the sync
trigger_sync_task = PythonOperator(
    task_id='trigger_airbyte_sync',
    python_callable=trigger_sync,
    dag=dag,
)

# Task to check sync status
check_status_task = PythonOperator(
    task_id='check_airbyte_sync_status',
    python_callable=check_sync_status,
    provide_context=True,
    dag=dag,
)

# Task to run DBT commands in a virtual environment
dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command="""
    source /home/alwin/dbt-venv/bin/activate && \
    cd /home/alwin/dbt_mixue && \
    dbt run
    """,
)

# Define task dependencies
trigger_get_token >> trigger_sync_task >> check_status_task >> dbt_run
