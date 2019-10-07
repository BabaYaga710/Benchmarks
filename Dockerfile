# This is a Dockerfile to build a Docker image with
# Miniconda.

# We will start from a base Ubuntu 18.04
FROM ubuntu:18.04

# Create non-root user, install dependencies, install Anaconda
RUN apt-get update --fix-missing && \
    apt-get install -y build-essential tmux git gdb wget sudo && \
    useradd -m -s /bin/bash tboudwin && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O anaconda.sh && \
    mkdir -p /opt && \
    sh ./anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    chown -R tboudwin /opt && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /users/tboudwin/.bashrc && \
    echo "conda activate base" >> /users/tboudwin/.bashrc && \
    sudo su tboudwin -c 'conda install -y -c anaconda jupyter' && \
    sudo su tboudwin -c 'jupyter notebook --generate-config' && \
    echo "c.NotebookApp.token = u''" >> /users/tboudwin/.jupyter/jupyter_notebook_config.py 

USER tboudwin
ENV PATH "/bin:/usr/bin:$PATH"
WORKDIR "/users/tboudwin"
CMD ["/bin/bash"]
