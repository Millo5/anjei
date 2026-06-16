import json
from df.main import Template, Block, Item
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
ITEMS_DIR = SCRIPT_DIR / "items.json"
RECIPES_DIR = SCRIPT_DIR / "recipes.json"



def main():
    items = json.load(ITEMS_DIR.open())
    recipes = json.load(RECIPES_DIR.open())

    t = Template("const.data")
    t.add_parameter("items", "var")
    t.add_parameter("recipes", "var")

    args = []
    for item in items:
        args.append(Item.String(json.dumps(item), True))

    t.add_block(Block.create_list("items", args))

    args = []
    for recipe in recipes:
        args.append(Item.String(json.dumps(recipe), True))
    
    t.add_block(Block.create_list("recipes", args))

    t.to_millomod()


if __name__ == "__main__":
    main()

