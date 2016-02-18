#!/bin/sh -ex
make get
make all
python run-checklist.py
aws s3 sync dist $AWS_DESTINATION
