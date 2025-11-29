# 1. Usamos la imagen ligera de Node (Alpine Linux)
FROM node:lts-alpine

# 2. INSTALAMOS OPENSSL (CRÍTICO para Prisma en Alpine)
# Sin esto, Prisma falla porque Alpine no trae las librerías SSL por defecto
RUN apk add --no-cache openssl libc6-compat

# 3. Directorio de trabajo
WORKDIR /app

# 4. Copiamos los archivos de configuración de paquetes
COPY package*.json ./

# 5. ESTRUCTURA DE CARPETAS (CRÍTICO para Prisma)
# Tu package.json espera encontrar el schema en "src/prisma/schema.prisma"
# Creamos la carpeta explícitamente y copiamos el archivo ahí.
RUN mkdir -p src/prisma
COPY src/prisma/schema.prisma ./src/prisma/

# 6. Instalamos dependencias y GENERAMOS el cliente de Prisma
# Al hacerse aquí adentro, se descarga el binario correcto para Linux Alpine
RUN npm install --omit=dev
RUN npx prisma generate

# 7. Copiamos el código compilado (JavaScript)
# Jenkins debe haber ejecutado "npm run build" antes de este paso
COPY dist/api .

# 8. Exponemos el puerto interno (NestJS suele usar 3000 o 3333)
EXPOSE 3000

# 9. Comando de inicio
CMD ["node", "main.js"]
