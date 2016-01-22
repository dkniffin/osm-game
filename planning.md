# Schema
- Characters
 - name:string, lat:decimal, lon:decimal, player:boolean, stats:hstore
- CharacterItems
 - character_id:int, item_id:int
- Items
 - name:string, type:string, attributes:hstore
- Enemies
 - lat:decimal, lng:decimal, type:string
- Buildings
 - geom:???, type:string

# Player actions
- Move character
- Collect resources
- Attack
- Heal
- Fortify
- Train (increase skills)
