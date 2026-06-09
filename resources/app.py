import json
from df.main import Template, Block, Item
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
ELEMENTS_DIR = SCRIPT_DIR / "elements.json"



def main():
    elements = json.load(ELEMENTS_DIR.open())

    t = Template("const.data")
    t.add_parameter("data", "var")

    items = []
    for element in elements:
        items.append(Item.String(json.dumps(element), True))
    

    t.add_block(Block.create_list("data", items))
    t.to_millomod()


if __name__ == "__main__":
    main()

