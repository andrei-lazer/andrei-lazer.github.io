---
title: Thoughts on Neovim
date: 2025-12-26 
tags:
    - posts
    - fun
---

I use [Neovim](https://neovim.io/) btw, and this is a blog post about it.

## TLDR: use vim motions, and here's my config
I think everyone should learn vim motions. For the amount of time it takes to learn (maybe a week if
you're a full-time dev?), it will save you so much time and frustration. Even if you're still an
Eclipse fan in 2025, I'd highly recommend learning the basics of vim motions.

Also, here's my [Neovim config](https://github.com/andrei-lazer/dotfiles/tree/main/.config/nvim).

Read on if you're really interested in my very generic opinions on Neovim.

## Neovim vs vim
I use Neovim over vim because I prefer lua over vimscript, and there are a lot of Neovim-only
plugins. Unless you're really into some weird niche thing vim has kept since 1976, I'd recommend you
also use Neovim.

## Why not VSCode?

The main reason I use Neovim over VSCode is (surprise surprise) the customizability. Its entire
design philosophy is built around the idea that every part of the editor should be modifiable and
extensible. Neovim in particular uses lua as its scripting language, which means if you're able to
code something in lua, you can get it to run in your editor.

Also, Neovim (can) very nicely follow the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).
As a very picky person, I much prefer being able to pick separate tools. For example, VSCode all but
forces you to use their terminal, but Neovim has great interoperability with [tmux](https://github.com/tmux/tmux/wiki).

If you know you're not into messing with config files for ages or optimizing your keybinds, then I probably
wouldn't recommend Neovim. However, if you're even a little bit curious, I'd really recommend giving
it a shot. Here are some resources I used to get started:

- [Josean Martinez](https://www.youtube.com/@joseanmartinez)
    - [Full Neovim setup (most updated version)](https://www.youtube.com/watch?v=oBiBEx7L000&t=161s)
    - [Full Neovim setup (the one I used)](https://www.youtube.com/watch?v=6pAG3BHurdM&t=4325s&pp=ygUPam9zZWFuIG1hcnRpbmV6)
    - [dotfiles management](https://www.youtube.com/watch?v=06x3ZhwrrwA&pp=ygUPam9zZWFuIG1hcnRpbmV6)
- [TJ DeVries](https://www.youtube.com/@teej_dv)
    - [Neovim setup guide](https://www.youtube.com/watch?v=m8C0Cq9Uv9o&t=89s&pp=ygUGbmVvdmlt)
    - [oil.nvim](https://www.youtube.com/watch?v=-r1mMg-yVZE&pp=ygUGbmVvdmlt)
- Miscellaneous videos
    - [New native lsp run-through](https://www.youtube.com/watch?v=HLp879ZDhVc&pp=ygUGbmVvdmlt)
    - [The perfect Neovim setup for Python](https://www.youtube.com/watch?v=4BnVeOUeZxc&list=PL05iK6gnYad1sb4iQyqsim_Jc_peZdNXf&index=4&pp=iAQB)
    - [The perfect Neovim setup for C++](https://www.youtube.com/watch?v=lsFoZIg-oDs&list=PL05iK6gnYad1sb4iQyqsim_Jc_peZdNXf&index=6&pp=iAQB)
