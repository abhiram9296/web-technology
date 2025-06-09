<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String phoneNumber = request.getParameter("phone_number");
    String address = request.getParameter("address");
    String preferredTheme = request.getParameter("theme") != null ? request.getParameter("theme") : "light";
    String message = null;
    String messageType = "success"; // Default to success
    
    // Store theme in session for persistence
    session.setAttribute("userTheme", preferredTheme);
    
    // Get theme from session if not in request
    if (preferredTheme == null && session.getAttribute("userTheme") != null) {
        preferredTheme = (String) session.getAttribute("userTheme");
    }

    if (fullName != null && email != null && password != null) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create a connection to the database
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/digitalpaymentsystem", "root", "admin");

            // Check if email already exists
            PreparedStatement checkStmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE email = ?");
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);
            
            if (count > 0) {
                message = "Email already registered. Please use a different email.";
                messageType = "error";
            } else {
                // Input validation
                if (password.length() < 8) {
                    message = "Password must be at least 8 characters long.";
                    messageType = "error";
                } else if (!email.contains("@")) {
                    message = "Please enter a valid email address.";
                    messageType = "error";
                } else {
                    // SQL query to insert user data
                    String sql = "INSERT INTO users (full_name, email, password_hash, phone_number, address) VALUES (?, ?, ?, ?, ?)";

                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, fullName);
                    stmt.setString(2, email);
                    
                    // In a real application, you would hash the password
                    // This is a simple example of password hashing with SHA-256
                    // String hashedPassword = org.apache.commons.codec.digest.DigestUtils.sha256Hex(password);
                    // stmt.setString(3, hashedPassword);
                    
                    // For now, using plain password (not recommended for production)
                    stmt.setString(3, password);
                    stmt.setString(4, phoneNumber);
                    stmt.setString(5, address);

                    int result = stmt.executeUpdate();

                    if (result > 0) {
                        message = "Registration successful! Please log in.";
                        messageType = "success";
                    } else {
                        message = "Registration failed. Please try again.";
                        messageType = "error";
                    }
                }
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            message = "This email is already registered.";
            messageType = "error";
        } catch (Exception e) {
            message = "Database error: " + e.getMessage();
            messageType = "error";
        } finally {
            if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
    
    // Dynamic CSS based on theme
    String backgroundColor = preferredTheme.equals("dark") ? "#1a1a1a" : "#f4f5f7";
    String textColor = preferredTheme.equals("dark") ? "#e0e0e0" : "#333333";
    String cardBg = preferredTheme.equals("dark") ? "#2d2d2d" : "#ffffff";
    String inputBg = preferredTheme.equals("dark") ? "#3d3d3d" : "#f8f9fa";
    String inputBorder = preferredTheme.equals("dark") ? "#4d4d4d" : "#ced4da";
    String primaryColor = preferredTheme.equals("dark") ? "#7289da" : "#4e73df";
    String hoverColor = preferredTheme.equals("dark") ? "#677bc4" : "#375dcc";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration - Digital Payment System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --background-color: <%= backgroundColor %>;
            --text-color: <%= textColor %>;
            --card-bg: <%= cardBg %>;
            --input-bg: <%= inputBg %>;
            --input-border: <%= inputBorder %>;
            --primary-color: <%= primaryColor %>;
            --hover-color: <%= hoverColor %>;
            --success-color: #28a745;
            --error-color: #dc3545;
            --warning-color: #ffc107;
            --box-shadow: <%= preferredTheme.equals("dark") ? "0 4px 6px rgba(0, 0, 0, 0.3)" : "0 4px 6px rgba(0, 0, 0, 0.1)" %>;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            transition: background-color 0.3s, color 0.3s;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('https://www.paymentsjournal.com/wp-content/uploads/2021/12/secure-online-payment-internet-banking-via-credit-card-mobile-scaled.jpg');
            background-size: cover; /* Adjust as needed */
            background-position: center; /* Adjust as needed */
            background-repeat: no-repeat;            color: var(--text-color);
            line-height: 1.6;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            width: 100%;
            max-width: 500px;
        }
        
        .card {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--box-shadow);
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .header p {
            color: <%= preferredTheme.equals("dark") ? "#b0b0b0" : "#6c757d" %>;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
            font-size: 14px;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--input-border);
            border-radius: 6px;
            background-color: var(--input-bg);
            color: var(--text-color);
            font-size: 14px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px <%= preferredTheme.equals("dark") ? "rgba(114, 137, 218, 0.25)" : "rgba(78, 115, 223, 0.25)" %>;
        }
        
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 20px;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s, transform 0.1s;
            width: 100%;
        }
        
        .btn:hover {
            background-color: var(--hover-color);
        }
        
        .btn:active {
            transform: translateY(1px);
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
        }
        
        .alert-success {
            background-color: <%= preferredTheme.equals("dark") ? "#2a5d2a" : "#d4edda" %>;
            color: <%= preferredTheme.equals("dark") ? "#c3e6cb" : "#155724" %>;
            border: 1px solid <%= preferredTheme.equals("dark") ? "#3a7d3a" : "#c3e6cb" %>;
        }
        
        .alert-error {
            background-color: <%= preferredTheme.equals("dark") ? "#5d2a2a" : "#f8d7da" %>;
            color: <%= preferredTheme.equals("dark") ? "#e6c3c3" : "#721c24" %>;
            border: 1px solid <%= preferredTheme.equals("dark") ? "#7d3a3a" : "#f5c6cb" %>;
        }
        
        .alert i {
            margin-right: 10px;
        }
        
        .theme-toggle {
            position: absolute;
            top: 20px;
            right: 20px;
            background-color: transparent;
            border: none;
            color: var(--text-color);
            font-size: 20px;
            cursor: pointer;
            padding: 5px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .theme-toggle:hover {
            background-color: <%= preferredTheme.equals("dark") ? "#3d3d3d" : "#e2e2e2" %>;
        }
        
        .form-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: <%= preferredTheme.equals("dark") ? "#a0a0a0" : "#6c757d" %>;
        }
        
        .form-footer a {
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .form-footer a:hover {
            text-decoration: underline;
        }
        
        .password-wrapper {
            position: relative;
        }
        
        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: <%= preferredTheme.equals("dark") ? "#a0a0a0" : "#6c757d" %>;
            cursor: pointer;
        }
        
        /* Password strength indicator */
        .password-strength {
            height: 5px;
            margin-top: 5px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .strength-weak {
            background-color: #dc3545;
            width: 33%;
        }
        
        .strength-medium {
            background-color: #ffc107;
            width: 66%;
        }
        
        .strength-strong {
            background-color: #28a745;
            width: 100%;
        }
        
        /* Responsive adjustments */
        @media (max-width: 576px) {
            .container {
                padding: 10px;
            }
            
            .card {
                padding: 20px;
            }
            
            .header h2 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <button class="theme-toggle" id="theme-toggle" title="Toggle theme">
        <i class="fas <%= preferredTheme.equals("dark") ? "fa-sun" : "fa-moon" %>"></i>
    </button>
    
    <div class="container">
        <div class="card">
            <div class="header">
                <h2>Create Your Account</h2>
                <p>Join Digital Payment System to manage your finances securely</p>
            </div>
            
            <% if (message != null) { %>
                <div class="alert <%= messageType.equals("success") ? "alert-success" : "alert-error" %>">
                    <i class="fas <%= messageType.equals("success") ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                    <%= message %>
                </div>
            <% } %>
            
            <form action="register.jsp" method="post" id="registrationForm">
                <input type="hidden" name="theme" id="theme-input" value="<%= preferredTheme %>">
                
                <div class="form-group">
                    <label for="full_name">Full Name</label>
                    <input type="text" class="form-control" id="full_name" name="full_name" 
                           value="<%= fullName != null ? fullName : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" class="form-control" id="email" name="email" 
                           value="<%= email != null ? email : "" %>" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input type="password" class="form-control" id="password" name="password" 
                               required minlength="8">
                        <button type="button" class="toggle-password" id="toggle-password">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <div class="password-strength" id="password-strength"></div>
                    <small id="password-feedback" style="display: none; margin-top: 5px; font-size: 12px;"></small>
                </div>
                
                <div class="form-group">
                    <label for="phone_number">Phone Number</label>
                    <input type="tel" class="form-control" id="phone_number" name="phone_number" 
                           value="<%= phoneNumber != null ? phoneNumber : "" %>">
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea class="form-control" id="address" name="address"><%= address != null ? address : "" %></textarea>
                </div>
                
                <button type="submit" class="btn">Register</button>
                
                <div class="form-footer">
                    Already have an account? <a href="login.jsp">Log in</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Theme toggle functionality
        const themeToggle = document.getElementById('theme-toggle');
        const themeInput = document.getElementById('theme-input');
        
        themeToggle.addEventListener('click', function() {
            const currentTheme = themeInput.value;
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            
            themeInput.value = newTheme;
            
            // Submit form to update theme
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = window.location.href;
            
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'theme';
            input.value = newTheme;
            
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        });
        
        // Password visibility toggle
        const togglePassword = document.getElementById('toggle-password');
        const passwordInput = document.getElementById('password');
        
        togglePassword.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.querySelector('i').classList.toggle('fa-eye');
            this.querySelector('i').classList.toggle('fa-eye-slash');
        });
        
        // Password strength meter
        const passwordStrength = document.getElementById('password-strength');
        const passwordFeedback = document.getElementById('password-feedback');
        
        passwordInput.addEventListener('input', function() {
            const value = this.value;
            
            if (value.length === 0) {
                passwordStrength.className = 'password-strength';
                passwordStrength.style.width = '0';
                passwordFeedback.style.display = 'none';
                return;
            }
            
            passwordFeedback.style.display = 'block';
            
            // Very basic strength detection
            if (value.length < 8) {
                passwordStrength.className = 'password-strength strength-weak';
                passwordFeedback.textContent = 'Password is too short';
                passwordFeedback.style.color = '#dc3545';
            } else if (value.length >= 8 && (!/[A-Z]/.test(value) || !/[0-9]/.test(value))) {
                passwordStrength.className = 'password-strength strength-medium';
                passwordFeedback.textContent = 'Moderate - add uppercase letters and numbers';
                passwordFeedback.style.color = '#ffc107';
            } else if (value.length >= 10 && /[A-Z]/.test(value) && /[0-9]/.test(value) && /[^A-Za-z0-9]/.test(value)) {
                passwordStrength.className = 'password-strength strength-strong';
                passwordFeedback.textContent = 'Strong password';
                passwordFeedback.style.color = '#28a745';
            } else {
                passwordStrength.className = 'password-strength strength-medium';
                passwordFeedback.textContent = 'Add special characters for stronger password';
                passwordFeedback.style.color = '#ffc107';
            }
        });
        
        // Form validation
        const form = document.getElementById('registrationForm');
        
        form.addEventListener('submit', function(event) {
            const password = passwordInput.value;
            
            if (password.length < 8) {
                event.preventDefault();
                alert('Password must be at least 8 characters long');
                return false;
            }
            
            return true;
        });
    </script>
</body>
</html>