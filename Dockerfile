# Usa un'immagine Node leggera
FROM node:20-alpine AS builder
WORKDIR /app

# Installa le dipendenze
COPY package*.json ./
RUN npm install

# Copia il resto dei file e builda l'app
COPY . .
RUN npm run build

# Stage di produzione
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV production

# Copia solo il necessario dal builder
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
CMD ["npm", "start"]
