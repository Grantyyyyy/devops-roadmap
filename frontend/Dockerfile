# ================================
# Stage 1: Builder
# ================================
FROM node:24-alpine AS builder

WORKDIR /app

# Copy package files first (layer caching!)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Build for production
RUN npm run build

# ================================
# Stage 2: Release
# ================================
FROM nginx:alpine AS release

# Copy built files from Stage 1
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
