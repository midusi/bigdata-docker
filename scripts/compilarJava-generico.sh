# Correr dentro de la carpeta con el codigo fuente (usualmente dentro de 'src')
javac ./*.java -classpath $HADOOP_HOME/share/hadoop/common/lib/commons-cli-1.2.jar:$HADOOP_HOME/share/hadoop/common/hadoop-common-3.1.2.jar:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-3.1.2.jar -d ./bin/

# Generar un jar dentro de la carpeta bin
jar -cvf ./bin/<nombre del ejecutable>.jar -C ./bin/ .

# Ejecutar el jar
# <source>: ruta del archivo de entrada (si se quiere usar un script local usar file:// como prefijo)
# <dest>: ruta del directorio donde se guardaran los resultados si se especifica solo un nombre (ej.: 'resultados') y no 
# una ruta (ej.: '/resultados') se guardaran en el HDFS como /user/root/<nombre>
hadoop jar ./bin/<nombre del ejecutable>.jar <nombre del package de java>.<nombre de la clase principal> <source> <dest>