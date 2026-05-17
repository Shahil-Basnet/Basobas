<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${fn:escapeXml(property.title)} - Property Details | Basobas</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

    <c:set var="page" value="properties" scope="request" />
    
    <jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/WEB-INF/includes/topbar.jsp" />

        <div class="dashboard-container">
            <!-- Header -->
            <div class="page-header">
                <div>
                    <div class="section-badge">PROPERTY MANAGEMENT</div>
                    <h1 class="page-title">${fn:escapeXml(property.title)}</h1>
                    <p class="page-subtitle">${property.displayId}</p>
                </div>
                <div style="display: flex; gap: 0.5rem;">
                    <a href="${pageContext.request.contextPath}/landlord/properties?action=edit&id=${property.displayId}" class="btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 0.25rem;">
                        <span class="material-symbols-outlined" style="font-size: 1rem;">edit</span>
                        Edit Property
                    </a>
                    <a href="${pageContext.request.contextPath}/landlord/properties" class="btn-outline" style="text-decoration: none; display: inline-flex; align-items: center; gap: 0.25rem;">
                        <span class="material-symbols-outlined" style="font-size: 1rem;">arrow_back</span>
                        Back to Properties
                    </a>
                </div>
            </div>

            <!-- Two Column Layout -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                
                <!-- LEFT COLUMN: Property Info -->
                <div>
                    <!-- Basic Info Card -->
                    <div class="dashboard-card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3>Basic Information</h3>
                        </div>
                        <div style="padding: 1rem;">
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 0.75rem 0; font-weight: 600; width: 40%;">Property ID</td>
                                    <td style="padding: 0.75rem 0;">${property.displayId}</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 0.75rem 0; font-weight: 600;">Property Type</td>
                                    <td style="padding: 0.75rem 0; text-transform: capitalize;">${property.propertyType}</td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 0.75rem 0; font-weight: 600;">Status</td>
                                    <td style="padding: 0.75rem 0;">
                                        <span class="status-badge" style="
                                            ${property.status == 'available' ? 'background: #d1fae5; color: #059669;' : ''}
                                            ${property.status == 'rented' ? 'background: #fee2e2; color: #dc2626;' : ''}
                                            ${property.status == 'inactive' ? 'background: #f3f4f6; color: #6b7280;' : ''}
                                            padding: 0.25rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600;">
                                            ${property.status == 'available' ? 'Available' : ''}
                                            ${property.status == 'rented' ? 'Rented' : ''}
                                            ${property.status == 'inactive' ? 'Inactive' : ''}
                                        </span>
                                    </td>
                                </tr>
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 0.75rem 0; font-weight: 600;">Created Date</td>
                                    <td style="padding: 0.75rem 0;">${property.createdAt}</td>
                                </tr>
                                <tr>
                                    <td style="padding: 0.75rem 0; font-weight: 600;">Description</td>
                                    <td style="padding: 0.75rem 0;">${fn:escapeXml(property.description)}</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-- Location Card -->
                    <div class="dashboard-card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3>Location Details</h3>
                        </div>
                        <div style="padding: 1rem;">
                            <table style="width: 100%; border-collapse: collapse;">
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 0.75rem 0; font-weight: 600; width: 40%;">City</td>
                                    <td style="padding: 0.75rem 0;">${fn:escapeXml(property.city)}</td>
                                </tr>
                                <c:if test="${not empty property.wardNumber}">
                                    <tr style="border-bottom: 1px solid #e5e7eb;">
                                        <td style="padding: 0.75rem 0; font-weight: 600;">Ward Number</td>
                                        <td style="padding: 0.75rem 0;">${property.wardNumber}</td>
                                    </tr>
                                </c:if>
                                <c:if test="${not empty property.address}">
                                    <tr>
                                        <td style="padding: 0.75rem 0; font-weight: 600;">Full Address</td>
                                        <td style="padding: 0.75rem 0;">${fn:escapeXml(property.address)}</td>
                                    </tr>
                                </c:if>
                            </table>
                        </div>
                    </div>

                    <!-- Specifications Card -->
                    <div class="dashboard-card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3>Specifications</h3>
                        </div>
                        <div style="padding: 1rem;">
                            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem;">
                                <div>
                                    <div style="font-size: 0.7rem; color: #6b7280;">Bedrooms</div>
                                    <div style="font-size: 1.1rem; font-weight: 600;">${property.bedrooms}</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.7rem; color: #6b7280;">Bathrooms</div>
                                    <div style="font-size: 1.1rem; font-weight: 600;">${property.bathrooms}</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.7rem; color: #6b7280;">Floor Number</div>
                                    <div style="font-size: 1.1rem; font-weight: 600;">${property.floorNumber != null ? property.floorNumber : 'Ground'}</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.7rem; color: #6b7280;">Monthly Rent</div>
                                    <div style="font-size: 1.1rem; font-weight: 700; color: var(--primary);">रू <fmt:formatNumber value="${property.monthlyRent}" groupingUsed="true"/></div>
                                </div>
                                <div>
                                    <div style="font-size: 0.7rem; color: #6b7280;">Security Deposit</div>
                                    <div style="font-size: 1.1rem; font-weight: 500;">रू <fmt:formatNumber value="${property.securityDeposit}" groupingUsed="true"/></div>
                                </div>
                                <c:if test="${property.powerBackupHours != null and property.powerBackupHours > 0}">
                                    <div>
                                        <div style="font-size: 0.7rem; color: #6b7280;">Power Backup</div>
                                        <div style="font-size: 1.1rem; font-weight: 500;">${property.powerBackupHours} hours/day</div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty property.waterSource}">
                                    <div>
                                        <div style="font-size: 0.7rem; color: #6b7280;">Water Source</div>
                                        <div style="font-size: 1.1rem; font-weight: 500; text-transform: capitalize;">${property.waterSource}</div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty property.roadAccess}">
                                    <div>
                                        <div style="font-size: 0.7rem; color: #6b7280;">Road Access</div>
                                        <div style="font-size: 1.1rem; font-weight: 500; text-transform: capitalize;">
                                            ${property.roadAccess == '2w' ? '2-Wheeler Only' : ''}
                                            ${property.roadAccess == '4w' ? '4-Wheeler Only' : ''}
                                            ${property.roadAccess == 'both' ? '2W & 4W Access' : ''}
                                            ${property.roadAccess == 'none' ? 'No Access' : ''}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- RIGHT COLUMN: Tenant & Requests -->
                <div>
                    <!-- Current Tenant Section (if rented) -->
                    <c:if test="${property.status == 'rented' and not empty currentTenant}">
                        <div class="dashboard-card" style="margin-bottom: 1.5rem;">
                            <div class="card-header">
                                <h3>Current Tenant</h3>
                            </div>
                            <div style="padding: 1rem;">
                                <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
                                    <div style="width: 60px; height: 60px; background: linear-gradient(135deg, var(--primary), var(--primary-container)); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                        <span class="material-symbols-outlined" style="font-size: 2rem; color: white;">person</span>
                                    </div>
                                    <div>
                                        <h3 style="margin-bottom: 0.25rem;">${fn:escapeXml(currentTenant.fullName)}</h3>
                                        <p style="color: #6b7280; font-size: 0.875rem;">${currentTenant.displayId}</p>
                                    </div>
                                </div>
                                <table style="width: 100%; border-collapse: collapse;">
                                    <tr style="border-bottom: 1px solid #e5e7eb;">
                                        <td style="padding: 0.75rem 0; font-weight: 600; width: 40%;">Email</td>
                                        <td style="padding: 0.75rem 0;">${fn:escapeXml(currentTenant.email)}</td>
                                    </tr>
                                    <tr style="border-bottom: 1px solid #e5e7eb;">
                                        <td style="padding: 0.75rem 0; font-weight: 600;">Phone</td>
                                        <td style="padding: 0.75rem 0;">${fn:escapeXml(currentTenant.phone)}</td>
                                    </tr>
                                    <c:if test="${not empty property.currentLeaseStart}">
                                        <tr style="border-bottom: 1px solid #e5e7eb;">
                                            <td style="padding: 0.75rem 0; font-weight: 600;">Lease Start</td>
                                            <td style="padding: 0.75rem 0;">${property.currentLeaseStart}</td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${not empty property.currentLeaseEnd}">
                                        <tr>
                                            <td style="padding: 0.75rem 0; font-weight: 600;">Lease End</td>
                                            <td style="padding: 0.75rem 0;">${property.currentLeaseEnd}</td>
                                        </tr>
                                    </c:if>
                                </table>
                                <div style="margin-top: 1rem; display: flex; gap: 0.5rem;">
                                    <a href="#" class="btn-outline" style="flex: 1; text-align: center; text-decoration: none;">
                                        <span class="material-symbols-outlined" style="font-size: 1rem;">chat</span>
                                        Message Tenant
                                    </a>
                                    <a href="${pageContext.request.contextPath}/landlord/payments?propertyId=${property.propertyId}" class="btn-primary" style="flex: 1; text-align: center; text-decoration: none;">
                                        <span class="material-symbols-outlined" style="font-size: 1rem;">payments</span>
                                        View Payments
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Rental Requests Section -->
                    <div class="dashboard-card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3>Rental Requests</h3>
                            <a href="${pageContext.request.contextPath}/landlord/requests/list" class="view-all-link">View All →</a>
                        </div>
                        <div style="padding: 1rem;">
                            <c:choose>
                                <c:when test="${empty requests}">
                                    <div style="text-align: center; padding: 2rem; color: #6b7280;">
                                        <span class="material-symbols-outlined" style="font-size: 3rem;">inbox</span>
                                        <p>No rental requests yet</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="req" items="${requests}" end="2">
                                        <div style="padding: 0.75rem; border-bottom: 1px solid #e5e7eb;">
                                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                                <div>
                                                    <span style="font-weight: 600;">${req.tenantName}</span>
                                                    <span style="font-size: 0.7rem; color: #6b7280; margin-left: 0.5rem;">${req.displayId}</span>
                                                </div>
                                                <span class="status-badge" style="
                                                    ${req.status == 'pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                                                    ${req.status == 'approved' ? 'background: #d1fae5; color: #059669;' : ''}
                                                    ${req.status == 'rejected' ? 'background: #fee2e2; color: #dc2626;' : ''}
                                                    padding: 0.25rem 0.5rem; border-radius: 2rem; font-size: 0.65rem; font-weight: 600;">
                                                    ${req.status}
                                                </span>
                                            </div>
                                            <div style="font-size: 0.8rem; color: #6b7280;">
                                                Move-in: ${req.requestedMoveInDate} • ${req.requestedLeaseDurationMonths} months
                                            </div>
                                            <c:if test="${not empty req.tenantMessage}">
                                                <div style="font-size: 0.75rem; background: #f9fafb; padding: 0.5rem; margin-top: 0.5rem; border-radius: 0.5rem;">
                                                    "${fn:escapeXml(req.tenantMessage)}"
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Photos Section -->
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h3>Property Photos</h3>
                            <a href="${pageContext.request.contextPath}/landlord/properties?action=edit&id=${property.displayId}" class="view-all-link">Manage Photos →</a>
                        </div>
                        <div style="padding: 1rem;">
                            <c:choose>
                                <c:when test="${empty photos}">
                                    <div style="text-align: center; padding: 2rem; color: #6b7280;">
                                        <span class="material-symbols-outlined" style="font-size: 3rem;">photo_camera</span>
                                        <p>No photos uploaded yet</p>
                                        <a href="${pageContext.request.contextPath}/landlord/properties?action=edit&id=${property.displayId}" class="btn-outline" style="margin-top: 0.5rem; display: inline-block;">Add Photos</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.5rem;">
                                        <c:forEach var="photo" items="${photos}" begin="0" end="5">
                                            <div style="position: relative; border-radius: 0.5rem; overflow: hidden; aspect-ratio: 1/1;">
                                                <img src="${pageContext.request.contextPath}/property-photo/${photo.photoUrl}" 
                                                     style="width: 100%; height: 100%; object-fit: cover;"
                                                     onerror="this.src='${pageContext.request.contextPath}/assets/no-image.jpg'">
                                                <c:if test="${photo.primary}">
                                                    <div style="position: absolute; top: 0.25rem; right: 0.25rem; background: var(--primary); border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center;">
                                                        <span class="material-symbols-outlined" style="font-size: 0.75rem; color: white;">star</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <style>
        .btn-outline {
            background: transparent;
            border: 1px solid var(--primary);
            color: var(--primary);
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
        }
        .btn-outline:hover {
            background: rgba(51, 79, 43, 0.05);
        }
        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-container));
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
        }
        .btn-primary:hover {
            opacity: 0.9;
        }
        .section-badge {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        .view-all-link {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--primary);
            text-decoration: none;
        }
        .dashboard-card {
            background: white;
            border-radius: 1rem;
            border: 1px solid #e5e7eb;
            overflow: hidden;
        }
        .card-header {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-header h3 {
            font-size: 1rem;
            font-weight: 700;
            margin: 0;
        }
    </style>

</body>
</html>