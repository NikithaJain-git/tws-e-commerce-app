# Stage 1: Build Stage
FROM node:18-alpine AS builder
WORKDIR /app
RUN apk add --no-cache python3 make g++
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM gcr.io/distroless/nodejs18-debian11
WORKDIR /app
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
USER nonroot
EXPOSE 3000
CMD ["server.js"]

