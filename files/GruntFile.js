
/*jshint node:true*/

module.exports = function (grunt) {

    'use strict';

    require('time-grunt')(grunt);
    require('load-grunt-tasks')(grunt);


    var theConfig = {
        themeName: '#themeName#',
        appName: '#appName#',
        src: 'wp-content/themes/<%= config.themeName %>/',
        dist: 'dist',
        images: 'bin'
    };

    grunt.initConfig({

        config: theConfig,


    /*===========================================
    =            JavasScript Modules            =
    ===========================================*/


        /**
        *
        * Display JS lint output in the console
        *
        **/

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



        /**
        *
        * Use Modernizr library to clean Js & CSS files
        *
        **/

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




        /**
        *
        * Use RequireJS to handle project dependencies and build the final js production file
        *
        **/

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




    /*===================================================
    =            Style Modules (LESS OR CSS)            =
    ====================================================*/




        /**
        *
        * Run the LESS preprocessing
        *
        **/

        less: {
            dev: {
                options: {
                    sourceMap: true
                },
                files: {
                    '<%= config.src %>tmp/style.css': '<%= config.src %>less/style.less',
                    '<%= config.src %>tmp/style.admin.css': '<%= config.src %>less/style.admin.less'
                }
            },
            dist: {
                options: {
                    compress: true,
                    report: true
                },
                files: {
                    '<%= config.src %>dist/style.css': '<%= config.src %>less/style.less',
                    '<%= config.src %>dist/style.admin.css': '<%= config.src %>less/style.admin.less'
                }
            }
        },



        /**
        *
        * Display CSS lint output in the console
        *
        **/

        csslint: {
            strict: {
                options: {
                    import: 2
                },
                src: ['<%= config.src %>tmp/style.css']
            }
        },



        /**
        *
        * Combination of Media Queries at the bottom of the css file
        * Used to avoid multiple Meadia queries definition while keep the context in LESS files
        *
        **/

        combine_mq: {
            new_filename: {
                options: {
                    beautify: true
                },
                src: '<%= config.src %>dist/style.css',
                dest: '<%= config.src %>dist/style-mq.css'
            }
        },




        /**
        *
        * Concatenate the final CSS file with the theme info
        * Wordpress can now display theme info in the backend
        *
        **/

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






    /*=============================
    =            Watch            =
    =============================*/





        /**
        *
        * Declaration of automatically triggered tasks
        *
        **/

        watch: {
            php: {
                files: [
                    '<%= config.src %>templates/**/*.php',
                    '<%= config.src %>class/**/*.php',
                    '<%= config.src %>setup/*.php'
                ],
                options: {
                    livereload: true
                },
            },
            less: {
                files: ['<%= config.src %>less/**/*.less'],
                tasks: ['less:dev', 'concat:dev', 'copy:admin', 'csslint'],
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



    /*====================================
    =            Clean Module            =
    ====================================*/



        /**
        *
        * Remove all compiled files from the filetree
        *
        **/

        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '<%= config.src %>tmp',
                        '<%= config.src %>dist',
                        '<%= config.src %>main.js',
                        '<%= config.src %>main.js.map',
                        '<%= config.src %>style.admin.css',
                        '<%= config.src %>res/public/*'
                    ]
                }]
            },
            dev: '<%= config.src %>tmp'
        },





    /*===================================
    =            Copy Module            =
    ===================================*/



        /**
        *
        * Spread compiled files through WordPress filetree
        *
        **/

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
                    },
                    {
                        src: '<%= config.src %>tmp/style.admin.css',
                        dest: '<%= config.src %>style.admin.css'
                    }
                ]
            },
            admin: {
                files: [
                    {
                        src: '<%= config.src %>tmp/style.admin.css',
                        dest: '<%= config.src %>style.admin.css'
                    }
                ]
            },
            dist: {
                files: [
                    {
                        src: '<%= config.src %>dist/main.js',
                        dest: '<%= config.src %>main.js'
                    },
                    {
                        src: '<%= config.src %>dist/style.admin.css',
                        dest: '<%= config.src %>style.admin.css'
                    }
                ]
            }
        },




    /*=========================================
    =            Concurrent Module            =
    =========================================*/



        /**
        *
        * Define grunt command allowed to run at the same time
        *
        **/


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







    /*=====================================
    =            Image Modules            =
    =====================================*/



        /**
        *
        * Minifying images from the res/img directory to res/public
        *
        **/

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




        /**
        *
        * Compile images into unique sprite file
        * Does not minify the sprite file
        *
        **/

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



    /*===================================
    =            Open Module            =
    ===================================*/



        /**
        *
        * Open the home page of the project on dev environnement
        *
        **/

        open: {
            all: {
                path: 'http://com.<%= config.themeName %>'
            }
        },





    /*-----  End of Grunt config  ------*/
    });


    grunt.registerTask('image', [
        'imagemin:dev',
        'sprite:dev',
    ]);


    grunt.registerTask('dev', [
        'image',
        'concurrent:dev',
        'concat:dev',
        'copy:dev'
    ]);


    grunt.registerTask('server', [
        'image',
        'dev',
        'open',
        'watch'
    ]);

    grunt.registerTask('build', [
        'imagemin:dist',
        'sprite:dist',
        'clean:dist',
        'concurrent:dist',
        'sprite:dist',
        'modernizr',
        'combine_mq',
        'concat:dist',
        'copy:dist'
    ]);

};
