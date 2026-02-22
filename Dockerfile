FROM node:20-alpine

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

# Pre-download ALL v86 assets at build time
RUN apk add --no-cache curl && \
    mkdir -p public/v86/bios public/v86/images && \
    echo "Downloading libv86.js..." && \
    curl -fL https://copy.sh/v86/build/libv86.js -o public/v86/libv86.js && \
    echo "Downloading v86.wasm..." && \
    curl -fL https://copy.sh/v86/build/v86.wasm -o public/v86/v86.wasm && \
    echo "Downloading seabios..." && \
    curl -fL https://copy.sh/v86/bios/seabios.bin -o public/v86/bios/seabios.bin && \
    echo "Downloading vgabios..." && \
    curl -fL https://copy.sh/v86/bios/vgabios.bin -o public/v86/bios/vgabios.bin && \
    echo "Downloading Windows 95 disk image from archive.org..." && \
    curl -fL "https://archive.org/download/windows-95-oem-x03-52599/c.img" -o public/v86/images/windows95.img && \
    echo "All assets cached!" && \
    ls -lh public/v86/ public/v86/bios/ public/v86/images/

EXPOSE 3000
CMD ["node", "server.js"]