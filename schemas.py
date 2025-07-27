from pydantic import BaseModel
from datetime import date

class PeliculaBase(BaseModel):
    titulo: str
    fecha_vista: date
    calificacion: int
    comentario: str

class PeliculaCreate(PeliculaBase):
    pass

class PeliculaOut(PeliculaBase):
    id: int

    class Config:
        from_attributes = True

