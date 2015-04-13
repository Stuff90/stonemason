. ~/stonemason/style.sh
. ~/stonemason/packages/wordpress.sh

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
                    __stonemason_wordpress ${2}
                } fi
            };;
            ("wp") {
                clear
                if [[ -z "$2" ]]; then {
                    echo -e "Please set a project name"
                } else {
                    __stonemason_wordpress ${2}
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