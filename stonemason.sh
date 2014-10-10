stonemason () {
    clear
    if [[ -z "$1" ]]; then {
        echo -e "Please set a project type"
    } else {
        case $1 in
            ("wordpress") {
                clear
                if [[ -z "$2" ]]; then {
                    echo -e "Please set a project name"
                } else {
                    git clone https://github.com/WordPress/WordPress.git ${2}
                    cd ${2}
                    mkdir wp-content/themes/${2}

                    mkdir wp-content/themes/${2}/styles
                    mkdir wp-content/themes/${2}/scripts
                    mkdir wp-content/themes/${2}/res
                    mkdir wp-content/themes/${2}/res/img
                    mkdir wp-content/themes/${2}/res/font

                    touch wp-content/themes/${2}/header.php
                    touch wp-content/themes/${2}/index.php
                    touch wp-content/themes/${2}/footer.php
                    touch wp-content/themes/${2}/functions.php

                    touch wp-content/themes/${2}/style.css

                    rm -R .git

                    echo -e "A wordpress has been planted !"
                } fi
            };;
            [nN]|[nN][oO]) {
                clear
            };;
            *) {
                clear
            };;
        esac
    } fi
}