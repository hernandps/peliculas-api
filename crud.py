from sqlalchemy.orm import Session
import models, schemas

def crear_pelicula(db: Session, pelicula: schemas.PeliculaCreate):
    db_pelicula = models.Pelicula(**pelicula.dict())
    db.add(db_pelicula)
    db.commit()
    db.refresh(db_pelicula)
    return db_pelicula

def obtener_peliculas(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Pelicula).offset(skip).limit(limit).all()
