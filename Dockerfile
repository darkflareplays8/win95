FROM node:20-alpine

WORKDIR /app
COPY package.json ./
RUN npm install
COPY . .

RUN apk add --no-cache curl && \
    mkdir -p public/v86/bios public/v86/images && \
    curl -fL https://copy.sh/v86/build/libv86.js -o public/v86/libv86.js && \
    curl -fL https://copy.sh/v86/build/v86.wasm -o public/v86/v86.wasm && \
    curl -fL https://copy.sh/v86/bios/seabios.bin -o public/v86/bios/seabios.bin && \
    curl -fL https://copy.sh/v86/bios/vgabios.bin -o public/v86/bios/vgabios.bin && \
    echo "Downloading MS-DOS 6.22 image..." && \
    curl --compressed -fL "https://i.copy.sh/msdos622.img" -o public/v86/images/os.img && \
    echo "Done!" && ls -lh public/v86/images/

EXPOSE 3000
CMD ["node", "server.js"]
