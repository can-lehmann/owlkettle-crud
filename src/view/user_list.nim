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

import owlkettle
import edit_user_dialog
import ../model/user_model

viewable UserList:
  ## Displays a list of users
  
  filter: string ## Filter used to search for users
  model: UserModel ## Model of all users

method view(list: UserListState): Widget =
  result = gui:
    ScrolledWindow:
      ListBox:
        # Create a row for each user that matches the given filter
        for user in list.model.search(list.filter):
          Box:
            orient = OrientX
            margin = 6
            spacing = 6
            
            Label:
              text = user.lastName & ", " & user.firstName
              xAlign = 0 # Align left
            
            # Edit Button
            
            Button {.expand: false.}:
              icon = "entity-edit"
              
              proc clicked() =
                ## Opens the EditUserDialog for updating the existing user
                
                let (res, state) = list.app.open: gui:
                  EditUserDialog:
                    user = user
                    mode = EditUserUpdate
                
                if res.kind == DialogAccept:
                  # The "Update" button was clicked
                  list.model.update(EditUserDialogState(state).user)
            
            # Delete Button
            
            Button {.expand: false.}:
              icon = "user-trash-symbolic"
              
              proc clicked() =
                list.model.delete(user.id)

export UserList
