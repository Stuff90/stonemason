__stonemason_wordpress () {
	themeName=${1}


    # =======================
    # Clone WordPress package
    # =======================
    git clone https://github.com/WordPress/WordPress.git ${1}
    cd ${1}
    mkdir wp-content/themes/${1}

    mkdir -p wp-content/themes/${1}/less/mixins
    mkdir -p wp-content/themes/${1}/res/img
    mkdir -p wp-content/themes/${1}/res/font

    touch wp-content/themes/${1}/index.php
    touch wp-content/themes/${1}/functions.php
    touch wp-content/themes/${1}/header.php
    touch wp-content/themes/${1}/footer.php


    touch wp-content/themes/${1}/style.css

    cp ~/stonemason/files/style.less wp-content/themes/${1}/less/style.less
    touch wp-content/themes/${1}/less/variables.less
    touch wp-content/themes/${1}/less/fonts.less
    touch wp-content/themes/${1}/less/mixins/mixins.less

    rm -R .git

    echo -e "A wordpress has been planted !"


    # =========================
    # Add the package.json file
    # =========================
    cp ~/stonemason/files/package.json ./package.json

    # App name
    read -r -p "App name ? (${themeName}): " appName
    if [ -z "$appName" ]; then
    	appName=${themeName}
    fi
    sed -i -e "s/#appName#/$appName/g" package.json

    # App version
    read -r -p "Version ? (0.0.1): " appVersion
    if [ -z "$appVersion" ]; then
    	appVersion="0.0.1"
    fi
    sed -i -e "s/#appVersion#/$appVersion/g" package.json

    # App author
    read -r -p "Author ?: " appAuthor
    sed -i -e "s/#appAuthor#/$appAuthor/g" package.json

    # App description
    read -r -p "Description ?: " appDescription
    sed -i -e "s/#appDescription#/$appDescription/g" package.json

    rm package.json-e

    npm install



    # =======================
    # Add the bower.json file
    # =======================
    cp ~/stonemason/files/bower.json ./bower.json

    sed -i -e "s/#appName#/$appName/g" bower.json
    sed -i -e "s/#appVersion#/$appVersion/g" bower.json

    cp ~/stonemason/files/.bowerrc ./.bowerrc
    sed -i -e "s/#themeName#/$themeName/g" .bowerrc

    rm bower.json-e

    bower install



    # =========================
    # Add the GruntFile.js file
    # =========================
    cp ~/stonemason/files/GruntFile.js ./GruntFile.js

    sed -i -e "s/#themeName#/$themeName/g" GruntFile.js
    sed -i -e "s/#appName#/$appName/g" GruntFile.js

    rm GruntFile.js-e


    # ===================
    # Create js app files
    # ===================

    mkdir -p wp-content/themes/${1}/scripts/${appName}
    cp ~/stonemason/files/config-dev.js wp-content/themes/${1}/scripts/config-dev.js
    cp ~/stonemason/files/config-prod.js wp-content/themes/${1}/scripts/config-prod.js
    cp ~/stonemason/files/main.js wp-content/themes/${1}/scripts/${appName}/main.js

}

















