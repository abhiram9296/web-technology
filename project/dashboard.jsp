<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Gateway Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --primary-light: #e0e7ff;
            --secondary-color: #3f37c9;
            --accent-color: #4895ef;
            --success-color: #4cc9f0;
            --warning-color: #f8961e;
            --danger-color: #f72585;
            --dark-color: #1a1a2e;
            --light-color: #f8f9fa;
            --gray-color: #6c757d;
            --border-radius: 12px;
            --box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f7ff;
            color: var(--dark-color);
            line-height: 1.6;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }

        h1 {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--dark-color);
            position: relative;
            display: inline-block;
        }

        h1::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 4px;
            background: var(--primary-color);
            border-radius: 2px;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-weight: 600;
            font-size: 1.2rem;
        }

        /* Tab styles */
        .tab-container {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .tab-buttons {
            display: flex;
            position: relative;
        }

        .tab-btn {
            flex: 1;
            padding: 15px 20px;
            border: none;
            background: transparent;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.95rem;
            color: var(--gray-color);
            transition: var(--transition);
            text-align: center;
            position: relative;
            z-index: 2;
        }

        .tab-btn:hover {
            color: var(--primary-color);
        }

        .tab-btn.active {
            color: var(--primary-color);
            font-weight: 600;
        }

        .tab-indicator {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 3px;
            background: var(--primary-color);
            transition: var(--transition);
            z-index: 1;
        }

        .tab-content {
            display: none;
            padding: 25px;
            animation: fadeIn 0.5s;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .tab-content.active {
            display: block;
        }

        /* Gateway cards */
        .gateways-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        .gateway-card {
            background: white;
            padding: 25px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            transition: var(--transition);
            border-left: 4px solid var(--primary-color);
            position: relative;
            overflow: hidden;
        }

        .gateway-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .gateway-card h3 {
            margin: 0 0 15px;
            color: var(--dark-color);
            font-size: 1.3rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .gateway-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
        }

        .gateway-card p {
            margin: 8px 0;
            color: var(--gray-color);
            font-size: 0.9rem;
        }

        .currency-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 15px;
        }

        .currency-chip {
            background-color: var(--primary-light);
            color: var(--primary-color);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        /* Transactions table */
        .transactions-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
        }

        .transactions-table th,
        .transactions-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .transactions-table th {
            background-color: var(--primary-light);
            color: var(--primary-color);
            font-weight: 600;
        }

        .transactions-table tr:hover {
            background-color: #f9f9f9;
        }

        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            color: white;
            display: inline-block;
            text-transform: uppercase;
        }

        .status-completed {
            background-color: var(--success-color);
        }

        .status-pending {
            background-color: var(--warning-color);
        }

        .status-failed {
            background-color: var(--danger-color);
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }

        .empty-state i {
            font-size: 60px;
            margin-bottom: 20px;
            color: var(--primary-light);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .dashboard-container {
                padding: 15px;
            }
            
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            h1 {
                font-size: 1.8rem;
            }
            
            .tab-buttons {
                flex-direction: column;
            }
            
            .gateways-grid {
                grid-template-columns: 1fr;
            }
            
            .transactions-table {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Payment Gateway Dashboard</h1>
            <div class="user-profile">
                <div class="avatar">AD</div>
                <div class="user-info">
                    <h3>Abhiram</h3>
                    <p>Last login: 2 hours ago</p>
                </div>
            </div>
        </div>

        <div class="tab-container">
            <div class="tab-buttons">
                <div class="tab-indicator" style="width: 50%; transform: translateX(0%);"></div>
                <button class="tab-btn active" data-tab="gateways">
                    <i class="material-icons-round">payment</i> Gateways
                </button>
                <button class="tab-btn" data-tab="transactions">
                    <i class="material-icons-round">receipt_long</i> Transactions
                </button>
            </div>

            <!-- Gateways Tab -->
            <div id="gateways" class="tab-content active">
                <h2 class="section-title">
                    <i class="material-icons-round">account_balance</i> Available Payment Gateways
                </h2>
                <div class="gateways-grid">
                    <div class="gateway-card">
                        <h3><div class="gateway-icon"><i class="material-icons-round">account_balance_wallet</i></div> Alipay</h3>
                        <p>Popular in China, used globally for online and in-store payments with over 1.3 billion users.</p>
                        <p><strong>Processing Time:</strong> Instant - 3 business days</p>
                        <p><strong>Fees:</strong> 0.55% - 1.2% per transaction</p>
                        <div class="currency-list">
                            <span class="currency-chip">CNY</span>
                            <span class="currency-chip">USD</span>
                            <span class="currency-chip">EUR</span>
                            <span class="currency-chip">GBP</span>
                        </div>
                    </div>

                    <div class="gateway-card">
                        <h3><div class="gateway-icon"><i class="material-icons-round">chat</i></div> WeChat Pay</h3>
                        <p>Widely used in China, often linked to messaging and lifestyle app WeChat with 1.2 billion users.</p>
                        <p><strong>Processing Time:</strong> Instant - 2 business days</p>
                        <p><strong>Fees:</strong> 0.6% - 1% per transaction</p>
                        <div class="currency-list">
                            <span class="currency-chip">CNY</span>
                            <span class="currency-chip">USD</span>
                        </div>
                    </div>

                    <div class="gateway-card">
                        <h3><div class="gateway-icon"><i class="material-icons-round">public</i></div> PayPal</h3>
                        <p>International gateway supporting multiple currencies and merchant integrations in 200+ markets.</p>
                        <p><strong>Processing Time:</strong> Instant - 5 business days</p>
                        <p><strong>Fees:</strong> 1.9% - 3.5% + fixed fee</p>
                        <div class="currency-list">
                            <span class="currency-chip">USD</span>
                            <span class="currency-chip">EUR</span>
                            <span class="currency-chip">GBP</span>
                            <span class="currency-chip">CAD</span>
                            <span class="currency-chip">AUD</span>
                            <span class="currency-chip">+25 more</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Transactions Tab -->
            <div id="transactions" class="tab-content">
                <h2 class="section-title">
                    <i class="material-icons-round">history</i> Transaction History
                </h2>
                <table class="transactions-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Gateway</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>TXN-1001</td>
                            <td>PayPal</td>
                            <td>$125.00</td>
                            <td><span class="status-badge status-completed">Completed</span></td>
                            <td>2025-04-20 14:30:22</td>
                        </tr>
                        <tr>
                            <td>TXN-1002</td>
                            <td>Alipay</td>
                            <td>$850.00</td>
                            <td><span class="status-badge status-pending">Pending</span></td>
                            <td>2025-04-19 10:15:47</td>
                        </tr>
                        <tr>
                            <td>TXN-1003</td>
                            <td>WeChat Pay</td>
                            <td>$1,200.00</td>
                            <td><span class="status-badge status-completed">Completed</span></td>
                            <td>2025-04-18 18:45:12</td>
                        </tr>
                        <tr>
                            <td>TXN-1004</td>
                            <td>PayPal</td>
                            <td>$75.50</td>
                            <td><span class="status-badge status-failed">Failed</span></td>
                            <td>2025-04-17 09:20:33</td>
                        </tr>
                        <tr>
                            <td>TXN-1005</td>
                            <td>Alipay</td>
                            <td>$2,300.00</td>
                            <td><span class="status-badge status-completed">Completed</span></td>
                            <td>2025-04-15 16:10:08</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching functionality
            const tabButtons = document.querySelectorAll('.tab-btn');
            const tabContents = document.querySelectorAll('.tab-content');
            const tabIndicator = document.querySelector('.tab-indicator');
            
            tabButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons and contents
                    tabButtons.forEach(btn => btn.classList.remove('active'));
                    tabContents.forEach(content => content.classList.remove('active'));
                    
                    // Add active class to clicked button and corresponding content
                    this.classList.add('active');
                    const tabId = this.getAttribute('data-tab');
                    document.getElementById(tabId).classList.add('active');
                    
                    // Move the indicator
                    const buttonIndex = Array.from(tabButtons).indexOf(this);
                    const buttonWidth = 100 / tabButtons.length;
                    tabIndicator.style.width = `${buttonWidth}%`;
                    tabIndicator.style.transform = `translateX(${buttonIndex * 100}%)`;
                });
            });
            
            // Simulate loading data (in a real app, this would be AJAX)
            function loadTransactions() {
                // This would be replaced with actual API calls
                console.log("Loading transactions...");
            }
            
            // Initialize
            loadTransactions();
        });
    </script>
</body>
</html>