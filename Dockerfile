FROM node:18

WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies
RUN npm install

# Install TypeScript globally
RUN npm install -g typescript

# Copy the entire project
COPY . .

# Compile TypeScript (creates dist folder)
RUN tsc

# Generate Prisma client
RUN npx prisma generate --schema=src/prisma/schema.prisma || true

EXPOSE 3000

CMD ["node", "dist/main.js"]
