If you write a body, please add trailers at the end (for example issues and PR references, or co-authors), without relying on GitHub's flavored Markdown:
``` bash
Body.

Issue #10: https://github.com/namespace/project/issues/10
Related to PR namespace/other-project#15: https://github.com/namespace/other-project/pull/15
```
These "trailers" must appear at the end of the body, without any blank lines between them. The trailer title can contain any character except colons :. We expect a full URI for each trailer, not just GitHub autolinks (for example, full GitHub URLs for commits and issues, not the hash or the #issue-number).

We do not enforce a line length on commit messages summary and body, but please avoid very long summaries, and very long lines in the body, unless they are part of code blocks that must not be wrapped.