FROM amazonlinux:2018.03

RUN yum -y install git \
    python36 \
    python36-pip \
    python36-devel \
    gcc-c++ \
    zip && \
    yum -y group install "Development Tools" && \
    yum clean all

# boto3 is available to lambda processes by default,
# but it's not in the amazonlinux image
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install boto3 awscli

RUN python3 -m pip install "numpy<1.18"

COPY requirements.txt /requirements.txt

RUN python3 -m pip install -r /requirements.txt

COPY bin/* /usr/local/bin/

COPY config/manifest_types.txt /
COPY config/collection_ids.txt /collection_ids.txt
