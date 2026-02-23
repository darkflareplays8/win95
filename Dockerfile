FROM node:20-alpine

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

RUN apk add --no-cache curl && \
    mkdir -p public/v86/bios public/v86/images && \
    echo "Downloading v86 assets..." && \
    curl -fL https://copy.sh/v86/build/libv86.js -o public/v86/libv86.js && \
    curl -fL https://copy.sh/v86/build/v86.wasm -o public/v86/v86.wasm && \
    curl -fL https://copy.sh/v86/bios/seabios.bin -o public/v86/bios/seabios.bin && \
    curl -fL https://copy.sh/v86/bios/vgabios.bin -o public/v86/bios/vgabios.bin && \
    echo "Downloading Windows 98 image from i.copy.sh..." && \
    curl -fL "https://i.copy.sh/windows98.img" -o public/v86/images/windows98.img && \
    echo "Done!" && \
    ls -lh public/v86/images/

EXPOSE 3000
CMD ["node", "server.js"]
