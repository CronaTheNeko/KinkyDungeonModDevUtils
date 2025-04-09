// BEGIN Model and Layer text keys
// Save base game's AddModel function
window.MDUVanillaAddModel = AddModel
// Override game's AddModel function
window.AddModel = function(model, strings) {
  // If this is the first call of this function, we need to setup our model storage area
  if (window.MDUModels == undefined)
    window.MDUModels = {}
  // Save the model being declared for later use
  window.MDUModels[model.Name] = model
  // Call the base game's AddModel function
  MDUVanillaAddModel(model, strings)
}
// As the name implies, reads all the models made by mods and returns the needed text keys
window.MDUGenerateTextKeysFromModels = function(known_keys) {
  // If known_keys wasn't given by the user, declare it to an empty object to avoid erroring out
  if (known_keys == undefined)
    known_keys = {}
  // Reset our text key output storage
  window.MDUTextKeys = {}

  // Check for new wardrobe categories
  let new_cats = KDWardrobeCategories.filter((v) => {
    const key = "cat_" + v;
    if (TextGet(key) == key)
      return true
  })
  new_cats.forEach((v) => { MDUTextKeys["cat_" + v] = v; })

  // Helper function to construct layer names
  function layerKey(model, layer) {
    return "m_" + model + "_l_" + layer
  }
  // Loop all mod models
  for (var key in window.MDUModels) {
    // If the base model name isn't in known_keys, add it to output storage
    if (!known_keys.hasOwnProperty("m_" + key))
      MDUTextKeys["m_" + key] = key
    // Loop all of the current model's layers
    for (var layer in window.MDUModels[key].Layers) {
      // If this layer's name isn't in known_keys, add it to output storage
      if (!known_keys.hasOwnProperty(layerKey(key, layer)))
        MDUTextKeys[layerKey(key, layer)] = layer
    }
  }
  // Info Modal
  let keysStr = "{\n"
  for (var key in MDUTextKeys) {
    keysStr += "  \"" + key + "\": \"" + MDUTextKeys[key] + "\",\n"
  }
  keysStr += "}"
  const modalStr = `// You probably want to change the value for each of these keys
const textKeys = ${keysStr}
for (var key in textKeys) {
  if (TextGet(key) == key)
    addTextKey(key, textKeys[key])
}`
  MDUShowOutputModal(modalStr, [ "Here's some generated code for adding your outfit text keys to the game. You likely want to change the value for each generated key." ])
  // Return output storage to user for easier use
  return MDUTextKeys
}
// END Model and Layer text keys

// BEGIN ModFiles
// Returns a list of assets loaded by mods
// NOTE: This function does NOT return .js or .ks files in the array
window.MDUGetModFiles = function(known_files) {
  // Make sure known_files isn't undefined
  if (known_files == undefined)
    known_files = []
  // Reset ModFiles
  window.MDUModFiles = []
  // Helper function to easily add file exclusions
  function addfile(file) {
    if (file.startsWith("http"))
      return false
    if (file.startsWith("Game"))
      return false
    if (file.includes("mod.json"))
      return false
    if (file.endsWith("/"))
      return false
    return true
  }
  // Loop through each mod file and decide whether or not to add it
  for (var file in KDModFiles) {
    if (addfile(file) && !known_files.includes(file)) {
      MDUModFiles.push(file)
    }
  }
  // Info Modal
  let filesStr = "[\n"
  for (var file of MDUModFiles) {
    filesStr += "  \"" + file + "\",\n"
  }
  filesStr += "]"
  const modalStr = `const assets = ${filesStr}
for (var file of assets) {
  try {
    PIXI.Texture.fromURL(KDModFiles[file])
  } catch (error) {
    console.error("Failed to load asset " + file + " !", error)
  }
}`
  MDUShowOutputModal(modalStr, [ "Here's some generated code for preloading your textures. Save this into a script and it *should* preload your textures, assuming your file order is such that the texture files are loaded before your scripts execute." ])
  // Return found files
  return MDUModFiles
}
// Returns all mod files that should be put in fileorder in mod.json
window.MDUGetFileOrderFiles = function(known_files) {
  if (known_files == undefined)
    known_files = []
  window.MDUAllModFiles = []
  function addfile(file) {
    if (file == "mod.json") // KD mod mod.json
      return false
    if (file.endsWith(".md")) // Markdown files
      return false
    if (file.endsWith("/")) // Directory
      return false
    if (file == "ModDevUtils_TextKeys.ks") // This script
      return false
    if (file.startsWith("ModDevUtils_")) // This mod's files
      return false
    return true
  }
  for (var file of KDAllModFiles) {
    if (addfile(file.filename) && !known_files.includes(file.filename)) {
      MDUAllModFiles.push(file.filename)
    }
  }
  MDUAllModFiles.sort((a, b) => {
    var ar = a.endsWith(".ks") || a.endsWith(".js")
    var br = b.endsWith(".ks") || b.endsWith(".js")
    if (ar && br)
      return 0
    if (ar)
      return 1
    if (br)
      return -1
  })
  // Info Modal
  let filesStr = "[\n"
  for (var file of MDUAllModFiles) {
    filesStr += "    \"" + file + "\",\n"
  }
  filesStr += "  ],"
  const modalStr = `"fileorder": ${filesStr}`
  MDUShowOutputModal(modalStr, [ "Here's some generated code to add to your mod.json. The order of this \"fileorder\" is the order that the game loaded them in and you may need to reorder them to get everything working properly." ])
  //
  return MDUAllModFiles
}
// END ModFiles

// BEGIN Modal Dialogue for displaying usable code from helpers
// Based on the vanilla crash handler buttons (KinkyDungeonErrorModalButton)
window.MDUModalButton = function(text) {
  const button = document.createElement("button");
  button.textContent = text;
  Object.assign(button.style, {
    fontSize: "1.25em",
    padding: "0.5em 1em",
    backgroundColor: KDButtonColor,
    border: `2px solid #ff66ff`, //${KDBorderColor}`,
    color: KDBaseWhite,
    cursor: "pointer",
  });
  return button;
}
// Based on the vanilla crash handler modal (KinkyDungeonShowCrashReportModal)
window.MDUShowOutputModal = function(report, desc) {
  if (desc == undefined)
    desc = [ "Here's the example code for the info gathered. ", "I have tried to make this example code usable as is, but it may need some tweaking or values set in order to work as expected." ]
  const id = "mod-dev-utils-modal"; // "kinky-dungeon-crash-report";

  if (document.querySelector(`#${id}`)) {
    return;
  }

  const backdrop = document.createElement("div");
  backdrop.id = id;
  Object.assign(backdrop.style, {
    position: "fixed",
    inset: 0,
    backgroundColor: "#000000a0",
    fontFamily: "'Arial', sans-serif",
    fontSize: "1.8vmin",
    lineHeight: 1.6,
  });

  const modal = document.createElement("div");
  Object.assign(modal.style, {
    position: "absolute",
    display: "flex",
    flexFlow: "column nowrap",
    width: "90vw",
    maxWidth: "1440px",
    maxHeight: "90vh",
    overflow: "hidden",
    backgroundColor: "#282828",
    color: "#fafafa",
    left: "50%",
    top: "50%",
    transform: "translate(-50%, -50%)",
    padding: "1rem",
    borderRadius: "2px",
    boxShadow: "1px 1px 40px -8px #ffffff80",
  });
  backdrop.appendChild(modal);

  const heading = document.createElement("h1");
  Object.assign(heading.style, {
    display: "flex",
    flexFlow: "row nowrap",
    alignItems: "center",
    justifyContent: "space-around",
    textAlign: "center",
  });
  heading.appendChild(KinkyDungeonErrorImage("WolfgirlPet"));
  heading.appendChild(KinkyDungeonErrorImage("Wolfgirl"));
  heading.appendChild(KinkyDungeonErrorImage("WolfgirlPet"));
  heading.appendChild(document.createTextNode("Mod Dev Utils Info"));
  heading.appendChild(KinkyDungeonErrorImage("WolfgirlPet"));
  heading.appendChild(KinkyDungeonErrorImage("Wolfgirl"));
  heading.appendChild(KinkyDungeonErrorImage("WolfgirlPet"));
  modal.appendChild(heading);

  const hr = document.createElement("hr");
  Object.assign(hr.style, {
    border: `1px solid #ff66ff`, //${KDBorderColor}`,
    margin: "0 0 1.5em",
  });
  modal.appendChild(hr);

  // modal.appendChild(KinkyDungeonErrorPreamble([
  //   "Here's the example code for the info gathered. ",
  //   "I have tried to make this example code usable as is, but it may need some tweaking or values set in order to work as expected.",
  // ]));
  modal.appendChild(KinkyDungeonErrorPreamble(desc))
  modal.appendChild(KinkyDungeonErrorPreamble([
    "Below is hopefully working code.",
  ]));

  const pre = document.createElement("pre");
  Object.assign(pre.style, {
    flex: 1,
    backgroundColor: "#1a1a1a",
    border: "1px solid #ffffff40",
    fontSize: "1.1em",
    padding: "1em",
    userSelect: "all",
    overflowWrap: "anywhere",
    overflowX: "hidden",
    overflowY: "auto",
    color: "#ffbbff", //KDBorderColor,
  });
  pre.textContent = `${report}`;
  modal.appendChild(pre);

  const buttons = document.createElement("div");
  Object.assign(buttons.style, {
    display: "flex",
    flexFlow: "row wrap",
    justifyContent: "flex-end",
    gap: "1em",
  });
  modal.appendChild(buttons);

  const copyButton = MDUModalButton("Copy to clipboard");
  copyButton.addEventListener("click", () => {
    KinkyDungeonErrorCopy(report, pre)
      .then(copied => {
        copyButton.textContent = copied ? "Awoo!" : "Failed";
      })
      .catch(() => void 0);
  });
  buttons.appendChild(copyButton);

  const closeButton = MDUModalButton("Close");
  closeButton.addEventListener("click", () => {
    backdrop.remove();
  });
  buttons.appendChild(closeButton);

  document.body.appendChild(backdrop);
}
// END Modal Dialogue
