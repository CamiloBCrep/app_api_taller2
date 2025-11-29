# 1. Usamos la imagen ligera de Node (Alpine Linux)
FROM node:lts-alpine

# 2. Creamos el directorio de trabajo
WORKDIR /app

# 3. Copiamos los archivos de dependencias
COPY package*.json ./

# 4. COPIA CRÍTICA: Copiamos la carpeta de Prisma
# (Asegúrate de que la ruta 'src/prisma' sea correcta en tu repo)
COPY src/prisma ./prisma

# 5. Instalamos dependencias y GENERAMOS el cliente Prisma
# Al ejecutarse aquí adentro, Prisma descarga el binario correcto para Alpine (musl)
RUN npm install --omit=dev
RUN npx prisma generate

# 6. Copiamos el código compilado desde tu carpeta dist
# (Jenkins debe haber ejecutado 'npm run build' antes)
COPY dist/api .

# 7. Exponemos el puerto interno (NestJS/Express suele usar 3000 o 3333)
EXPOSE 3000

# 8. Arrancamos la aplicación
CMD ["node", "main.js"]
