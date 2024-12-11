# Set base image to build and run app
FROM node:18 AS build-stage

# Set working directory for container, install node_modules, and copy project contents to container
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Build the app, set production build runtime, and copy production build files to appropriate folder in container
RUN npm run build
FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expose port 80 and run the production build serve command
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]