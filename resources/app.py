import json
from df.main import Template, Block, Item
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
ELEMENTS_DIR = SCRIPT_DIR / "elements.json"
FORMS_DIR = SCRIPT_DIR / "forms.json"



def main():
    elements = json.load(ELEMENTS_DIR.open())
    forms = json.load(FORMS_DIR.open())

    t = Template("const.data")
    t.add_parameter("data", "var")
    t.add_parameter("forms", "var")

    items = []
    for element in elements:
        items.append(Item.String(json.dumps(element), True))

    t.add_block(Block.create_list("data", items))

    items = []
    for form in forms:
        items.append(Item.String(json.dumps(form), True))
    
    t.add_block(Block.create_list("forms", items))

    t.to_millomod()


if __name__ == "__main__":
    main()

