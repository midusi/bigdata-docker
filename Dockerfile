# Formamos la imagen a partir de Ubuntu 18.04 LTS
FROM ubuntu:18.04

# Definimos las variables de entorno requeridas por Hadoop
ENV HADOOP_HOME "/usr/local/hadoop"
ENV HADOOP_STREAMING_HOME "$HADOOP_HOME/share/hadoop/tools/lib"

# Esta linea es necesaria sino no se puede usar el comando source
SHELL ["/bin/bash", "-c"]

# Instalacion y configuracion
RUN apt update \
    # Instalamos Python 3.x, Java (OpenJDK), y algunas otras herramientas para que funcione todo
    # Configuro SSH para que no arroje problemas con la conexion
    && apt install -y python3 python3-venv openjdk-8-jdk wget ssh openssh-server openssh-client net-tools nano iputils-ping \
    && echo 'ssh:ALL:allow' >> /etc/hosts.allow \
    && echo 'sshd:ALL:allow' >> /etc/hosts.allow \
    && ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && service ssh restart \
    # Descargamos y extraemos Hadoop
    && wget http://apache.dattatec.com/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz \
    # Configuramos Hadoop y despues borro el .tar.gz descargado
    && tar -xzvf hadoop-3.1.2.tar.gz \
    && mv hadoop-3.1.2 $HADOOP_HOME \
    && echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && echo 'export PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc \
    && echo 'export PATH=$PATH:$HADOOP_HOME/sbin' >> ~/.bashrc \
    && rm hadoop-3.1.2.tar.gz \
    # Descargamos Apache Spark
    && wget apache.dattatec.com/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz \
    # Descomprimimos, agregamos al path y despues eliminamos el tar de instalacion de Apache Spark
    && tar -xvzf spark-2.4.3-bin-hadoop2.7.tgz \
    && mv spark-2.4.3-bin-hadoop2.7 sbin/ \
    && echo 'export PATH=$PATH:/sbin/spark-2.4.3-bin-hadoop2.7/sbin/' >> ~/.bashrc \
    && echo 'export PATH=$PATH:/sbin/spark-2.4.3-bin-hadoop2.7/bin/' >> ~/.bashrc \
    && rm spark-2.4.3-bin-hadoop2.7.tgz \
    && mv ${HADOOP_STREAMING_HOME}/hadoop-streaming-3.1.2.jar ${HADOOP_STREAMING_HOME}/hadoop-streaming.jar \
    && source ~/.bashrc

# Algunas variables de entorno requeridas
ENV HDFS_NAMENODE_USER "root"
ENV HDFS_DATANODE_USER "root"
ENV HDFS_SECONDARYNAMENODE_USER "root"
ENV YARN_RESOURCEMANAGER_USER "root"
ENV YARN_NODEMANAGER_USER "root"
ENV PYSPARK_PYTHON "python3"

# Copio el entrypoint para reiniciar SSH
# Sino sale error 22 cannot connect
COPY ./config/entrypoint.sh .
RUN chmod 700 ./entrypoint.sh

# Reemplazo la configuracion de Hadoop para un correcto funcionamiento
WORKDIR /usr/local/hadoop/etc/hadoop
COPY ./config/core-site.xml .
COPY ./config/hdfs-site.xml .
COPY ./config/mapred-site.xml .
COPY ./config/yarn-site.xml .

# Pasamos el script para levantar haddop en el directorio principal
WORKDIR /home/big_data
COPY ./config/hadoopAction.sh .

# Inicia en el entrypoint para reiniciar SSH
ENTRYPOINT ["/entrypoint.sh"]
