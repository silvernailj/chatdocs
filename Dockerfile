## NAME:  chatdocs container
## VERSION: 0.0.1
## TO BUILD  docker build -t chatdocs .
## TO RUN    docker run -p 8080:5000 -v /path/to/local/directory:/app/source_documents -it chatdocs bash
## MODIFY /app/chatdocs/chatdocs/data/chatdocs.yml --> instead of localost, make host 0.0.0.0
## USE FOR CHATDOCS  /venv/bin/chatdocs
## ADD FILES TO CHATDOCS  /venv/bin/chatdocs add /app/source_documents

# Base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y git build-essential cmake libomp-dev nano

# Install Git and create source_documents directory
RUN python -m venv /venv && \
    /venv/bin/pip install --no-cache-dir --upgrade pip && \
    mkdir source_documents

# Set the Python and pip aliases
RUN echo "alias python=python3" >> /root/.bashrc \
    && echo "alias pip=/venv/bin/pip3" >> /root/.bashrc \
    && echo "alias chatdocs='/venv/bin/chatdocs'" >> /root/.bashrc

# Clone the chatdocs repository
RUN git clone https://github.com/marella/chatdocs.git

# Install chatdocs and required dependencies
RUN /venv/bin/pip install -e chatdocs

# Set the working directory to chatdocs
WORKDIR /app/chatdocs

# Download required resources
RUN /venv/bin/chatdocs download

# Set the working directory back to the root
WORKDIR /app
