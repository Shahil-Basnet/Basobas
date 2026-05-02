<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Properties Management | Basobas</title>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- Material Icons -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">

<!-- CSS Files -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h1>Basobas</h1>
            <p>Estate Management</p>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                <span class="material-symbols-outlined">group</span>
                <span>Users</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/properties" class="nav-link active">
                <span class="material-symbols-outlined">real_estate_agent</span>
                <span>Properties</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/rental-requests" class="nav-link">
                <span class="material-symbols-outlined">key</span>
                <span>Rental Requests</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/payments" class="nav-link">
                <span class="material-symbols-outlined">payments</span>
                <span>Payments</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/maintenance" class="nav-link">
                <span class="material-symbols-outlined">build</span>
                <span>Maintenance</span>
            </a>
            <a href="#" class="nav-link">
                <span class="material-symbols-outlined">assessment</span>
                <span>Reports</span>
            </a>
        </div>
        <div class="profile-section">
            <div class="avatar">AD</div>
            <div class="profile-info">
                <p>Admin User</p>
                <span>Administrator</span>
            </div>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">
        <div class="top-bar">
            <div class="search-wrapper">
                <span class="material-symbols-outlined">search</span>
                <input type="text" placeholder="Search system-wide...">
            </div>
            <div class="admin-badge">
                <button class="icon-btn">
                    <span class="material-symbols-outlined">notifications_none</span>
                </button>
                <button class="icon-btn">
                    <span class="material-symbols-outlined">settings</span>
                </button>
                <div class="admin-name">Admin</div>
            </div>
        </div>

        <div class="dashboard-container">
            <!-- Header -->
            <div class="page-header">
                <div>
                    <div class="section-badge">Property Management</div>
                    <h2 class="page-title">Properties</h2>
                    <p class="page-subtitle">View all property listings across your estate platform. (Read-only)</p>
                </div>
            </div>

            <!-- Filter Bar -->
            <div class="filter-bar">
                <div class="filter-input-wrapper">
                    <span class="material-symbols-outlined">search</span>
                    <input type="text" class="filter-input" id="searchInput"
                        placeholder="Search by title, city, or landlord...">
                </div>
                <div class="flex" style="gap: 0.5rem;">
                    <select id="statusFilter" class="filter-input" style="width: 140px;">
                        <option value="all">All Status</option>
                        <option value="available">Available</option>
                        <option value="rented">Rented</option>
                        <option value="maintenance">Maintenance</option>
                    </select>
                </div>
            </div>

            <!-- Properties Table -->
            <div class="dashboard-card">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th data-sort="display_id">Property ID</th>
                                <th data-sort="title">Title</th>
                                <th data-sort="landlord_name">Landlord</th>
                                <th data-sort="city">City</th>
                                <th data-sort="monthly_rent">Rent</th>
                                <th data-sort="bedrooms">Beds</th>
                                <th data-sort="property_type">Type</th>
                                <th data-sort="status">Status</th>
                                <th data-sort="created_at">Listed On</th>
                                <th style="text-align: center;">Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data loaded dynamically by JavaScript -->
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination">
                    <p class="text-muted" style="font-size: 0.75rem;">Loading properties...</p>
                    <div class="flex items-center" style="gap: 0.25rem;">
                        <button class="pagination-btn" disabled>
                            <span class="material-symbols-outlined">chevron_left</span>
                        </button>
                        <button class="page-number active">1</button>
                        <button class="pagination-btn">
                            <span class="material-symbols-outlined">chevron_right</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- JavaScript -->
    <script>
        // State variables
        let currentPage = 1;
        let sortBy = 'property_id';
        let sortOrder = 'DESC';
        let searchTimeout;
        
        // DOM elements
        let searchInput;
        let statusFilter;
        
        const contextPath = document.documentElement.getAttribute('data-context-path');
        
        // Fetch properties from server
        async function fetchProperties() {
            const params = new URLSearchParams({
                format: 'json',
                page: currentPage,
                sortBy: sortBy,
                sortOrder: sortOrder
            });
            if (searchInput && searchInput.value.trim()) {
                params.set('search', searchInput.value.trim());
            }
            if (statusFilter && statusFilter.value !== 'all') {
                params.set('status', statusFilter.value);
            }
            
            try {
                const response = await fetch(contextPath + '/admin/properties?' + params);
                if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
                const data = await response.json();
                updateTable(data.properties);
                updatePagination(data.page, data.totalPages, data.total);
            } catch (error) {
                console.error('Error fetching properties:', error);
                const tbody = document.querySelector('.data-table tbody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 3rem;">Error loading properties. Please try again.</div></td></tr>';
                }
            }
        }
        
        // Update table with property data
        function updateTable(properties) {
            const tbody = document.querySelector('.data-table tbody');
            if (!tbody) return;
            
            if (!properties || properties.length === 0) {
                tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 3rem;">No properties found</div></td></tr>';
                return;
            }
            
            let html = '';
            for (const p of properties) {
                const statusClass = p.status === 'available' ? 'role-tenant' : 
                                   (p.status === 'rented' ? 'role-manager' : 'role-maintenance');
                html += '<tr>' +
                    '<td>' + p.displayId + '</td>' +
                    '<td><div class="font-bold">' + escapeHtml(p.title) + '</div></td>' +
                    '<td>' + escapeHtml(p.landlordName || '-') + '</td>' +
                    '<td>' + escapeHtml(p.city) + '</td>' +
                    '<td class="text-primary font-bold">$' + Number(p.monthlyRent).toLocaleString() + '</td>' +
                    '<td>' + p.bedrooms + '</td>' +
                    '<td>' + escapeHtml(p.propertyType) + '</td>' +
                    '<td><span class="badge-role ' + statusClass + '">' + p.status + '</span></td>' +
                    '<td>' + (p.createdAt ? p.createdAt.substring(0, 10) : '-') + '</td>' +
                    '<td style="text-align: center;">' +
                        '<button class="action-btn action-view" onclick="viewProperty(\'' + p.displayId + '\')" title="View Details">' +
                            '<span class="material-symbols-outlined">visibility</span>' +
                        '</button>' +
                    '</td>' +
                ')}';
            }
            tbody.innerHTML = html;
        }
        
        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
        }
        
        function updatePagination(page, totalPages, total) {
            const showing = document.querySelector('.pagination .text-muted');
            const flex = document.querySelector('.pagination .flex');
            if (!showing || !flex) return;
            
            const start = (page - 1) * 10 + 1;
            const end = Math.min(page * 10, total);
            showing.textContent = 'Showing ' + start + '-' + end + ' of ' + total + ' properties';
            
            flex.innerHTML = '';
            if (page > 1) {
                flex.innerHTML += '<button class="pagination-btn" onclick="changePage(' + (page - 1) + ')"><span class="material-symbols-outlined">chevron_left</span></button>';
            }
            const startPage = Math.max(1, page - 2);
            const endPage = Math.min(totalPages, page + 2);
            for (let i = startPage; i <= endPage; i++) {
                flex.innerHTML += '<button class="page-number ' + (i === page ? 'active' : '') + '" onclick="changePage(' + i + ')">' + i + '</button>';
            }
            if (page < totalPages) {
                flex.innerHTML += '<button class="pagination-btn" onclick="changePage(' + (page + 1) + ')"><span class="material-symbols-outlined">chevron_right</span></button>';
            }
        }
        
        function changePage(p) { currentPage = p; fetchProperties(); }
        
        // Event listeners
        document.addEventListener('DOMContentLoaded', () => {
            searchInput = document.getElementById('searchInput');
            statusFilter = document.getElementById('statusFilter');
            
            // Sort column clicks
            document.querySelectorAll('th[data-sort]').forEach(th => {
                th.addEventListener('click', () => {
                    const column = th.dataset.sort;
                    if (sortBy === column) {
                        sortOrder = sortOrder === 'ASC' ? 'DESC' : 'ASC';
                    } else {
                        sortBy = column;
                        sortOrder = 'ASC';
                    }
                    currentPage = 1;
                    fetchProperties();
                });
            });
            
            if (searchInput) {
                searchInput.addEventListener('input', () => {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => { currentPage = 1; fetchProperties(); }, 300);
                });
            }
            if (statusFilter) {
                statusFilter.addEventListener('change', () => { currentPage = 1; fetchProperties(); });
            }
            
            fetchProperties();
        });
        
        // Global functions
        window.viewProperty = function(displayId) {
            window.location.href = contextPath + '/admin/properties/view?displayId=' + displayId;
        };
    </script>
</body>
</html>