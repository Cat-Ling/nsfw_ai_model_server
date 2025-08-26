# Base image: Ubuntu 22.04 with Python 3.12 pre-installed
FROM python:3.12-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy Python dependencies and install
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

# Copy your wheel and install it
COPY dist/ai_processing-0.0.0-cp312-cp312-linux_x86_64.whl /tmp/
RUN python -m pip install --no-cache-dir /tmp/ai_processing-0.0.0-cp312-cp312-linux_x86_64.whl

# Set working directory
WORKDIR /app
COPY . /app

# Expose the port FastAPI uses
EXPOSE 8000

# Command to run your server
CMD ["python", "server.py"]
