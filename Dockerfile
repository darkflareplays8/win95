FROM node:20-alpine

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

# Pre-download all v86 assets at build time so users don't wait
RUN apk add --no-cache curl && \
    mkdir -p public/v86/bios public/v86/images && \
    echo "Downloading libv86.js..." && \
    curl -L https://copy.sh/v86/build/libv86.js -o public/v86/libv86.js && \
    echo "Downloading seabios..." && \
    curl -L https://copy.sh/v86/bios/seabios.bin -o public/v86/bios/seabios.bin && \
    echo "Downloading vgabios..." && \
    curl -L https://copy.sh/v86/bios/vgabios.bin -o public/v86/bios/vgabios.bin && \
    echo "Downloading Windows 95 image (242MB)..." && \
    curl -L https://copy.sh/v86/images/windows95.img -o public/v86/images/windows95.img && \
    echo "All assets cached!"

EXPOSE 3000
CMD ["node", "server.js"]