# MXQ H3Q44 Armbian BSP

Arquivos de suporte para a TV Box MXQ 4K H3Q44 V3.0 com Allwinner H3,
usando Armbian `5.15.93-sunxi`.

## Conteudo

```text
driver/sunxi-nand/
  sunxi_nand.c   Driver NAND sunxi modificado
  internals.h    Header interno usado pelo driver
  Makefile       Makefile para compilar modulo externo

dtb/
  sun8i-h3-mxq-4k-h3q44.dts
  sun8i-h3-mxq-4k-h3q44.dtb
  sun8i-h3-mxq-4k-h3q44.preprocessed.dts
  sun8i-h3-mxq-4k-h3q44.compiled.dts

scripts/
  remote_build_sunxi_nand.sh

reference/android-stock/
  dtb/        DTB/DTS extraidos do Android stock
  fex/        sys_config, sys_partition, env e MBR Allwinner
  metadata/   tabela de itens do container IMAGEWTY
```

## Driver NAND

O driver foi baseado no `sunxi_nand` do kernel `5.15.93` e recebeu ajustes
para esta NAND MLC usada pela TV Box:

- `ignore_bbm`: permite ignorar marcadores BBM/OOB herdados do Android.
- `known_bad`: permite informar blocos realmente ruins conhecidos.
- `slc_pairing`: registra particoes MTD SLC-on-MLC usando pairing `dist3`.

No sistema testado, os blocos realmente ruins observados foram:

```text
90,91,527,528,529
```

O rootfs UBIFS foi usado com:

```text
mtdparts=1c03000.nand-controller:720M(prebad),16M(skipbad90_91),3480M(nanddata1),24M(skipbad527_529),-(ubi)slc
ubi.mtd=ubi
root=ubi0:rootfs
rootfstype=ubifs
```

## Compilar

No proprio Armbian, com os headers corretos instalados:

```sh
cd driver/sunxi-nand
make -C /lib/modules/$(uname -r)/build M=$PWD modules
```

O resultado esperado e:

```text
sunxi_nand.ko
```

## Instalar modulo

Exemplo para substituir o modulo do kernel em `5.15.93-sunxi`:

```sh
KREL="$(uname -r)"
sudo cp sunxi_nand.ko /tmp/sunxi_nand.ko
sudo xz -c /tmp/sunxi_nand.ko | sudo tee /lib/modules/$KREL/kernel/drivers/mtd/nand/raw/sunxi_nand.ko.xz >/dev/null
sudo depmod -a "$KREL"
```

Depois, o initramfs precisa conter:

```text
nand
sunxi_nand
ubi
ubifs
```

E deve ser regenerado:

```sh
sudo update-initramfs -u -k "$KREL"
```

## Instalar DTB

No Armbian usado nos testes, os DTBs ficam em:

```text
/boot/dtb-5.15.93-sunxi/
```

Exemplo:

```sh
sudo cp dtb/sun8i-h3-mxq-4k-h3q44.dtb /boot/dtb-5.15.93-sunxi/
```

E em `/boot/armbianEnv.txt`:

```text
fdtfile=sun8i-h3-mxq-4k-h3q44.dtb
```

## Referencia Android stock

A pasta `reference/android-stock/` contem arquivos pequenos extraidos da
imagem Android original da TV Box. Ela serve para comparacao e reverse
engineering, nao para build direto do Armbian.

Os arquivos mais uteis sao:

```text
reference/android-stock/dtb/mxq-4k-h3q44-android-stock.dts
reference/android-stock/dtb/mxq-4k-h3q44-android-stock.dtb
reference/android-stock/fex/sys_config.fex
reference/android-stock/fex/sys_partition.fex
reference/android-stock/fex/env.txt
reference/android-stock/metadata/allwinner-items.json
```

Use o DTS Android para comparar pinos, reguladores e perifericos com o DTS
mainline em `dtb/sun8i-h3-mxq-4k-h3q44.dts`. O `sys_partition.fex` e o
`env.txt` documentam o layout e os comandos de boot usados pelo firmware
Android original.

## Observacoes

Este material e especifico para a combinacao testada:

- TV Box MXQ 4K H3Q44 V3.0
- Allwinner H3
- NAND Micron `FxxL84C61KDBABJ4`
- Armbian `5.15.93-sunxi`
- Wi-Fi SDIO `sv6256p`

Atualizacoes de kernel podem substituir o modulo `sunxi_nand.ko.xz`.
Nesse caso, recompile e reinstale o modulo antes de reiniciar usando rootfs
na NAND.
