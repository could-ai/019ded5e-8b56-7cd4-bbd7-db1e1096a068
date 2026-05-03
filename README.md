# NexHR System

NexHR is a modern, responsive Human Resources application built with Flutter. Designed for administrators and HR personnel, it offers tools to manage the workforce efficiently through an intuitive interface that adapts seamlessly across Web, Desktop, and Mobile environments.

## Features

- **Responsive Dashboard**: An overview of essential workforce metrics including total employees, today's absences, and pending leave requests. Highlights recent leave activities and upcoming work anniversaries.
- **Employee Directory**: A searchable and filterable database of employees grouped by department, complete with a detailed view card for quick access to contact information and corporate details.
- **Leave Management**: A dedicated flow for handling time off. Easily filter leave requests by 'Pending', 'Approved', and 'Rejected', and take administrative action on requests directly from the interface.
- **Responsive Layout**: Adapts between a permanent side navigation rail on larger screens (Web/Desktop) and an ergonomic bottom navigation bar on mobile platforms.
- **Modern UI/UX**: Built with Material 3 design specifications, utilizing a clean and professional color palette.

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider (`provider`)
- **Date Handling**: `intl` for localized formatting

## Setup and Run Instructions

1. Ensure you have the Flutter SDK installed on your system.
2. Clone the repository and navigate into the project directory.
3. Run `flutter pub get` to install the required dependencies (`provider`, `intl`).
4. To run the app, execute `flutter run` and select your target device (Chrome, macOS/Windows, or an attached mobile simulator/device).

## Deployment

The application compiles natively to standard Flutter targets. To build a release web version, you can run `flutter build web` and serve the contents of the `build/web` directory on your preferred web host.

---

## About CouldAI

This application was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.
