// A custom top-level menu to the menu bar.


// Add commands and dividers to this menu.
var menuCaption = "CloudKit"; // Menu caption.
var menus = services["menus"]; // Access the menu bar.
var MenuItem = services.MenuItem; // Use this to create a menu item.
var Divider = services.Divider; // Use this to create a menu divider...
var fs = services["fs"];

// Set the top-level menu caption.
menus.setRootMenu(menuCaption, 900, plugin);


menus.addItemByPath(menuCaption + "/Configure", new MenuItem({}), 50, plugin);
menus.addItemByPath(menuCaption + "/Configure/Install docker profile", new MenuItem({
  onclick: installProfile.bind(null, "docker")
}), 100, plugin);
menus.addItemByPath(menuCaption + "/Configure/Install lamp profile", new MenuItem({
  onclick: installProfile.bind(null, "lamp")
}), 101, plugin);


//-----------------//
// Menu function   //
//-----------------//

function installProfile (profile){
  cmd = ["sudo","salt-call","state.apply","profiles." + profile,"--local","-l", "info"]
  
  var runner={
      "cmd": cmd,
      "info": "Started `" + cmd.join (' ') + "`",
      "env": {},
      "selector": ""
  }
  var optionTab = {
    editorType : "output", 
    active     : true,
    demandExisting : true,
    title  : "Install profile",
    document   : {output : {id : "salt"}}
  }
  if (pane = services["tabManager"].findPane( "pane1" )){
    optionTab['pane'] = pane
  }
  // Start runner
  process = services["run"].run (runner,{},"salt", function(err) {
    if (err) throw err;
    // Open output tab
    services["tabManager"].open(optionTab, function(){});
  })
}



//-----------------//
// Utils function  //
//-----------------//

function updateInitScript(string){
  return services["settings"].setJson("user/config/init.js",string)
}

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
