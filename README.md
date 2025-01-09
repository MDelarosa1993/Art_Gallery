# **🎨 Online Art Gallery API**

The Online Art Gallery API is a Rails API-only application that connects **artists**, **buyers**, and **admins**. Artists can upload and manage their artwork, buyers can browse and purchase artwork, and admins oversee platform operations. This API features secure JWT-based authentication, role-based access control, and dynamic order management.

---

## **Features**

- **JWT Authentication**: Secure login and token-based API requests.
- **Role-Based Access Control**: Enforced permissions for artists, buyers, and admins.
- **Dynamic Artwork Management**: Artists can create, update, and delete their artwork.
- **Order System**: Buyers can create and manage orders with detailed purchase history.
- **Admin Controls**: Admins can manage users, oversee orders, and resolve disputes.
- **RESTful API Endpoints**: Structured routes for users, orders, and admin functionalities.

---

## **Installation**

### **Prerequisites**
- Ruby 3.2.2
- Rails 7.1.3
- PostgreSQL

### **Steps**
1. Clone the repository:
   ```bash
   git clone git@github.com:MDelarosa1993/Art_Gallery.git
   cd Art_Gallery
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```
4. Start the Rails server:
   ```bash
   rails server
   ```

---

## **Database Schema**

### **Users Table**
- `id`: Primary key
- `name`: String
- `email`: String (unique)
- `password_digest`: String
- `role`: Enum (`artist`, `buyer`, `admin`)
- Timestamps: `created_at`, `updated_at`

### **Artworks Table**
- `id`: Primary key
- `title`: String
- `description`: Text
- `price`: Decimal
- `user_id`: Foreign key (User, role: `artist`)
- Timestamps: `created_at`, `updated_at`

### **Orders Table**
- `id`: Primary key
- `user_id`: Foreign key (User, role: `buyer`)
- `total_price`: Decimal
- `status`: String (`pending`, `completed`, `cancelled`)
- Timestamps: `created_at`, `updated_at`

### **Order Items Table**
- `id`: Primary key
- `order_id`: Foreign key (Order)
- `artwork_id`: Foreign key (Artwork)
- `quantity`: Integer
- `price`: Decimal
- Timestamps: `created_at`, `updated_at`

---

## **API Endpoints**

### **Users**
- `POST /api/v1/users`: Register a new user.
- `POST /api/v1/auth`: Authenticate a user and return a JWT token.

### **Artworks**
- `GET /api/v1/users/:user_id/artworks`: List artworks for a specific artist.
- `POST /api/v1/users/:user_id/artworks`: Create a new artwork (artists only).
- `DELETE /api/v1/users/:user_id/artworks/:id`: Delete an artwork (artists only).

### **Orders**
- `GET /api/v1/users/:user_id/orders`: Retrieve all orders for a buyer.
- `POST /api/v1/users/:user_id/orders`: Create a new order.

### **Admin**
- `GET /api/v1/admin/users`: Retrieve all users grouped by roles.
- `GET /api/v1/admin/orders`: View all orders across the platform.

---

## **Key Gems**

| **Gem**              | **Purpose**                                         |
|-----------------------|-----------------------------------------------------|
| `bcrypt`             | Secure password handling.                           |
| `jwt`                | JSON Web Tokens for authentication.                |
| `rspec-rails`        | Testing framework for Rails.                        |
---

## **Testing**

The application uses **RSpec** for testing with coverage for:
- Authentication and authorization.
- CRUD operations for users, artworks, and orders.
- Admin-only functionality.

### **Run Tests**
```bash
bundle exec rspec
```

---

## **API Documentation**

### **Example: Create an Order**
#### Request
```http
POST /api/v1/users/1/orders
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>

{
  "order": {
    "total_price": 150.00,
    "order_items_attributes": [
      { "artwork_id": 2, "quantity": 1, "price": 150.00 }
    ]
  }
}
```
#### Response
```json
{
  "id": 1,
  "user_id": 1,
  "total_price": "150.0",
  "status": "pending",
  "order_items": [
    {
      "artwork_id": 2,
      "quantity": 1,
      "price": "150.0"
    }
  ]
}
```

---

## **Future Enhancements**

- **Search Functionality**: Implement search filters for artworks by category, price, or artist.
- **Email Notifications**: Notify users about order status and updates.
- **Analytics Dashboard**: Add a detailed admin dashboard for monitoring platform activity.
- **Promotions**: Enable discount codes for buyers during checkout.
- **Serializers**: Only send the data thats needed, no sensitive information.
---