# Ha habido errores con la compilacion porque no estaba vacia la carpeta bin.
# Asi que por la dudas se borra
rm -rf ./bin/*

# Correr dentro de la carpeta con el codigo fuente (usualmente dentro de 'src')
javac ./*.java -classpath $HADOOP_HOME/share/hadoop/common/lib/commons-cli-1.2.jar:$HADOOP_HOME/share/hadoop/common/hadoop-common-3.1.2.jar:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-3.1.2.jar -d ./bin/

# Generar un jar dentro de la carpeta bin
jar -cvf ./bin/ejecutable.jar -C ./bin/ .

# Ejecutar el jar
hadoop jar ./bin/ejecutable.jar wordcount.Main file:///home/big_data/practicas/texto.txt /resultados_wordcount