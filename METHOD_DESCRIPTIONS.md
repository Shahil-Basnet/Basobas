# Basobas Project - Method Descriptions

## Table of Contents
1. [Model Classes](#model-classes)
2. [DAO Classes](#dao-classes)
3. [Service Classes](#service-classes)
4. [Controller Classes](#controller-classes)
5. [Filter Classes](#filter-classes)
6. [Configuration Classes](#configuration-classes)

---

## Model Classes

### User.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `User()` | None | Constructor | Default constructor initializing role to "tenant". |
| `User(String username, String email, String password, String role, String dateOfBirth)` | username, email, password, role, dateOfBirth | Constructor | Parameterized constructor for user registration with essential user details. |
| `getUserId()` | None | int | Returns the unique user ID. |
| `getDisplayId()` | None | String | Returns the display ID (formatted user identifier like TE00001). |
| `getUsername()` | None | String | Returns the username of the user. |
| `getEmail()` | None | String | Returns the email address of the user. |
| `getPassword()` | None | String | Returns the hashed password of the user. |
| `getRole()` | None | String | Returns the role of the user (admin, landlord, tenant). |
| `getFullName()` | None | String | Returns the full name of the user. |
| `getPhone()` | None | String | Returns the phone number of the user. |
| `getAddress()` | None | String | Returns the address of the user. |
| `getDateOfBirth()` | None | String | Returns the date of birth of the user. |
| `getRegisteredAt()` | None | String | Returns the timestamp when the user was registered. |
| `getLastLoggedIn()` | None | String | Returns the timestamp of the last login. |
| `setUserId(int userId)` | userId | void | Sets the unique user ID. |
| `setDisplayId(String displayId)` | displayId | void | Sets the display ID of the user. |
| `setUsername(String username)` | username | void | Sets the username of the user. |
| `setEmail(String email)` | email | void | Sets the email address of the user. |
| `setPassword(String password)` | password | void | Sets the password (stored as hashed password). |
| `setRole(String role)` | role | void | Sets the role of the user (admin, landlord, tenant). |
| `setFullName(String fullName)` | fullName | void | Sets the full name of the user. |
| `setPhone(String phone)` | phone | void | Sets the phone number of the user. |
| `setAddress(String address)` | address | void | Sets the address of the user. |
| `setDateOfBirth(String dateOfBirth)` | dateOfBirth | void | Sets the date of birth of the user. |
| `setRegisteredAt(String registeredAt)` | registeredAt | void | Sets the registration timestamp. |
| `setLastLoggedIn(String lastLoggedIn)` | lastLoggedIn | void | Sets the last login timestamp. |
| `isAdmin()` | None | boolean | Checks if the user has admin role. Returns true if admin, false otherwise. |
| `isLandlord()` | None | boolean | Checks if the user has landlord role. Returns true if landlord, false otherwise. |
| `isTenant()` | None | boolean | Checks if the user has tenant role. Returns true if tenant, false otherwise. |

---

### Property.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `Property()` | None | Constructor | Default constructor initializing property with standard default values (apartment type, 1 bed/bath, available status). |
| `Property(String title, String description, int landlordId, String landlordName, String propertyType, int bedrooms, double bathrooms, double monthlyRent, double securityDeposit, String city, String address, int wardNumber, int floorNumber, String roadAccess, String waterSource, int powerBackupHours)` | Multiple parameters | Constructor | Parameterized constructor for creating new property with full details. |
| `getPropertyId()` | None | int | Returns the unique property ID from database. |
| `setPropertyId(int propertyId)` | propertyId | void | Sets the unique property ID. |
| `getDisplayId()` | None | String | Returns the display ID (formatted as PR00001). |
| `setDisplayId(String displayId)` | displayId | void | Sets the display ID of the property. |
| `getTitle()` | None | String | Returns the title/name of the property. |
| `setTitle(String title)` | title | void | Sets the title of the property. |
| `getDescription()` | None | String | Returns the detailed description of the property. |
| `setDescription(String description)` | description | void | Sets the description of the property. |
| `getLandlordId()` | None | int | Returns the ID of the landlord who owns the property. |
| `setLandlordId(int landlordId)` | landlordId | void | Sets the landlord ID. |
| `getLandlordName()` | None | String | Returns the name of the landlord. |
| `setLandlordName(String landlordName)` | landlordName | void | Sets the landlord name. |
| `getPropertyType()` | None | String | Returns the property type (apartment, house, condo, studio, room, flat, basement). |
| `setPropertyType(String propertyType)` | propertyType | void | Sets the property type. |
| `getBedrooms()` | None | int | Returns the number of bedrooms. |
| `setBedrooms(int bedrooms)` | bedrooms | void | Sets the number of bedrooms. |
| `getBathrooms()` | None | double | Returns the number of bathrooms. |
| `setBathrooms(double bathrooms)` | bathrooms | void | Sets the number of bathrooms. |
| `getMonthlyRent()` | None | double | Returns the monthly rent amount. |
| `setMonthlyRent(double monthlyRent)` | monthlyRent | void | Sets the monthly rent amount. |
| `getSecurityDeposit()` | None | double | Returns the security deposit amount. |
| `setSecurityDeposit(double securityDeposit)` | securityDeposit | void | Sets the security deposit amount. |
| `getCity()` | None | String | Returns the city where the property is located. |
| `setCity(String city)` | city | void | Sets the city. |
| `getAddress()` | None | String | Returns the detailed address of the property. |
| `setAddress(String address)` | address | void | Sets the address. |
| `getWardNumber()` | None | int | Returns the ward number (Nepal-specific location detail). |
| `setWardNumber(int wardNumber)` | wardNumber | void | Sets the ward number. |
| `getFloorNumber()` | None | int | Returns the floor number of the property. |
| `setFloorNumber(int floorNumber)` | floorNumber | void | Sets the floor number. |
| `getRoadAccess()` | None | String | Returns the road access type (2w, 4w, both, none). |
| `setRoadAccess(String roadAccess)` | roadAccess | void | Sets the road access type. |
| `getWaterSource()` | None | String | Returns the water source (municipal, tanker, well, borewell). |
| `setWaterSource(String waterSource)` | waterSource | void | Sets the water source. |
| `getPowerBackupHours()` | None | int | Returns the number of hours of power backup available. |
| `setPowerBackupHours(int powerBackupHours)` | powerBackupHours | void | Sets the power backup hours. |
| `getStatus()` | None | String | Returns the property status (available, rented, maintenance, inactive). |
| `setStatus(String status)` | status | void | Sets the property status. |
| `getAvailableFrom()` | None | String | Returns the date when the property becomes available. |
| `setAvailableFrom(String availableFrom)` | availableFrom | void | Sets the available from date. |
| `getCreatedAt()` | None | String | Returns the creation timestamp. |
| `setCreatedAt(String createdAt)` | createdAt | void | Sets the creation timestamp. |
| `getUpdatedAt()` | None | String | Returns the last update timestamp. |
| `setUpdatedAt(String updatedAt)` | updatedAt | void | Sets the update timestamp. |
| `getPhotos()` | None | List<PropertyPhoto> | Returns the list of property photos. |
| `setPhotos(List<PropertyPhoto> photos)` | photos | void | Sets the list of property photos. |
| `getAmenities()` | None | List<String> | Returns the list of amenities available in the property. |
| `setAmenities(List<String> amenities)` | amenities | void | Sets the list of amenities. |
| `isAvailable()` | None | boolean | Checks if property status is "available". Returns true if available, false otherwise. |
| `getFormattedRent()` | None | String | Returns the monthly rent formatted with currency symbol and commas (e.g., रु 25,000). |
| `toString()` | None | String | Returns string representation of property with displayId, title, city, and rent. |

---

### PropertyPhoto.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `PropertyPhoto()` | None | Constructor | Default constructor initializing photo as non-primary with display order 0. |
| `PropertyPhoto(int propertyId, String photoUrl, boolean isPrimary, String caption)` | propertyId, photoUrl, isPrimary, caption | Constructor | Parameterized constructor for creating property photo with essential details. |
| `getPhotoId()` | None | int | Returns the unique photo ID. |
| `setPhotoId(int photoId)` | photoId | void | Sets the photo ID. |
| `getPropertyId()` | None | int | Returns the ID of the property this photo belongs to. |
| `setPropertyId(int propertyId)` | propertyId | void | Sets the property ID. |
| `getPhotoUrl()` | None | String | Returns the URL/path of the photo file. |
| `setPhotoUrl(String photoUrl)` | photoUrl | void | Sets the photo URL. |
| `isPrimary()` | None | boolean | Checks if this is the primary/main photo. Returns true if primary, false otherwise. |
| `setPrimary(boolean primary)` | primary | void | Sets whether this photo is the primary photo. |
| `getCaption()` | None | String | Returns the caption/description of the photo. |
| `setCaption(String caption)` | caption | void | Sets the photo caption. |
| `getDisplayOrder()` | None | int | Returns the display order of the photo. |
| `setDisplayOrder(int displayOrder)` | displayOrder | void | Sets the display order. |
| `getUploadedAt()` | None | String | Returns the upload timestamp. |
| `setUploadedAt(String uploadedAt)` | uploadedAt | void | Sets the upload timestamp. |

---

## DAO Classes

### UserDAO.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `findByUsername(String username)` | username | User | Searches for a user by username. Returns the User object if found, null otherwise. |
| `findByName(String fullName)` | fullName | User | Searches for a user by full name. Returns the User object if found, null otherwise. |
| `findByEmail(String email)` | email | User | Searches for a user by email address. Returns the User object if found, null otherwise. |
| `findById(int userId)` | userId | User | Searches for a user by user ID. Returns the User object if found, null otherwise. |
| `findByDisplayId(String displayId)` | displayId | User | Searches for a user by display ID. Returns the User object if found, null otherwise. |
| `findByRole(String role)` | role | List<User> | Retrieves all users with a specific role. Returns list of User objects ordered by user_id descending. |
| `searchUsers(String keyword)` | keyword | List<User> | Performs partial search by username, email, or full name. Returns list of matching User objects. |
| `getAllUsers()` | None | List<User> | Retrieves all users stored in the system. Returns a copy of the list containing all user accounts ordered by user_id descending. |
| `countByRole(String role)` | role | int | Counts the number of users with a specific role. Returns the count of users with the given role. |
| `countAllUsers()` | None | int | Counts the total number of users in the system. Returns the total user count. |
| `countUsersFiltered(String search, String role)` | search, role | int | Counts users with applied filters (search keyword and role). Returns the count of filtered users. |
| `getUsersFiltered(String search, String role, int offset, int limit, String sortBy, String sortOrder)` | search, role, offset, limit, sortBy, sortOrder | List<User> | Retrieves filtered users with pagination and sorting. Returns list of filtered and sorted User objects. |
| `save(User user)` | user | boolean | Creates a new user account and stores it in the database. Returns true if successfully added, false otherwise. Also generates and sets displayId. |
| `updateLastLoggedIn(int userId)` | userId | void | Updates the last login timestamp to current time for the specified user. |
| `update(User user)` | user | boolean | Updates user profile information (fullName, phone, address, dateOfBirth). Returns true if successful, false otherwise. |
| `changePassword(int userId, String hashedPassword)` | userId, hashedPassword | boolean | Updates the password for a user (password should be hashed before calling). Returns true if successful, false otherwise. |
| `delete(int userId)` | userId | boolean | Deletes a user from the database. Returns true if successfully deleted, false otherwise. |
| `extractUserFromResultSet(ResultSet rs)` | rs | User (private) | Helper method to extract and map ResultSet data to User object. Returns a fully populated User object. |

---

### PropertyDAO.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `save(Property property)` | property | boolean | Creates a new property and stores it in the database. Returns true if successful, false otherwise. Also generates and sets displayId. |
| `findById(int propertyId)` | propertyId | Property | Searches for a property by property ID. Returns Property object if found, null otherwise. |
| `findByDisplayId(String displayId)` | displayId | Property | Searches for a property by display ID. Returns Property object if found, null otherwise. |
| `getAllProperties()` | None | List<Property> | Retrieves all properties from the database. Returns list of Property objects ordered by property_id descending. |
| `getFilteredProperties(String search, String status, String city, int offset, int limit, String sortBy, String sortOrder)` | search, status, city, offset, limit, sortBy, sortOrder | List<Property> | Retrieves properties with search, status, and city filters along with pagination and sorting. Returns filtered and sorted list of Property objects. |
| `countFilteredProperties(String search, String status, String city)` | search, status, city | int | Counts properties matching the applied filters. Returns the count of filtered properties. |
| `updateStatus(int propertyId, String status)` | propertyId, status | boolean | Updates the status of a property (available, rented, maintenance, inactive). Returns true if successful, false otherwise. |
| `delete(int propertyId)` | propertyId | boolean | Deletes a property from the database. Returns true if successfully deleted, false otherwise. |
| `countAllProperties()` | None | int | Counts the total number of properties in the database. Returns total property count. |
| `countByStatus(String status)` | status | int | Counts the number of properties with a specific status. Returns count of properties with the given status. |
| `generateDisplayId(int propertyId)` | propertyId (private) | String | Generates a formatted display ID for a property (e.g., PR00001). Returns the generated display ID. |
| `updateDisplayId(int propertyId, String displayId)` | propertyId, displayId (private) | void | Updates the display ID in the database after property creation. |
| `getSafeColumnName(String column)` | column (private) | String | Validates column names to prevent SQL injection. Returns safe column name or default. |
| `extractPropertyFromResultSet(ResultSet rs)` | rs (private) | Property | Helper method to extract and map ResultSet data to Property object. Returns a fully populated Property object. |

---

## Service Classes

### AuthService.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `login(String username, String plainPassword)` | username, plainPassword | User | Validates user login by checking if username exists and password matches (using BCrypt). Returns User object if valid, null otherwise. Also updates last login timestamp. |
| `register(String username, String email, String plainPassword, String role, String dateOfBirth)` | username, email, plainPassword, role, dateOfBirth | boolean | Creates a new user account if username and email don't already exist. Hashes password using BCrypt. Returns true if registration successful, false otherwise. |
| `register(String username, String email, String plainPassword, String role, String dateOfBirth, String fullName, String phone, String address)` | username, email, plainPassword, role, dateOfBirth, fullName, phone, address | boolean | Overloaded method for registration with optional profile fields. Creates user account with all details. Returns true if successful, false otherwise. |
| `changePassword(String username, String oldPassword, String newPassword)` | username, oldPassword, newPassword | boolean | Changes the password for a user after verifying the old password. Hashes new password using BCrypt. Returns true if successful, false otherwise. |
| `usernameExists(String username)` | username | boolean | Checks if a username is already registered. Returns true if username exists, false otherwise. |
| `emailExists(String email)` | email | boolean | Checks if an email address is already registered. Returns true if email exists, false otherwise. |

---

## Controller Classes

### AuthController.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `doGet(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles GET requests for login, register, and logout pages. Routes to appropriate JSP page or invalidates session. |
| `doPost(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles POST requests for login and registration forms. Calls processLogin or processRegister based on servlet path. |
| `processLogin(HttpServletRequest request, HttpServletResponse response)` | request, response | void (private) | Validates username and password, authenticates user using AuthService. Sets session attribute and redirects based on user role (admin/landlord/tenant). Shows error if login fails. |
| `processRegister(HttpServletRequest request, HttpServletResponse response)` | request, response | void (private) | Validates registration form data, checks password matching and minimum length (6 chars). Creates user account using AuthService. Redirects to login on success or shows error. |

---

### AdminUserManagementController.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `doGet(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles GET requests for admin user management page. Calls handleList to display filtered user list. |
| `doPost(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles POST requests for user actions (delete, resetPassword, bulkDelete, create). Performs database operations and redirects. |
| `handleList(HttpServletRequest request, HttpServletResponse response)` | request, response | void (private) | Retrieves filtered users with pagination, sorting, and role counts. Supports both HTML and JSON responses based on format parameter. |
| `buildUsersJson(List<User> users, int total, int page, int totalPages, int adminCount, int landlordCount, int tenantCount)` | users, total, page, totalPages, adminCount, landlordCount, tenantCount | String (private) | Builds JSON response containing user list and pagination/role statistics. Returns properly formatted JSON string. |
| `escapeJson(String s)` | s | String (private) | Escapes special characters in JSON strings to prevent syntax errors. Returns escaped string or empty string if null. |
| `handleView(HttpServletRequest request, HttpServletResponse response)` | request, response | void (private) | Placeholder method for viewing user details (currently not implemented). |
| `handleEdit(HttpServletRequest request, HttpServletResponse response)` | request, response | void (private) | Placeholder method for editing user information (currently not implemented). |
| `handleCreate(HttpServletRequest request, HttpServletResponse response)` | request, response | void (private) | Placeholder method for creating new user via form (functionality in doPost). |

---

### AdminPropertyController.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `doGet(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles GET requests for admin property management. Checks admin authorization and retrieves filtered properties with pagination. |
| `doPost(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles POST requests (currently redirects back to properties list). |
| `buildPropertiesJson(List<Property> properties, int total, int page, int totalPages)` | properties, total, page, totalPages | String (private) | Builds JSON response containing property list and pagination information. Returns properly formatted JSON string. |
| `escapeJson(String s)` | s | String (private) | Escapes special characters in JSON strings to prevent syntax errors. Returns escaped string or empty string if null. |

---

### AdminDashboardController.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `doGet(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles GET requests for admin dashboard page. Forwards request to admin/dashboard.jsp. |
| `doPost(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles POST requests by delegating to doGet method. |

---

### TenantDashboardController.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `doGet(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles GET requests for tenant dashboard page. Forwards request to tenant/dashboard.jsp. |
| `doPost(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles POST requests by delegating to doGet method. |

---

### LandlordDashboardController.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `doGet(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles GET requests for landlord dashboard page. Forwards request to landlord/dashboard.jsp. |
| `doPost(HttpServletRequest request, HttpServletResponse response)` | request, response | void | Handles POST requests by delegating to doGet method. |

---

## Filter Classes

### AuthFilter.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `init(FilterConfig filterConfig)` | filterConfig | void | Initializes the filter (currently no-op). Called when filter is first loaded. |
| `doFilter(ServletRequest request, ServletResponse response, FilterChain chain)` | request, response, chain | void | Intercepts all HTTP requests and checks if user is logged in. Allows access to public paths (login, register, static resources) without authentication. Redirects to login page if user is not authenticated. |
| `destroy()` | None | void | Cleans up filter resources when servlet container shuts down (currently no-op). |

---

## Configuration Classes

### DatabaseConfig.java

| Method | Parameters | Return Type | Logic |
|--------|-----------|-------------|-------|
| `getConnection()` | None | Connection | Establishes a connection to MySQL database (basobas_db) at localhost:3306. Loads MySQL JDBC driver and returns active database connection. Returns null if driver not found or connection fails. |
| `main(String[] args)` | args | void | Test method to verify database connection. Called to check if database configuration is correct. |

---

## Summary Statistics

**Total Classes:** 14
**Total Methods:** 165+ (including constructors, getters, setters, and private helpers)

**Package Breakdown:**
- Model (3 classes): User, Property, PropertyPhoto
- DAO (2 classes): UserDAO, PropertyDAO  
- Service (1 class): AuthService
- Controller (6 classes): AuthController, AdminUserManagementController, AdminPropertyController, AdminDashboardController, TenantDashboardController, LandlordDashboardController
- Filter (1 class): AuthFilter
- Config (1 class): DatabaseConfig

