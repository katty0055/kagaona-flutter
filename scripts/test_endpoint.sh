#!/bin/bash

# Cargar las variables de entorno desde el archivo .env que está en el directorio principal
if [ -f "../.env" ]; then
  export $(grep -v '^#' ../.env | xargs)
  echo "Variables de entorno cargadas desde ../.env"
else
  echo "Error: No se encontró el archivo .env en el directorio principal"
  exit 1
fi

# URL del endpoint
URL="${BASE_URL}/${API_KEY}/noticias"

# Contador de intentos
attempt=0

echo "Probando el endpoint: $URL"

while true; do
  # Incrementar el contador de intentos
  ((attempt++))

  # Realizar la solicitud con curl
  response=$(curl -s -o /dev/null -w "%{http_code}" -X GET "$URL")

  echo "Intento $attempt: Código de respuesta HTTP $response"

  # Verificar si el código de respuesta es un error 4xx
  if [[ $response == 4* ]]; then
    echo "Se recibió un código de error 4xx: $response"
    break
  fi

  # Esperar 1 segundo antes del siguiente intento
  #sleep 0.5
done