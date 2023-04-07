# MIT License
# 
# Copyright (c) 2023 Can Joshua Lehmann
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import std/[tables, strutils, sugar, hashes, algorithm]
import tiny_sqlite

# We create a custom type for representing the ID of a user.
# This way Nim's type system automatically prevents us from using it as a regular integer and
# from confusing it with the ID of another entity.

type UserId* = distinct int64

proc `==`*(a, b: UserId): bool {.borrow.}
proc hash*(id: UserId): Hash {.borrow.}
proc `$`*(id: UserId): string =
  result = "user" & $int(id)

type User* = object
  ## Represents a user
  id*: UserId
  firstName*: string
  lastName*: string

proc matches*(user: User, filter: string): bool =
  ## Checks if the user matches the given filter.
  ## This function is used to search the list of users.
  filter.toLowerAscii() in toLowerAscii(user.firstName & " " & user.lastName)

type UserModel* = ref object
  ## Model for storing all users. We model this as a ref object, so that changes
  ## made by any widget are also known to all other widgets that use the model.
  
  db: DbConn
  users: Table[UserId, User]

proc newUserModel*(path: string = ":memory:"): UserModel =
  ## Load a UserModel from a database
  
  let db = openDatabase(path)
  
  # Create the User table
  db.exec("""
    CREATE TABLE IF NOT EXISTS User(
      id INTEGER PRIMARY KEY,
      firstName TEXT,
      lastName TEXT
    )
  """)
  
  # Load all existing users into UserModel.users
  var users = initTable[UserId, User]()
  for row in db.iterate("SELECT id, firstName, lastName FROM User"):
    let (id, firstName, lastName) = row.unpack((UserId, string, string))
    users[id] = User(id: id, firstName: firstName, lastName: lastName)
  
  result = UserModel(db: db, users: users)

proc add*(model: UserModel, user: User) =
  ## Adds a new user to the model
  
  # Insert new user into database
  model.db.exec(
    "INSERT INTO User (firstName, lastName) VALUES (?, ?)",
    user.firstName, user.lastName
  )
  
  # Insert new user into UserModel.users
  let id = UserId(model.db.lastInsertRowId)
  model.users[id] = user.dup(id = id)

proc update*(model: UserModel, user: User) =
  ## Updates an existing user. Users are compared by their ID.
  
  # Update user in database
  model.db.exec(
    "UPDATE User SET firstName = ?, lastName = ? WHERE id = ?",
    user.firstName, user.lastName, user.id
  )
  
  # Update UserModel.users
  model.users[user.id] = user

proc search*(model: UserModel, filter: string): seq[User] =
  ## Returns a seq of all users that match the given filter.
  for id, user in model.users:
    if user.matches(filter):
      result.add(user)
  
  result.sort((a, b: User) => cmp(a.lastName, b.lastName))

proc delete*(model: UserModel, id: UserId) =
  ## Deletes the user with the given ID
  
  # Delete user from database
  model.db.exec("DELETE FROM User WHERE id = ?", id)
  
  # Update UserModel.users
  model.users.del(id)

proc clear*(model: UserModel) =
  ## Deletes all users
  
  # Delete all users from database
  model.db.exec("DELETE FROM User")
  
  # Update UserModel.users
  model.users.clear()
