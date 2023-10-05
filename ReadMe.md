# Daily

## Overview

The **Daily Task Manager App** is a productivity tool designed to help you manage your daily tasks efficiently. It is built using Core Data for data storage, CocoaPods for third-party library management, and follows the Model-View-Controller (MVC) architectural pattern to ensure a clean and maintainable codebase.

## Features

- Create and manage daily tasks.
- Mark tasks as complete or incomplete.
- Organize tasks by category.
- Search for specific tasks.
  
## Installation

1. Clone the repository from GitHub:
   ```
   git clone https://github.com/raminatastanova/daily.git
   ```

2. Navigate to the project directory:
   ```
   cd daily
   ```

3. Install the required CocoaPods dependencies:
   ```
   pod install
   ```

4. Open the Xcode workspace file:
   ```
   open Daily.xcworkspace
   ```

5. Build and run the app on the iOS Simulator or your physical iOS device.

## Usage

1. **Create a Category**: Tap the "+" button to add a new category. Enter the category name.
  
2. **Create a Task**: Tap the selected category to assign task to it. Tap "+" button to add a new task. Enter the task name.

3. **Manage Tasks**: Swipe left on a task to reveal options for deleting it. Tap on the task to mark it as "done".

4. **Search**: Quickly find a specific task by using the search bar.

## Architecture

The Daily Task Manager App follows the Model-View-Controller (MVC) architectural pattern:

- **Model**: Handles data storage and retrieval using Core Data. The data models include Item, Category.

- **View**: Presents the user interface, including task lists and input forms.

- **Controller**: Manages user interactions, processes data, and updates the UI. The controllers include TodoListViewController, CategoryViewController, and SwipeTableViewController.
