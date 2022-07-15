## The Makefile includes instructions on environment setup and lint tests
# Create and activate a virtual environment
# Install dependencies in requirements.txt
# Dockerfile should pass hadolint
# app.py should pass pylint
# (Optional) Build a simple integration test

setup:
	# Create python virtualenv & source it
	# source ~/.devops/bin/activate
	python3 -m venv ~/.udacity_capstone
	source ~/.udacity_capstone/bin/activate
	
install:
	# This should be run from inside a virtualenv
	echo "Installing: dependencies..."
	pip install --upgrade pip &&\
	    pip install -r app/requirements.txt
	echo "Installing: hadolint..."
	./bin/install_hadolint.sh
	
test:
	# Additional, optional, tests could go here
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	# See local hadolint install instructions:   https://github.com/hadolint/hadolint
	# This is linter for Dockerfiles
	./bin/hadolint app/Dockerfile
	# This is a linter for Python source code linter: https://www.pylint.org/
	# This should be run from inside a virtualenv
	pylint --disable=R,C,W1203,W1202 app/app.py
	
run-app:
	python3 app/app.py
	
build-docker:
	./bin/build_docker.sh

run-docker: build-docker
	./bin/run_docker.sh
	
upload-docker: build-docker
	./bin/upload_docker.sh
