# Ori's Mouse ToolTip (OMTT)

A World of Warcraft (WoW) Classic Hardcore addon designed to enhance tooltip positioning and visual customization. Built using the Ace3 library for streamlined development and modular functionality.

---

## Features

- **Custom Tooltip Positioning**: Adjust the tooltip position relative to your cursor.
- **Class-Based Coloring**: Dynamically color tooltips based on the player's class.
- **Debugging Support**: Toggle debugging for detailed logs.
- **Reset to Defaults**: Restore settings quickly and easily.

---

## Installation

1. Download the latest release from the [Releases](https://github.com/Oricul/WoW_OMTT/releases) page.
2. Extract the `.zip` file into your `World of Warcraft/_classic_era_/Interface/AddOns/` directory.
3. Ensure the folder is named `OMTT` to load the addon correctly.

---

## Usage

OMTT offers several slash commands to interact with its features. Type `/omtt` in-game to access settings or execute commands.

### Slash Commands

| Command                      | Description                                                                                              |
|------------------------------|----------------------------------------------------------------------------------------------------------|
| `/omtt`                      | Opens the settings interface.                                                                           |
| `/omtt help`                 | Displays all available commands.                                                                        |
| `/omtt debug`                | Toggles debugging mode on or off.                                                                       |
| `/omtt offset <x or y> <value>` | Adjusts the tooltip's X or Y offset. Example: `/omtt offset x 50`.                                       |
| `/omtt anchor <anchor>`      | Sets the tooltip's anchor point. Valid options: `TOPLEFT`, `TOP`, `CENTER`, `ANCHOR_CURSOR`, etc.       |
| `/omtt colorize`             | Toggles class-based tooltip coloring.                                                                   |

---

## Options

OMTT integrates with the Ace3 configuration system and can be customized via the in-game settings menu:

1. Open **Game Menu** > **Options** > **AddOns**.
2. Select **Ori's Mouse ToolTip**.
3. Modify settings such as tooltip anchor, offsets, and class colorization.

---

## Language Support

OMTT supports multiple languages, including:
- English
- Simplified Chinese
- Korean
- Japanese
- Spanish
- French
- German

> **Note**: All translations are AI-generated and may require fine-tuning. If you notice any errors or inaccuracies, feel free to open an issue or submit a pull request.

---

## Dependencies

OMTT requires the Ace3 library, which is included in the `Libs` folder. [Ace3 LICENSE](Libs/Ace3/LICENSE.txt)

---

## Contributing

We welcome contributions to improve OMTT! To get started:
1. Fork the repository.
2. Make your changes.
3. Submit a pull request with a detailed description of your changes.

---

## License

OMTT is licensed under [GPL-3.0](LICENSE).

---

### Acknowledgements

Special thanks to the [Ace3](https://github.com/WoWUIDev/Ace3) development team and the World of Warcraft addon community for providing the tools and inspiration to make this addon possible.

Additional thanks to [TTOM by rakkarage](https://github.com/rakkarage/TTOM) and [Simple Mouse Tooltip by Bakatrinh](https://www.curseforge.com/wow/addons/simplemousetooltip) for the inspiration and starting point.
