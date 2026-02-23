FROM node:20-alpine

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

RUN apk add --no-cache curl unzip && \
    mkdir -p public/v86/bios public/v86/images && \
    echo "Downloading v86 assets..." && \
    curl -fL https://copy.sh/v86/build/libv86.js -o public/v86/libv86.js && \
    curl -fL https://copy.sh/v86/build/v86.wasm -o public/v86/v86.wasm && \
    curl -fL https://copy.sh/v86/bios/seabios.bin -o public/v86/bios/seabios.bin && \
    curl -fL https://copy.sh/v86/bios/vgabios.bin -o public/v86/bios/vgabios.bin && \
    echo "Downloading Windows 98 SE image..." && \
    curl -fL "https://archive.org/download/bochs_windows_images/Windows%2098.zip" -o /tmp/win98.zip && \
    echo "Extracting..." && \
    unzip -o /tmp/win98.zip -d /tmp/win98/ && \
    ls -lh /tmp/win98/ && \
    find /tmp/win98/ -name "*.img" -o -name "*.hdd" -o -name "*.disk" | head -1 | xargs -I{} cp {} public/v86/images/windows98.img && \
    rm -rf /tmp/win98.zip /tmp/win98 && \
    echo "Done!" && \
    ls -lh public/v86/images/

EXPOSE 3000
CMD ["node", "server.js"]
