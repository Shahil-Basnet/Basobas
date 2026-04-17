<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Basobas | Admin Dashboard</title>
    <!-- Google Fonts (clean, modern) -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Material Icons (lightweight, consistent) -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    <style>
        /* ---------- RESET & BASE (vanilla CSS, no frameworks) ---------- */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f4f6f9;
            color: #1e2a3a;
            line-height: 1.5;
        }

        /* ---------- SIDEBAR (flex column, fixed) ---------- */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            width: 260px;
            height: 100vh;
            background: #ffffff;
            border-right: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            z-index: 50;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.02);
        }

        .sidebar-header {
            padding: 28px 24px;
            border-bottom: 1px solid #edf2f7;
        }

        .sidebar-header h1 {
            font-size: 1.65rem;
            font-weight: 700;
            background: linear-gradient(135deg, #1e3c2c, #2b5e3b);
            background-clip: text;
            -webkit-background-clip: text;
            color: transparent;
            letter-spacing: -0.3px;
        }

        .sidebar-header p {
            font-size: 0.7rem;
            color: #5b6e8c;
            margin-top: 6px;
            font-weight: 500;
        }

        .nav-links {
            flex: 1;
            padding: 24px 16px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            color: #4a5b6e;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .nav-link .material-symbols-outlined {
            font-size: 1.35rem;
        }

        .nav-link.active {
            background: #eef5ea;
            color: #1f5437;
            font-weight: 600;
        }

        .nav-link:not(.active):hover {
            background: #f1f5f9;
            color: #1f3b2c;
        }

        .profile-section {
            padding: 20px 20px 28px;
            border-top: 1px solid #eef2f6;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            width: 44px;
            height: 44px;
            background: #2c5f3a;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .profile-info p {
            font-size: 0.8rem;
            font-weight: 500;
            color: #1e2a3a;
        }

        .profile-info span {
            font-size: 0.7rem;
            color: #6c7a91;
        }

        /* ---------- MAIN LAYOUT (margin-left for sidebar) ---------- */
        .main-content {
            margin-left: 260px;
            min-height: 100vh;
            background: #f8fafc;
        }

        /* top bar (clean, sticky) */
        .top-bar {
            position: sticky;
            top: 0;
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid #e9edf2;
            padding: 0 32px;
            height: 70px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            z-index: 40;
        }

        .search-wrapper {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 48px;
            padding: 8px 18px;
            width: 280px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }

        .search-wrapper .material-symbols-outlined {
            color: #8896ab;
            font-size: 1.2rem;
        }

        .search-wrapper input {
            border: none;
            background: transparent;
            outline: none;
            font-size: 0.85rem;
            width: 100%;
            font-family: 'Inter', sans-serif;
        }

        .admin-badge {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .icon-btn {
            background: transparent;
            border: none;
            cursor: pointer;
            color: #4f6f8f;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 40px;
            padding: 6px;
        }

        .admin-name {
            font-size: 0.85rem;
            font-weight: 500;
            background: #eef2fa;
            padding: 6px 14px;
            border-radius: 40px;
        }

        /* content container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 28px 32px 48px;
        }

        /* welcome */
        .welcome h2 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #0f2b1f;
        }
        .welcome p {
            color: #5b6e8c;
            margin-top: 6px;
            font-size: 0.9rem;
        }

        /* stats grid (flex/grid hybrid, no bootstrap) */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin: 32px 0 40px;
        }

        .stat-card {
            background: white;
            border-radius: 1.25rem;
            padding: 1.4rem 1.2rem;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.02), 0 1px 2px rgba(0, 0, 0, 0.03);
            border: 1px solid #edf2f0;
            transition: transform 0.2s ease, box-shadow 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 20px -12px rgba(0, 32, 16, 0.08);
        }
        .stat-icon {
            width: 46px;
            height: 46px;
            background: #eaf6ef;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }
        .stat-icon .material-symbols-outlined {
            font-size: 1.8rem;
            color: #2c6e3c;
        }
        .stat-card h4 {
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #5e6f8d;
            margin-bottom: 8px;
        }
        .stat-number {
            font-size: 2.2rem;
            font-weight: 800;
            color: #1e2f2a;
            line-height: 1.2;
        }
        .stat-trend {
            font-size: 0.7rem;
            margin-top: 10px;
            color: #448b5c;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* tabs (pure css, no js) */
        .tabs-container {
            background: white;
            border-radius: 1.5rem;
            border: 1px solid #eef2f0;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .tab-buttons {
            display: flex;
            gap: 2px;
            background: #f9fbfd;
            border-bottom: 1px solid #eef2f0;
            padding: 0 1rem;
        }
        .tab-btn {
            padding: 1rem 1.6rem;
            font-weight: 600;
            font-size: 0.85rem;
            background: transparent;
            border: none;
            cursor: pointer;
            color: #5b6f8c;
            transition: all 0.2s;
            position: relative;
            font-family: 'Inter', sans-serif;
        }
        .tab-btn.active {
            color: #236b3e;
        }
        .tab-btn.active::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 2.5px;
            background: #2b6e3c;
            border-radius: 2px;
        }
        .tab-content {
            display: none;
            padding: 1.5rem 1.8rem;
            animation: fade 0.2s ease;
        }
        .tab-content.active-tab {
            display: block;
        }
        @keyframes fade {
            from { opacity: 0; transform: translateY(4px);}
            to { opacity: 1; transform: translateY(0);}
        }

        /* tables (responsive, horizontal scroll on mobile) */
        .table-responsive {
            overflow-x: auto;
            border-radius: 1rem;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.85rem;
        }
        .data-table th {
            text-align: left;
            padding: 1rem 0.8rem 0.8rem 0.8rem;
            font-weight: 600;
            color: #4a627a;
            border-bottom: 1px solid #eef2f0;
        }
        .data-table td {
            padding: 0.9rem 0.8rem;
            border-bottom: 1px solid #f0f4f9;
            color: #1f2f3c;
        }
        .data-table tr:hover td {
            background: #fafdf8;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 30px;
            font-size: 0.7rem;
            font-weight: 600;
        }
        .badge-pending { background: #fff3e0; color: #b45f06; }
        .badge-approved { background: #e0f2e9; color: #1c6e3f; }
        .badge-rejected { background: #ffe6e5; color: #bc3f2e; }
        .badge-available { background: #e0f2e9; color: #1f6e43; }
        .badge-rented { background: #e8edf5; color: #2c5282; }

        .delete-btn {
            background: none;
            border: 1px solid #f0c0c0;
            background-color: #fff7f7;
            padding: 4px 12px;
            border-radius: 30px;
            font-size: 0.7rem;
            font-weight: 500;
            color: #bc544b;
            cursor: pointer;
            transition: 0.1s;
        }
        .delete-btn:hover {
            background-color: #fce4e2;
            border-color: #cb7b72;
        }
        .search-input {
            border: 1px solid #e2e8f0;
            border-radius: 40px;
            padding: 8px 16px;
            width: 260px;
            font-size: 0.8rem;
            margin-bottom: 1rem;
            font-family: 'Inter', sans-serif;
        }
        .flex-between {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        .mt-2 { margin-top: 8px; }
        .text-muted { color: #6f7d95; font-size: 0.75rem; }

        /* footer / responsiveness */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                z-index: 1000;
                transition: transform 0.2s;
                box-shadow: 2px 0 12px rgba(0,0,0,0.1);
            }
            .main-content {
                margin-left: 0;
            }
            .top-bar {
                padding: 0 20px;
            }
            .container {
                padding: 20px;
            }
            .tab-buttons {
                overflow-x: auto;
            }
            .tab-btn {
                padding: 0.8rem 1rem;
                white-space: nowrap;
            }
            /* simple fallback: you could add a hamburger, but we keep sidebar hidden on mobile for simplicity */
            body:before {
                content: "☰";
                position: fixed;
                bottom: 20px;
                left: 20px;
                background: #2c6e3c;
                color: white;
                padding: 10px 14px;
                border-radius: 40px;
                z-index: 1100;
                font-weight: bold;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                cursor: pointer;
            }
            /* quick temporary access: click on pseudo-element to show sidebar? not perfect but keeps readability */
        }
    </style>
</head>
<body>

<!-- SIDEBAR (left nav) -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h1>Basobas</h1>
        <p>Estate Management</p>
    </div>
    <div class="nav-links">
        <a href="#" class="nav-link active">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Dashboard</span>
        </a>
        <a href="#" class="nav-link">
            <span class="material-symbols-outlined">group</span>
            <span>Users</span>
        </a>
        <a href="#" class="nav-link">
            <span class="material-symbols-outlined">real_estate_agent</span>
            <span>Properties</span>
        </a>
        <a href="#" class="nav-link">
            <span class="material-symbols-outlined">key</span>
            <span>Rental Requests</span>
        </a>
        <a href="#" class="nav-link">
            <span class="material-symbols-outlined">payments</span>
            <span>Payments</span>
        </a>
        <a href="#" class="nav-link">
            <span class="material-symbols-outlined">build</span>
            <span>Maintenance</span>
        </a>
    </div>
    <div class="profile-section">
        <div class="avatar">AJ</div>
        <div class="profile-info">
            <p>Shahil Basnet</p>
            <span>Administrator</span>
        </div>
    </div>
</aside>

<!-- MAIN CONTENT -->
<main class="main-content">
    <div class="top-bar">
        <div class="search-wrapper">
            <span class="material-symbols-outlined">search</span>
            <input type="text" placeholder="Search properties, users...">
        </div>
        <div class="admin-badge">
            <button class="icon-btn"><span class="material-symbols-outlined">notifications_none</span></button>
            <div class="admin-name">Admin</div>
        </div>
    </div>

    <div class="container">
        <!-- welcome row -->
        <div class="welcome">
            <h2>Portfolio Overview</h2>
            <p>Track and manage all rentals, tenants, and properties from one place.</p>
        </div>

        <!-- STATS CARDS (clean, essential) -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon"><span class="material-symbols-outlined">groups</span></div>
                <h4>Total Users</h4>
                <div class="stat-number">1,284</div>
                <div class="stat-trend"><span class="material-symbols-outlined" style="font-size: 1rem;">trending_up</span> +12% vs last month</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><span class="material-symbols-outlined">apartment</span></div>
                <h4>Properties</h4>
                <div class="stat-number">452</div>
                <div class="stat-trend"><span class="material-symbols-outlined" style="font-size: 1rem;">location_city</span> 14 regions</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><span class="material-symbols-outlined">description</span></div>
                <h4>Active Leases</h4>
                <div class="stat-number">398</div>
                <div class="stat-trend"><span class="material-symbols-outlined" style="font-size: 1rem;">verified</span> 88% occupied</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon"><span class="material-symbols-outlined">pending_actions</span></div>
                <h4>Pending Requests</h4>
                <div class="stat-number">27</div>
                <div class="stat-trend"><span class="material-symbols-outlined" style="font-size: 1rem;">schedule</span> 5 urgent</div>
            </div>
        </div>

        <!-- TABS (users, properties, rental requests) - pure CSS tabs -->
        <div class="tabs-container">
            <div class="tab-buttons">
                <button class="tab-btn active" data-tab="tab1">👥 Users</button>
                <button class="tab-btn" data-tab="tab2">🏠 Properties</button>
                <button class="tab-btn" data-tab="tab3">📋 Rental Requests</button>
            </div>
            <!-- TAB 1 - Users Management -->
            <div id="tab1" class="tab-content active-tab">
                <div class="flex-between">
                    <h3 style="font-weight: 600;">Registered users</h3>
                    <input type="text" class="search-input" placeholder="Search by name or email..." id="userSearch">
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Registered</th><th>Last Login</th><th>Actions</th></tr>
                        </thead>
                        <tbody id="userTableBody">
                            <tr><td>1</td><td>james_carter</td><td>james@example.com</td><td>Tenant</td><td>2024-05-12</td><td>2025-04-14</td><td><button class="delete-btn" data-id="1">Delete</button></td></tr>
                            <tr><td>2</td><td>sarah_landlord</td><td>sarah@props.com</td><td>Landlord</td><td>2024-02-20</td><td>2025-04-15</td><td><button class="delete-btn" data-id="2">Delete</button></td></tr>
                            <tr><td>3</td><td>mike_tenant</td><td>mike.r@mail.com</td><td>Tenant</td><td>2024-08-01</td><td>2025-04-10</td><td><button class="delete-btn" data-id="3">Delete</button></td></tr>
                            <tr><td>4</td><td>linda_homes</td><td>linda@homes.com</td><td>Landlord</td><td>2024-01-15</td><td>2025-04-12</td><td><button class="delete-btn" data-id="4">Delete</button></td></tr>
                            <tr><td>5</td><td>new_user</td><td>new@rentalhub.com</td><td>Tenant</td><td>2025-04-01</td><td>—</td><td><button class="delete-btn" data-id="5">Delete</button></td></tr>
                        </tbody>
                    </table>
                </div>
                <div class="text-muted mt-2">Showing last 5 entries.</div>
            </div>
            <!-- TAB 2 - Properties Management -->
            <div id="tab2" class="tab-content">
                <div class="flex-between">
                    <h3 style="font-weight: 600;">All property listings</h3>
                    <input type="text" class="search-input" placeholder="Filter by title or city..." id="propertySearch">
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead><tr><th>ID</th><th>Title</th><th>Landlord</th><th>City</th><th>Monthly Rent</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody id="propertyTableBody">
                            <tr><td>101</td><td>Sunny Apartments</td><td>sarah_landlord</td><td>Miami</td><td>$1,250</td><td><span class="badge badge-available">Available</span></td><td><button class="delete-btn" data-prop="101">Delete</button></td></tr>
                            <tr><td>102</td><td>Downtown Loft</td><td>linda_homes</td><td>Chicago</td><td>$1,890</td><td><span class="badge badge-rented">Rented</span></td><td><button class="delete-btn" data-prop="102">Delete</button></td></tr>
                            <tr><td>103</td><td>Greenfield House</td><td>sarah_landlord</td><td>Austin</td><td>$2,100</td><td><span class="badge badge-available">Available</span></td><td><button class="delete-btn" data-prop="103">Delete</button></td></tr>
                            <tr><td>104</td><td>Seaside Villa</td><td>linda_homes</td><td>Santa Monica</td><td>$3,200</td><td><span class="badge badge-rented">Rented</span></td><td><button class="delete-btn" data-prop="104">Delete</button></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- TAB 3 - Rental Requests -->
            <div id="tab3" class="tab-content">
                <div class="flex-between">
                    <h3 style="font-weight: 600;">Incoming & pending rental applications</h3>
                    <input type="text" class="search-input" placeholder="Filter by property..." id="requestSearch">
                </div>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead><tr><th>ID</th><th>Property</th><th>Tenant</th><th>Landlord</th><th>Move-in Date</th><th>Status</th></tr></thead>
                        <tbody id="requestTableBody">
                            <tr><td>R01</td><td>Sunny Apartments</td><td>james_carter</td><td>sarah_landlord</td><td>2025-05-01</td><td><span class="badge badge-pending">Pending</span></td></tr>
                            <tr><td>R02</td><td>Downtown Loft</td><td>mike_tenant</td><td>linda_homes</td><td>2025-04-20</td><td><span class="badge badge-approved">Approved</span></td></tr>
                            <tr><td>R03</td><td>Greenfield House</td><td>new_user</td><td>sarah_landlord</td><td>2025-06-10</td><td><span class="badge badge-pending">Pending</span></td></tr>
                            <tr><td>R04</td><td>Seaside Villa</td><td>james_carter</td><td>linda_homes</td><td>2025-05-15</td><td><span class="badge badge-rejected">Rejected</span></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
    (function() {
        // ----- TAB SWITCHING -----
        const tabsBtns = document.querySelectorAll('.tab-btn');
        const contents = document.querySelectorAll('.tab-content');
        
        function activateTab(tabId) {
            contents.forEach(content => {
                content.classList.remove('active-tab');
            });
            const activeContent = document.getElementById(tabId);
            if(activeContent) activeContent.classList.add('active-tab');
            
            tabsBtns.forEach(btn => {
                btn.classList.remove('active');
                if(btn.getAttribute('data-tab') === tabId) {
                    btn.classList.add('active');
                }
            });
        }
        
        tabsBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                const tabId = btn.getAttribute('data-tab');
                if(tabId) activateTab(tabId);
            });
        });
        
        // optional: keep first tab active on load
        if(!document.querySelector('.tab-content.active-tab')) {
            activateTab('tab1');
        }
        
        // ----- SIMPLE SEARCH FILTERS (demo / frontend only - but matches requirements for UI filtering)-----
        const userSearch = document.getElementById('userSearch');
        const propertySearch = document.getElementById('propertySearch');
        const requestSearch = document.getElementById('requestSearch');
        
        function filterTable(tableBodyId, searchTerm, columnIndices) {
            const tbody = document.getElementById(tableBodyId);
            if(!tbody) return;
            const rows = tbody.querySelectorAll('tr');
            const term = searchTerm.toLowerCase().trim();
            rows.forEach(row => {
                let match = false;
                if(term === "") {
                    match = true;
                } else {
                    for(let idx of columnIndices) {
                        const cell = row.cells[idx];
                        if(cell && cell.innerText.toLowerCase().includes(term)) {
                            match = true;
                            break;
                        }
                    }
                }
                row.style.display = match ? '' : 'none';
            });
        }
        
        if(userSearch) {
            userSearch.addEventListener('input', (e) => {
                filterTable('userTableBody', e.target.value, [1,2]);
            });
        }
        if(propertySearch) {
            propertySearch.addEventListener('input', (e) => {
                filterTable('propertyTableBody', e.target.value, [1,3]);
            });
        }
        if(requestSearch) {
            requestSearch.addEventListener('input', (e) => {
                filterTable('requestTableBody', e.target.value, [1]);
            });
        }
        
        // Delete buttons simulation (console warning + visual removal for UI consistency)
        const deleteUserBtns = document.querySelectorAll('#userTableBody .delete-btn');
        const deletePropBtns = document.querySelectorAll('#propertyTableBody .delete-btn');
        
        function attachDeleteEvent(buttons, type) {
            buttons.forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    const row = btn.closest('tr');
                    if(row && confirm(`Delete this ${type}? (UI demo - backend required)`)) {
                        row.remove();
                        console.log(`${type} deleted (frontend demo)`);
                    }
                });
            });
        }
        
        attachDeleteEvent(deleteUserBtns, 'user');
        attachDeleteEvent(deletePropBtns, 'property');
        
        // For dynamic rows future-proof (if needed)
        const observer = new MutationObserver(() => {
            attachDeleteEvent(document.querySelectorAll('#userTableBody .delete-btn'), 'user');
            attachDeleteEvent(document.querySelectorAll('#propertyTableBody .delete-btn'), 'property');
        });
        observer.observe(document.getElementById('userTableBody'), { childList: true, subtree: true });
        observer.observe(document.getElementById('propertyTableBody'), { childList: true, subtree: true });
    })();
</script>
</body>
</html>