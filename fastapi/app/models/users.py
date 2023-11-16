from ..database import Base
from sqlalchemy import Column, Integer, String, ARRAY, ForeignKey

class LocalUser(Base):
  __tablename__ = "users"
  
  id = Column(Integer, primary_key= True, nullable= False)
  name = Column(String, nullable= False)
  email = Column(String, nullable= False)
  password = Column(String, nullable=False)
  points = Column(Integer, nullable= False)
  bio = Column(String, nullable= True)
  profile_pic = Column(String, nullable= True)
  group_ids = Column(ARRAY)
  enrolled_course_ids = Column(ARRAY)
  followings = Column(ARRAY)
  followers = Column(ARRAY)

