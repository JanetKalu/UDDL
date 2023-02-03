## What you can contribute
1. Documentation - Documentation (developer, user, etc.) is the primary mechanism for scalable knowledge transfer. 
N00bs in particular are ***strongly*** encouraged to contribute to documentation efforts. Why, you ask? Because, as a n00b, 
what you find hard to understand is also likely to be hard to understand for other n00bs. The longer you are exposed to this code/ 
the more you know, the harder it becomes to see things through the eyes of other n00bs. Capturing reactions/ complaints/ confusion from your
early exposure is valuable feedback to help us improve. Those contributions can be in the form of issues or, ideally, pull requests that address
the problem you've identified. Whatever you submit, please articulate as precisely and concisely as you can the problem and, in the case of PRs, 
your solution and why you think its a good one. Create the documentation you wish we had - don't wait on others to create an issue for it. Instead,
create the issue and then feel free to address the issue you created. Even if you only get partway, it will start a discussion - and that's good!
2. Working examples / tests - Tests serve multiple purposes. They both show that the code works in a particular way *and* provide examples of how
to get the code to do specific things. As examples, they should be whatever is needed to educate the reader on a particular technique. Create the 
examples you wish we had - don't wait on others to create an issue for it. Instead, create the issue and then feel free to address the issue you created.
Even if you only get partway, it will start a discussion - and that's good!
3. Addressing issues - There is always a need here. Feel free to pick any you feel comfortable with. Hopefully, these are described in enough detail
that they are easy to understand. If not, ask questions. If you don't understand, then the issue writer will clarify.
4. UI / UX - The key to successful tools is that they allow users to work in the way they feel most productive. There are many possible ways to
review and edit the same information. It could be in textual format, graphical, tabular, or ??? If you've got ideas on how to improve the UI, then
there is lots of opportunity for you here.
5. Other? It is certainly possible that there are even more opportunities. If you think something is missing, don't hesitate to get involved adding it.


### Commits in your pull-requests should

- Have a useful description prefixed with the package name (E.g.: "foopkg: Add
  libzot dependency")
- Include Signed-off-by tag in the commit comments.  See: [Sign your
  work](https://openwrt.org/submitting-patches#sign_your_work)

## Advice on pull requests

Pull requests are the easiest way to contribute changes to git repos at Github.
They are the preferred contribution method, as they offer a nice way for
commenting and amending the proposed changes.

- You need a local "fork" of the Github repo.

- Use a "feature branch" for your changes. That separates the changes in the
  pull request from your other changes and makes it easy to edit/amend commits
  in the pull request. Workflow using "feature_x" as the example:
  - Update your local git fork to the tip (of the master, usually)
  - Create the feature branch with `git checkout -b feature_x`
  - Edit changes and commit them locally
  - Push them to your Github fork by `git push -u origin feature_x`. That
    creates the "feature_x" branch at your Github fork and sets it as the
    remote of this branch
  - When you now visit Github, you should see a proposal to create a pull
    request

- If you later need to add new commits to the pull request, you can simply
  commit the changes to the local branch and then use `git push` to
  automatically update the pull request.

- If you need to change something in the existing pull request (e.g. to add a
  missing signed-off-by line to the commit message), you can use `git push -f`
  to overwrite the original commits. That is easy and safe when using a feature
  branch. Example workflow:
  - Checkout the feature branch by `git checkout feature_x`
  - Edit changes and commit them locally. If you are just updating the commit
    message in the last commit, you can use `git commit --amend` to do that
  - If you added several new commits or made other changes that require
    cleaning up, you can use `git rebase -i HEAD~X` (X = number of commits to
    edit) to possibly squash some commits
  - Push the changed commits to Github with `git push -f` to overwrite the
    original commits in the "feature_x" branch with the new ones. The pull
    request gets automatically updated

## If you have commit access

- Do NOT use git push --force.
- Do NOT commit to other maintainer's packages without their consent.
- Use Pull Requests if you are unsure and to suggest changes to other
  maintainers.

### Gaining commit access

- We will gladly grant commit access to responsible contributors who have made
  useful pull requests and / or feedback or patches to this repository or
  OpenWrt in general. Please include your request for commit access in your next
  pull request or ticket.

## Release Branches

- Old stable branches were named after the following pattern "for-XX.YY" (e.g.
  for-14.07) before the LEDE split.  During the LEDE split there was only one
  release branch with the name "lede-17.01".  After merging the LEDE fork with
  OpenWrt the release branches are named according to the following pattern
  "openwrt-XX.YY" (e.g. openwrt-18.06).
- These branches are built with the respective OpenWrt release and are created
  during the release stabilisation phase.
- Please ONLY cherry-pick or commit security and bug-fixes to these branches.
- Do NOT add new packages and do NOT do major upgrades of packages here.
- If you are unsure if your change is suitable, please use a pull request.

## Common LICENSE tags (short list)

(Complete list can be found at: <https://spdx.org/licenses>)

| Full Name                                        | Identifier               |
| ------------------------------------------------ | :----------------------- |
| Apache License 1.0                               | Apache-1.0               |
| Apache License 1.1                               | Apache-1.1               |
| Apache License 2.0                               | Apache-2.0               |
| Artistic License 1.0                             | Artistic-1.0             |
| Artistic License 1.0 w/clause 8                  | Artistic-1.0-cl8         |
| Artistic License 1.0 (Perl)                      | Artistic-1.0-Perl        |
| Artistic License 2.0                             | Artistic-2.0             |
| BSD 2-Clause "Simplified" License                | BSD-2-Clause             |
| BSD 2-Clause FreeBSD License                     | BSD-2-Clause-FreeBSD     |
| BSD 2-Clause NetBSD License                      | BSD-2-Clause-NetBSD      |
| BSD 3-Clause "New" or "Revised" License          | BSD-3-Clause             |
| BSD with attribution                             | BSD-3-Clause-Attribution |
| BSD 3-Clause Clear License                       | BSD-3-Clause-Clear       |
| BSD 4-Clause "Original" or "Old" License         | BSD-4-Clause             |
| BSD-4-Clause (University of California-Specific) | BSD-4-Clause-UC          |
| BSD Protection License                           | BSD-Protection           |
| GNU General Public License v1.0 only             | GPL-1.0-only             |
| GNU General Public License v1.0 or later         | GPL-1.0-or-later         |
| GNU General Public License v2.0 only             | GPL-2.0-only             |
| GNU General Public License v2.0 or later         | GPL-2.0-or-later         |
| GNU General Public License v3.0 only             | GPL-3.0-only             |
| GNU General Public License v3.0 or later         | GPL-3.0-or-later         |
| GNU Lesser General Public License v2.1 only      | LGPL-2.1-only            |
| GNU Lesser General Public License v2.1 or later  | LGPL-2.1-or-later        |
| GNU Lesser General Public License v3.0 only      | LGPL-3.0-only            |
| GNU Lesser General Public License v3.0 or later  | LGPL-3.0-or-later        |
| GNU Library General Public License v2 only       | LGPL-2.0-only            |
| GNU Library General Public License v2 or later   | LGPL-2.0-or-later        |
| Fair License                                     | Fair                     |
| ISC License                                      | ISC                      |
| MIT License                                      | MIT                      |
| No Limit Public License                          | NLPL                     |
| OpenSSL License                                  | OpenSSL                  |
| X11 License                                      | X11                      |
| zlib License                                     | Zlib                     |

## Continuous Integration

To simplify review and require less human resources, a CI tests all packages.
Passing CI tests are not a hard requirement but a good indicator what the
Buildbots will think about the proposed patch.

