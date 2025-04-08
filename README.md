# Mod Dev Utils
A set of utility functions to help you develop mods. Currently fairly small, but will grow as I find more uses and suggestions are made.

What's currently included?
- AddModel function override
- MDUGenerateTextKeysFromModels function
- MDUGetModFiles function
- MDUGetFileOrderFiles function

## AddModel Function Override
This function overrides the vanilla `AddModel` so that all models added by mods will be seen and recorded by this function before they are added to the game via the vanilla AddModel function.

Usage: Exactly the same as the vanilla `AddModel`, including the optional second parameter

Effect: Stores each model given into `MDUModels` for use by `MDUGenerateTextKeysFromModels`, then passes the model to the original `AddModel` function

## MDUGenerateTextKeysFromModels
This function goes through all models added by mods and pieces together the text keys required for adding names to those models and their layers. Also checks for new wardrobe categories and returns a placeholder key for those as well.

Usage: With no parameters, this function will return all generated text keys. If you need to update your text keys, you can pass a dictionary object containing all your known text keys and this function will return the new ones.

Effect: Returns a dictionary with each text key being a key/property, and the value for that property set to "BOGUS". The value for each of these keys is a placeholder and should be replaced with the text you desire. This dictionary is also saved in `MDUTextKeys` if you need to retrieve it later.

### How to use MDUGenerateTextKeysFromModels return value?
As an example of how to utilize this return value, you can use the following:
```
const textKeys = { ... }
for (var key in textKeys) {
  addTextKey(key, textKeys[key])
}
```
Paste in the object from `MDUGenerateTextKeysFromModels` into `textKeys` and edit the value for each of the keys in that object, and you'll be good to go on model and layer names.

## MDUGetModFiles
This function returns all mod asset files, useful for preloading lots of assets or defining a mod.json `fileorder` array.

Usage: With no parameters, this function will return all mod assets. If you need to update your asset list, you can pass an array of known asset paths and this function will return the new ones.

Effect: Returns an array of all asset files found loaded by mods. This array is also save in `MDUModFiles` if you need to retrieve it later.

Note: This function does NOT return `.js` or `.ks` files, as they are not listed in `KDModFiles`, and as such this function's return is not fully ready for use in mod.json. See [MDUGetFileOrderFiles](#mdugetfileorderfiles) for making a `fileorder` array for mod.json.

### How to use MDUGetModFiles return value for asset loading?
As an example of how to utilize this return value, you can use the following:
```
const assets = [ ... ]
for (var file of assets) {
  try {
    PIXI.Texture.fromURL(KDModFiles[file])
  } catch (error) {
    console.error("Failed to load asset " + file + " !", error)
  }
}
```
Paste in the array from `MDUGetModFiles` into `assets` and this code will attempt to preload your assets while not risking crashing the game if anything goes wrong with PIXI

## MDUGetFileOrderFiles
This function returns all mod files that should be placed in a `fileorder` array for your mod's `mod.json`. Unlike `MDUGetModFiles`, this function includes `.js` and `.ks` files.

Usage: With no parameters, this function will return all mod files relevant to a `fileorder` array. If you need to update your file list, you can pass an array of known file paths and this function will return the new ones.

Effect: Returns an array of all mod files to be added to the `fileorder` array in your mod.json file. This array is also saved in `MDUAllModFiles` if you need to retrieve it later.

### How to use MDUGetFileOrderFiles return value?
The array returned includes all relevant mod files in the order they were loaded by the game. If this ordering works fine, there's technically no need to define `fileorder` in your mod.json. However, if you need to change this order, simply copy out the array returned, change the order to how you like/need it to be, and save that array in the `fileorder` property of your mod.json
