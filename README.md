# Mod Dev Utils
A set of utility functions to help you develop mods. Currently fairly small, but will grow as I find more uses and suggestions are made.

What's currently included?
- AddModel function override
- MDUGenerateTextKeysFromModels function

## AddModel Function Override
This function overrides the vanilla `AddModel` so that all models added by mods will be seen and recorded by this function before they are added to the game via the vanilla AddModel function.

Usage: Exactly the same as the vanilla `AddModel`, including the optional second parameter

Effect: Stores each model given into `MDUModels` for use by `MDUGenerateTextKeysFromModels`, then passes the model to the original `AddModel` function

## MDUGenerateTextKeysFromModels
This function goes through all models added by mods and pieces together the text keys required for adding names to those models and their layers.

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