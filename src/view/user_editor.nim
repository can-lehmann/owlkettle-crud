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

viewable UserEditor:
  ## A form for editing a User
  
  user: User ## The user that is being edited
  
  # Since User is passed by value, we need to notify the parent widget of
  # any changes to the user. The changed callback 
  proc changed(user: User)

method view(editor: UserEditorState): Widget =
  result = gui:
    # A grid is used to ensure that the entries are vertically aligned.
    Grid:
      margin = 12
      columnSpacing = 12
      rowSpacing = 6
    
      # First Name
      
      Label {.x: 0, y: 0.}:
        text = "First Name"
        xAlign = 0 # Align left
      
      Entry {.x: 1, y: 0, hExpand: true.}:
        text = editor.user.firstName
        
        proc changed(text: string) =
          editor.user.firstName = text
          
          # Call the changed callback
          if not editor.changed.isNil:
            editor.changed.callback(editor.user)
      
      # Last Name
      
      Label {.x: 0, y: 1.}:
        text = "Last Name"
        xAlign = 0 # Align left
      
      Entry {.x: 1, y: 1, hExpand: true.}:
        text = editor.user.lastName
        
        proc changed(text: string) =
          editor.user.lastName = text
          
          # Call the changed callback
          if not editor.changed.isNil:
            editor.changed.callback(editor.user)

export UserEditor
