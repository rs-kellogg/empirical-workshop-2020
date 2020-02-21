FROM continuumio/miniconda3

WORKDIR /home/root/work

ADD environment.yml /tmp/environment.yml
RUN conda update -n base -c defaults conda
RUN conda env create -f /tmp/environment.yml

# Pull the environment name out of the environment.yml
RUN echo "source activate $(head -1 /tmp/environment.yml | cut -d' ' -f2)" > ~/.bashrc
ENV PATH /opt/conda/envs/$(head -1 /tmp/environment.yml | cut -d' ' -f2)/bin:$PATH

COPY --chown=root:root ./kelloggrs /home/root/work/kelloggrs
COPY --chown=root:root ./setup.py /home/root/work/setup.py
RUN pip install .
