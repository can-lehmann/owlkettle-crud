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
import ../model/user_model

viewable AppMenuButton:
  ## A button that opens the main menu of the application
  
  userModel: UserModel

method view(button: AppMenuButtonState): Widget =
  result = gui:
    MenuButton:
      icon = "open-menu-symbolic"
      
      # A menu is created using the PopoverMenu widget.
      # It allows us to create menus & submenus.
      PopoverMenu:
        Box:
          orient = OrientY
          
          # Menu entries are created using the ModelButton widget
          
          ModelButton:
            text = "Add Example Users"
            
            proc clicked() =
              ## Adds some example users to the model
              
              const EXAMPLE_USERS = [
                User(firstName: "Max", lastName: "Mustermann"),
                User(firstName: "John", lastName: "Doe"),
                User(firstName: "Erika", lastName: "Mustermann"),
                User(firstName: "Jane", lastName: "Doe")
              ]
              
              for user in EXAMPLE_USERS:
                button.userModel.add(user)
          
          ModelButton:
            text = "Delete All"
            
            proc clicked() =
              ## Deletes all users
              button.userModel.clear()

export AppMenuButton
