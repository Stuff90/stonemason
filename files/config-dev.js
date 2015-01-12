/*global requirejs*/

requirejs.config({

    paths: {

        'modernizr': '../../bower_components/modernizr/modernizr',
        'requirelib': '../../bower_components/requirejs/require',
        'jquery': '../../bower_components/jquery/dist/jquery'

    },

    shim: {},

    modules: [
        {
            namespace: 'main',
            name: 'main',
            create: true,
            include: [
                'modernizr',
                'requirelib',
                'jquery'
            ]
        }
    ]

});