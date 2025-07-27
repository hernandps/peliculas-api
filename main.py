from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
import models, schemas, crud
from database import engine, Base, SessionLocal
from fastapi.middleware.cors import CORSMiddleware

# Crea las tablas
Base.metadata.create_all(bind=engine)

app = FastAPI()

# Permitir acceso desde frontend (web)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # puedes restringir a ["http://localhost:59232"] si deseas
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Dependencia para la sesión de base de datos
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def read_root():
    return {"mensaje": "API de películas"}

@app.post("/peliculas/", response_model=schemas.PeliculaOut)
def crear_pelicula(pelicula: schemas.PeliculaCreate, db: Session = Depends(get_db)):
    return crud.crear_pelicula(db, pelicula)

@app.get("/peliculas/", response_model=list[schemas.PeliculaOut])
def leer_peliculas(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.obtener_peliculas(db, skip=skip, limit=limit)
