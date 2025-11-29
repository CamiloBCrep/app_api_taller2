# 1. Usamos la imagen ligera de Node (Alpine)
FROM node:lts-alpine

# --- CORRECCIÓN 1: Instalar OpenSSL ---
# Prisma necesita openssl y librerías de compatibilidad C para funcionar en Alpine
RUN apk add --no-cache openssl libc6-compat

WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# --- CORRECCIÓN 2: Recrear la ruta exacta ---
# Tu package.json busca el schema en "src/prisma/schema.prisma"
# Creamos la carpeta explícitamente y copiamos el archivo ahí.
RUN mkdir -p src/prisma
COPY src/prisma/schema.prisma ./src/prisma/

# Instalamos dependencias y GENERAMOS el cliente
# Ahora sí encontrará OpenSSL y la ruta correcta del schema
RUN npm install --omit=dev
RUN npx prisma generate

# Copiamos el código compilado (que Jenkins generó antes)
COPY dist/api .

# Exponemos el puerto y arrancamos
EXPOSE 3000
CMD ["node", "main.js"]
