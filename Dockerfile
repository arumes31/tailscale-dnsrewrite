FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    dnsmasq \
    curl \
    dnsutils \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
    && curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && rm -rf /var/lib/apt/lists/*

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
