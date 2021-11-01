setup:
	bash setup.sh $(TAG)

create:
	rm -f oojs-ui/php/themes/DyeTheme.php
	rm -rf oojs-ui/src/themes/dye
	cd oojs-ui && grunt add-theme --name=Dye --template=WikimediaUI

convert:
	bash convert.sh

build:
	cd oojs-ui && grunt build

copy:
	rm -rf dist
	mkdir -p dist/resources/ooui/themes
	cp oojs-ui/dist/*dye* dist/resources/ooui
	cp -r oojs-ui/dist/images dist/resources/ooui
	cp -r oojs-ui/dist/themes/dye dist/resources/ooui/themes
	mkdir -p dist/includes/ooui
	cp oojs-ui/php/themes/DyeTheme.php dist/includes/ooui
