if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Faltan argumentos! Uso: compilarJava.sh <nombre de ejecutable> <package.clasePrincipal> [<parametro1> <parametros2> ...]"
    exit
fi

# Refactoring de los parametros
nombreEjecutable=$1
packageYClasePrincipal=$2

# Correr dentro de la carpeta con el codigo fuente (usualmente dentro de 'src')
javac ./src/*.java -classpath $HADOOP_HOME/share/hadoop/common/lib/commons-cli-1.2.jar:$HADOOP_HOME/share/hadoop/common/hadoop-common-3.1.2.jar:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-3.1.2.jar -d ./bin/

# Generar un jar dentro de la carpeta bin
jar -cvf ./bin/$nombreEjecutable.jar -C ./bin/ .

# Ejecutar el jar con los parametros pasados
hadoop jar ./bin/$nombreEjecutable.jar $packageYClasePrincipal "${@:3}"