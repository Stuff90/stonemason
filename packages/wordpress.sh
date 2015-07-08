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
    read -rs -p "" databasePassword
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
    sed -i -e "s/#appAuthor#/$appAuthor/g" ./wp-content/themes/${themeName}/theme.info


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

    sed -i -e "s/#appURI#/$appURI/g" package.json
    sed -i -e "s/#appName#/$appName/g" package.json
    sed -i -e "s/#appAuthor#/$appAuthor/g" package.json
    sed -i -e "s/#appVersion#/$appVersion/g" package.json
    sed -i -e "s/#appDescription#/$appDescription/g" package.json




    echo -e "${INFO}Now we have to run the npm install"
    read

    clear

    sudo npm install


    echo -e "${INFO}Now need to get dependencies through bower install"
    read

    clear

    bower install


    echo -e "${INFO}Let's run a grunt task to check if all is in place here"
    read

    clear

    grunt server


    rm -rf .bowerrc-e
    rm -rf package.json-e
    rm -rf bower.json-e
    rm -rf GruntFile.js-e
    rm -rf wp-config.php-e
    rm -rf ./wp-content/themes/${themeName}/theme.info-e
}

















