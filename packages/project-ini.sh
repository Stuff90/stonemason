
__stonemason_project_ini () {


	defaultProjectName="newProject"
	defaultAppName="app"
	defaultProjectType="none"
	defaultThemeName=${defaultProjectName}
	defaultAppVersion="0.0.1"
	defaultAppAuthor="Author unnamed"
	defaultAppURI=""
	defaultAppDescription="No description entered"





    # Project name
    echo -e "${INVITE}What is the name of the new project directory ?"
    echo -e "${INVITE}Default : newProject"
    read -r -p "" projectName

    if [ -z "$projectName" ]; then
        projectName=${defaultProjectName}
    fi



    # Theme name
    echo -e "${INVITE}What will be the new ${LRED}Theme name${RESTORE} ? "
    echo -e "${INVITE}Default : ${defaultThemeName}"
    read -r -p "" themeName
    if [ -z "$themeName" ]; then
        themeName=${defaultThemeName}
    fi



    # App name
    echo -e "${INVITE}What will be the new ${LPURPLE}App name${RESTORE} ? "
    echo -e "${INVITE}Default : ${themeName}"
    read -r -p "" appName
    if [ -z "$appName" ]; then
        appName=${defaultAppName}
    fi

    # App version
    echo -e "${INVITE}What is the ${LBLUE}App version${RESTORE} you want to set for the fron app ${LPURPLE}${appName}${RESTORE} ?"
    echo -e "${INVITE}Default : ${LBLUE}0.0.1${RESTORE} (pattern must be XX.XX.XX)"
    read -r -p "" appVersion
    if [ -z "$appVersion" ]; then
    	appVersion=${defaultAppVersion}
    fi



    # App author
    echo -e "${INVITE}And who is the author of this app ?"
    read -r -p "" appAuthor
    if [ -z "$appAuthor" ]; then
    	appAuthor=${defaultAppAuthor}
    fi



    # App author URI
    echo -e "${INVITE}Don't forgot to leave an URI where you can be found (without htt://)"
    read -r -p "" appURI
    if [ -z "$appURI" ]; then
    	appURI=${defaultAppURI}
    fi



    # App description
    echo -e "${INVITE}Add a quick description of ${LRED}${appName}${RESTORE}, it will be easier to get more developers work on this !"
    read -r -p "" appDescription
    if [ -z "$appDescription" ]; then
    	appDescription=${defaultAppDescription}
    fi



    # Once we get the project, we create it and move into it
	mkdir ${projectName}
	cd ${projectName}

	rm -rf `pwd`/project.ini

	echo "appName=${appName}"				>> `pwd`/project.ini
	echo "projectType=${projectType}"		>> `pwd`/project.ini
	echo "projectName=${projectName}"		>> `pwd`/project.ini
	echo "themeName=${themeName}" 			>> `pwd`/project.ini
	echo "appVersion=${appVersion}" 		>> `pwd`/project.ini
	echo "appAuthor=${appAuthor}"			>> `pwd`/project.ini
	echo "appURI=${appURI}"		>> `pwd`/project.ini
	echo "appDescription=${appDescription}"	>> `pwd`/project.ini



    # Project type
    echo -e "${INVITE}What kind of project is it ?"
    echo -e "${INVITE}List of generators available :"
    echo -e "${INVITE}	* Wordpress (type \"wp\")"
    echo -e "${INFO}There is more to come"
    read -r -p "" projectType

    if [ -z "$projectType" ]; then
        projectType=${defaultProjectType}
    fi





    case $projectType in
        ("wp") {
            __stonemason_wordpress_ini
            __stonemason_wordpress_gen
        };;
        [nN]|[nN][oO]) {
            clear
        };;
        *) {
            clear
        };;
    esac



}