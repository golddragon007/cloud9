// Add a custom top-level menu to the menu bar.
// Add commands and dividers to this menu.
var menuCaption = "CloudKit"; // Menu caption.
var menus = services["menus"]; // Access the menu bar.
var MenuItem = services.MenuItem; // Use this to create a menu item.
var Divider = services.Divider; // Use this to create a menu divider...
var fs = services["fs"];

// Set the top-level menu caption.
menus.setRootMenu(menuCaption, 900, plugin);

menus.addItemByPath(menuCaption + "/Docker", new MenuItem({}), 100, plugin);

menus.addItemByPath(menuCaption + "/Docker/Generate dokcer-compose.yml", new MenuItem({
  onclick: generateDockerComposeFile
}), 100, plugin);

menus.addItemByPath(menuCaption + "/Test", new MenuItem({
  onclick: test
}), 100, plugin);


function getArgs(func) {
  // First match everything inside the function argument parens.
  var args = func.toString().match(/function\s.*?\(([^)]*)\)/)[1];

  // Split the arguments string into an array comma delimited.
  return args.split(',').map(function(arg) {
    // Ensure no inline comments are parsed and trim the whitespace.
    return arg.replace(/\/\*.*\*\//, '').trim();
  }).filter(function(arg) {
    // Ensure no undefined values are added.
    return arg;
  });
}

function test() {
  services["dialog.info"].show("Results")
}

function generateDockerComposeFile() {
  const DOCKER_COMPOPOSE_SRC="~/environment/cloud9/conf.default/CloudKit/docker/docker-compose.yml"
  console.log(services)
  // Create a file dialog.
  var fileDialog = services["dialog.file"];

  fileDialog.show(
    "Specify the file name and choose a path",
    "docker-compose.yml",
    function() {
      fileDialog.hide();
      filepath = "~/environment/" + fileDialog.directory + "/" + fileDialog.filename
      fs.exists(filepath, (exists) => {
        if (exists) {
          services["dialog.fileoverwrite"].show(
            "Cannot create file",
            "Overwrite ?",
            "The target file '" + filepath + "' already exist",
            function() {
              copyAndOpenFile(DOCKER_COMPOPOSE_SRC, filepath)
            },
            function() {
              return
            }, {}
          );
        } else {
          copyAndOpenFile(DOCKER_COMPOPOSE_SRC, filepath)
        }
      });
    },
    function() {
      // User chose the Cancel button.
      //services["dialog.alert"].show("Results", "File info", "You chose Cancel.");
      //fileDialog.hide();
    }

  );
}

function copyAndOpenFile(source, target) {
  var path = require('path');
  var filename = path.basename(target);

  fs.copy(source, target, err => {
    if (err) {
      console.log(err)
      return
    }
    services["dialog.info"].show("File '" + filename + "' copied", 1000)
    targetFile = services.tabManager.openFile(target)
    services.tabManager.focusTab(targetFile)
    services.openfiles.refresh()

    // services.openPath.open({'path' : "~/environment/" + fileDialog.directory})
    services.tree.refresh()

  });
}