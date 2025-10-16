import pypandoc
import jinja2
import os


def render_toc(pages):
    template = jinja2.Template(open('learn.jinja').read())
    full_content = template.render(pages=pages)
    with open("html/learn.html", 'w') as f:
        f.write(full_content)


def template(title, pdf, content):
    template = jinja2.Template(open('template.jinja').read())
    return template.render(title=title, pdf=pdf, content=content)


def render_file(path):
    content = pypandoc.convert_file(path, 'html5')
    title = path.split('.')[0].replace('-', ' ').capitalize()
    full_content = template(title, path.replace("typst", "pdf"), content)
    with open("html/" + path.replace("typst", "html"), 'w') as f:
        f.write(full_content)
    return {"title": title, "url": path.replace(".html", "")}


# Delete all html files in the html folder
# for path in os.listdir('src/learn/html'):
#    if path.endswith('.html'):
#        os.remove('html/' + path)

typst_files = [path for path in os.listdir('.') if path.endswith('.typst')]
pages = []
for path in typst_files:
    pages.append(render_file(path))
render_toc(pages)
