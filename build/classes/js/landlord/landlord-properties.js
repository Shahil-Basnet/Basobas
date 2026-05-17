// State variables
// Get context path with fallback
const contextPath = window.contextPath || '';
if (!contextPath) {
    console.warn('contextPath not set, using empty string');
}
let currentPage = 1;
let sortBy = 'property_id';
let sortOrder = 'DESC';
let searchTimeout;
// DOM elements
let searchInput, statusFilter, tbody, selectAllCheckbox, bulkActions, selectedCountSpan;

// Helper functions
function escapeHtml(str) {
    if (!str) return '';
    return String(str).replace(/[&<>]/g, function(m) {
        if (m === '&') return '&amp;';
        if (m === '<') return '&lt;';
        if (m === '>') return '&gt;';
        return m;
    });
}

function formatNumber(num) {
    return Number(num).toLocaleString('en-IN');
}

function getLocationDisplay(property) {
    let location = escapeHtml(property.city);
    if (property.wardNumber) {
        location += ', Ward ' + property.wardNumber;
    }
    return location;
}

function getStatusBadge(status) {
    if (status === 'available') {
        return '<span class="badge-status status-available">Available</span>';
    } else if (status === 'rented') {
        return '<span class="badge-status status-rented">Rented</span>';
    }
    return '<span class="badge-status">' + escapeHtml(status) + '</span>';
}

function getDisplayId(property) {
    if (property.displayId && property.displayId !== '') {
        return property.displayId;
    }
    return 'PR' + String(property.propertyId).padStart(5, '0');
}

// Update table
function updateTable(properties) {
    if (!tbody) return;

    if (!properties || properties.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 4rem;"><div class="empty-properties"><span class="material-symbols-outlined">inventory_2</span><h3>No properties found</h3><p>Get started by adding your first property.</p><a href="' + window.contextPath + '/landlord/properties?action=add" class="create-user-btn" style="display: inline-flex; margin-top: 1rem; text-decoration: none;"><span class="material-symbols-outlined">add</span>Add Property</a></div></td></tr>';
        return;
    }

    let html = '';
    for (let i = 0;i < properties.length;i++) {
        const p = properties[i];
        const displayId = getDisplayId(p);

        html += '<tr data-property-id="' + p.propertyId + '" data-display-id="' + displayId + '">';
        html += '<td><input type="checkbox" class="propertyCheckbox" value="' + displayId + '"></td>';
        html += '<td class="font-mono" style="font-size: 0.8rem; color: var(--on-surface-variant);">' + escapeHtml(displayId) + '</td>';
        html += '<td><strong>' + escapeHtml(p.title) + '</strong></td>';
        html += '<td>' + getLocationDisplay(p) + '</td>';
        html += '<td><strong style="color: var(--primary);">रू ' + formatNumber(p.monthlyRent) + '</strong></td>';
        html += '<td>' + p.bedrooms + ' Beds, ' + p.bathrooms + ' Baths</td>';
        html += '<td><span style="font-size: 0.75rem; text-transform: capitalize;">' + escapeHtml(p.propertyType) + '</span></td>';
        html += '<td>' + getStatusBadge(p.status) + '</td>';
        html += '<td style="font-size: 0.75rem; color: var(--on-surface-variant);">' + (p.createdAt ? p.createdAt.substring(0, 10) : '-') + '</td>';
        html += '<td style="text-align: center;">';
        html += '<div style="display: flex; gap: 0.25rem; justify-content: center;">';
        html += '<button class="action-btn action-view" onclick="viewProperty(\'' + displayId + '\')" title="View Details">';
        html += '<span class="material-symbols-outlined">visibility</span>';
        html += '</button>';
        html += '<button class="action-btn action-edit" onclick="editProperty(\'' + displayId + '\')" title="Edit Property">';
        html += '<span class="material-symbols-outlined">edit</span>';
        html += '</button>';
        html += '<button class="action-btn action-delete" onclick="openDeleteModal(\'' + displayId + '\', \'' + escapeHtml(p.title) + '\')" title="Delete Property">';
        html += '<span class="material-symbols-outlined">delete</span>';
        html += '</button>';
        html += '</div>';
        html += '</td>';
        html += '</tr>';
    }
    tbody.innerHTML = html;
    updateBulkActions();
}

// Update stats
function updateStats(stats) {
    if (!stats) return;
    document.getElementById('totalCount').textContent = stats.total || 0;
    document.getElementById('availableCount').textContent = stats.available || 0;
    document.getElementById('rentedCount').textContent = stats.rented || 0;
}

// Update pagination
function updatePagination(page, totalPages, total) {
    const paginationInfo = document.getElementById('paginationInfo');
    const paginationControls = document.getElementById('paginationControls');

    if (paginationInfo) {
        const start = total === 0 ? 0 : (page - 1) * 10 + 1;
        const end = Math.min(page * 10, total);
        paginationInfo.textContent = `Showing ${start}-${end} of ${total} properties`;
    }

    if (paginationControls) {
        let controls = '';

        if (page > 1) {
            controls += '<button class="pagination-btn" onclick="changePage(' + (page - 1) + ')"><span class="material-symbols-outlined">chevron_left</span></button>';
        }

        const startPage = Math.max(1, page - 2);
        const endPage = Math.min(totalPages, page + 2);
        for (let i = startPage;i <= endPage;i++) {
            controls += '<button class="page-number ' + (i === page ? 'active' : '') + '" onclick="changePage(' + i + ')">' + i + '</button>';
        }

        if (page < totalPages) {
            controls += '<button class="pagination-btn" onclick="changePage(' + (page + 1) + ')"><span class="material-symbols-outlined">chevron_right</span></button>';
        }

        paginationControls.innerHTML = controls || '<span style="font-size: 0.75rem;">No results</span>';
    }
}

function changePage(page) {
    currentPage = page;
    fetchProperties();
}

// Sort handling
function updateSortIndicators() {
    document.querySelectorAll('th[data-sort]').forEach(th => {
        th.classList.remove('sort-asc', 'sort-desc');
        const indicatorSpan = th.querySelector('.sort-indicator');
        if (indicatorSpan) {
            const iconSpan = indicatorSpan.querySelector('.material-symbols-outlined');
            if (iconSpan) iconSpan.textContent = 'unfold_more';
        }
    });

    const currentSortHeader = document.querySelector(`th[data-sort="${sortBy}"]`);
    if (currentSortHeader) {
        currentSortHeader.classList.add(sortOrder === 'ASC' ? 'sort-asc' : 'sort-desc');
        const indicatorSpan = currentSortHeader.querySelector('.sort-indicator');
        if (indicatorSpan) {
            const iconSpan = indicatorSpan.querySelector('.material-symbols-outlined');
            if (iconSpan) iconSpan.textContent = sortOrder === 'ASC' ? 'expand_less' : 'expand_more';
        }
    }
}

// Bulk actions
function updateBulkActions() {
    const checked = document.querySelectorAll('.propertyCheckbox:checked');
    if (bulkActions) {
        bulkActions.classList.toggle('active', checked.length > 0);
        if (selectedCountSpan) selectedCountSpan.textContent = checked.length;
    }
    if (selectAllCheckbox) {
        const allCheckboxes = document.querySelectorAll('.propertyCheckbox');
        selectAllCheckbox.checked = allCheckboxes.length > 0 && allCheckboxes.length === checked.length;
    }
}

function deleteSelected() {
    const selected = Array.from(document.querySelectorAll('.propertyCheckbox:checked')).map(cb => cb.value);
    if (selected.length === 0) return;

    showConfirm(`Delete ${selected.length} selected property(s)? This action cannot be undone.`, "Confirm Bulk Delete", function() {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.contextPath + '/landlord/properties';
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'bulkDelete';
        form.appendChild(actionInput);
        selected.forEach(id => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'displayIds';
            input.value = id;
            form.appendChild(input);
        });
        document.body.appendChild(form);
        form.submit();
    });
}

// Property actions
// Property actions
function viewProperty(displayId) {
    window.location.href = window.contextPath + '/landlord/property-view?id=' + displayId;
}

function editProperty(displayId) {
    window.location.href = window.contextPath + '/landlord/properties?action=edit&id=' + displayId;
}

let deletePropertyId = null;

function openDeleteModal(displayId, title) {
    deletePropertyId = displayId;
    document.getElementById('deletePropertyTitle').textContent = title;
    document.getElementById('deleteModal').style.display = 'flex';
}

function closeDeleteModal() {
    document.getElementById('deleteModal').style.display = 'none';
    deletePropertyId = null;
}

function confirmDelete() {
    if (deletePropertyId) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = window.contextPath + '/landlord/properties';
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'displayId';
        idInput.value = deletePropertyId;
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    }
}

// Fetch properties from server
async function fetchProperties() {
    const params = new URLSearchParams({
        format: 'json',
        page: currentPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
        limit: 10
    });

    if (searchInput && searchInput.value.trim()) {
        params.set('search', searchInput.value.trim());
    }
    if (statusFilter && statusFilter.value !== 'all') {
        params.set('status', statusFilter.value);
    }

    try {
        const response = await fetch(window.contextPath + '/landlord/properties?' + params.toString());
        if (!response.ok) throw new Error('Failed to fetch properties');

        const data = await response.json();
        updateTable(data.properties);
        updateStats(data.stats);
        updatePagination(data.page, data.totalPages, data.total);
        updateSortIndicators();

    } catch (error) {
        console.error('Error fetching properties:', error);
        if (tbody) {
            tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 3rem; color: var(--error);">Error loading properties. Please refresh the page.</td></tr>';
        }
    }
}

// Add sort indicators to headers
function addSortIndicators() {
    const headers = document.querySelectorAll('th[data-sort]');
    for (let i = 0;i < headers.length;i++) {
        const th = headers[i];
        const indicatorSpan = document.createElement('span');
        indicatorSpan.className = 'sort-indicator';
        indicatorSpan.innerHTML = '<span class="material-symbols-outlined">unfold_more</span>';
        th.appendChild(indicatorSpan);

        th.addEventListener('click', function() {
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
    }
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    searchInput = document.getElementById('searchInput');
    statusFilter = document.getElementById('statusFilter');
    tbody = document.getElementById('propertiesTableBody');
    selectAllCheckbox = document.getElementById('selectAllCheckbox');
    bulkActions = document.getElementById('bulkActions');
    selectedCountSpan = document.getElementById('selectedCount');

    addSortIndicators();

    // Search debounce
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(function() {
                currentPage = 1;
                fetchProperties();
            }, 300);
        });
    }

    // Status filter
    if (statusFilter) {
        statusFilter.addEventListener('change', function() {
            currentPage = 1;
            fetchProperties();
        });
    }

    // Reset filters
    const resetBtn = document.getElementById('resetFiltersBtn');
    if (resetBtn) {
        resetBtn.addEventListener('click', function() {
            if (searchInput) searchInput.value = '';
            if (statusFilter) statusFilter.value = 'all';
            currentPage = 1;
            fetchProperties();
        });
    }

    // Select all checkbox
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function(e) {
            document.querySelectorAll('.propertyCheckbox').forEach(cb => {
                cb.checked = e.target.checked;
            });
            updateBulkActions();
        });
    }

    // Bulk delete
    const bulkDeleteBtn = document.getElementById('bulkDeleteBtn');
    if (bulkDeleteBtn) {
        bulkDeleteBtn.addEventListener('click', deleteSelected);
    }

    // Confirm delete modal
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    if (confirmDeleteBtn) {
        confirmDeleteBtn.addEventListener('click', confirmDelete);
    }

    // Close modal on outside click
    window.onclick = function(event) {
        const modal = document.getElementById('deleteModal');
        if (event.target === modal) {
            closeDeleteModal();
        }
    };

    // Listen for checkbox changes
    document.addEventListener('change', function(e) {
        if (e.target.classList && e.target.classList.contains('propertyCheckbox')) {
            updateBulkActions();
        }
    });

    // Initial load
    fetchProperties();
});