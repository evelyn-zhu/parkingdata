# NYC Parking Data Project

## Key Functionalities
- **Large-Scale Dataset**: Analyzes 9 million rows of NYC parking ticket data from [Kaggle](https://www.kaggle.com/new-york-city/nyc-parking-tickets/version/2).
- **Interactive Front-End**: A custom UI with a black background and NYC skyline silhouette.
- **Database Operations**: Includes scripts for automated **data import**, **advanced features** (indexes, transformations), and **CRUD** operations (create, read, update, delete).
- **PHP-Driven Backend**: Manages data connections, insertion, deletion, and retrieval for real-time queries.
- **Full Setup Guide**: Streamlined instructions to quickly replicate or adapt the system using MAMP.

---

## Overview
This project provides a **comprehensive solution** for working with large-scale parking ticket data in New York City. It includes:
1. **Front-End Website** built with HTML, CSS, and PHP for user interaction.
2. **Database Setup Scripts** to create and populate MySQL tables.
3. **Advanced Features** for extended data analysis (via `features.sql`).
4. **PHP Scripts** (`conn.php`, `insertParkingData.php`, etc.) to manage data flow.

---

## Project Setup

1. **Download/Move Files**  
   - Place this entire project folder into:
     ```
     Applications/MAMP/htdocs
     ```
   - (Adjust paths if using a different server environment.)

2. **Initialize the Database**  
   - Run `databaseSetup.sql` to create tables and import the main dataset.
   - **Note**: The import can take ~30 minutes due to the 9 million-row dataset.

3. **Add Advanced Features**  
   - Run `features.sql` to enable additional database optimizations or indexing.

4. **Configure Database Connection**  
   - Update `conn.php` with your local DB credentials (database name, user, password).

5. **Launch the Project**  
   - Start MAMP (or your local server) and navigate to:
     ```
     http://localhost:8888/NYC-Parking-Data-Project/index.html
     ```
   - **Recommended**: Use Safari to ensure the full UI displays correctly.

6. **Verify the UI**  
   - If you see a black background and a NYC skyline silhouette, the front-end is successfully set up.

---

## Usage

- **Data Exploration**: Search for tickets, filter by various criteria, or view “most wanted” ticket data (via `mostWanted.php`).
- **Database Modifications**: Use pages like `deleteTicket.php` or `updateVehicle.php` to remove or modify existing records.
- **Performance Testing**: If needed, test queries and load times on the massive dataset to see how the system handles large data volumes.

---

## File Descriptions

- **`databaseSetup.sql`**  
  - Main script to create database tables and import the large NYC parking dataset.
  
- **`features.sql`**  
  - Additional SQL for enhanced features (indexes, transformations).

- **`conn.php`**  
  - Centralized credentials for database connection.

- **`index.html`**  
  - Entry point for the front-end UI.

- **`deleteTicket.php`, `insertParkingData.php`, etc.**  
  - Server-side PHP scripts to handle CRUD operations on the parking ticket dataset.

- **`.css` Files**  
  - Styling assets (such as `project.css`), ensuring a consistent look and feel.

---

## Notes & Recommendations

- **Browser Compatibility**: Some Chrome versions may not fully display UI elements. Safari is recommended.
- **Data Volume**: Because the dataset is large, certain queries or imports may take a significant amount of time.
- **Local Environment**: This project is demonstrated using MAMP with default ports (often port 8888). Adjust accordingly for your setup.

---

## Contributors
- [**Reilly Koren**](https://github.com/korenrh)  
- [**Evelyn (Junyi) Zhu**](https://github.com/evelyn-zhu)

---

*© 2025. For academic and demonstration purposes.*  
