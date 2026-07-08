# Antigravity Developer Rules for FIRE TODO

This document defines the strict development rules and guidelines for the FIRE TODO project. All agents and developers must adhere to these rules to maintain codebase consistency and architecture quality.

---

## 1. UI Architecture & Mixins
*   **Mixins for Screens:** Every screen must leverage Dart Mixins to separate UI structure from its event handlers, state listeners, and helper methods. Keep the main build method clean by delegating actions to screen mixins.
*   **Maximized Mixin Usage:** Maximize the use of mixins to extract screen-specific logic (e.g., date calculations, formatting, event dispatchers) away from the widget build trees.

## 2. State Management & `setState`
*   **Strict BLoC/Cubit Usage:** All business logic and screen-level state management must use BLoC or Cubit.
*   **Minimal `setState`:** `setState` is strictly forbidden for screen-level state or major components. It is **only** allowed in small, isolated, leaf-level widgets that rebuild a tiny portion of the UI (e.g., a local checkbox animation, a custom switch, or a text-field focus indicator).

## 3. Layered Architecture & Validations
*   **UI Validations Only:** Form, input, and UI validation logic (e.g., checking if a text field is empty, email formats) must be performed strictly in the UI layer (screens/widgets).
*   **Separation of Concerns:**
    *   **BLoC/Cubit:** Strictly manages state emissions, handling events, and coordinating use cases.
    *   **Domain Layer:** Business models (`TaskEntity`, `CategoryEntity`) and use cases.
    *   **Data Layer:** Datasources (Isar local database) and repositories.

## 4. Coding Cleanliness & Standards
*   **No Hardcoded Text:** Never write literal, hardcoded strings in the codebase. All UI text, dialog titles, button labels, and descriptions must use localized translation keys via `AppStrings` and `tr()`.
*   **No Comments:** Do not write or leave comments (neither documentation comments nor inline comments) in the codebase. Write clean, self-documenting code.
*   **Use Existing Colors:** Never use ad-hoc hex colors or `Color` constants. Always reuse tokens defined in `AppColors`.

## 5. Reusable Components Registry
Before creating a new widget, always check and reuse these existing components:

### Dialogs
*   `showAddTaskDialog(context, categoryId)`: Opens the dialog to add a new task.
*   `showAddCategoryDialog(context, title)`: Opens the dialog to create a new category.
*   `DeleteConfirmationDialog.show(...)`: Opens confirmation dialog before deleting elements.
*   `showComingSoonDialog(context)`: Shows a placeholder popup for upcoming features.

### Core Widgets
*   `GlobalText`: Universal widget for localized text rendering using project fonts.
*   `GlobalImage`: Universal widget supporting SVGs and local image assets.
*   `AppButton`: Reusable primary button matching styling guidelines.
*   `CustomCloseButton`: Styled close/cancel circular button.
*   `TaskItemCard`: Renders a task with swipe-to-delete, check box, and detail page transitions.
*   `TaskNotAvailableWidget`: Renders the default empty task list state.
*   `ToDoBadge`: Badge showing "TO-DO" next to user name.
*   `SearchTextfield`: Styled input field for searching tasks.
