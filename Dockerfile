# ---------- Stage 1: Build ----------
FROM node:18 AS build

WORKDIR /app

# Copy workspace config
COPY package*.json ./
COPY tsconfig*.json ./
COPY nx.json ./
COPY project.json ./

RUN npm install

# Copy source code
COPY src ./src

# Generate Prisma client
RUN npx prisma generate --schema=src/prisma/schema.prisma

# Build Nx project (output: dist/api/main.js)
RUN npm run build


# ---------- Stage 2: Production ----------
FROM node:18 AS production

WORKDIR /app

COPY package*.json ./
RUN npm install --production

# Copy Prisma schema
COPY src/prisma ./src/prisma

# Generate Prisma client again for runtime
RUN npx prisma generate --schema=src/prisma/schema.prisma

# Copy built output
COPY --from=build /app/dist ./dist

ENV NODE_ENV=production
ENV MONGODB_URI=mongodb://mongo:27017/realworld
ENV SECRET=supersecretkey

EXPOSE 3000

CMD ["node", "dist/api/main.js"]
