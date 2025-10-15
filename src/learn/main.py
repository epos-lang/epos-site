import pypandoc
import jinja2


def template(title, content):
    template = jinja2.Template(open('template.jinja').read())
    return template.render(title=title, content=content)


def render_file(path):
    content = pypandoc.convert_file(path, 'html5')
    title = path.split('.')[0].replace('-', ' ').capitalize()
    return template(title, content)


full_content = render_file('index.typst')
with open('index.html', 'w') as f:
    f.write(full_content)
