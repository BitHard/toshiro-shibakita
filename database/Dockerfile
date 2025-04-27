FROM mariadb:10.11

# Update system and add essential services
RUN apt-get update && \
    apt-get install -y \
    nfs-kernel-server \
    rpcbind \
    iputils-ping \
    net-tools \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Directory to export
RUN mkdir -p /var/lib/mysql_export

# SOlve problems of permissions
RUN chmod 777 /var/lib/mysql_export

RUN echo "/var/lib/mysql_export *(rw,sync,no_subtree_check,no_root_squash)" > /etc/exports

# Ports exposed:
# - 3306: MySQL
# - 2049: NFS
# - 111: Portmap/RPCbind
EXPOSE 3306 2049 111

# Initiate servicess (MYSQL + NFS server)
#CMD rpcbind -w && \
#    exportfs -ra && \
#    mysqld_safe 
CMD rpcbind -w && exportfs -ra && docker-entrypoint.sh mysqld