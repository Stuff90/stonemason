. ~/stonemason/style.sh

. ~/stonemason/packages/project-ini.sh

. ~/stonemason/packages/wordpress.sh


stonemason () {

    clear
    echo "===================================================================="
    echo "=     _____ _                    ___  ___                          ="
    echo "=    /  ___| |                   |  \\/  |                          ="
    echo "=    \\ \`--.| |_ ___  _ __   ___  | .  . | __ _ ___  ___  _ __      ="
    echo "=     \`--. \\ __/ _ \\| '_ \\ / _ \\ | |\\/| |/ _\` / __|/ _ \\| '_ \\     ="
    echo "=    /\\__/ / || (_) | | | |  __/ | |  | | (_| \\__ \\ (_) | | | |    ="
    echo "=    \\____/ \\__\\___/|_| |_|\\___| \\_|  |_/\\__,_|___/\\___/|_| |_|    ="
    echo "===================================================================="

    echo -e "\n${WHITE}License MIT\n${RESTORE}"

    echo -e "Copyright (c) 2014 Simon BERNARD, contributors\n"
    echo -e "Permission is hereby granted, free of charge, to any person\nobtaining a copy of this software and associated documentation\nfiles (the \"Software\"), to deal in the Software without\nrestriction, including without limitation the rights to use,\ncopy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the\nSoftware is furnished to do so, subject to the following\nconditions:\n"
    echo -e "The above copyright notice and this permission notice shall be\nincluded in all copies or substantial portions of the Software.\n"
    echo -e "THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,\nEXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES\nOF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND\nNONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT\nHOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,\nWHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING\nFROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR\nOTHER DEALINGS IN THE SOFTWARE.\n"

    echo -e "${INFO}Thanks for using StoneMason\n${INFO}Find all updates at : https://github.com/Stuff90/stonemason\n"

    __stonemason_project_ini


    # if [[ -z "$1" ]]; then {
    #     echo -e "Please set a project type"
    # } else {
    #     case $1 in
    #         ("wordpress") {
    #             clear
    #             if [[ -z "$2" ]]; then {
    #                 echo -e "Please set a project name"
    #             } else {
    #                 __stonemason_wordpress ${2}
    #             } fi
    #         };;
    #         ("wp") {
    #             clear
    #             if [[ -z "$2" ]]; then {
    #                 echo -e "Please set a project name"
    #             } else {
    #                 __stonemason_wordpress ${2}
    #             } fi
    #         };;
    #         ("ini") {
    #             clear
    #             __stonemason_project_ini ${2}
    #         };;
    #         [nN]|[nN][oO]) {
    #             clear
    #         };;
    #         *) {
    #             clear
    #         };;
    #     esac
    # } fi
}