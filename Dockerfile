FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

# Install ts-node to run TS directly
RUN npm install -g ts-node typescript

COPY . .

# Generate Prisma client
RUN npx prisma generate --schema=src/prisma/schema.prisma || true

EXPOSE 3000

CMD ["ts-node", "src/main.ts"]
