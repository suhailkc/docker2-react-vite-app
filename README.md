# React + TypeScript + Vite Application

A modern React application built with TypeScript and Vite, containerized with Docker for easy deployment and development.

## 🐳 Docker Overview

This project is fully containerized using Docker, making it easy to run in any environment without worrying about Node.js version compatibility or dependency management.

### Docker Features

- **Lightweight Base Image**: Uses `node:22-alpine` for minimal image size
- **Fast Package Management**: Uses `pnpm` for efficient dependency installation
- **Development Ready**: Configured to run Vite dev server with hot module replacement
- **Port Exposed**: Application runs on port `5173`

## 🚀 Quick Start with Docker

### Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your system
- Docker Desktop (for macOS/Windows) or Docker Engine (for Linux)

### Running the Application

1. **Build the Docker image:**
   ```bash
   docker build -t docker2-react-vite-app .
   ```

2. **Run the container:**
   ```bash
   docker run -p 5173:5173 docker2-react-vite-app
   ```

3. **Access the application:**
   Open your browser and navigate to `http://localhost:5173`

### Docker Commands

#### Build the image
```bash
docker build -t docker2-react-vite-app .
```

#### Run in detached mode (background)
```bash
docker run -d -p 5173:5173 --name react-vite-app docker2-react-vite-app
```

#### Run with volume mounting (for development)
```bash
docker run -p 5173:5173 -v $(pwd):/app -v /app/node_modules docker2-react-vite-app
```

#### Stop the container
```bash
docker stop react-vite-app
```

#### Remove the container
```bash
docker rm react-vite-app
```

#### View running containers
```bash
docker ps
```

#### View container logs
```bash
docker logs react-vite-app
```

#### Follow container logs
```bash
docker logs -f react-vite-app
```

#### Execute commands in running container
```bash
docker exec -it react-vite-app sh
```

## 📦 Dockerfile Details

The Dockerfile is optimized for development and uses a multi-stage approach:

```dockerfile
FROM node:22-alpine        # Lightweight Node.js 22 Alpine image
WORKDIR /app              # Set working directory
RUN npm install -g pnpm   # Install pnpm globally
COPY package*.json .      # Copy package files
RUN pnpm install          # Install dependencies
COPY . .                  # Copy application code
CMD ["pnpm","run","dev"]  # Start development server
EXPOSE 5173               # Expose Vite default port
```

### Key Points:

- **Alpine Linux**: Reduces image size significantly
- **pnpm**: Faster and more disk-efficient than npm
- **Layer Caching**: Package files are copied before source code to leverage Docker layer caching
- **Host Binding**: Vite is configured to bind to `0.0.0.0` to accept connections from outside the container

## 🛠️ Development

### Local Development (without Docker)

If you prefer to run the application locally:

1. **Install dependencies:**
   ```bash
   npm install -g pnpm
   pnpm install
   ```

2. **Start development server:**
   ```bash
   pnpm run dev
   ```

### Available Scripts

- `pnpm run dev` - Start development server with HMR
- `pnpm run build` - Build for production
- `pnpm run lint` - Run ESLint
- `pnpm run preview` - Preview production build

## 🏗️ Building for Production

### Using Docker

1. **Create a production Dockerfile** (or modify the existing one):
   ```dockerfile
   FROM node:22-alpine AS builder
   WORKDIR /app
   RUN npm install -g pnpm
   COPY package*.json .
   RUN pnpm install
   COPY . .
   RUN pnpm run build

   FROM nginx:alpine
   COPY --from=builder /app/dist /usr/share/nginx/html
   EXPOSE 80
   CMD ["nginx", "-g", "daemon off;"]
   ```

2. **Build and run:**
   ```bash
   docker build -t react-vite-app:prod .
   docker run -p 8080:80 react-vite-app:prod
   ```

### Local Production Build

```bash
pnpm run build
```

The production build will be in the `dist` directory.

## 📝 Project Structure

```
.
├── Dockerfile              # Docker configuration
├── .dockerignore          # Files to exclude from Docker build
├── package.json           # Project dependencies and scripts
├── vite.config.ts        # Vite configuration
├── tsconfig.json         # TypeScript configuration
├── index.html            # HTML entry point
└── src/                  # Source code
    ├── main.tsx          # Application entry point
    ├── App.tsx           # Main App component
    └── ...
```

## 🔧 Configuration

### Vite Configuration

The Vite dev server is configured to bind to `0.0.0.0` to accept connections from outside the container:

```typescript
// vite.config.ts
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',  // Important for Docker
    port: 5173
  }
})
```

### Docker Ignore

The `.dockerignore` file excludes `node_modules` from the Docker build context to speed up builds and reduce image size.

## 🐛 Troubleshooting

### Port Already in Use

If port 5173 is already in use, you can map to a different port:

```bash
docker run -p 3000:5173 docker2-react-vite-app
```

Then access the app at `http://localhost:3000`

### Container Won't Start

1. Check container logs:
   ```bash
   docker logs react-vite-app
   ```

2. Verify the image was built correctly:
   ```bash
   docker images | grep docker2-react-vite-app
   ```

### Hot Module Replacement Not Working

Ensure you're using volume mounting when developing:
```bash
docker run -p 5173:5173 -v $(pwd):/app -v /app/node_modules docker2-react-vite-app
```

### Permission Issues (Linux)

If you encounter permission issues, you may need to run Docker with sudo or add your user to the docker group.

## 📚 Technologies Used

- **React 19.2.0** - UI library
- **TypeScript** - Type safety
- **Vite 7.2.4** - Build tool and dev server
- **pnpm** - Package manager
- **Docker** - Containerization
- **ESLint** - Code linting

## 🤝 Contributing

1. Make your changes
2. Test with Docker: `docker build -t docker2-react-vite-app . && docker run -p 5173:5173 docker2-react-vite-app`
3. Ensure linting passes: `pnpm run lint`

## 📄 License

This project is private and not licensed for public use.
