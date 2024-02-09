# playground.nvim

Create temporary playgrounds effortlessly.

## Features

* Create scratch environments, configured to your liking
* Cleans itself up based on persistence defined by user ([configuration](#configuration) for more details)
  * never delete
  * delete after closing neovim
  * delete after `x` hours
* Optional integration with plugins:
  * telescope
* Run code with `michaelb/sniprun` (preferred) or `metakirby5/codi.vim`
  * working on an internal way to define how to run the whole file, without the need of another plugin

## Installation

Example installation is done using [lazy.nvim](https://github.com/folke/lazy.nvim).  
Plugin works out of the box. No configuration is required.

```lua
{  
  'CoderJoshDK/playground.nvim',
  cmds = {
    "Playground",
    "PlaygroundSelect",
    "PlaygroundDelete",
    "PlaygroundDeleteAll",
  }
}
```

## Commands

If possible, `telescope` is used, unless overridden by config. `telescope` is an optional dependency.

Basic commands:

| Command                | Args            | Description                                                                                                                                                                                                                                                        |
| ---------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `:Playground`          | `[ft]` `[name]` | Creates a new playground of file type `[ft]` with name `[name]`. If `[ft]` is not present, the command prompts you for the file extension. For example, if you wanted a python file, enter `py`. If no `[name]` is provided, the current time is used as the name. |  
| `:PlaygroundSelect`    | `nil`           | Opens an existing playground. Prompts user for specific playground to open.                                                                                                                                                                                        |
| `:PlaygroundSearch`    | `nil`           | Live grep search the files inside all playgrounds. (Requires telescope)                                                                                                                                                                                            |
| `:PlaygroundDelete`    | `nil`           | Deletes expired playgrounds. Expiration is defined by setup configuration `{hours_to_live}`. See [configuration](#configuration). `:PlaygroundDelete` is attached, as an auto command, on `VimLeave`.                                                              |
| `:PlaygroundDeleteAll` | `nil`           | Deletes all playgrounds regardless of configs or file age.                                                                                                                                                                                                         |

## Configuration

Playground.nvim comes with the following defaults

```lua
{  
  -- Absolute path to where playgrounds are created and managed
  -- The given example path is for MacOS, but the correct OS path will be used
  -- WARNING Must be an absolute path
  root_dir = "/Users/<user>/.cache/nvim/playground.nvim/", 
  -- When no `ft` is given to `scratch.open_playground`, use the following default extension
  default_ft = "txt",
  -- hours_to_live can be:
  -- * -1 : never delete files (unless `:PlaygroundDeleteAll` is ran)
  -- * n  : delete all playgrounds on `VimLeave`, after `n` hours since playground creation
  hours_to_live = -1,
  -- Add any file type extension that you want custom settings for
  ft = {
      txt = {
          -- lines of text to add to the top of the file
          lines = { "Quick Notes", os.date("%Y-%m-%d-%H:%M:%S") }
      },
      -- example of a python setup. But not set as a default
      -- py = {
      --     lines = { "import numpy", "print('hi')" }
      -- }
  },
  telescope = true, -- weather or not to use telescope (if available)
}
```

### Extra Configuration Details

<details>
  <summary>More info on `hours_to_live`</summary>

`hours_to_live` defines the minimum amount of hours for the created playground to exist for.
A created playground, will keep track of its creation time. When the user exits vim (`VimLeave`,) an auto command is ran.
The function ends up being the same as `:PlaygroundDelete`.
  
Some examples:

* If set to `0`; the playgrounds will be deleted as soon as you leave neovim.
* If set to `1`; if you create a playground at 12:20, and leave at 12:40, that playground will still exist.
    If you then come back at 15:30, the playground you created will still exist. Only until you leave again, will it now be deleted.
* If set to `-1`; your created playgrounds will not be automatically deleted.

</details>

<details>
  <summary>More info on `root_dir`</summary>
  The root directory must be an absolute path. The folder it points to, must not contain anything besides files and folders generated by this plugin.
  It is highly recommended that you leave this option alone.
</details>

## Contributing

PRs are always welcome. You are also welcome to create an issue for any features you want and your justification for it.

## Inspiration

Original inspiration comes from [LintaoAmons/scratch.nvim](https://github.com/LintaoAmons/scratch.nvim)
