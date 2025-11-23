FROM node:18

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Install TypeScript compiler
RUN npm install -g typescript

# Copy source code
COPY . .

# Transpile TypeScript to JavaScript
RUN tsc

# Generate Prisma client
RUN npx prisma generate --schema=src/prisma/schema.prisma || true

EXPOSE 3000

CMD ["node", "dist/main.js"]
