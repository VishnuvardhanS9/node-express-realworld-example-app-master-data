FROM node:18

WORKDIR /app

# Install app dependencies
COPY package*.json ./
RUN npm install

# Install TypeScript globally
RUN npm install -g typescript

# Copy the project
COPY . .

# Compile TypeScript → dist/
RUN tsc

# Generate Prisma client
RUN npx prisma generate --schema=src/prisma/schema.prisma || true

EXPOSE 3000

# RUN THE BUILT JS FILE (NOT TS FILES)
CMD ["node", "dist/main.js"]
