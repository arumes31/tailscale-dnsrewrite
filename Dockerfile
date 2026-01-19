FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    dnsmasq \
    curl \
    bind-tools \
    iputils \
    bash \
    tailscale

# Copy configuration and scripts
COPY entrypoint.sh /entrypoint.sh

# Make scripts executable
RUN chmod +x /entrypoint.sh

# Create Tailscale socket directory
RUN mkdir -p /var/run/tailscale

# Expose DNS port
EXPOSE 53/udp

# Set up Tailscale state directory
VOLUME /var/lib/tailscale

# Use entrypoint
ENTRYPOINT ["/entrypoint.sh"]