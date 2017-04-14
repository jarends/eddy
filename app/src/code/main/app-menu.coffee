electron = require 'electron'
app      = electron.app
Menu     = electron.Menu
Dialog   = electron.dialog


class AppMenu


    constructor: (@ctx) ->
        @init()


    init: () ->

        Menu.setApplicationMenu Menu.buildFromTemplate [

            id: 'eddy'
            label: 'eddy'
            submenu: [
                label:       'About eddy'
                id:          'about'
                accelerator: 'CmdOrCtrl+.'
                click:       @clickHandler
            ,
                type: 'separator'
            ,
                label:       'Hide eddy'
                id:          'hide'
                accelerator: 'Command+H'
                role:        'hide'
            ,
                label:       'Hide Others'
                id:          'hide-others'
                accelerator: 'Command+Alt+H'
                role:        'hideothers'
            ,
                type: 'separator'
            ,
                label:       'Toggle Dev-Tools'
                id:          'toggle-dev-tools'
                accelerator: 'Alt+CmdOrCtrl+I'
                click:       @clickHandler
            ,
                label:       'Reload'
                id:          'reload'
                accelerator: 'CmdOrCtrl+R'
                click:       @clickHandler
            ,
                type: 'separator'
            ,
                label:       'Quit'
                id:          'quit'
                accelerator: 'Command+Q'
                click:       @clickHandler
            ]
        ,
            id: 'file'
            label: 'File'
            submenu: [
                label:       'Open File'
                id:          'open-file'
                accelerator: 'CmdOrCtrl+o'
                click:       @clickHandler
            ,
                type: 'separator'
            ]
        ]


    showAddFolderDialog: () ->
        opts =
            title:       'add folder'
            defaultPath: @ctx.store.get 'lastFolderPath'
            properties: [
                'openDirectory'
                'showHiddenFiles'
            ]

        Dialog.showOpenDialog opts, (filePaths) =>
            if filePaths
                path = filePaths[0]
                @ctx.folders.addFolder path
                @ctx.store.set 'lastFolderPath', path
        null




    clickHandler: (item, win) =>
        console.log 'menu item clicked: ', item.id
        switch item.id
            when 'reload'           then win.webContents.reloadIgnoringCache()
            when 'toggle-dev-tools' then win.webContents.toggleDevTools()
            when 'quit'             then app.quit()
            when 'add-folder'       then @showAddFolderDialog()


module.exports = AppMenu
