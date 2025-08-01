# Stunning Banana Tree

### Nuzcraft participates in the RoguelikeDev subreddit tutorial series

Announcement post [here](https://old.reddit.com/r/roguelikedev/comments/1luh8og/roguelikedev_does_the_complete_roguelike_tutorial/). I'm starting a week or two behind, but I'm looking forward to the project.

I'm using [prism](https://github.com/PrismRL/prism), a new roguelike engine for LOVE. There is a game template that I'll be referencing to get started, but going to be building it up from scratch to help me learn.

# Dev Log

## Get started?

- following prism documentation and game template
- set up prism as a submodule (never done that before) since I expect it will be getting updates
- set up [stylua](https://github.com/JohnnyMorganz/StyLua) cause I've never done that before either
- setting up local debugging was a little big painful, but I was able to copy an old project where I figured it out before
- print a little hello world, learn more about supressing warnings from the language server, and we're gonna be good to start coding for real soon!
- welp.. I tried to backend my way into understanding some of template project structure, but I think I'll better understand it by pushing ahead into the tutorial and not getting fustrated for not understanding all the dependency stuff just yet

## Creating an enemy

- I'm glad I went the route of pushing ahead into the tutorial, there's a lot of cool things happening to deal with components and dependencies that I'm too smoothbrain to understand just yet
- I tried editing the mapbuilder to spawn a kobold in from the start just like spawning in the player, but it didn't work and I don't know why
- nvm, I figured it out. The Kobold didn't have a position component, so I couldn't set the position. Adding in the position component allowed it to be set by the mapbuilder
