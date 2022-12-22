---
id: 2022-12-22-rebase-key-bindings-for-sublime-merge
title: 'Rebase Key Bindings for Sublime Merge'
date: 2022-12-22T13:51:43+00:00
layout: post
guid: http://viteinfinite.com/?p=174576765
permalink: /2022/12/rebase-key-bindings-for-sublime-merge/
always_show_full: true
categories:
  - Git
  - Development
---

For the last couple of years, I've been happily using [Sublime Merge](https://www.sublimemerge.com/), the last Git interface from the creators of [Sublime Text](https://www.sublimetext.com/). 

I personally find it super fast and I particularily like the 3-way merge interface as well as its command-oriented interface.

Another feature I appreciate in Sublime Merge are the actions for editing your Git history, available from the _Edit Commit_ menu. I understand many would favor the command line interactive rebase interface - which is indeed hard to beat in terms of ergonomics. Still, rather than going back and forward from Sublime Merge and the CLI, I end up performing all rebases from Sublime Merge.

Thing is, in Sublime Merge the _Edit Commit_ actions don't have a default key binding associated to them. Luckily, that's easy to change.

Here's how:

1. In `~/Library/Application Support/Sublime Merge/Packages/User/`, create or edit a file named `Default (OSX).sublime-keymap`
2. In that file add the following configuration:

```json
[
    {
        "keys": ["option+shift+down"],
        "command": "move_commit",
        "args": { "commit": "$commit", "down": true },
    },
    {
        "keys": ["option+shift+up"],
        "command": "move_commit",
        "args": { "commit": "$commit", "down": false },
    },
    {
        "keys": ["option+shift+f"],
        "command": "fixup_commits",
        "args": { "commit": "$commit" },
    },
    {
        "keys": ["option+shift+s"],
        "command": "squash_commit",
        "args": { "commit": "$commit" },
    },
    {
        "keys": ["option+shift+f"],
        "command": "fixup_commits",
    },
    {
        "keys": ["option+shift+c"],
        "command": "edit_commit_contents",
        "args": { "commit": "$commit" },
    },
]
```

Then save and restart Sublime Merge.

The configuration above allows you to:

- Move commits up/down
- Fixup commits
- Squash a commit with its parent
- Edit commit contents (split a commit, modify its contents, ...)

That's all (at least for macOS)! Hope it will help those of you enjoying Sublime Merge - or my future self when looking for this answer!
