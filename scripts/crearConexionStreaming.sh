# Abre una conexion netcat en el puerto especificado.
# Si no se especifica se utiliza el 7777
if [ -z "$1" ]; then
    echo "No se especifico ningun puerto. Usando 7777 por defecto."
    PORT=7777
else
    PORT=$1
fi

nc -lk -p $PORT 127.0.0.1