// State variables
let currentPage = 1;
let sortBy = 'user_id';
let sortOrder = 'DESC';
let searchTimeout;

// DOM elements (will be assigned in DOMContentLoaded)
let searchInput;
let roleFilter;
let bulkDeleteBtn;

const contextPath = window.contextPath;

// Fetch users from server
async function fetchUsers() {
    const params = new URLSearchParams({
        format: 'json',
        page: currentPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
        limit: 5   // ← ADD THIS LINE
    });
    if (searchInput.value.trim()) params.set('search', searchInput.value.trim());
    if (roleFilter.value !== 'all') params.set('role', roleFilter.value);

    console.log('Fetching:', contextPath + '/admin/users?' + params);

    try {
        const response = await fetch(contextPath + '/admin/users?' + params);
        console.log('Response status:', response.status);
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        const data = await response.json();
        console.log('Data received:', data);
        updateTable(data.users);
        updatePagination(data.page, data.totalPages, data.total);
        updateSortIndicators();
        updateMetrics(data.adminCount, data.landlordCount, data.tenantCount);
    } catch (error) {
        console.error('Error fetching users:', error);
        const tbody = document.querySelector('.data-table tbody');
        tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 3rem;"><div class="text-muted">Error loading users. Please try again.</div></td></tr>';
        showToast('Error loading users', 'error');
    }
}

// Update metrics cards
function updateMetrics(adminCount, landlordCount, tenantCount) {
    const cards = document.querySelectorAll('.stat-card');
    if (cards.length >= 3) {
        cards[0].querySelector('.stat-number').textContent = adminCount;
        cards[1].querySelector('.stat-number').textContent = landlordCount;
        cards[2].querySelector('.stat-number').textContent = tenantCount;
    }
}

// Update table with user data
function updateTable(users) {
    const tbody = document.querySelector('.data-table tbody');
    tbody.innerHTML = '';
    if (users.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" style="text-align: center; padding: 3rem;"><div class="text-muted">No users found</div></td></tr>';
        return;
    }

    const rows = users.map(user =>
        '<tr>' +
        '<td><input type="checkbox" class="userCheckbox" value="' + escapeHtml(user.displayId) + '"></td>' +
        '<td>' + escapeHtml(user.displayId) + '</td>' +
        '<td><div class="font-bold">' + escapeHtml(user.fullName || '-') + '</div></td>' +
        '<td>' + escapeHtml(user.username) + '</td>' +
        '<td>' + escapeHtml(user.email) + '</td>' +
        '<td><span class="badge-role role-' + escapeHtml(user.role) + '">' + escapeHtml(user.role) + '</span></td>' +
        '<td>' + escapeHtml(user.phone || '-') + '</td>' +
        '<td>' + escapeHtml(user.registeredAt) + '</td>' +
        '<td>' + escapeHtml(user.lastLoggedIn) + '</td>' +
        '<td style="text-align: center;">' +
        '<div class="flex justify-center" style="gap: 0.5rem;">' +
        '<button class="action-btn action-view" onclick="viewUser(\'' + escapeHtml(user.displayId) + '\')">' +
        '<span class="material-symbols-outlined">visibility</span>' +
        '</button>' +
        '<button class="action-btn action-edit" onclick="editUser(\'' + escapeHtml(user.displayId) + '\')">' +
        '<span class="material-symbols-outlined">edit_square</span>' +
        '</button>' +
        '<button class="action-btn" style="color: #6366f1;" title="Reset Password" onclick="resetPassword(\'' + escapeHtml(user.displayId) + '\')">' +
        '<span class="material-symbols-outlined">lock_reset</span>' +
        '</button>' +
        (user.role !== 'admin' ? '<button class="action-btn action-delete" onclick="deleteUser(\'' + escapeHtml(user.displayId) + '\')">' +
            '<span class="material-symbols-outlined">delete</span>' +
            '</button>' : '') +
        '</div>' +
        '</td>' +
        '</tr>'
    ).join('');
    tbody.innerHTML = rows;
    updateBulkActions();
}

// Update pagination display
function updatePagination(page, totalPages, total) {
    const showing = document.querySelector('.pagination .text-muted');
    const limit = 5;
    const start = total === 0 ? 0 : (page - 1) * limit + 1;
    const end = Math.min(page * limit, total);
    showing.textContent = 'Showing ' + start + '-' + end + ' of ' + total + ' users';

    const flex = document.querySelector('.pagination .flex');
    flex.innerHTML = '';

    if (page > 1) {
        flex.innerHTML += '<button class="pagination-btn" onclick="changePage(' + (page - 1) + ')"><span class="material-symbols-outlined">chevron_left</span></button>';
    }

    const startPage = Math.max(1, page - 2);
    const endPage = Math.min(totalPages, page + 2);
    for (let i = startPage;i <= endPage;i++) {
        flex.innerHTML += '<button class="page-number ' + (i === page ? 'active' : '') + '" onclick="changePage(' + i + ')">' + i + '</button>';
    }

    if (page < totalPages) {
        flex.innerHTML += '<button class="pagination-btn" onclick="changePage(' + (page + 1) + ')"><span class="material-symbols-outlined">chevron_right</span></button>';
    }
}

// Change page
function changePage(p) {
    currentPage = p;
    fetchUsers();
}

// Update bulk actions visibility
function updateBulkActions() {
    const checked = document.querySelectorAll('.userCheckbox:checked');
    const bulkActions = document.querySelector('.bulk-actions');
    if (bulkActions) {
        bulkActions.style.display = checked.length > 0 ? 'flex' : 'none';
    }
}

// Update sort indicators in table headers
function updateSortIndicators() {
    // Reset all headers to neutral state
    document.querySelectorAll('th[data-sort]').forEach(th => {
        th.classList.remove('sort-asc', 'sort-desc');
        const indicatorSpan = th.querySelector('.sort-indicator .material-symbols-outlined');
        if (indicatorSpan) {
            indicatorSpan.textContent = 'unfold_more';
        }
    });

    // Update the current sort column
    const currentSortHeader = document.querySelector(`th[data-sort="${sortBy}"]`);
    if (currentSortHeader) {
        currentSortHeader.classList.add(sortOrder === 'ASC' ? 'sort-asc' : 'sort-desc');
        const indicatorSpan = currentSortHeader.querySelector('.sort-indicator .material-symbols-outlined');
        if (indicatorSpan) {
            if (sortOrder === 'ASC') {
                indicatorSpan.textContent = 'expand_less';  // Up arrow for ascending
            } else {
                indicatorSpan.textContent = 'expand_more';  // Down arrow for descending
            }
        }
    }
}

// ========== CRUD OPERATIONS ==========

// Reset password function
function resetPassword(displayId) {
    showConfirm('Reset password for this user? It will be set to a default value.', 'Reset Password', () => {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/admin/users';
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'resetPassword';
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'displayId';
        idInput.value = displayId;
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    });
}

// Delete user function
function deleteUser(displayId) {
    showConfirm('Are you sure you want to delete this user? This action cannot be undone.', 'Confirm Delete', () => {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/admin/users';
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        const idInput = document.createElement('input');
        idInput.type = 'hidden';
        idInput.name = 'displayId';
        idInput.value = displayId;
        form.appendChild(actionInput);
        form.appendChild(idInput);
        document.body.appendChild(form);
        form.submit();
    });
}

function viewUser(displayId) {
    window.location.href = contextPath + '/admin/users/view?displayId=' + displayId;
}

function editUser(displayId) {
    window.location.href = contextPath + '/admin/users/edit?displayId=' + displayId;
}

// ========== MODAL FUNCTIONS ==========
function openCreateUserModal() {
    const modal = document.getElementById('createUserModal');
    if (modal) {
        modal.style.display = 'flex';
        document.getElementById('createUserForm').reset();
    }
}

function closeCreateUserModal() {
    const modal = document.getElementById('createUserModal');
    if (modal) {
        modal.style.display = 'none';
    }
}

// Handle create user form submission
document.getElementById('createUserForm')?.addEventListener('submit', async (e) => {
    e.preventDefault();

    // Get form values
    const fullName = document.getElementById('fullName').value.trim();
    const username = document.getElementById('username').value.trim();
    const email = document.getElementById('email').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const role = document.getElementById('role').value;
    const dateOfBirth = document.getElementById('dateOfBirth').value;
    const address = document.getElementById('address').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // Validation
    if (!fullName || !username || !email || !password) {
        showToast('Please fill in all required fields', 'warning');
        return;
    }

    if (password !== confirmPassword) {
        showToast('Passwords do not match', 'error');
        return;
    }

    if (password.length < 4) {
        showToast('Password must be at least 4 characters', 'warning');
        return;
    }

    // Check if email is valid
    if (!isValidEmail(email)) {
        showToast('Please enter a valid email address', 'error');
        return;
    }

    // Submit to server
    try {
        const response = await fetch(contextPath + '/admin/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                action: 'create',
                fullName: fullName,
                username: username,
                email: email,
                phone: phone,
                role: role,
                dateOfBirth: dateOfBirth,
                address: address,
                password: password
            })
        });

        if (response.ok) {
            console.log('User created successfully, showing toast now');
            showToast('User created successfully!', 'success');
            console.log('Toast should be visible now');
            closeCreateUserModal();
            fetchUsers(); // Refresh the table
        } else {
            const error = await response.text();
            showToast(error || 'Error creating user', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showToast('Network error. Please try again.', 'error');
    }
});

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('createUserModal');
    if (event.target === modal) {
        closeCreateUserModal();
    }
};

// ========== BULK DELETE CONFIRMATION ==========
function confirmBulkDelete(selectedIds) {
    showConfirm(`Delete ${selectedIds.length} selected user(s)? This action cannot be undone.`, 'Confirm Bulk Delete', () => {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = contextPath + '/admin/users';
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'bulkDelete';
        form.appendChild(actionInput);
        selectedIds.forEach(id => {
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

// ========== EVENT LISTENERS ==========
document.addEventListener('DOMContentLoaded', () => {
    // Assign DOM elements
    searchInput = document.getElementById('searchInput');
    roleFilter = document.getElementById('roleFilter');
    bulkDeleteBtn = document.getElementById('bulkDeleteBtn');

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
            fetchUsers();
            updateSortIndicators();
        });
    });

    // Search input with debounce
    if (searchInput) {
        searchInput.addEventListener('input', () => {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                currentPage = 1;
                fetchUsers();
            }, 300);
        });
    }

    // Role filter
    if (roleFilter) {
        roleFilter.addEventListener('change', () => {
            currentPage = 1;
            fetchUsers();
        });
    }

    // Checkbox changes (for bulk actions)
    document.addEventListener('change', (e) => {
        if (e.target.classList && e.target.classList.contains('userCheckbox')) {
            updateBulkActions();
        }
    });

    // Bulk delete button
    if (bulkDeleteBtn) {
        bulkDeleteBtn.addEventListener('click', () => {
            const selected = Array.from(document.querySelectorAll('.userCheckbox:checked')).map(cb => cb.value);
            if (selected.length === 0) {
                showToast('No users selected', 'warning');
                return;
            }
            confirmBulkDelete(selected);
        });
    }

    // Initialize
    fetchUsers();
    updateSortIndicators();
});