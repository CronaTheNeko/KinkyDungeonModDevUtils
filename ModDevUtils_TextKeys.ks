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
