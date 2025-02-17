# JSON Keeper CLI

A **Ruby-based Command Line Interface (CLI)** for creating, reading, updating, deleting, and searching JSON data.  
This project is structured for **maintainability and clarity**, allowing you to handle complex nested objects and arrays easily.

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Features](#features)  
3. [Prerequisites](#prerequisites)  
4. [File Structure](#file-structure)  
5. [Installation & Setup](#installation--setup)  
6. [Making the CLI Executable](#making-the-cli-executable)  
7. [Usage](#usage)  
   - [Creating a JSON File](#creating-a-json-file)  
   - [Reading a JSON File](#reading-a-json-file)  
   - [Updating a JSON File](#updating-a-json-file)  
   - [Deleting a JSON File](#deleting-a-json-file)  
   - [Deleting a Key from a JSON File](#deleting-a-key-from-a-json-file)  
   - [Searching in a JSON File](#searching-in-a-json-file)  
8. [How to Integrate into Your Project](#how-to-integrate-into-your-project)  
9. [Running Tests](#running-tests)  
10. [Contributing](#contributing)  
11. [License](#license)

---

## Project Overview

**JSON Keeper CLI** is designed to simplify local JSON data management. It allows you to:

- Create JSON files with **multiple keys** (including nested objects and arrays).
- Read entire JSON files or specific keys.
- Update existing JSON files (including adding new keys, nested objects, and lists).
- Delete entire JSON files or just specific keys.
- Search for keys or values within JSON data (including nested objects).

This tool is especially helpful for developers who want a quick and intuitive way to manipulate JSON data without needing a full database setup.

---

## Features

1. **Create**  
   - Create new JSON files with **nested objects** and **arrays** in one go.
2. **Read**  
   - Read full JSON files or retrieve a specific key.
3. **Update**  
   - Add or modify existing keys (including nested objects).
4. **Delete**  
   - Delete entire JSON files or a specific key from a file.
5. **Search**  
   - Search by key or value, with support for **nested structures**.
6. **Flexible Input Parsing**  
   - Automatically detect integers, floats, booleans, null, and comma-separated lists.

---

## Prerequisites

- **Ruby** 3.0+ (earlier versions may work, but 3.0+ is recommended).
- **Bundler** (if you want to manage gems with a Gemfile).
- **Git** (if you want to clone and contribute).

---

## File Structure

Below is the recommended project structure. Each file has a dedicated purpose:

```
    JK/
    ├── bin/
    │   └── jk.rb                # Main executable CLI script
    ├── data/                    # Directory where JSON files are stored
    ├── lib/
    │   ├── file_manager.rb      # Manages file paths and existence checks
    │   ├── data_parser.rb       # Handles type conversions (e.g., string -> int)
    │   ├── create.rb            # Functions for creating JSON files
    │   ├── read.rb              # Functions for reading JSON files
    │   ├── update.rb            # Functions for updating JSON files
    │   ├── delete.rb            # Functions for deleting files or keys
    │   ├── search.rb            # Functions for searching within JSON
    │   └── json_keeper.rb       # Main class that imports modules above
    ├── spec/
    │   ├── json_keeper_spec.rb  # RSpec tests for core logic
    │   └── spec_helper.rb       # RSpec configuration
    ├── Gemfile                  # Gem dependencies (RSpec, etc.)
    ├── Gemfile.lock
    └── README.md                # This documentation
```

---

## Installation & Setup

1. **Clone the Repository**  

   ```bash
   git clone https://github.com/ciamuthama/jk.git
   cd jk
   ```

2. **Install Dependencies** (Optional if you’re using Bundler)

   ```bash
   bundle install
   ```

   This installs gems listed in the `Gemfile` (like RSpec) else add this to an existing gemfile.
   
   ```bash
   group :test do
    gem 'rspec'
   end

   ```

3. **Check Ruby Version**  

   ```bash
   ruby -v
   ```

   Ensure it’s 3.0 or higher.

4. **Create the `data` Folder**  
   If not already present, create a `data/` folder to store your JSON files:

   ```bash
   mkdir data
   ```

---

## Making the CLI Executable

1. **Make `bin/jk.rb` Executable**  

   ```bash
   chmod +x bin/jk.rb
   ```

2. **Run the CLI**  

   ```bash
   bin/jk.rb
   ```

   You should see:

   ```
   Welcome to JSON Keeper! 🚀
   📂 JSON Keeper CLI 📂
   ----------------------
   1. Create a new JSON file
   2. Read an existing JSON file
   ...
   ```

3. **Optional: Add to Your Path**  
   If you want to run `jk` from anywhere:

   ```bash
   export PATH="$PATH:/path/to/JK/bin"
   ```

   Then simply type:

   ```bash
   jk.rb
   ```

---

## Usage

Below are common CLI flows. In each example, the tool will prompt you for further input.

### Creating a JSON File

```
$ bin/jk.rb
1 Create a new JSON file
    Enter the filename (without .json extension): users
    Enter a key (or press enter to finish): name
    Do you want to nest an object inside 'name'? (y/n): n
    Enter a value for 'name' (comma-separated for list): Alice
    Enter a key (or press enter to finish): age
    Do you want to nest an object inside 'age'? (y/n): n
    Enter a value for 'age' (comma-separated for list): 25
    Enter a key (or press enter to finish):   # Press Enter to finish
    Success: file 'users' created successfully! 🎉
```

### Reading a JSON File

```
$ bin/jk.rb
2 Read an existing JSON file
    Enter the filename (without .json extension) to read: users
    Enter a key to retrieve (or press Enter for full file):   # Press Enter for full file
    📂 Full JSON Data:
        {
        "name": "Alice",
        "age": 25
        }
```

### Updating a JSON File

```
$ bin/jk.rb
3 Update a JSON file
    Enter the filename (without .json extension) to update: users
    Enter the key to update (or press enter to finish): location
    Do you want to nest an object inside 'location'? (y/n): n
    Enter a value for 'location' (comma-separated for list): New York
    Enter the key to update (or press enter to finish):   # Press Enter to finish
    ✅ Success: Updated 'users.json' with new values!
```

### Deleting a JSON File

```
$ bin/jk.rb
4 Delete a JSON file
    Enter the filename (without .json extension) to delete: users
    ✅ Success: File 'users.json' deleted!
```

### Deleting a Key from a JSON File

```
$ bin/jk.rb
5 Delete a key from a JSON file
    Enter the filename (without .json extension) to delete a key from: users
    Enter the key to delete (or press enter to finish): age
    ✅ Success: Key 'age' deleted from 'users.json'!
    Delete another key? (y/n): n
```

### Searching in a JSON File

```
$ bin/jk.rb
6 Search in a JSON file
    Enter the filename (without .json extension) to search in: users
    Enter the search query (key or value): Ali
    ✅ Found 1 match(es):
    📌 {name: "Alice"}
```

---

## How to Integrate into Your Project

1. **Copy the `lib/` folder** into your existing Ruby project.  
2. **Copy the `bin/jk.rb`** or rename it to your desired CLI name.  
3. **Adjust** the `require_relative` paths if your folder structure is different.  
4. **Update** any references to `JsonKeeperCLI` or `JsonKeeper` if you rename them.  
5. **Ensure** you have a `data/` folder or specify a different folder in your `file_manager.rb`.

---

## Running Tests

We use **RSpec** for testing.

1. **Install RSpec** (if you haven’t):

   ```bash
   gem install rspec
   # or
   bundle add rspec
   ```

2. **Run Tests**:

   ```bash
   rspec
   ```

   This will discover and run all tests in the `spec/` folder.

3. **Test Examples**:
   - `spec/json_keeper_spec.rb` checks the **core logic** of JSON Keeper.

---

## Contributing

1. **Fork** the repository.  
2. **Create a new branch** for your feature:  

   ```bash
   git checkout -b feature/awesome-feature
   ```

3. **Commit** your changes with descriptive messages:  

   ```bash
   git commit -m "Add awesome feature for nested objects"
   ```

4. **Push** to your fork:  

   ```bash
   git push origin feature/awesome-feature
   ```

5. **Open a Pull Request** on the original repository. We’ll review your changes and merge them if they fit well!

---

## License

This project is available under the **MIT License**. Feel free to use, modify, and distribute it as per the license terms.

---

**Happy JSON Managing!** If you have any questions or suggestions, feel free to open an issue or submit a pull request. We appreciate your contributions!
