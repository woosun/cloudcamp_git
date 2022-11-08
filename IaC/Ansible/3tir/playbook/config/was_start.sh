#!/bin/bash
source /tmp/env_db_host
gunicorn --bind=0.0.0.0:8000 wsgi:app