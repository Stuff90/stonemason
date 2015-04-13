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
    echo -e "${INVITE}What is the ${LBLUE}App version${RESTORE} you want to set for the fron app ${LPURPLE}${appName}${RESTORE} ?"
    echo -e "${INVITE}Default : ${LBLUE}0.0.1${RESTORE}"
    read -r -p "" appVersion
    if [ -z "$appVersion" ]; then
    	appVersion="0.0.1"
    fi
    sed -i -e "s/#appVersion#/$appVersion/g" package.json

    echo -e ""; echo -e "";
    echo -e "${INFO}Great, we are working on ${LPURPLE}${appName}${RESTORE} at ${LBLUE}${appVersion}${RESTORE} for project ${LRED}${themeName}${RESTORE} !"
    echo -e ""; echo -e "";



    # App author
    echo -e "${INVITE}And who is the author of this app ?"
    read -r -p "" appAuthor
    sed -i -e "s/#appAuthor#/$appAuthor/g" package.json

    # App description
    echo -e "${INVITE}Add a quick description of ${LRED}${appName}${RESTORE}, it will be easier to get more developers work on this !"
    read -r -p "" appDescription
    sed -i -e "s/#appDescription#/$appDescription/g" package.json


    echo -e ""; echo -e "";
    echo -e "${INFO}Quick summary ?"
    echo -e ""
    echo -e "${NOTICE}  Project name : ${projectName}"
    echo -e "${NOTICE}  The project is Wordpress-based"
    echo -e "${NOTICE}  The dedicated theme name is ${LRED}${themeName}${RESTORE}"
    echo -e "${NOTICE}  In this theme, the front application ${LPURPLE}${appName}${RESTORE} has been created at version ${LBLUE}${appVersion}${RESTORE}"
    echo -e "${NOTICE}  ${appAuthor} authored the Front App, see the description :"
    echo -e "${NOTICE}  ${appDescription}"

    echo -e ""; echo -e "";

    echo -e "${INFO}Now we will run npm install"
    echo -e "${INVITE}Ready ?"
    read

    clear

    npm install



    # =======================
    # Add the bower.json file
    # =======================

    echo -e "${INFO}Now we will run bower install"
    echo -e "${INVITE}Ready ?"
    read

    cp ~/stonemason/files/bower.json ./bower.json

    sed -i -e "s/#appName#/$appName/g" bower.json
    sed -i -e "s/#appVersion#/$appVersion/g" bower.json

    cp ~/stonemason/files/.bowerrc ./.bowerrc
    sed -i -e "s/#themeName#/$themeName/g" .bowerrc

    clear

    bower install



    # =========================
    # Add the GruntFile.js file
    # =========================

    cp ~/stonemason/files/GruntFile.js ./GruntFile.js

    sed -i -e "s/#themeName#/$themeName/g" GruntFile.js
    sed -i -e "s/#appName#/$appName/g" GruntFile.js


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

















