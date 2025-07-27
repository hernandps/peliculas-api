from sqlalchemy import Column, Integer, String, Date, Text
from database import Base

class Pelicula(Base):
    __tablename__ = "peliculas"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String(200), nullable=False)
    fecha_vista = Column(Date, nullable=False)
    calificacion = Column(Integer)
    comentario = Column(Text)
