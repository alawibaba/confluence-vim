" based on
" http://brainacle.com/how-to-write-vim-plugins-with-python.html

" TODO deal with alternate encodings

if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

" Vim comments start with a double quote.
" Function definition is VimL. We can mix VimL and Python in
" function definition.
function! OpenConfluencePage(article_name)
" We start the python code like the next line.

python << EOF
# the vim module contains everything we need to interface with vim
import json
import html2text
import requests
import vim

cb = vim.current.buffer

article_name = vim.eval("a:article_name")
article_name = article_name[article_name.find("//")+2:]

r = requests.get('https://openedx.atlassian.net/wiki/rest/api/content', params={'spaceKey': '~ali', 'title': article_name, 'status': 'current', 'expand': 'body.view,version.number', 'limit': 1})
#vim.command("echom \"%s\"" % "\\\"".join(repr(r.text).split("\"")))
resp = json.loads(r.text)['results']
if len(resp) > 0:
    vim.command("let b:confid = %d" % int(resp[0]['id']))
    vim.command("let b:confv = %d" % int(resp[0]['version']['number']))

    article = resp[0]['body']['view']['value']
    h = html2text.HTML2Text()
    h.body_width = 0
    article_markdown = h.handle(article)
    
    del cb[:]
    for line in article_markdown.split('\n'):
        cb.append(line.encode('utf8'))
    del cb[0]
else:
    vim.command("let b:confid = 0")
    vim.command("let b:confv = 0")
    vim.command("echo \"New confluence entry - %s\"" % article_name)
vim.command("set filetype=mkd")

EOF
" Here the python code is closed. We can continue writing VimL or python again.
endfunction

function! WriteConfluencePage(article_name)
python << EOF
import json
import markdown
import requests
import vim

cb = vim.current.buffer

article_name = vim.eval("a:article_name")
article_name = article_name[article_name.find("//")+2:]
article_id = int(vim.eval("b:confid"))
article_v = int(vim.eval("b:confv")) + 1
article_content = markdown.markdown("\n".join(cb))

if article_id > 0:
    jj = {"id": str(article_id), "title": article_name, "type": "page", "space": { "key": "~ali" }, "version": { "number": article_v }, "body": { "storage": { "value": article_content, "representation": "storage" } } }
    r = requests.put('https://openedx.atlassian.net/wiki/rest/api/content/%d' % article_id, json=jj)
else:
    jj = {"type": "page", "space": {"key": "~ali"}, "title": article_name, "body": {"storage": {"value": article_content, "representation": "storage"}}}
    r = requests.post('https://openedx.atlassian.net/wiki/rest/api/content', params={'spaceKey': '~ali', 'title': article_name}, json=jj)
#vim.command("echom \"%s\"" % "\\\"".join(repr(r.text).split("\"")))
resp = json.loads(r.text)
vim.command("let b:confid = %d" % int(resp['id']))
vim.command("let b:confv = %d" % int(resp['version']['number']))
vim.command("let &modified = 0")
vim.command("echo \"Confluence entry %s written.\"" % article_name)
EOF
endfunction

augroup Confluence
  au!
  au BufReadCmd conf://* call OpenConfluencePage(expand("<amatch>"))
  au BufWriteCmd conf://* call WriteConfluencePage(expand("<amatch>"))
augroup END
