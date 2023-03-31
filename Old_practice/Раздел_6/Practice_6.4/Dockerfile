FROM centos:7

# Expose ports
EXPOSE 9200 9300

# Set environment variables
ENV ES_HOME=/usr/share/elasticsearch \
    ES_USER=elasticsearch

# Create Elasticsearch user
RUN adduser ${ES_USER} #elasticsearch

# Set workdir app
WORKDIR ${ES_HOME}

# Install necessary packages for Elasticsearch and Python
RUN yum install -y java-1.8.0-openjdk-headless perl-Digest-SHA python3 \
    && yum -y clean all \
    && rm -rf /var/cache/yum

# Copy install file in docker from host.
COPY ./elasticsearch-7.12.1-linux-x86_64.tar.gz elasticsearch.tar.gz
COPY ./elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

# Unarchive and install Elasticsearch. Set access rights for workdir
RUN tar -xzf elasticsearch.tar.gz --directory=${ES_HOME} \
    && rm -f elasticsearch.tar.gz \
    && chmod 744 ${ES_HOME}

# Switch to Elasticsearch user
USER ${ES_USER}

# Start Elasticsearch
CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]