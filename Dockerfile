#Base Image
FROM debian:stretch-slim
LABEL name="lighthouse-headless" maintainer="Naresh Anjuru <nareshanjuru@gmail.com>" 

ENV CHROME_VERSION="google-chrome-stable"
ENV CHROME_FLAGS="--headless --disable-gpu --no-sandbox"
ENV INSTALL_DIR = "/home/chrome/reports"

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    dos2unix \
    --no-install-recommends \
  && curl -sSL https://deb.nodesource.com/setup_10.x | bash - \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update && apt-get install -y \
    ${CHROME_VERSION:-google-chrome-stable} \
    nodejs \
    --no-install-recommends \
  && apt-get purge --auto-remove -y curl gnupg \
  && rm -rf /var/lib/apt/lists/*

# lighthouse
ARG CACHEBUST=1
RUN npm install -g lighthouse

#COPY entrypoint.sh to container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && dos2unix /entrypoint.sh && mkdir -p $INSTALL_DIR

# Workdirectory of application
WORKDIR $INSTALL_DIR

# Disable Lighthouse error reporting to prevent prompt.
ENV CI=true

#ENTRYPOINT ["/entrypoint.sh"]
