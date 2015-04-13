__stonemason_wordpress () {
    projectName=${1}


    # =======================
    # Clone WordPress package
    # =======================

    echo -e "${INVITE}Which version of WordPress do we use ? : "
    echo -e "${INVITE}The version type must match a tag in the official WordPress github repository "
    echo -e "${INVITE}Default : 4.1.1"
    read -r -p "" wordpressTagVersion

    if [ -z "$wordpressTagVersion" ]; then
        wordpressTagVersion="4.1.1"
    fi

    echo -e "${INFO}We will install WordPress at its version ${wordpressTagVersion}"
    echo -e "${INFO}Git can do this job, see :"
    echo -e ""

    git clone -b ${wordpressTagVersion} https://github.com/WordPress/WordPress.git ${projectName}

    cd ${projectName}

    rm -rf .git
    clear

    echo -e ""
    echo -e "${INFO}A wordpress ${wordpressTagVersion} has been planted !"
    echo -e ""
    echo -e "${NOTICE}We will now set the project NOTICErmations :"
    echo -e "${NOTICE}    -> ${LRED}Theme name${RESTORE}"
    echo -e "${NOTICE}    -> Front ${LPURPLE}App name${RESTORE}"
    echo -e "${NOTICE}    -> Front ${LBLUE}App version${RESTORE}"
    echo -e "${NOTICE}    -> Front App Author"
    echo -e "${NOTICE}    -> Front App Description"
    echo -e ""
    echo -e "${INFO}Get ready ..."
    echo -e ""

    # Theme name
    echo -e "${INVITE}What will be the new ${LRED}Theme name${RESTORE} ? "
    echo -e "${INVITE}Default : ${projectName}"
    read -r -p "" themeName
    if [ -z "$themeName" ]; then
        themeName=${projectName}
    fi

    mkdir wp-content/themes/${themeName}

    # mkdir -p wp-content/themes/${themeName}/less/mixins
    mkdir -p wp-content/themes/${themeName}/res/img
    mkdir -p wp-content/themes/${themeName}/res/font

    touch wp-content/themes/${themeName}/index.php
    touch wp-content/themes/${themeName}/functions.php
    touch wp-content/themes/${themeName}/header.php
    touch wp-content/themes/${themeName}/footer.php


    touch wp-content/themes/${themeName}/style.css

    echo -e "${INFO}Alright, theme ${LRED}${themeName}${RESTORE} created !"
    echo -e "${INFO}The basic files has been planted as well, look :"

    echo -e ""
    echo -e "$> ls -lai wp-content/themes/${LRED}${themeName}${RESTORE}"
    echo -e ""
    ls -lai wp-content/themes/${themeName}
    echo -e ""



    # =========================
    # Add the package.json file
    # =========================
    cp ~/stonemason/files/package.json ./package.json

    # App name
    echo -e "${INVITE}What will be the new ${LPURPLE}App name${RESTORE} ? "
    echo -e "${INVITE}The Front ${LPURPLE}App name${RESTORE} is simply the name of the directory where the front js files will be stored"
    echo -e "${INVITE}Default : ${LRED}${themeName}${RESTORE}"
    read -r -p "" appName
    if [ -z "$appName" ]; then
        appName=${themeName}
    fi
    sed -i -e "s/#appName#/$appName/g" package.json

    echo -e ""; echo -e "";
    echo -e "${INFO}The front app name of project ${LRED}${themeName}${RESTORE} is now ${LPURPLE}${appName}${RESTORE} !"
    echo -e ""; echo -e "";




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
    cp ~/stonemason/files/config-dist.js wp-content/themes/${1}/scripts/config-dist.js
    cp ~/stonemason/files/main.js wp-content/themes/${1}/scripts/${appName}/main.js

    # ================
    # Create CSS files
    # ================

    cp -r ~/stonemason/files/less wp-content/themes/${1}/less
}

















