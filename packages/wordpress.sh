__stonemason_wordpress_ini () {

    defaultDatabaseName="no database selected"
    defaultDatabaseUser="no user selected"
    defaultDatabasePassword=""
    defaultDatabaseHost="127.0.0.1"
    defaultWordpressTagVersion="4.1.1"
    defaultTablePrefix="wp_"




    # Wordpress version
    echo -e "${INVITE}Which version of WordPress do we use ?"
    echo -e "${INVITE}The version type must match a tag in the official WordPress github repository "
    echo -e "${INVITE}Leave this field empty if you do not use WordPress builder "
    echo -e "${INVITE}Default : 4.1.1"
    read -r -p "" wordpressTagVersion

    if [ -z "$wordpressTagVersion" ]; then
        wordpressTagVersion=${defaultWordpressTagVersion}
    fi



    # Database Name
    echo -e "${INVITE}Database name ?"
    read -r -p "" databaseName
    if [ -z "$databaseName" ]; then
        databaseName=${defaultDatabaseName}
    fi


    # Database User
    echo -e "${INVITE}Database user ?"
    read -r -p "" databaseUser
    if [ -z "$databaseUser" ]; then
        databaseUser=${defaultDatabaseUser}
    fi


    # Database password
    echo -e "${INVITE}Database password ?"
    read -r -p "" databasePassword
    if [ -z "$databasePassword" ]; then
        databasePassword=${defaultDatabasePassword}
    fi


    # Database host
    echo -e "${INVITE}Database host ?"
    read -r -p "" databaseHost
    if [ -z "$databaseHost" ]; then
        databaseHost=${defaultDatabaseHost}
    fi


    # Table prefix
    echo -e "${INVITE}Table prefix ?"
    read -r -p "" tablePrefix
    if [ -z "$tablePrefix" ]; then
        tablePrefix=${defaultTablePrefix}
    fi


    echo "tablePrefix=${tablePrefix}"              >> `pwd`/project.ini
    echo "databaseName=${databaseName}"            >> `pwd`/project.ini
    echo "databaseUser=${databaseUser}"            >> `pwd`/project.ini
    echo "databaseHost=${databaseHost}"            >> `pwd`/project.ini
    echo "databasePassword=${databasePassword}"    >> `pwd`/project.ini
    echo "wordpressTagVersion=${wordpressTagVersion}"  >> `pwd`/project.ini
}


# echo -ne '#####                     (33%)\r' ; sleep 1 ;echo -ne '#############             (66%)\r';sleep 1 ;echo -ne '#######################   (100%)\r';echo -ne '\n'



__stonemason_wordpress_gen () {


    echo -e "${INFO}Now the config is set, are you ready to gen all files ?"
    read

    clear

    wordpressTagVersion=$(awk -F "=" '/wordpressTagVersion/ {print $2}' project.ini)
    themeName=$(awk -F "=" '/themeName/ {print $2}' project.ini)
    appName=$(awk -F "=" '/appName/ {print $2}' project.ini)
    appVersion=$(awk -F "=" '/appVersion/ {print $2}' project.ini)
    appURI=$(awk -F "=" '/appURI/ {print $2}' project.ini)
    appDescription=$(awk -F "=" '/appDescription/ {print $2}' project.ini)
    appAuthor=$(awk -F "=" '/appAuthor/ {print $2}' project.ini)
    tablePrefix=$(awk -F "=" '/tablePrefix/ {print $2}' project.ini)
    databaseName=$(awk -F "=" '/databaseName/ {print $2}' project.ini)
    databaseUser=$(awk -F "=" '/databaseUser/ {print $2}' project.ini)
    databaseHost=$(awk -F "=" '/databaseHost/ {print $2}' project.ini)
    databasePassword=$(awk -F "=" '/databasePassword/ {print $2}' project.ini)

    echo -e "${INFO}We will install WordPress at its version ${wordpressTagVersion}"
    echo -e "${INFO}Git can do this job, see :\n"

    # git clone -b ${wordpressTagVersion} https://github.com/WordPress/WordPress.git .
    git init
    git remote add origin https://github.com/WordPress/WordPress.git
    git fetch --tags
    git checkout tags/${wordpressTagVersion}
    git pull origin ${wordpressTagVersion}

    rm -rf .git
    rm -rf ./wp-content/themes/* # remove defaults themes



    # Create the skeleton of the theme (copied from files)

    cp -r ~/stonemason/files/wordpress ./wp-content/themes/${themeName}

    # change the app name
    mv ./wp-content/themes/${themeName}/scripts/app ./wp-content/themes/${themeName}/scripts/${appName}

    # Clone the less dir from github
    git clone https://github.com/Stuff90/LessTree.git ./wp-content/themes/${themeName}/less
    rm -rf ./wp-content/themes/${themeName}/less/.git
    mkdir ./wp-content/themes/${themeName}/less/remixings
    # Get dependenciy from github through curl
    curl -s "https://raw.githubusercontent.com/christopher-ramirez/remixings/master/remixins.less" > ./wp-content/themes/${themeName}/less/remixings/remixins.less

    sed -i -e "s/#themeName#/$themeName/g" ./wp-content/themes/${themeName}/theme.info
    sed -i -e "s/#appName#/$appName/g" ./wp-content/themes/${themeName}/theme.info
    sed -i -e "s/#appVersion#/$appVersion/g" ./wp-content/themes/${themeName}/theme.info
    sed -i -e "s/#appURI#/$appURI/g" ./wp-content/themes/${themeName}/theme.info
    sed -i -e "s/#appDescription#/$appDescription/g" ./wp-content/themes/${themeName}/theme.info



    cp ~/stonemason/files/.gitignore ./.gitignore

    cp ~/stonemason/files/wp-config.php ./wp-config.php

    sed -i -e "s/#tablePrefix#/$tablePrefix/g" ./wp-config.php
    sed -i -e "s/#databaseName#/$databaseName/g" ./wp-config.php
    sed -i -e "s/#databaseUser#/$databaseUser/g" ./wp-config.php
    sed -i -e "s/#databaseHost#/$databaseHost/g" ./wp-config.php
    sed -i -e "s/#databasePassword#/$databasePassword/g" ./wp-config.php



    cp ~/stonemason/files/GruntFile.js ./GruntFile.js

    sed -i -e "s/#themeName#/$themeName/g" GruntFile.js
    sed -i -e "s/#appName#/$appName/g" GruntFile.js


    cp ~/stonemason/files/.bowerrc ./.bowerrc

    sed -i -e "s/#themeName#/$themeName/g" .bowerrc


    cp ~/stonemason/files/bower.json ./bower.json

    sed -i -e "s/#appName#/$appName/g" bower.json
    sed -i -e "s/#appVersion#/$appVersion/g" bower.json


    cp ~/stonemason/files/package.json ./package.json

    sed -i -e "s/#appName#/$appName/g" package.json
    sed -i -e "s/#appVersion#/$appVersion/g" package.json
    sed -i -e "s/#appAuthor#/$appAuthor/g" package.json
    sed -i -e "s/#appDescription#/$appDescription/g" package.json
    sed -i -e "s/#appURI#/$appURI/g" package.json




    echo -e "${INFO}Now we have to run the npm install"
    read

    clear

    npm install


    echo -e "${INFO}Now need to get dependencies through bower install"
    read

    clear

    bower install


    echo -e "${INFO}Let's make a build to check if all is in place here"
    read

    clear

    grunt build

    # sed -i -e "s/#appName#/$appName/g" package.json

    # sed -i -e "s/#appVersion#/$appVersion/g" package.json

    # sed -i -e "s/#appAuthor#/$appAuthor/g" package.json

    # sed -i -e "s/#appDescription#/$appDescription/g" package.json


    # mv -R ./wp-content/themes/wordpress ./wp-content/themes/${themeName}

    # git fetch

    # __stonemason_project_dir ${1}
    # __stonemason_project_ini
    # # =======================
    # # Clone WordPress package
    # # =======================

    # echo -e "${INVITE}Which version of WordPress do we use ? : "
    # echo -e "${INVITE}The version type must match a tag in the official WordPress github repository "
    # echo -e "${INVITE}Default : 4.1.1"
    # read -r -p "" wordpressTagVersion

    # if [ -z "$wordpressTagVersion" ]; then
    #     wordpressTagVersion="4.1.1"
    # fi

    # echo -e "${INFO}We will install WordPress at its version ${wordpressTagVersion}"
    # echo -e "${INFO}Git can do this job, see :"
    # echo -e ""

    # git clone -b ${wordpressTagVersion} https://github.com/WordPress/WordPress.git ${projectName}

    # cd ${projectName}

    # rm -rf .git
    # clear

    # echo -e ""
    # echo -e "${INFO}A wordpress ${wordpressTagVersion} has been planted !"
    # echo -e ""
    # echo -e "${NOTICE}We will now set the project NOTICErmations :"
    # echo -e "${NOTICE}    -> ${LRED}Theme name${RESTORE}"
    # echo -e "${NOTICE}    -> Front ${LPURPLE}App name${RESTORE}"
    # echo -e "${NOTICE}    -> Front ${LBLUE}App version${RESTORE}"
    # echo -e "${NOTICE}    -> Front App Author"
    # echo -e "${NOTICE}    -> Front App Description"
    # echo -e ""
    # echo -e "${INFO}Get ready ..."
    # echo -e ""

    # # Theme name
    # echo -e "${INVITE}What will be the new ${LRED}Theme name${RESTORE} ? "
    # echo -e "${INVITE}Default : ${projectName}"
    # read -r -p "" themeName
    # if [ -z "$themeName" ]; then
    #     themeName=${projectName}
    # fi

    # mkdir wp-content/themes/${themeName}

    # # mkdir -p wp-content/themes/${themeName}/less/mixins
    # mkdir -p wp-content/themes/${themeName}/res/img
    # mkdir -p wp-content/themes/${themeName}/res/font

    # touch wp-content/themes/${themeName}/index.php
    # touch wp-content/themes/${themeName}/functions.php
    # touch wp-content/themes/${themeName}/header.php
    # touch wp-content/themes/${themeName}/footer.php


    # touch wp-content/themes/${themeName}/style.css

    # echo -e "${INFO}Alright, theme ${LRED}${themeName}${RESTORE} created !"
    # echo -e "${INFO}The basic files has been planted as well, look :"

    # echo -e ""
    # echo -e "$> ls -lai wp-content/themes/${LRED}${themeName}${RESTORE}"
    # echo -e ""
    # ls -lai wp-content/themes/${themeName}
    # echo -e ""



    # # =========================
    # # Add the package.json file
    # # =========================
    # cp ~/stonemason/files/package.json ./package.json


    # # App name
    # echo -e "${INVITE}What will be the new ${LPURPLE}App name${RESTORE} ? "
    # echo -e "${INVITE}The Front ${LPURPLE}App name${RESTORE} is simply the name of the directory where the front js files will be stored"
    # echo -e "${INVITE}Default : ${LRED}${themeName}${RESTORE}"
    # read -r -p "" appName
    # if [ -z "$appName" ]; then
    #     appName=${themeName}
    # fi
    # sed -i -e "s/#appName#/$appName/g" package.json

    # echo -e ""; echo -e "";
    # echo -e "${INFO}The front app name of project ${LRED}${themeName}${RESTORE} is now ${LPURPLE}${appName}${RESTORE} !"
    # echo -e ""; echo -e "";




    # # App version
    # echo -e "${INVITE}What is the ${LBLUE}App version${RESTORE} you want to set for the fron app ${LPURPLE}${appName}${RESTORE} ?"
    # echo -e "${INVITE}Default : ${LBLUE}0.0.1${RESTORE}"
    # read -r -p "" appVersion
    # if [ -z "$appVersion" ]; then
    # 	appVersion="0.0.1"
    # fi
    # sed -i -e "s/#appVersion#/$appVersion/g" package.json

    # echo -e ""; echo -e "";
    # echo -e "${INFO}Great, we are working on ${LPURPLE}${appName}${RESTORE} at ${LBLUE}${appVersion}${RESTORE} for project ${LRED}${themeName}${RESTORE} !"
    # echo -e ""; echo -e "";



    # # App author
    # echo -e "${INVITE}And who is the author of this app ?"
    # read -r -p "" appAuthor
    # sed -i -e "s/#appAuthor#/$appAuthor/g" package.json

    # # App description
    # echo -e "${INVITE}Add a quick description of ${LRED}${appName}${RESTORE}, it will be easier to get more developers work on this !"
    # read -r -p "" appDescription
    # sed -i -e "s/#appDescription#/$appDescription/g" package.json


    # echo -e ""; echo -e "";
    # echo -e "${INFO}Quick summary ?"
    # echo -e ""
    # echo -e "${NOTICE}  Project name : ${projectName}"
    # echo -e "${NOTICE}  The project is Wordpress-based"
    # echo -e "${NOTICE}  The dedicated theme name is ${LRED}${themeName}${RESTORE}"
    # echo -e "${NOTICE}  In this theme, the front application ${LPURPLE}${appName}${RESTORE} has been created at version ${LBLUE}${appVersion}${RESTORE}"
    # echo -e "${NOTICE}  ${appAuthor} authored the Front App, see the description :"
    # echo -e "${NOTICE}  ${appDescription}"

    # echo -e ""; echo -e "";

    # echo -e "${INFO}Now we will run npm install"
    # echo -e "${INVITE}Ready ?"
    # read

    # clear

    # npm install



    # # =======================
    # # Add the bower.json file
    # # =======================

    # echo -e "${INFO}Now we will run bower install"
    # echo -e "${INVITE}Ready ?"
    # read

    # cp ~/stonemason/files/bower.json ./bower.json

    # sed -i -e "s/#appName#/$appName/g" bower.json
    # sed -i -e "s/#appVersion#/$appVersion/g" bower.json

    # cp ~/stonemason/files/.bowerrc ./.bowerrc
    # sed -i -e "s/#themeName#/$themeName/g" .bowerrc

    # clear

    # bower install



    # # =========================
    # # Add the GruntFile.js file
    # # =========================

    # cp ~/stonemason/files/GruntFile.js ./GruntFile.js

    # sed -i -e "s/#themeName#/$themeName/g" GruntFile.js
    # sed -i -e "s/#appName#/$appName/g" GruntFile.js


    # # ===================
    # # Create js app files
    # # ===================

    # mkdir -p wp-content/themes/${themeName}/scripts/${appName}
    # cp ~/stonemason/files/config-dev.js wp-content/themes/${themeName}/scripts/config-dev.js
    # cp ~/stonemason/files/config-dist.js wp-content/themes/${themeName}/scripts/config-dist.js
    # cp ~/stonemason/files/main.js wp-content/themes/${themeName}/scripts/${appName}/main.js

    # # ================
    # # Create CSS files
    # # ================

    # echo -e "${INFO}Now we need to plant the LESS structure !"
    # echo -e "${INVITE}Ready ?"
    # read

    # git clone https://github.com/christopher-ramirez/remixings.git wp-content/themes/${themeName}/less/remixings && rm -rf wp-content/themes/${themeName}/less/remixings/.git


    # echo -e "${INFO}Last step, pass a grunt build, just to be sure all dependencies are there"
    # echo -e "${INVITE}Ready ?"
    # read


    rm -rf .bowerrc-e
    rm -rf package.json-e
    rm -rf bower.json-e
    rm -rf GruntFile.js-e
    rm -rf wp-config.php-e
    rm -rf ./wp-content/themes/${themeName}/theme.info-e

    # clear
    # grunt build

    # echo -e "${INFO}It's all good"
    # echo -e "${INFO}Have fun captain ;)"
}

















