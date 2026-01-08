# Gunakan Node.js 20 sebagai basis (Debian Bookworm)
FROM node:20-bookworm

# Install dependensi dasar, Nginx, PHP (CLI only), dan library untuk Puppeteer/Chrome
RUN apt-get update && apt-get install -y \
    nginx \
    php-cli \
    php-pgsql \
    git \
    gnupg \
    # Library di bawah ini wajib untuk whatsapp-web.js (Puppeteer)
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pnpm (opsional, tapi lebih cepat dari npm untuk Next.js)
RUN npm install -g pnpm

# Konfigurasi Nginx dasar (Opsional, bisa diatur nanti)
# COPY nginx.conf /etc/nginx/sites-available/default

# Workspace folder
WORKDIR /workspaces/spmb-tuban-app