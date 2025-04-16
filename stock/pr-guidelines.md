
---
## Pull requests guidelines

Link to any related issue in the Pull Request message.

During the review, we recommend using fixups:
``` bash
# SHA is the SHA of the commit you want to fix
git commit --fixup=SHA
```

Once all the changes are approved, you can squash your commits:
``` bash
git rebase -i --autosquash main
```

And force-push:
``` bash
git push -f
```

If this seems all too complicated, you can push or force-push each new commit, and we will squash them ourselves if needed, before merging.