# Use node:22-alpine as base image
FROM node:22-alpine

# Set working directory in container
WORKDIR /app

# Enable corepack for pnpm
RUN corepack enable

# Copy package files
COPY package.json pnpm-lock.yaml .

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy source code to container
COPY . .

# Expose port 5173
EXPOSE 5173

# Start development server
CMD ["pnpm","run","dev"]