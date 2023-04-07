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
import user_editor

type EditUserDialogMode* = enum
  EditUserCreate = "Create"
  EditUserUpdate = "Update"

viewable EditUserDialog:
  ## A dialog for editing a user. We use the same dialog for creating and updating
  ## a user. Since we want to use different titles and labels for the buttons in each case,
  ## the EditUserDialog.mode field specifies the purpose of the dialog.
  
  user: User ## The user being edited
  mode: EditUserDialogMode ## Purpose of the dialog (create/update)

method view(dialog: EditUserDialogState): Widget =
  result = gui:
    Dialog:
      title = $dialog.mode & " User"
      defaultSize = (400, 200)
      
      # Dialog Buttons
      
      DialogButton {.addButton.}:
        # Create / Update Button
        text = $dialog.mode
        style = [ButtonSuggested]
        res = DialogAccept
      
      DialogButton {.addButton.}:
        text = "Cancel"
        res = DialogCancel
      
      # Content
      
      UserEditor:
        user = dialog.user
        proc changed(user: User) =
          dialog.user = user

export EditUserDialog, EditUserDialogState
