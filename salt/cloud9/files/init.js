// Add commands and dividers to this menu.
var menuCaption = "CloudKit"; // Menu caption.
var menus = services["menus"]; // Access the menu bar.
var MenuItem = services.MenuItem; // Use this to create a menu item.
var Divider = services.Divider; // Use this to create a menu divider...
var fs = services["fs"];

// Set the top-level menu caption.
menus.setRootMenu(menuCaption, 900, plugin);

// -- CloudKitMenu Configure --
menus.addItemByPath(menuCaption + "/Configure", new MenuItem({}), 50, plugin);
menus.addItemByPath(menuCaption + "/Configure/Install docker profile", new MenuItem({
  onclick: runSaltCall.bind(null, "profiles.docker")
}), 100, plugin);
menus.addItemByPath(menuCaption + "/Configure/Install lamp profile", new MenuItem({
  onclick: runSaltCall.bind(null, "profiles.lamp")
}), 101, plugin);
menus.addItemByPath(menuCaption + "/Configure/Configure git", new MenuItem({
  onclick: configGit
}), 102, plugin);

// -- CloudKitMenu Docker --
menus.addItemByPath(menuCaption + "/Docker", new MenuItem({}), 100, plugin);

menus.addItemByPath(menuCaption + "/Docker/Generate dokcer-compose.yml", new MenuItem({
  onclick: generateDockerComposeFile
}), 100, plugin);


//--------------------//
// Callback function  //
//--------------------//

function runSaltCall(state, param = {}) {
  cmd = ["sudo", "salt-call", "state.apply", state, "-l", "info"]
  if (param.length > 0) {
    cmd = cmd.concat(param)
  }
  cmmd = cmd.join(' ')

  fs.writeFile("/tmp/run.sh", cmmd, function(err) {
    if (err) console.error(err);
    fs.chmod("/tmp/run.sh", "755", function() {
      var runner = {
        "cmd": ["/home/ec2-user/environment/tmp/run.sh", "rm /home/ec2-user/environment/tmp/run.sh"],
        "info": "Started `" + cmmd + "`",
        "env": {},
        "selector": "",
        "title": "runner title"
      }
      var optionTab = {
        editorType: "output",
        active: true,
        demandExisting: true,
        document: {
          title: "My Process Name",
          output: {
            id: "name_of_process"
          }
        }
      }
      if (pane = services["tabManager"].findPane("pane1")) {
        optionTab['pane'] = pane
      }

      // Open output tab
      services["tabManager"].open(optionTab, function() {});

      // Start runner
      process = services["run"].run(runner, {}, "name_of_process", function(err) {
        if (err) throw err;
      })
    })
  })
}

function configGit() {
  var Form = services.Form;
  var myForm = new Form({
    title: "My Title",
    name: "myForm",
    form: [{
        title: "Git commit username",
        name: "user",
        type: "textbox",
        message: "John doe",
        realtime: true
      },
      {
        title: "Git commit mail",
        name: "mail",
        type: "textbox",
        message: "john.doe@mail.com",
        realtime: true,
        style: "height:50px;"
      },
      {
        name: "mySubmit",
        type: "submit",
        caption: "Submit",
        onclick: mySubmitOnClick,
        default: false,
        margin: "25 0 0 0"
      }
    ]
  });

  services['ui'].insertCss("div.dialog div.bk-container .hsplitbox{height: 50px !important;}" +
    ".label { color: #222; } " +
    ".spinner .divfix input {color: #222;}", plugin);

  var Dialog = services.Dialog;
  var myDialog = new Dialog("AWS Cloud9", [], {
    allowClose: true,
    title: "Configure git"
  });

  myDialog.on("draw", function(e) {
    myForm.attachTo(e.html);
  });
  myDialog.show();

  function mySubmitOnClick() {
    values = myForm.toJson()
    myDialog.hide();
    var pi = JSON.stringify({
      "git": {
        "username": values["user"].trim(),
        "mail": values["mail"].trim()
      }
    });
    var option = [
      'pillar=' + '\'' + pi + '\''
    ]
    runSaltCall("config.git", option)
  }
}

function generateDockerComposeFile() {
  const DOCKER_COMPOPOSE_SRC = "~/environment/.c9/docker/docker-compose/docker-compose-all.yml"
  console.log(services)
  // Create a file dialog.
  var fileDialog = services["dialog.file"];

  fileDialog.show(
    "Specify the file name and choose a path",
    "docker-compose.yml",
    function() {
      fileDialog.hide();
      var filepath = "~/environment/" + fileDialog.directory + "/" + fileDialog.filename
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
    function() {}
  );
}


//-----------------//
// Utils function  //
//-----------------//

function updateInitScript(string) {
  return services["settings"].setJson("user/config/init.js", string)
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