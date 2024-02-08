# playground.nvim

Create temporary playgrounds effortlessly.

## Features

* Create scratch environments, configured to your liking
* Persistence defined by user
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

:Playground [ft] [name]

: Creates a new playground of file type [ft] with name [name]
If [ft] is not present, command prompts you for the file extension.
For example, if you wanted a python file, enter `py`
If no [name] is provided, the current time is used as the name

:PlaygroundSelect

: Opens an existing playground
Prompts user for specific playground to open

:PlaygroundDelete

: Deletes expired playgrounds
Expiration is defined by setup configuration {hours_to_live}. See [configuration](#configuration).
`:PlaygroundDelete` is attached, as an auto command, to `VimLeave`

:PlaygroundDeleteAll

: Deletes all playgrounds regardless of configs or file age

## Configuration

Playground.nvim comes with the following defaults

```lua
{  
  -- Aboslute path to where playgrounds are created and managed
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

## Contributing

PRs are always welcome. You are also welcome to create an issue for any features you want and your justification for it.

## Inspiration

Original inspiration comes from [LintaoAmons/scratch.nvim](https://github.com/LintaoAmons/scratch.nvim)
