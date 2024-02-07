# Things I plan to implement (or at least try to)

- [ ] If telescope is available, use it for `PlaygroundSelect`
- [ ] Special instructions for construction of workspace and build for running code
  - While I expect most of the time, to just use a code runner, some special instructions might be wanted.
  - Copy how zen-mode handles for when you leave the space (in this case, leave the playground) and track if you are in a playground. If you are, and a `PlaygroundBuild` is triggered, use custom build settings.
- [ ] `PlaygroundDeleteSpecific` that lets you select a workspace to delete, and not just `PlaygroundDeleteAll`
- [ ] A visual mode playground option. Where running `:Playground` in visual mode, will bring that text into a new playground. Automatically detecting file type and all other needed info
