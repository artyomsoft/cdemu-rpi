FROM ubuntu:22.04 as linux-builder
RUN apt update && apt install --yes git bc bison flex libssl-dev make libc6-dev libncurses5-dev kmod wget
RUN apt install --yes crossbuild-essential-armhf

RUN mkdir /app
WORKDIR /app/
RUN git clone --depth=1 -b rpi-5.15.y https://github.com/raspberrypi/linux 

ENV KERNEL=kernel7
WORKDIR /app/linux/

RUN wget https://raw.githubusercontent.com/tjmnmk/gadget_cdrom/master/tools/kernel/00-remove_iso_limit.patch &&\
    git apply  --ignore-space-change --ignore-whitespace 00-remove_iso_limit.patch  

RUN mkdir -p /app/linux/dist/root/ /app/linux/dist/boot/overlays/ /app/linux/dist/boot/
RUN make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
RUN make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
RUN env PATH=$PATH && make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=dist/root modules_install

RUN cp arch/arm/boot/zImage dist/boot/$KERNEL.img
RUN cp arch/arm/boot/dts/*.dtb dist/boot/
RUN cp arch/arm/boot/dts/overlays/*.dtb* dist/boot/overlays/
RUN cp arch/arm/boot/dts/overlays/README dist/boot/overlays/

RUN find /app/linux/dist/root -type l -delete
FROM ubuntu:22.04

RUN apt update && apt install --yes wget kpartx xz-utils
RUN mkdir /app
WORKDIR /app/

RUN wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2022-09-26/2022-09-22-raspios-bullseye-armhf-lite.img.xz
RUN unxz 2022-09-22-raspios-bullseye-armhf-lite.img.xz

COPY files/ /app/files/
COPY --from=linux-builder /app/linux/dist /app/linux/
COPY make-image.sh /app/make-image.sh

RUN chmod +x make-image.sh

CMD ./make-image.sh

