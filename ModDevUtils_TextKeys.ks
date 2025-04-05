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
  // Helper function to construct layer names
  function layerKey(model, layer) {
    return "m_" + model + "_l_" + layer
  }
  // Loop all mod models
  for (var key in window.MDUModels) {
    // If the base model name isn't in known_keys, add it to output storage
    if (!known_keys.hasOwnProperty("m_" + key))
      MDUTextKeys["m_" + key] = "BOGUS"
    // Loop all of the current model's layers
    for (var layer in window.MDUModels[key].Layers) {
      // If this layer's name isn't in known_keys, add it to output storage
      if (!known_keys.hasOwnProperty(layerKey(key, layer)))
        MDUTextKeys[layerKey(key, layer)] = "BOGUS"
    }
  }
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
    return true
  }
  // Loop through each mod file and decide whether or not to add it
  for (var file in KDModFiles) {
    if (addfile(file) && !known_files.includes(file)) {
      MDUModFiles.push(file)
    }
  }
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
    if (file == "ModDevUtils_TextKeys.ks") // This script
      return false
    return true
  }
  for (var file of KDAllModFiles) {
    if (addfile(file.filename) && !known_files.includes(file.filename)) {
      MDUAllModFiles.push(file.filename)
    }
  }
}
// END ModFiles
