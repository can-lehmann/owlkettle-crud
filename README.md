# Owlkettle CRUD Example

A simple CRUD (Create, Read, Update, Delete) example application created using [owlkettle](https://github.com/can-lehmann/owlkettle).
It uses `owlkettle` for creating the user interface and `tiny_sqlite` for storing the entities.

![Screenshot](assets/screenshot.png)

## Installation

```bash
$ nimble install owlkettle@#head
$ nimble install tiny_sqlite
$ nim compile -r src/main.nim
```

## Project Structure

- **src**: Main source files for the application
  - **model**: Model
    - user_model.nim: `UserModel`, `User`, `UserId`
  - **view**: Custom Widgets
    - user_list.nim: `UserList` widget
    - search_bar.nim: `SearchBar` widget
    - edit_user_dialog.nim: `EditUserDialog`
    - user_editor.nim: `UserEditor` widget
    - app_menu_button.nim: `AppMenuButton` widget
  - main.nim: Entry point for the application and `App` widget

## Widgets

The following screenshots show how the custom widgets defined in src/view are used in the application.

![Widgets in the main application window](assets/app_widgets.png)

![Widgets in the EditUserDialog](assets/dialog_widgets.png)

## Funding

The funding for this example was donated by itwrx.org (@ITwrx).

## License

This example is licensed under the MIT license.
See `LICENSE.txt` for more information.
