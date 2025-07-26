from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

# Sample data model
class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    in_stock: bool = True

# Root route
@app.get("/")
def read_root():
    return {"demo test"}

# Item creation route
@app.post("/items/")
def create_item(item: Item):
    return {"message": "Item created successfully", "item": item}

# Item fetch route with path parameter
@app.get("/items/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "query": q}
