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
import model/user_model
import view/[edit_user_dialog, user_list, search_bar, app_menu_button]

const
  APP_NAME = "CRUD Example"
  DATABASE_PATH = "database.sqlite"

viewable App:
  ## Main Application
  userModel: UserModel ## The UserModel that stores all users.
  
  filter: string ## The search query used to search the user list.

method view(app: AppState): Widget =
  result = gui:
    Window:
      title = APP_NAME
      
      HeaderBar {.addTitlebar.}:
        # Button to create a new user
        Button {.addLeft.}:
          icon = "list-add-symbolic"
          style = [ButtonSuggested]
          
          proc clicked() =
            ## Opens the EditUserDialog for creating a new user
            
            let (res, state) = app.open: gui:
              EditUserDialog(mode = EditUserCreate)
            
            if res.kind == DialogAccept:
              # The "Create" button was clicked
              app.userModel.add(EditUserDialogState(state).user)
        
        # Button to open the main menu
        AppMenuButton {.addRight.}:
          userModel = app.userModel
      
      # Main content of the window: Contains the list of all users and
      # a search bar to search for a specific user.
      Box:
        orient = OrientY
        margin = 12
        spacing = 12
        
        SearchBar {.expand: false.}:
          filter = app.filter
          proc changed(filter: string) =
            app.filter = filter
        
        Frame:
          UserList:
            model = app.userModel
            filter = app.filter

when isMainModule:
  # Entry point for the application.
  # Loads the model from the database and starts the application.
  let model = newUserModel(DATABASE_PATH)
  brew(gui(App(userModel = model)), icons=["icons/"])
