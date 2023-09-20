Tap, descarga imágenes masivamente
==================================

[Tap](https://web.archive.org/web/20200901184022/https://github.com/cont3mpo/Tap) es un un script que hice para descargar las imágenes que veas en un sitio, y se usa en escritorios Linux y OS X.

Porqué hice a Tap
-----------------

Tap solo descarga imágenes en la url que le indiques. Solo eso.

Tap lo probé en sitios donde se suben muchas imágenes, como Imgur, Facebook, Twitter, Instagram, Deviantart, 4chan, Tumblr, Reddit, Flickr, Dribbble, y Pinterest. Y la información que muestra en terminal es mínima y simple, y además lanza notificación al terminar la descarga.

Sé que existe [image-scraper](https://web.archive.org/web/20200901184022/https://github.com/eduardschaeli/wget-image-scraper), pero este falló descargando desde varios de arriba. Además hay que agregar los enlaces a un archivo de texto manualmente, y lanza demasiada información en terminal, así que no.

Usando Tap
----------

[Tap](https://web.archive.org/web/20200901184022/https://github.com/cont3mpo/Tap) requiere de [curl](https://web.archive.org/web/20200901184022/http://manpages.ubuntu.com/manpages/trusty/en/man1/curl.1.html) y [wget](https://web.archive.org/web/20200901184022/http://manpages.ubuntu.com/manpages/trusty/en/man1/wget.1.html) para funcionar, [descargar y ver código fuente](https://web.archive.org/web/20200901184022/https://github.com/cont3mpo/Tap/releases) (zip). Dar permisos de ejecución (chmod +x tap.sh). Usen Homebrew en OS X para descargar wget.

Al usarlo pongan comillas en la URL, eso es algo que curl y wget todavía tienen que lidiar debido a los caracteres que podrían cortar el enlace:

`./tap.sh "http://sitio.com/"`

Descarga todas las imágenes que se vean en esa url. Soporta sitios que usen HTTP/HTTPS y formatos de imágenes JPG, JPEG, PNG, y GIF. En Instagram hasta descarga los videos en contenedor MP4.

En Facebook baja las imágenes del álbum que le indiques, y también si le indicas la url de la página donde aparece la foto más grande. No baja desde el muro/perfil de usuario porque es gigantesco la cantidad de código, y queda en loop.

## Código fuente
```
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
```

Malas mañas de algunos sitios
-----------------------------

Facebook y Instagram fueron una agonía, se esmeran mucho en que alguien no extraiga sus imágenes, pero Tap lo hizo. Y el único pero, es que en Facebook baja todas las imágenes sin su extensión, debido a que Facebook muestra las imágenes como enlaces sin extensión, pero igual se pueden ver con feh. O simplemente se puede hacer un renombrado masivo a todas las imágenes. Eso no lo agregué a Tap, porque dio más problemas que soluciones. Así que para mantener a Tap automático, tuve que dejarlo lo más simple posible. En los sitios donde se hace scroll para seguir viendo más, se crea una nueva página que no carga en la barra de direcciones (como twitter, instagram, facebook), y ahí estamos jodidos, ya que es como la dimensión desconocida.

En Pinterest descargará todas las imágenes y quedará esperando, eso pasa porque en Pinterest a cada rato aparece el mensaje de registro que es una jodida molestia. Pero pueden terminar Tap con "Ctrl + C" y tener sus imágenes de Pinterest. Todos los demás bien.

Con rename o mmv se puede hacer renombrado masivo para poner extensión JPG (si bajaste de Facebook):

`rename 's/(.*)/$1.jpg/' *` `mmv "*" "#1.jpg"`

4 de junio, 2015
