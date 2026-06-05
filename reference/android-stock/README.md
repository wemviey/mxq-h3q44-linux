# MXQ H3Q44 Android Stock Reference

Arquivos pequenos e uteis extraidos da imagem Android stock da TV Box
MXQ 4K H3Q44 V3.0.

Esta pasta e material de referencia para comparar com o BSP Armbian, nao e
uma imagem de flash.

## Conteudo

```text
dtb/
  mxq-4k-h3q44-android-stock.dtb
  mxq-4k-h3q44-android-stock.dts

fex/
  sys_config.fex
  config.fex
  sys_partition.fex
  sunxi_mbr.fex
  env.fex
  env.txt

metadata/
  allwinner-items.json
```

## DTB/DTS

`dtb/mxq-4k-h3q44-android-stock.dtb`

DTB original do Android stock, limpo, com tamanho real do FDT.

`dtb/mxq-4k-h3q44-android-stock.dts`

DTS decompilado do DTB Android. Este e o arquivo mais util para comparar
pinos, reguladores, Wi-Fi, IR, LED, Ethernet, NAND e outros perifericos com
o DTS usado no Armbian.

Observacao: o item Android `sunxi.fex` tambem e um DTB, mas e o mesmo
conteudo com padding zero ate o alinhamento do pacote Allwinner. Por isso ele
nao foi copiado separadamente.

## FEX/Layout

`fex/sys_config.fex`

Configuracao legada da placa usada pelo firmware Android/Allwinner. Pode
trazer informacoes que nao aparecem diretamente no DTS mainline.

`fex/config.fex`

Versao binaria/empacotada da configuracao. Mantida apenas para comparacao e
reverse engineering.

`fex/sys_partition.fex`

Layout textual das particoes Android, com nomes como `bootloader`, `env`,
`boot`, `system`, `recovery` e `UDISK`.

`fex/sunxi_mbr.fex`

MBR binario Allwinner derivado do layout de particoes Android.

`fex/env.fex`

Ambiente U-Boot Android em formato binario com CRC.

`fex/env.txt`

O mesmo ambiente U-Boot em forma textual, mais facil de revisar em Git.

## Metadata

`metadata/allwinner-items.json`

Tabela extraida do container `IMAGEWTY`, com nomes, offsets e tamanhos dos
itens da imagem Android stock.

## Arquivos deixados de fora

Estes arquivos foram extraidos, mas nao foram copiados por padrao:

```text
boot0_nand.fex
boot0_sdcard.fex
u-boot.fex
boot_package.fex
boot.fex
bootloader.fex
system.fex
recovery.fex
```

Motivo: sao binarios de boot/imagem Android, alguns grandes, e nao ajudam
muito no desenvolvimento do DTB/driver. Eles so valem a pena em um repositorio
se o objetivo tambem for documentar/restaurar a cadeia de boot Android.
