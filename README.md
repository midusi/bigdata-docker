# Conceptos y aplicaciones en Big Data

## Instalación

1. Instalar Docker para [Windows](https://docs.docker.com/docker-for-windows/install/), [MacOs](https://docs.docker.com/docker-for-mac/install/) o [Linux](https://docs.docker.com/install/) (ver distribución desplegando la opción Linux en el panel de la izquierda).
    - **(Solo Linux)** Instalar [docker-compose](https://docs.docker.com/compose/install/). En Windows y MacOs viene cuando se instala Docker.

1. Hacer un clone de este repositorio con `git clone git@github.com:midusi/bigdata-docker.git`

1. Abrir el archivo __docker-compose.yml__ y editar donde dice __\<ruta\>__ definiendo la carpeta donde se van a manejar todos los archivos locales que queremos que sean accesibles desde el contenedor. Ej. __/home/Facultad/Big_data/Practicas:/home/big_data/practica__. Ahora todos los archivos de __/home/Facultad/Big_data/Practicas__ del host se encuentran en el contenedor dentro de la ruta __/home/big_data/practica__. **Nota importante**: no hace falta hacer un restart del contenedor cuando los archivos en el host son editador, los cambios se representan en tiempo real en el contenedor de manera **bilateral**.

## Consideraciones **IMPORTANTES!**

Considérese el contenedor como una máquina virtual sin interfaz gráfica donde se dejan todas las herramientas utilizadas durante la cursada. Cuando se cierra la consola donde corre el contenedor o se ejecuta el comando `exit` en el mismo este se cierra y hay que volver a levantarlo, el equivalente a cerrar la ventana del virtualbox donde corre la virtual o apagar la misma respectivamente. Hay otras diferencias que son muy importantes:

1. **Todos los puertos del contenedor se mapean al host**, es decir, que si en el contenedor levantamos Hadoop y este abre un servicio web en el puerto 9870, se debería poder abrir un navegador en el host y acceder a `localhost:9870` sin problemas.

1. **Nada de lo que NO esté mapeado en `docker-compose.yml` en la sección `volumes` se persiste**: todo lo que se cree en el contenedor una vez que este se baja se pierde, esto es una ventaja cuando se rompe la configuración o alguna dependencia, de esta manera el contenedor siempre se puede volver al estado funcional inicial. Lo que se mapee en la sección `volumes` será lo único que quedará guardado aún cuando el contenedor sea detenido. En nuestro caso definimos dos volumes:
    
    - **hdfs-data:/tmp/hadoop-root** es la carpeta donde Hadoop guarda los archivos del filesystem distribuido cuando hacemos uso del comando `hdfs dfs ...`. De esta manera no perdemos los resultados de los scripts que utilicen ese filesystem. **Esta línea no debería ser cambiada**.
    - **\<ruta\>:/home/big_data/practica** para poder escribir scripts con nuestras propias herramientas en el host en la ruta __\<ruta\>__ y que dichos archivos sean accesibles en el directorio __/home/big_data/practica__ para utilizarlos con Hadoop, Spark, HDFS, y el resto del software instalado en el contenedor. **Esta línea debería ser cambiada para mapear el directorio en el host de preferencia**.

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

## Ejemplos con Spark

Se deja a disposición una serie de ejemplos en el directorio principal del contenedor (`/home/big_data/ejemplos`) con código de diferentes usos de librerías de Spark como Mlib, GraphX, entre otros.

Mlib se puede ejecutar con:

`spark-submit <script de python>`

Para GraphX hay que ejecutar `spark-shell` de la siguiente manera:

`spark-shell -i <script de scala>`

Si se quiere editar dichos ejemplos se recomienda copiar los scripts en el directorio mapeado (el mapeo se hizo desde el `docker-compose.yml` en la sección de instalación) para que los cambios no se pierdan cuando se baje el contenedor.

## Ejecución de cluster con Spark (para cuando se pida en clase)

En el nodo **Master**:

- Correr `start-master.sh --host <IP del nodo master>`

En los nodos **Workers**:

- Correr `start-slave.sh spark://<IP del nodo master>:7077`

Se pueden ver los workers agregados en __\<IP del nodo master\>:8081__ (en la PC que lo hostea se puede acceder a través del **localhost:8080**).

Los workers pueden ver su panel en el __localhost:8081__.

Para correr una consola de pyspark en dicho cluster se debe ejecutar

`pyspark --master spark://<IP del nodo master>:7077`

De esta manera el proceso de pyspark correrá en el cluster establecido y no de manera local.

El proceso es el mismo para **spark-submit**:

`spark-submit --master spark://<IP del nodo master>:7077`

## Diferencias con la máquina virtual

### Hadoop

- Debido a que la versión de Hadoop es diferente, el puerto para acceder al manager del master cambió de **50070** a **9870**.

- **Compilación Java!!!**: ya no tenés que preocuparte por correr todos los comandos de compilación para Java. Se deja a disposición un script global llamado `compilarJava.sh`. Para usarlo seguir los siguientes pasos:
    1. Posicionarse en la carpeta del proyecto a compilar.
    1. El código fuente debe estar en una carpeta `src`. Y debe existir una carpeta `bin` a la misma altura.
    1. El script recibe los sig. parámetros: nombre del proyecto, package y clase pricipal (en el formato <package.clase>) y los parámetros propios del script. Ejemplo de Wordcount:
    
        ```
        compilarJava.sh \
            ejemplo_wordcount \
            wordcount.Main \
            file:///..../Libros/pg13507.txt \
            resultado_ejemplo
        ```

### Hadoop Streaming con Python

- **Los scripts deben estar en python3**
- La cabecera debe ser cambiada de `#!/usr/bin/env python` a `#!/usr/bin/python3`
- El script ahora se simplificó para las nuevas rutas de los ejecutables. Ver nuevo script de ejecución en __ejecutarHadoopStreamingPython.sh__ (disponible ejemplo en el archivo __ejecutarHadoopStreamingPython-ejemplo.sh__)
- **Al igual que con Hadoop**, se deja un script global que simplifica la ejecucion llamado `ejecutarHadoopStreamingPython.sh` que recibe 4 parámetros: source, dest, mapper y reducer. Ejemplo de Wordcount:

    ```
    ejecutarHadoopStreamingPython.sh \
        file:///..../Libros/pg13507.txt \
        resultados_python_streaming \
        /home/big_data/practica/WordCount/Python/mapper.py \
        /home/big_data/practica/WordCount/Python/reducer.py
    ```

### Spark Streaming

- **Para abrir una conexión con netcat** en vez de utilizar `nc -lk 7777` utilizar `crearConexionStreaming.sh [<puerto>]` (el puerto es opcional, si no se especifica se usa por defecto el 7777). En caso de que quiera crear la conexión manualmente se puede correr `nc -lk -p 7777 localhost`.

## Problemas comunes

A continuación se listan los problemas más comunes y sus soluciones:

#### Problema

> Solving Docker permission denied while trying to connect to the Docker daemon socket

#### Solución

Se debe agregar el usuario actual al grupo "docker" del sistema como lo indica la [documentación post-instalación](https://docs.docker.com/install/linux/linux-postinstall/):

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Correr `docker info` y verificar que no arroja el error.

#### Problema

> WARNING: Error loading config file: /home/user/.docker/config.json -stat /home/user/.docker/config.json: permission denied

#### Solución

Como se indica en la documentación post-instalación referenciada arriba, para solucionar este problema correr:

```
rm -rf ~/.docker/
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

#### Problema

Al querer levantar el contenedor arroja en pantalla:

> Cannot create container for service bigdata: Conflict. The container name "\<algun nombre\>" is already in use

#### Solución

Este problema ocurre porque quedó levantado el contenedor. Basta con pararlo para que el comando funcione:

`docker container rm -f big_data`

## Actualización de la imagen de Docker

En el caso de que se agreguen cambios a la imagen, se puede actualizar la misma ejecutando en una consola:

`docker image pull genarocamele/bigdata:latest`