from .db_config import Base
from sqlalchemy import Column, Integer, String, Boolean, Float, Time, DECIMAL, CHAR, VARCHAR, BigInteger, DateTime
from sqlalchemy import Column, Integer, String
from sqlalchemy.sql.sqltypes import TIMESTAMP
from sqlalchemy import Column, ForeignKey
from sqlalchemy.sql import text
from sqlalchemy.orm import relationship


class Restaurant(Base):
	__tablename__ = 'restaurant'

	rid = Column(Integer, primary_key=True, index=True, autoincrement=True)
	name = Column(String)
	owner = Column(Integer)
	address = Column(String)
	zip = Column(Integer)
	phone = Column(BigInteger)
	opentime = Column(Time)
	closetime = Column(Time)
	description = Column(String)
	price = Column(String)
	rating = Column(DECIMAL(3, 2))
	status = Column(String)
	menu = Column(String)
	menu_photo = Column(String)


class Cuisine(Base):
	__tablename__ = 'cuisine'

	cid = Column(Integer, primary_key=True, index=True, autoincrement=True, nullable=False)
	name = Column(String)
	description = Column(String, nullable=False)

class Photo(Base):
	__tablename__ = 'photo'

	pid = Column(Integer, primary_key=True, index=True, autoincrement=True, nullable=False)
	restaurant = Column(Integer)
	user = Column(Integer)
	image = Column(String)
	description = Column(String)


class Review(Base):
	__tablename__ = 'review'

	rvid = Column(Integer, primary_key=True, index=True, autoincrement=True, nullable=False)
	restaurant = Column(Integer)
	user = Column(Integer)
	rating = Column(Integer)
	text = Column(String)
	time = Column(TIMESTAMP(timezone=True))
	replying = Column(Integer)
	photo = Column(Integer)

class User(Base):
	__tablename__ = 'user'

	uid = Column(Integer, primary_key=True, index=True, autoincrement=True)
	username = Column(String(15), unique=True, index=True)
	email = Column(String(45), unique=True)
	password = Column(String(70))
	user_type = Column(CHAR(15))  # admin, owner, user
	phone = Column(BigInteger)
	status = Column(String(20))
	photo = Column(String(255))
	created = Column(TIMESTAMP)
	updated = Column(TIMESTAMP)