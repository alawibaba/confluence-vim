# confluence-vim
A vim plugin for taking notes in markdown and storing them in a confluence wiki.

It's really simple, I hope you like it.

You need to install html2text, markdown, and requests, and your vim needs to
be compiled with python support. You also need to write your credentials in
your .netrc file.

## Usage

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
