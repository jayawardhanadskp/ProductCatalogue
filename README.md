# Product Catalogue Application


![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dio](https://img.shields.io/badge/Dio-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Hive](https://img.shields.io/badge/Hive-FF6F00?style=for-the-badge&logo=hive&logoColor=white)
![GoRouter](https://img.shields.io/badge/GoRouter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Mocktail](https://img.shields.io/badge/Mocktail-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Flutter CI](https://github.com/jayawardhanadskp/ProductCatalogue/actions/workflows/flutter_ci.yml/badge.svg)


A Flutter product catalogue app built for the practical assessment. This project demonstrates a production-ready approach to building a scalable, responsive, and robust mobile application using Flutter and Dart. Browse products, infinite scrolling pagination, filter by category, search by name, save favourites and theme management — all backed by [DummyJSON](https://dummyjson.com/).


## Project Overview

The app has three real screens (Home, Product Details, Favourites) and one intentionally static demo screen (Cart — more on that in Assumptions below). Products load from DummyJSON with pagination, category filtering, and debounced search. Favourites persist locally with Hive, so they survive an app restart. Light/dark theme is switchable and follows the system by default.

Key features implemented:
- **Infinite Scrolling Pagination**: The product grid dynamically loads more items as the user scrolls, seamlessly managing API offset and limit parameters to handle large catalogues efficiently.
- **Debounced Real-Time Search**: The search functionality utilizes a 300ms debounce timer to prevent API spam, ensuring smooth typing and optimized network usage.
- **Category Filtering**: Users can filter products by specific categories. The category list automatically scrolls to keep the selected category in view.
- **Persistent Favorites**: Users can add products to their favorites list. These are saved locally using a Hive database, meaning favorites persist even when the app is completely closed and reopened.
- **System-Wide Theme Management**: Full support for Light and Dark modes. The user's preference is saved locally via Hive and applied instantly across the entire application without requiring a restart.
- **Advanced UI/UX**: Utilizes a CustomScrollView with slivers for a sticky search bar and header. Includes shimmer loading effects for network images, beautiful empty states, and graceful error handling with retry mechanisms.
- **Stateful Routing**: Built with GoRouter's StatefulNavigationShell to preserve the state of the Home, Favorites, and Cart tabs when switching between them.



## Setup Instructions

### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio / VS Code with Flutter extension
- Connected Android device, iOS simulator, or Android emulator

### Installation and Running

1. Clone the repository:
   ```bash
   git clone https://github.com/jayawardhanadskp/ProductCatalogue.git
   cd ProductCatalogue
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the project:
   ```bash
   flutter run --dart-define=BASE_URL=https://dummyjson.com
   ```
The base URL is passed in via `--dart-define` rather than hardcoded, so it can be swapped per environment without touching code (see `app_config.dart`).

### Building Release APK

```bash
flutter build apk --release --dart-define=BASE_URL=https://dummyjson.com
```
The output APK lands in `build/app/outputs/flutter-apk/app-release.apk`.



## Architecture

The project follows a clean, layered architecture designed to separate business logic, network communication, database operations, and UI presentation.

### Folder Structure
```text
lib/
├── app/          # Core routing setup (GoRouter) and main AppShell layout
├── config/       # App-wide constants (base URL)
├── models/       # Data models + generated Hive adapters
├── providers/    # State management (Provider / ChangeNotifier)
├── services/     # External integrations: Network (Dio) and Database (Hive)
├── theme/        # Centralized design system (Colors, Dimensions, TextStyles)
├── views/        # UI screens grouped by feature (Home, Product, Cart, Favorites)
├── widgets/      # Globally Reusable UI components (Shimmer Images, Theme Toggles)
└── main.dart     # Entry point, Hive setup, Dependency Initialization wiring
```
Services and providers are kept as separate layers on purpose: a `ProductService`/`FavouriteDatabaseService` only knows how to talk to Dio or Hive, and has no idea a UI exists. A `ProductProvider`/`FavouriteProvider` only knows about loading flags and lists, and has no idea whether the data came from a REST API or a local box. This split is what let me swap out how favourites are stored midway through the project (see Challenges) without touching a single widget.



### State Management
The `provider` package is used for reactive state management, keeping the UI perfectly synchronized with the underlying data.

- **ProductProvider**: product list, pagination, debouncing search inputs, category filtering. Separate loading/error flags per action (`isInitialLoading` vs `isSearchLoading` vs `isCategoryProductsLoading`) instead of one shared boolean, so the UI can show the right feedback for the right action instead of a generic spinner for everything.
- **FavouriteProvider**: favourite ids + toggle logic, with an optimistic update (flip the UI immediately, roll back if the write fails) so tapping a heart never feels laggy, instantly notifying all listeners across the Home grid, Product Details screen, Favorite Screen.
- **ThemeProvider**: Manages the active ThemeMode and synchronizes it with local storage. (As default System / Light / Dark)


### API Integration
Dio, wrapped in a single `DioClient` singleton. A few things worth calling out:
 
- **Error handling lives in one place.** Dio's `validateStatus` already rejects anything outside 2xx as a `DioException` before my code ever sees the response, so there's no manual `if (statusCode == 200)` check anywhere — that would just be re-checking something the client already guarantees. `DioClient.handleError` turns every `DioException` into a typed `ApiException` with a message that's actually useful (timeout vs no connection vs 404 vs 5xx), instead of every screen showing a raw stack trace.
- **Services are constructor-injected**, e.g. `ProductService({DioClient? client})`, so tests can pass a mock without touching the real network.
- **Image memory footprint.** Product images are decoded near their actual display size (`memCacheWidth`/`memCacheHeight` on every network image) rather than at full source resolution, since a thumbnail-sized grid card has no business holding a multi-megapixel bitmap in memory.


## Assumptions

- The app utilizes the DummyJSON REST API (`https://dummyjson.com`) to provide a realistic demonstration of remote data fetching, pagination, and search capabilities.
- Local storage using Hive was selected over SQLite to provide a lightweight, incredibly fast NoSQL solution for persisting user preferences and favorite items.
- **Favourites store a full local snapshot of the product**, not just an id. DummyJSON has no batch "get products by ids" endpoint, so a favourites screen backed by ids-only would mean firing one request per favourited item — slow, and completely broken offline.
- **Cart screen is a static UI demonstration, not a real feature.** It wasn't part of the core requirements, and the assessment explicitly asks not to over build. I mocked up the screen to show the intended layout/flow.
- **Theme follows the system by default**, with a manual override the user can set, persisted via Hive.
- **Product Details navigation uses direct object passing instead of re-fetching by ID.** Since the product catalogue endpoint already returns complete product payloads (description, ratings, image URLs), passing the `ProductModel` directly to `ProductDetailsScreen` provides an instant, zero-latency user experience without redundant network requests. (The underlying `ProductService.getProduct(id)` method is implemented and available should deep-linking or live stock checks be added in the future).



## Challenges & Solutions

- **Cards rendered a different height on different devices.** The product image inside each card had a fixed pixel height, but the grid cell's actual height depends on screen width — so iOS simulator, Android emulator, and a real Android device each computed a different cell size, and the fixed-height image either overflowed or left a gap. Rather than special-casing a different `childAspectRatio` per platform (which just relocates the bug to the next new device), I made the image `Expanded` inside the card's `Column`, so it always fills whatever space is actually left over after the text block — correct on any screen, no platform check needed.
- **Handling Large Data Sets**: Fetching all products at once would cause performance issues. This was solved by implementing a custom ScrollController listener in the HomeScreen that triggers the `ProductProvider` to fetch the next batch of products (pagination) before the user hits the bottom of the list.
- **Optimizing Search Requests**: Firing an API request for every keystroke during a search could lead to rate-limiting and UI stutter. This was handled by implementing a custom Timer-based debounce mechanism inside the provider, ensuring requests only fire when the user pauses typing.
- **The search bar didn't clear when a category was selected.** The `TextField`'s controller was local widget state with no link back to the provider that actually owns the current query — so clearing the query in the provider had no way to reach the widget. Fixed by having the search bar listen to the provider and sync its own controller only when the two drift apart, instead of fighting the user's own typing on every rebuild.
- **Search and category filtering fought each other.** My first version let a search query and a selected category both stay "active" in state at the same time, and `loadMore()` had to guess which one to paginate against — which meant one of them silently got ignored during pagination. Once I checked DummyJSON's actual docs, it turned out there's no endpoint that supports both together anyway (`/products/search` and `/products/category/{cat}` are separate, and neither accepts the other's parameter). So I made them mutually exclusive at the state level instead of patching around it: picking a category clears the current search, and typing a search clears the selected category. That removed the ambiguity in `loadMore()` entirely, and I added a small scroll-sync on the category chip row so it visibly resets to "All Items" when a search clears it, instead of silently changing state the user can't see.



## Testing

Test coverage focuses on core state management and network logic using **Mocktail** for isolation:

- **ProductProvider**: Tests pagination guards (prevents duplicate in-flight requests and halts when `hasMore` is false), search debouncing (rapid typing only triggers one request for the final query after 300ms), and error/loading state updates.
- **FavouriteProvider**: Tests initialization of local favorite IDs from Hive database, retrieval of saved product snapshots, and reactive toggle logic (adding/removing products from local storage).
- **ProductService**: Tests endpoint request shapes, query parameters (`limit`, `skip`, `q`), JSON parsing into `ProductResponseModel`, and translation of `DioException` errors into user-friendly `ApiException` objects.

To run the full test suite:
```bash
flutter test
```


## Continuous Integration (CI)

Every pull request targeting the `main` branch automatically triggers the CI pipeline using GitHub Actions.

The pipeline performs automated code quality checks and validation by running:

- `flutter analyze` - to identify potential code issues and maintain code quality.
- `flutter test` - to execute the unit test suite and ensure application functionality remains stable.

The workflow also supports manual execution through the GitHub Actions interface using `workflow_dispatch`.

This CI process helps maintain code reliability, detect issues early, and ensure that new changes meet the project's quality standards before being merged into the main branch.


## Future Improvements

- Implementation of a full checkout flow and cart item quantity management.
- Expansion of the testing suite to include comprehensive integration and UI widget tests alongside the existing unit tests.
- Offline caching of the API product responses to allow full catalogue browsing without an active internet connection.


## Screenshots

<table>
  <tr>
    <th>Light</th>
    <th>Dark</th>
  </tr>
  <tr>
    <td align="center">
      <img width="220" alt="home-light" src="https://github.com/user-attachments/assets/e681030c-b642-41db-bf2b-c8b32dc680d3" /><br/>
      <sub>Home</sub>
    </td>
    <td align="center">
      <img width="220" alt="home-dark" src="https://github.com/user-attachments/assets/a3e1bfb1-5ed6-42cc-845a-de9cc6ee121a" /><br/>
      <sub>Home</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="220" alt="details-light" src="https://github.com/user-attachments/assets/9ff7a5cd-cc4b-4136-9a7d-bb5ef1f703b8" /><br/>
      <sub>Product Details</sub>
    </td>
    <td align="center">
      <img width="220" alt="details-dark" src="https://github.com/user-attachments/assets/4d8a68a3-fd79-4ebe-bc40-a394fca22e11" /><br/>
      <sub>Product Details</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="220" alt="favourites-light" src="https://github.com/user-attachments/assets/5a00fe16-74c3-44a9-ae25-0fdb16bed4a7" /><br/>
      <sub>Favourites</sub>
    </td>
    <td align="center">
      <img width="220" alt="favourites-dark" src="https://github.com/user-attachments/assets/42ec30cd-ff68-4639-b7ab-0a4d9acacbf0" /><br/>
      <sub>Favourites</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img width="220" alt="cart-light" src="https://github.com/user-attachments/assets/1654013f-cc4e-4bd4-afa2-b5e516a7914d" /><br/>
      <sub>Cart (demo only)</sub>
    </td>
    <td align="center">
      <img width="220" alt="cart-dark" src="https://github.com/user-attachments/assets/9cf4a778-10b5-4e4b-b657-71ce6a0236d1" /><br/>
      <sub>Cart (demo only)</sub>
    </td>
  </tr>
</table>

## Demo Video

<table>
<tr>
<td width="300">

<video src="https://github.com/user-attachments/assets/b0b07e7e-a4c1-4d5d-be40-293552c20e62" controls></video>

</td>

</tr>
</table>


