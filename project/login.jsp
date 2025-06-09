<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.net.URLEncoder" %>  <!-- Add this import statement -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String error = null;

    if (email != null && password != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL 8+
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitalpaymentsystem", "root", "admin");

            String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password); // In production, hash before comparing

            rs = stmt.executeQuery();

            if (rs.next()) {
                // User found — redirect to dashboard with full_name
                String fullName = rs.getString("full_name");
                response.sendRedirect("dashboard.jsp?fullName=" + URLEncoder.encode(fullName, "UTF-8"));
                return;
            } else {
                error = "Invalid email or password.";
            }

        } catch (Exception e) {
            error = "Database error: " + e.getMessage();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment System Login</title>
    <style>
       html, body {
            height: 100%;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background-image: url('https://payneteasy.com/static/img/blog/key-digital-payment-trends-retailers-should-watch-in-2023/1.jpg?v=1');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        .container {
            max-width: 400px;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        h2 {
            text-align: center;
            color: #333;
        }
        label, input {
            display: block;
            width: 100%;
            margin-top: 10px;
        }
        input {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            margin-top: 20px;
            padding: 10px;
            background: #007BFF;
            color: white;
            border: none;
            border-radius: 5px;
        }
        .btn:hover {
            background: #0056b3;
        }
        .error-message {
            color: red;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Login to Payment System</h2>
    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>
    <form method="post" action="login.jsp">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <button type="submit" class="btn">Login</button>
    </form>
</div>
</body>
</html>
