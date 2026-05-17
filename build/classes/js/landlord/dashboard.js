// landlord/dashboard.js
document.addEventListener('DOMContentLoaded', () => {
    console.log('Landlord Dashboard loaded');
    
    // You'll later replace static numbers with fetch calls
    // Example: fetch stats, recent requests, upcoming payments
    
    const loadDashboardData = async () => {
        try {
            // Future: fetch data from /landlord/api/dashboard
            // Update stats, tables, etc.
        } catch (error) {
            console.error('Error loading dashboard data:', error);
        }
    };
    
    loadDashboardData();
});