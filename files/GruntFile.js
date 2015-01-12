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

        'bower-install': {
            src: {
                html: '<%= config.src %>/index.html',
                ignorePath: '<%= config.src %>/'
            }
        },

        watch: {
            less: {
                files: ['<%= config.src %>/less/*.less'],
                tasks: ['less:dev'],
                options: {
                    spawn: false,
                    interrupt: true
                },
            },
            // livereload: {
            //     options: {
            //         livereload: '<%= connect.options.livereload %>'
            //     },
            //     files: [
            //         '<%= config.src %>/*.html',
            //         '.tmp/styles/{,*/}*.css',
            //         '{.tmp,<%= config.src %>}/scripts/{,*/}*.js',
            //         '<%= config.src %>/<%= config.images %>/{,*/}*.{gif,jpeg,jpg,png,svg,webp}'
            //     ]
            // }
        },

        connect: {
            options: {
                port: 9000,
                livereload: 35729,
                hostname: 'localhost' // '0.0.0.0' to access the server from outside
            },
            livereload: {
                options: {
                    open: true,
                    base: [
                        '.tmp',
                        '<%= config.src %>'
                    ]
                }
            },
            dist: {
                options: {
                    open: true,
                    base: '<%= config.dist %>',
                    livereload: false
                }
            }
        },

        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '<%= config.src %>/tmp',
                        '<%= config.src %>/dist',
                    ]
                }]
            },
            dev: '<%= config.src %>/tmp'
        },

        jshint: {
            options: {
                jshintrc: 'node_modules/grunt-contrib-jshint/.jshintrc',
                reporter: require('jshint-stylish')
            },
            all: [
                'Gruntfile.js',
                '<%= config.src %>/scripts/{,*/}*.js'
            ]
        },

        rev: {
            dist: {
                files: {
                    src: [
                        '<%= config.dist %>/scripts/{,*/}*.js',
                        '<%= config.dist %>/styles/{,*/}*.css',
                        '<%= config.dist %>/<%= config.images %>/{,*/}*.{gif,jpeg,jpg,png,webp}',
                        '<%= config.dist %>/fonts/{,*/}*.*'
                    ]
                }
            }
        },

        useminPrepare: {
            options: {
                dest: '<%= config.dist %>'
            },
            html: '<%= config.src %>/index.html'
        },

        usemin: {
            options: {
                assetsDirs: ['<%= config.dist %>']
            },
            html: ['<%= config.dist %>/{,*/}*.html'],
            css: ['<%= config.dist %>/styles/{,*/}*.css']
        },

        imagemin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= config.src %>/<%= config.images %>',
                    src: '{,*/}*.{gif,jpeg,jpg,png}',
                    dest: '<%= config.dist %>/<%= config.images %>'
                }]
            }
        },

        svgmin: {
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= config.src %>/<%= config.images %>',
                    src: '{,*/}*.svg',
                    dest: '<%= config.dist %>/<%= config.images %>'
                }]
            }
        },

        htmlmin: {
            dist: {
                options: {},
                files: [{
                    expand: true,
                    cwd: '<%= config.src %>',
                    src: '*.html',
                    dest: '<%= config.dist %>'
                }]
            }
        },

        copy: {
            dist: {
                src: '<%= config.src %>/dist/main.js',
                dest: '<%= config.src %>/main.js'
            }
        },

        concurrent: {
            dev: [
                'less:dev'
            ],
            dist: [
                'less:dist',
                'imagemin',
                'svgmin',
                'htmlmin'
            ]
        },

        modernizr: {
            'devFile': '<%= config.src %>/bower_components/modernizr/modernizr.js',
            'outputFile': '<%= config.dist %>/bower_components/modernizr/modernizr.js',
            files: [
                '<%= config.dist %>/scripts/{,*/}*.js',
                '<%= config.dist %>/styles/{,*/}*.css'
            ],
            'parseFiles': true,
            uglify: true
        },

        requirejs: {
            dev: {
                options: {
                    optimize: 'none',
                    preserveLicenseComments: true,
                    generateSourceMaps: true,
                    removeCombined: true,
                    allowSourceOverwrites: true,
                    useStrict: true,
                    baseUrl: '<%= config.src %>/scripts/<%= config.appName %>',
                    mainConfigFile: '<%= config.src %>/scripts/config-dev.js',
                    dir: '<%= config.src %>/tmp/',
                    keepBuildDir: true
                }
            },
            dist: {
                options: {
                    optimize: 'uglify',
                    preserveLicenseComments: false,
                    generateSourceMaps: false,
                    removeCombined: true,
                    useStrict: true,
                    baseUrl: '<%= config.src %>/scripts/<%= config.appName %>',
                    mainConfigFile: '<%= config.src %>/scripts/config-dist.js',
                    dir: '<%= config.dist %>/scripts',
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
                    '<%= config.src %>style.css': '<%= config.src %>/less/style.less'
                }
            },
            dist: {
                options: {
                    compress: true,
                    report: true
                },
                files: {
                    '<%= config.src %>style.css': '<%= config.src %>/less/style.less'
                }
            }
        }

    });

    // Tasks.
    grunt.registerTask('default', ['jshint', 'build']);

    grunt.registerTask('build', [
        'clean:dist',
        'useminPrepare',
        'concurrent:dist',
        'requirejs:dist',
        'modernizr',
        'copy:dist',
        'rev',
        'usemin'
    ]);

    grunt.registerTask('serve', function (target) {
        
        if (target === 'build') {
            return grunt.task.run(['build', 'connect:dist:keepalive']);
        }

        grunt.task.run([
            'clean:server',
            'concurrent:dev',
            'requirejs:dev',
            'connect:livereload',
            'watch'
        ]);
    });

};