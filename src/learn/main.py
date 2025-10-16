import pypandoc
import jinja2
import os


def render_toc(pages):
    template = jinja2.Template(open('learn.jinja').read())
    full_content = template.render(pages=pages)
    with open("html/learn.html", 'w') as f:
        f.write(full_content)


def template(page):
    template = jinja2.Template(open('template.jinja').read())
    return template.render(page=page)


def get_page_dict(path):
    content = pypandoc.convert_file(path, 'html5')
    raw_path = '-'.join(path.split('.')[0].split('-')[1:])
    order = int(path.split('.')[0].split('-')[0])
    title = raw_path.replace('-', ' ').capitalize().replace("epos", "Epos")
    return {
        "title": title,
        "raw_path": raw_path,
        "order": order,
        "content": content
    }


def render_file(page):
    full_content = template(page)
    with open("html/" + page['raw_path'] + ".html", 'w') as f:
        f.write(full_content)


typst_files = [path for path in os.listdir('.') if path.endswith('.typst')]
pages = []
for path in typst_files:
    pages.append(get_page_dict(path))

pages_in_order = sorted(pages, key=lambda page: page['order'])

for index, page in enumerate(pages_in_order):
    if index < len(pages_in_order) - 1:
        page['next_site'] = pages_in_order[index + 1]['raw_path']
    render_file(page)
render_toc(pages_in_order)
