#!/bin/bash
service ssh restart > /dev/null 2>&1  # Para prevenir errores de SSH. Ademas oculta los mensajes de error y la salida standard
exec "$@"