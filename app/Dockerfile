FROM python:3.7.3-stretch

LABEL author="nhothuy48cb@gmail.com"

# Working Directory
WORKDIR /app

# Copy source code to working directory
COPY . /app/

# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install  --no-cache-dir --upgrade pip && \
    pip install  --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# Expose port 80
EXPOSE 80

# Run app at container launch
CMD ["python", "app.py"]

make-run-lint-fail