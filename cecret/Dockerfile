FROM ubuntu:latest

# Create new user and group
RUN groupadd -g 999 docker && \
    useradd -r -u 999 -g docker docker

# Set Docker host
# ENV DOCKER_HOST=unix:///var/run/docker.sock
ENV DOCKER_HOST=/var/run/docker.sock

# Add Docker binary to PATH
ENV PATH="/usr/bin/docker:${PATH}"

# Add new user to Docker group
RUN usermod -a -G docker docker

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip git
 
# Install staphb_toolkit
RUN pip install urllib3==1.26.7 && \
    pip install requests==2.26.0 && \
    git clone https://github.com/StaPH-B/staphb_toolkit.git

WORKDIR staphb_toolkit/packaging

RUN python3 setup.py install --user 

WORKDIR ../../

ENV PATH="${PATH}:/staphb_toolkit"

# Copy the pipeline code into the container
# COPY nextflow_pipeline.nf /app/nextflow_pipeline.nf

# Set the working directory
# WORKDIR /app

# Start the pipeline
#CMD ["nextflow", "run", "nextflow_pipeline.nf"]

# CMD ["staphb-tk"]
