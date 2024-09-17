# Use a multi-stage build

# Stage 1: Use an official NGINX image to extract binaries
FROM nginx:alpine as nginx-build

# Stage 2: Use Distroless as the base for the final image
FROM gcr.io/distroless/base-debian12

# Copy NGINX binaries from the first stage
COPY --from=nginx-build /usr/sbin/nginx /usr/sbin/nginx
COPY --from=nginx-build /etc/nginx /etc/nginx

# Expose the port NGINX will serve on
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
