# confluence-vim
A vim plugin for taking notes in markdown and storing them in a confluence wiki.

It's really simple, I hope you like it.

You need to install html2text, markdown, and requests, and your vim needs to
be compiled with python support. You also need to write your credentials in
your .netrc file.

## Usage

**Warning**: This plugin is basic and doesn't handle some existing confluence pages and features. My use case was Markdown-only pages for initial documentation and small changes. Always check the resulting saved page and revert if you have to.

In your vimrc, you need to set the url for confluence:

`let g:confluence_url = 'https://my-tenant.atlassian.net/wiki/rest/api/content`

Then you can open a file from the command-line like so:

`vim "conf://space_key/Article Name"`

# Screenshots

Creating a new entry:
![New Entry](/images/new-entry.png?raw=true)

Editing an entry:
![Editing](/images/editing.png?raw=true)

Saving an entry:
![Saving](/images/saving.png?raw=true)

Final Result:
![Result](/images/final-result.png?raw=true)

Page History:
![Page History](/images/history.png?raw=true)

# Notes/Gotchas
I forked this from a repo that had already done most of the work. My changes were:

- Removing hardcoded requirements (i.e. allowing you to define the confluence url in `.vimrc`
- Allowing you to specify the space key in the url
- Some minor error handling to stop shit blowing up. Needs more

The original author (@alawibaba) did the hard work. I just stood on that work.

