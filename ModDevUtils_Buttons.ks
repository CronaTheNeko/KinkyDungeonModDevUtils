window.MDU = {
  Utils: {
    ListPage: 0,
    ButtonPadding: 15,
    Scrollable: {
      YStart: 200,
      ButtonWidth: 350,
      ButtonHeight: 64,
      Rows: 8,
      Columns: 2,
      Area: undefined,
      X: CanvasWidth / 2,
      Buttons: [
        {
          name: "GenerateModelTextKeys",
          click: () => { console.log(MDUGenerateTextKeysFromModels()) }
        },
        {
          name: "GetModFiles",
          click: () => { console.log(MDUGetModFiles()) }
        },
        {
          name: "GetFileOrder",
          click: () => { console.log(MDUGetFileOrderFiles()) }
        },
      ],
      MaxPage: function() {
        return Math.ceil(MDU.Utils.Scrollable.Buttons.length / MDU.Utils.Scrollable.Area) - 1
      }
    },
    Back: {
      name: "MDU_Back",
      func: () => { KinkyDungeonState = "Menu" },
      enabled: true,
      left: (CanvasWidth / 2) - (350 / 2),
      top: CanvasHeight - 64,
      width: 350,
      height: 64,
      label: "Back To Menu",
      color: "#ff66ff"
    },
  },
  KinkyDungeonRun: KinkyDungeonRun
}
MDU.Utils.Scrollable.Area = MDU.Utils.Scrollable.Rows * MDU.Utils.Scrollable.Columns
KinkyDungeonRun = function() {
  MDU.KinkyDungeonRun()
  if (KinkyDungeonState == "Menu") {
    DrawButtonKDEx("ModDevUtils", () => { console.log('[MDU] Main menu button clicked'); KinkyDungeonState = "MDU" }, true, 0, 0, 500, 100, 'MDU test', '#ff66ff')
  } else if (KinkyDungeonState == "MDU") {
    // Back button
    DrawButtonKDEx(MDU.Utils.Back.name, MDU.Utils.Back.func, MDU.Utils.Back.enabled, MDU.Utils.Back.left, MDU.Utils.Back.top - MDU.Utils.ButtonPadding, MDU.Utils.Back.width, MDU.Utils.Back.height, MDU.Utils.Back.label, MDU.Utils.Back.color)
    DrawTextKD("Mod Developer Utilities", CanvasWidth / 2, 50, "#66f", undefined, 48, "center")
    //Scrollable
    let x = CanvasWidth / 2
    let count = 0
    let xOffset = 0
    let buttons_vis = MDU.Utils.Scrollable.Buttons.slice(
      MDU.Utils.ListPage * MDU.Utils.Scrollable.Area,
      MDU.Utils.ListPage * MDU.Utils.Scrollable.Area + MDU.Utils.Scrollable.Area
      )
    // Conditionally display scroll buttons
    if (MDU.Utils.Scrollable.MaxPage() > 0) {
      DrawButtonKDEx('MDUListUp', (b) => {
        console.log(MDU.Utils.ListPage, MDU.Utils.Scrollable.MaxPage(), MDU.Utils.ListPage < MDU.Utils.Scrollable.MaxPage())
        if (MDU.Utils.ListPage > 0)
          MDU.Utils.ListPage -= 1
        else
          MDU.Utils.ListPage = MDU.Utils.Scrollable.MaxPage()
        return true
      }, true, MDU.Utils.Scrollable.X, 150, 90, 40, "", KDBaseWhite, KinkyDungeonRootDirectory + "Up.png")
      DrawButtonKDEx('MDUListDown', (b) => {
        if (MDU.Utils.ListPage < MDU.Utils.Scrollable.MaxPage())
          MDU.Utils.ListPage += 1
        else
          MDU.Utils.ListPage = 0
        return true
      }, true, MDU.Utils.Scrollable.X - (MDU.Utils.Scrollable.ButtonWidth / 8) + 5, CanvasHeight - 200, 90, 40, "", KDBaseWhite, KinkyDungeonRootDirectory + "Down.png")
    }
    // Draw each function button
    let y = MDU.Utils.Scrollable.YStart
    buttons_vis.forEach((button) => {
      DrawButtonKDEx(
        button.name,
        button.click,
        true,
        MDU.Utils.Scrollable.X + xOffset - MDU.Utils.Scrollable.ButtonWidth,
        y,
        MDU.Utils.Scrollable.ButtonWidth,
        MDU.Utils.Scrollable.ButtonHeight,
        TextGet("MDU_Shortcuts_" + button.name),
        button.color ? button.color : "#fff"
      )
      y += MDU.Utils.Scrollable.ButtonHeight + MDU.Utils.ButtonPadding
      count++
      if (count == MDU.Utils.Scrollable.Rows) {
        xOffset = MDU.Utils.Scrollable.ButtonWidth + MDU.Utils.ButtonPadding
        y = MDU.Utils.Scrollable.YStart
      }
    })
  }
}
