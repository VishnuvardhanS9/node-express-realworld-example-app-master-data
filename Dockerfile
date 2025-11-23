# 1️⃣ Build stage
FROM node:18 AS build

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./
COPY nx.json ./
COPY project.json ./

# Install dependencies
RUN npm install

# Copy complete source
COPY src ./src

# Generate Prisma client
RUN npx prisma generate --schema=src/prisma/schema.prisma

# Build NX project (creates dist/api)
RUN npm run build

# 2️⃣ Production stage
FROM node:18-alpine AS prod

WORKDIR /app

# Copy build output
COPY --from=build /app/dist ./dist

# Copy package.json only (for runtime)
COPY package*.json ./

# Install only production deps
RUN npm install --production

EXPOSE 3000

CMD ["node", "dist/api/src/main.js"]
