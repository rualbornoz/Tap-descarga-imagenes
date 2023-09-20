#!/bin/bash
if [ $1 ]; then
carpeta=(`echo $1 | cut -d '/' -f 3-7 | sed 's|/|_|g'`)
mkdir -p $carpeta
echo "Descargando imágenes..."
wget -P $carpeta -q -nc -nd -np -p -k -H -R html -e robots=off -U Mozilla -A jpg,jpeg,png,gif $1 2> /tmp/error.log
curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'url[^>]*)' | sed '1,2d ; s/url(// ; s/)// ; s/amp;//g'` 2> /tmp/error.log || curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'src[^>]*" ' | sed 's/src=// ; s/[\]//g ; s/amp;//g ; s|[\"]||g' | grep -v -e '.css' -e '.js'` 2> /tmp/error.log
curl -s $1 | wget -P $carpeta -q -N `grep -o -i 'https:[^>]*.jpg' | sed 's/[\]//g ; s/"/\n/g' | grep https` 2> /tmp/error.log
curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'http://[^>]*.jpg'` 2> /tmp/error.log || curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'https://[^>]*.jpg'` 2> /tmp/error.log
curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'http://[^>]*.jpeg'` 2> /tmp/error.log || curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'https://[^>]*.jpeg'` 2> /tmp/error.log
curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'http://[^>]*.png'` 2> /tmp/error.log || curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'https://[^>]*.png'` 2> /tmp/error.log
curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'http://[^>]*.gif'` 2> /tmp/error.log || curl -s $1 | wget -P $carpeta -q -nc `grep -o -i 'https://[^>]*.gif'` 2> /tmp/error.log
echo "¡Listo, imágenes descargadas! ~ $carpeta"
else
echo "Sin URL no hay imágenes :("
fi
