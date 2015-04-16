
/*jshint node:true*/

module.exports = function (grunt) {

    'use strict';

    // show elapsed time at the end
    require('time-grunt')(grunt);

    // load all grunt tasks
    require('load-grunt-tasks')(grunt);

    grunt.initConfig({

        config: {
            themeName: '#themeName#',
            appName: '#appName#',
            src: 'wp-content/themes/<%= config.themeName %>/',
            dist: 'dist',
            images: 'bin'
        },

        // 'bower-install': {
        //     src: {
        //         html: '<%= config.src %>/index.html',
        //         ignorePath: '<%= config.src %>/'
        //     }
        // },

        express: {
            all: {
                options: {
                    bases: ['C:\\inetpub\\wwwroot\\test'],
                    port: 8080,
                    hostname: "0.0.0.0",
                    livereload: true
                }
            }
        },


        watch: {
              all: {
                files: ['<%= config.src %>/less/{,*/}*.less'],
                options: {
                  livereload: true,
                },
              },
            less: {
                files: ['<%= config.src %>/less/{,*/}*.less'],
                tasks: ['less:dev'],
                options: {
                    spawn: false,
                    interrupt: true
                },
            },
            requirejs: {
                files: ['<%= config.src %>/scripts/{,*/}*.js'],
                tasks: ['requirejs:dev','copy:dev'],
                options: {
                    spawn: false,
                    interrupt: true
                },
            }
        },

        open: {
            all: {
                path: 'http://com.<%= config.themeName %>'
            }
        },


        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '<%= config.src %>/main.js',
                        '<%= config.src %>/main.js.map',
                        '<%= config.src %>/tmp',
                        '<%= config.src %>/dist',
                    ]
                }]
            },
            dev: '<%= config.src %>/tmp'
        },

        // jshint: {
        //     options: {
        //         jshintrc: 'node_modules/grunt-contrib-jshint/.jshintrc',
        //         reporter: require('jshint-stylish')
        //     },
        //     all: [
        //         'Gruntfile.js',
        //         '<%= config.src %>/scripts/{,*/}*.js'
        //     ]
        // },

        // rev: {
        //     dist: {
        //         files: {
        //             src: [
        //                 '<%= config.dist %>/scripts/{,*/}*.js',
        //                 '<%= config.dist %>/styles/{,*/}*.css',
        //                 '<%= config.dist %>/<%= config.images %>/{,*/}*.{gif,jpeg,jpg,png,webp}',
        //                 '<%= config.dist %>/fonts/{,*/}*.*'
        //             ]
        //         }
        //     }
        // },

        // useminPrepare: {
        //     options: {
        //         dest: '<%= config.dist %>'
        //     },
        //     html: '<%= config.src %>/index.html'
        // },

        // usemin: {
        //     options: {
        //         assetsDirs: ['<%= config.dist %>']
        //     },
        //     html: ['<%= config.dist %>/{,*/}*.html'],
        //     css: ['<%= config.dist %>/styles/{,*/}*.css']
        // },

        // imagemin: {
        //     dist: {
        //         files: [{
        //             expand: true,
        //             cwd: '<%= config.src %>/<%= config.images %>',
        //             src: '{,*/}*.{gif,jpeg,jpg,png}',
        //             dest: '<%= config.dist %>/<%= config.images %>'
        //         }]
        //     }
        // },

        // svgmin: {
        //     dist: {
        //         files: [{
        //             expand: true,
        //             cwd: '<%= config.src %>/<%= config.images %>',
        //             src: '{,*/}*.svg',
        //             dest: '<%= config.dist %>/<%= config.images %>'
        //         }]
        //     }
        // },

        // htmlmin: {
        //     dist: {
        //         options: {},
        //         files: [{
        //             expand: true,
        //             cwd: '<%= config.src %>',
        //             src: '*.html',
        //             dest: '<%= config.dist %>'
        //         }]
        //     }
        // },

        copy: {
            dev: {
                files: [
                    {
                        src: '<%= config.src %>/tmp/main.js',
                        dest: '<%= config.src %>/main.js'
                    },
                    {
                        src: '<%= config.src %>/tmp/main.js.map',
                        dest: '<%= config.src %>/main.js.map'
                    }
                ]
            },
            dist: {
                src: '<%= config.src %>/dist/main.js',
                dest: '<%= config.src %>/main.js'
            }
        },


        // usemin: {
        //     html: ['<%= config.src %>/index.php'],
        // },

        // concurrent: {
        //     dev: [
        //         'less:dev'
        //     ],
        //     dist: [
        //         'less:dist',
        //         'imagemin',
        //         'svgmin',
        //         'htmlmin'
        //     ]
        // },

        modernizr: {
            'devFile': '<%= config.src %>/bower_components/modernizr/modernizr.js',
            'outputFile': '<%= config.src %>/<%= config.dist %>/bower_components/modernizr/modernizr.js',
            files: [
                '<%= config.src %>/<%= config.dist %>/scripts/{,*/}*.js',
                '<%= config.src %>/<%= config.dist %>/styles/{,*/}*.css'
            ],
            'parseFiles': true,
            uglify: true
        },


        concat: {
            themedev: {
                src: ['<%= config.src %>/theme.info', '<%= config.src %>/tmp/style.css'],
                dest: '<%= config.src %>/style.css',
            },
            themedist: {
                src: ['<%= config.src %>/theme.info', '<%= config.src %>/dist/style.css'],
                dest: '<%= config.src %>/style.css',
        }
        },


        requirejs: {
            dev: {
                options: {
                    name:'main',
                    optimize: 'none',
                    preserveLicenseComments: true,
                    generateSourceMaps: true,
                    removeCombined: true,
                    useStrict: true,
                    baseUrl: '<%= config.src %>/scripts/<%= config.appName %>',
                    mainConfigFile: '<%= config.src %>/scripts/config-dev.js',
                    out: '<%= config.src %>/tmp/main.js',
                    allowSourceOverwrites: true,
                    keepBuildDir: true
                }
            },
            dist: {
                options: {
                    name:'main',
                    optimize: 'uglify',
                    preserveLicenseComments: false,
                    generateSourceMaps: false,
                    removeCombined: true,
                    useStrict: true,
                    baseUrl: '<%= config.src %>/scripts/<%= config.appName %>',
                    mainConfigFile: '<%= config.src %>/scripts/config-dist.js',
                    out: '<%= config.src %>/dist/main.js',
                    keepBuildDir: true
                }
            }
        },

        less: {
            dev: {
                options: {
                    sourceMap: true
                },
                files: {
                    '<%= config.src %>/tmp/style.css': '<%= config.src %>/less/style.less'
                }
            },
            dist: {
                options: {
                    compress: true,
                    report: true
                },
                files: {
                    '<%= config.src %>/dist/style.css': '<%= config.src %>/less/style.less'
                }
            }
        }

    });

    // Tasks.
    // grunt.registerTask('default', ['jshint', 'build']);

    // grunt.registerTask('server', [
    //     'express',
    //     'open',
    //     'watch'
    //     ]);

    // grunt.registerTask('build', [
        // 'clean:dist',
        // 'useminPrepare',
        // 'concurrent:dist',
        // 'requirejs:dist',
        // 'modernizr',
        // 'copy:dist',
        // 'rev',
        // 'usemin'
    //     'less'
    // ]);

    // grunt.registerTask('serve', function (target) {

    //     if (target === 'build') {
    //         return grunt.task.run(['build', 'connect:dist:keepalive']);
    //     }

    //     grunt.task.run([
    //         'clean:server',
    //         'concurrent:dev',
    //         'requirejs:dev',
    //         'connect:livereload',
    //         'watch'
    //     ]);
    // });

};
