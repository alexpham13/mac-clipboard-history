# mac-clipboard-history
# Clipboard History App

A lightweight clipboard history manager for macOS, built using **Swift, SwiftUI, and AppKit**. The application automatically tracks copied text and images, allowing users to access, reuse, and manage their clipboard history through a simple interface.

## Features

- **Automatic Clipboard Monitoring** — Detects clipboard changes and updates history automatically.
- **Text and Image Support** — Stores copied text and images for later use.
- **Persistent History** — Saves clipboard history locally so it remains available after restarting the application.
- **Quick Copy** — Click a previous clipboard entry to copy it back to your clipboard.
- **Duplicate Management** — Moves previously copied items to the top instead of creating duplicates.
- **Individual Item Deletion** — Remove unwanted entries from clipboard history.
- **Recent History** — Maintains up to 50 clipboard entries.
- **Visual Selection** — Highlights the currently copied item.

## Tech Stack

| Technology | Purpose |
|---|---|
| Swift | Core application logic |
| SwiftUI | User interface |
| AppKit | macOS clipboard integration |
| NSPasteboard | Clipboard monitoring and management |
| UserDefaults | Local data persistence |
| Codable | Encoding and decoding clipboard history |

## How It Works

1. **Clipboard Monitoring:** The application checks the system clipboard every second using NSPasteboard.
2. **Change Detection:** The changeCount property determines whether the clipboard has been updated.
3. **History Management:** New text or image content is added to the beginning of the history list.
4. **Duplicate Detection:** Existing items are moved to the top rather than stored multiple times.
5. **Local Persistence:** Clipboard entries are encoded and saved using UserDefaults.
6. **Clipboard Restoration:** Selecting an entry writes its content back to the system clipboard.

## Project Structure

The application uses a ClipboardItem model to represent clipboard entries.

Each item contains:

- A unique identifier
- Optional text content
- Optional image data

The model conforms to Identifiable and Codable, supporting SwiftUI list rendering and local persistence.

## Challenges and What I Learned

Building this application helped me gain hands-on experience with macOS development and working with system-level APIs.

Key learning experiences included:

- Understanding how NSPasteboard detects clipboard changes.
- Using timers to monitor system activity.
- Managing dynamic application state with SwiftUI.
- Handling optional values and different clipboard data types.
- Implementing duplicate detection and history limits.
- Persisting custom Swift data structures using Codable and UserDefaults.
- Building and packaging a macOS application for use on another computer.

## Future Improvements

Potential enhancements include:

- Global keyboard shortcuts for opening clipboard history.
- Search functionality to locate previous entries.
- Pinning frequently used clipboard items.
- Customizable history limits.
- Improved application styling and accessibility.
- Menu bar integration for faster access.

## About This Project

This project was created as a hands-on learning experience to strengthen my understanding of **Swift, SwiftUI, macOS development, and application architecture**.

Rather than focusing only on programming concepts, I wanted to build a functional application that solves an everyday productivity problem.

The project helped me gain experience taking an application from an initial idea to a working, distributable macOS app.

## Author

**Alex Pham**

Computer Science — Software Engineering  
Louisiana State University

## License

No license has been specified for this project.
