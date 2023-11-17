from fastapi import APIRouter, Depends, status, HTTPException, Response
from fastapi.security.oauth2 import OAuth2PasswordRequestForm
from .. import schemas, database, utils, oauth
from sqlalchemy.orm import Session
from ..models import users


router = APIRouter(
    tags=['Authentication']
)

@router.post('/login',response_model= schemas.Token)
def login(user_credentials: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(database.get_db)):

    user = db.query(users.LocalUser).filter(users.LocalUser.email == user_credentials.username).first()
    
    if not user: 
        raise HTTPException(status_code= status.HTTP_403_FORBIDDEN, detail= f'Invalid Credentials')
    if not utils.verify(user_credentials.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail=f'Invalid Credentials')
    
    access_token = oauth.create_access_token(data= {"user_id": user.id, "name": user.name})
    
    return {"access_token": access_token, "token_type": "bearer"}
