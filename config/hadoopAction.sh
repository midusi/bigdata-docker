#!/bin/bash
# Levanta o baja los servicios de Hadoop
# Espera los parametros "start" o "stop"
if [ -z "$1" ]; then
    echo "No se envio ningun argumento. Ingrese: 'start' o 'stop'. Por ejemplo: './hadoopAction.sh start'"
    exit
fi

# Necesario para que cargue la configuracion de Hadoop
if [ "$1" == "start" ] ; then
    # Se le envia el parametro 'n' para que no formatee la particion
    # del namenode y se pierdan los datos
    echo "n" | hdfs namenode -format
fi

${1}-dfs.sh
${1}-yarn.sh

# Muestra los procesos levantados
jps

if [ "$1" == "start" ] ; then
    echo "Web UI at http://localhost:9870"
fi
