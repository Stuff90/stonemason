
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


        combine_mq: {
            new_filename: {
                options: {
                    beautify: true
                },
                src: '<%= config.src %>dist/style.css',
                dest: '<%= config.src %>dist/style-mq.css'
            }
        },


        watch: {
            php: {
                files: ['<%= config.src %>templates/**/*.php'],
                options: {
                    livereload: true
                },
            },
            less: {
                files: ['<%= config.src %>less/**/*.less'],
                tasks: ['less:dev', 'concat:dev'],
                options: {
                    livereload: true,
                    spawn: false,
                    interrupt: true
                },
            },
            image: {
                files: ['<%= config.src %>res/img/**/*'],
                tasks: ['imagemin:dev', 'sprite:dev' ],
                options: {
                    spawn: false,
                    interrupt: true
                },
            },
            requirejs: {
                files: ['<%= config.src %>scripts/**/*.js'],
                tasks: ['requirejs:dev','copy:dev', 'jshint'],
                options: {
                    livereload: true,
                    interrupt: true,
                    forever: true,
                    spawn: true
                },
            },
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
                        '<%= config.src %>tmp',
                        '<%= config.src %>dist',
                        '<%= config.src %>main.js',
                        '<%= config.src %>main.js.map',
                        '<%= config.src %>res/public/*'
                    ]
                }]
            },
            dev: '<%= config.src %>tmp'
        },

        jshint: {
            options: {
                curly: true,
                eqeqeq: true,
                eqnull: true,
                browser: true,
                globals: {
                    jQuery: true
                },
            },
            all: ['<%= config.src %>scripts/<%= config.appName %>/**/*.js']
        },


        copy: {
            dev: {
                files: [
                    {
                        src: '<%= config.src %>tmp/main.js',
                        dest: '<%= config.src %>main.js'
                    },
                    {
                        src: '<%= config.src %>tmp/main.js.map',
                        dest: '<%= config.src %>main.js.map'
                    }
                ]
            },
            dist: {
                files: [
                    {
                        src: '<%= config.src %>dist/main.js',
                        dest: '<%= config.src %>main.js'
                    }
                ]
            }
        },

        concurrent: {
            dev: [
                'less:dev',
                'requirejs:dev'
            ],
            dist: [
                'imagemin:dist',
                'less:dist',
                'requirejs:dist'
            ]
        },

        modernizr: {
            'devFile': '<%= config.src %>bower_components/modernizr/modernizr.js',
            'outputFile': '<%= config.src %><%= config.dist %>/bower_components/modernizr/modernizr.js',
            files: [
                '<%= config.src %><%= config.dist %>/scripts/{,*/}*.js',
                '<%= config.src %><%= config.dist %>/styles/{,*/}*.css'
            ],
            'parseFiles': true,
            uglify: true
        },


        concat: {
            dev: {
                files: {
                    '<%= config.src %>style.css' : ['<%= config.src %>theme.info', '<%= config.src %>tmp/style.css'],
                    '<%= config.src %>main.js' : ['<%= config.src %>theme.info', '<%= config.src %>tmp/main.js']
                }
            },
            dist: {
                src: ['<%= config.src %>theme.info', '<%= config.src %>dist/style-mq.css'],
                dest: '<%= config.src %>style.css',
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
                    baseUrl: '<%= config.src %>scripts/<%= config.appName %>',
                    mainConfigFile: '<%= config.src %>scripts/config-dev.js',
                    out: '<%= config.src %>tmp/main.js',
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
                    baseUrl: '<%= config.src %>scripts/<%= config.appName %>',
                    mainConfigFile: '<%= config.src %>scripts/config-dist.js',
                    out: '<%= config.src %>dist/main.js',
                    keepBuildDir: true
                }
            }
        },


        imagemin: {
            dev : {
                options: {
                    optimizationLevel: 0,
                },
                files: [{
                    expand: true,
                    cwd: '<%= config.src %>res/img',
                    src: ['**/*.{png,jpg,jpeg,gif}'],
                    dest: '<%= config.src %>res/public/'
                }]
            },
            dist : {
                options: {
                    optimizationLevel: 7,
                },
                files: [{
                    expand: true,
                    cwd: '<%= config.src %>res/img',
                    src: ['**/*.{png,jpg,jpeg,gif}'],
                    dest: '<%= config.src %>res/public/'
                }]
            }
        },


        sprite: {
            dev : {
                src: ['<%= config.src %>res/public/sprite/*.png'],
                dest: '<%= config.src %>res/public/sprite.generated.png',
                destCss: '<%= config.src %>less/conf/sprite.generated.less',
                algorithm: 'binary-tree',
                padding: 5
            },
            dist : {
                src: ['<%= config.src %>res/public/sprite/*.png'],
                dest: '<%= config.src %>res/public/sprite.generated.png',
                destCss: '<%= config.src %>less/conf/sprite.generated.less',
                algorithm: 'binary-tree',
            }
        },



        less: {
            dev: {
                options: {
                    sourceMap: true
                },
                files: {
                    '<%= config.src %>tmp/style.css': '<%= config.src %>less/style.less'
                }
            },
            dist: {
                options: {
                    compress: true,
                    report: true
                },
                files: {
                    '<%= config.src %>dist/style.css': '<%= config.src %>less/style.less'
                }
            }
        }

    });


    grunt.registerTask('image', [
        'imagemin:dev',
        'sprite:dev',
    ]);


    grunt.registerTask('dev', [
        'concurrent:dev',
        'concat:dev',
        'copy:dev'
    ]);


    grunt.registerTask('server', [
        'dev',
        'image',
        'watch'
    ]);

    grunt.registerTask('build', [
        'clean:dist',
        'concurrent:dist',
        'sprite:dist',
        'modernizr',
        'combine_mq',
        'concat:dist',
        'copy:dist'
    ]);

};
