# Conceptos y aplicaciones en Big Data

## Instalación

1. Instalar Docker para [Windows](https://docs.docker.com/docker-for-windows/install/), [MacOs](https://docs.docker.com/docker-for-mac/install/) o [Linux](https://docs.docker.com/install/) (ver distribución desplegando la opción Linux en el panel de la izquierda).
    - **(Solo Linux)** Instalar [docker-compose](https://docs.docker.com/compose/install/). En Windows y MacOs viene cuando se instala Docker.

1. Hacer un clone de este repositorio con `git clone git@github.com:midusi/bigdata-docker.git`

1. Abrir el archivo __docker-compose.yml__ y editar donde dice __\<ruta\>__ definiendo la carpeta donde se van a manejar todos los archivos locales que queremos que sean accesibles desde el contenedor. Ej. __/home/Facultad/Big_data/Practicas:/home/big_data/practica__. Ahora todos los archivos de __/home/Facultad/Big_data/Practicas__ se encuentran en el contenedor dentro de la ruta __/home/big_data/practica__. **Nota importante**: no hace falta hacer un restart del contenedor cuando los archivos en el host son editador, los cambios se representan en tiempo real en el contenedor.

## Ejecución de entorno

En la misma carpeta donde se encuentra el archivo docker-compose.yml ejecutar:

`docker-compose run --rm --name big_data bigdata`

Ahí mismo se abrirá una consola bash dentro del contenedor con todas las herramientas instaladas. Para salir del contenedor basta con ejecutar `exit` en dicha consola bash.

Si se quiere entrar al mismo contenedor por diferentes consolas se puede hacer a través de:

`docker container exec -it big_data bash`

Eso abrirá una consola en el contenedor que está corriendo. Se pueden abrir cuantas consolas se quiera en un mismo contenedor. Todas las conexiones se cerrarán cuando se baje el contenedor.

## Iniciar Hadoop

Para levantar los servicios de Hadoop se debe hacer uso del script __hadoopAction.sh__ ubicado en la carpeta principal __/home/big_data__.

Ejecutar cada vez que se levanta el contenedor `./hadoopAction.sh start`

Cuando se deje de usar ejecutar `./hadoopAction.sh stop` para bajar los servicios de manera segura.

Hay scripts genéricos y con ejemplos de compilación tanto para Java como para Python utilizando Hadoop en la carpeta __scripts__ de este repositorio.

## Ejecución de cluster con Spark

En el nodo **Master**:

- Correr `start-master.sh --host <IP del nodo master>`

En los nodos **Workers**:

- Correr `start-slave.sh spark://<IP del nodo master>:7077`

Se pueden ver los workers agregados en __<IP del nodo master>:8080__ (en la PC que lo hostea se puede acceder a través del **localhost:8080**).

Los workers pueden ver su panel en el __localhost:8081__.

Para correr una consola de pyspark en dicho cluster se debe ejecutar

`pyspark --master spark://<IP del nodo master>:7077`

De esta manera el proceso de pyspark correrá en el cluster establecido y no de manera local.

El proceso es el mismo para **spark-submit**:

`spark-submit --master spark://<IP del nodo master>:7077`

## Diferencias con la máquina virtual

### Hadoop

- Debido a que la versión de Hadoop es diferente, el puerto para entrar al manager del master cambió de **50070** a **9870**.

- **Compilación Java!!!**: ya no tenés que preocuparte por correr todos los comandos de compilación para Java. Se deja a disposición un script global llamado `compilarJava.sh`. Para usarlo seguir los siguientes pasos:
    1. Posicionarse en la carpeta del proyecto a compilar.
    1. El código fuente debe estar en una carpeta `src`. Y debe existir una carpeta `bin` a la misma altura.
    1. El script recibe los sig. parámetros: nombre del proyecto, package y clase pricipal (en el formato <package.clase>) y los parámetros propios del script. Ejemplo de Wordcount:
    
        `compilarJava.sh ejemplo_wordcount wordcount.Main file:///..../Libros/pg13507.txt resultado_ejemplo`

### Hadoop Streaming con Python
- **Los scripts deben estar en python3**
- La cabecera debe ser cambiada de `#!/usr/bin/env python` a `#!/usr/bin/python3`
- El script ahora se simplificó para las nuevas rutas de los ejecutables. Ver nuevo script de ejecución en __ejecutarHadoopStreamingPython.sh__ (disponible ejemplo en el archivo __ejecutarHadoopStreamingPython-ejemplo.sh__)

## Actualización de la imagen de Docker

En el caso de que se ageguen cambios a la imagen, se puede actualizar la misma ejecutando en una consola:

`docker image pull genarocamele/bigdata:latest`