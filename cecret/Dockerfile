FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip git
 
# Install staphb_toolkit
RUN pip install urllib3==1.26.7 && \
    pip install requests==2.26.0 && \
    git clone https://github.com/StaPH-B/staphb_toolkit.git && \ 
    cd staphb_toolkit/packaging/ && \ 
    pwd && \ 
    python3 setup.py install --user && \ 
    export PATH=$PATH:$(pwd)

# Copy the pipeline code into the container
# COPY nextflow_pipeline.nf /app/nextflow_pipeline.nf

# Set the working directory
WORKDIR /app

# Start the pipeline
#CMD ["nextflow", "run", "nextflow_pipeline.nf"]

CMD ["staphb-tk"]
