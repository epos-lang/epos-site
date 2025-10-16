import pypandoc
import jinja2
import os


def template(title, pdf, content):
    template = jinja2.Template(open('template.jinja').read())
    return template.render(title=title, pdf=pdf, content=content)


def render_file(path):
    content = pypandoc.convert_file(path, 'html5')
    title = path.split('.')[0].replace('-', ' ').capitalize()
    full_content = template(title, path.replace("typst", "pdf"), content)
    with open("html/" + path.replace("typst", "html"), 'w') as f:
        f.write(full_content)


typst_files = [path for path in os.listdir('.') if path.endswith('.typst')]
for path in typst_files:
    render_file(path)
