#!/bin/bash

echo "🚀 Setting up Admin Dashboard in Spring Boot..."
echo ""

# Create directory
echo "📁 Creating directory structure..."
mkdir -p backend/src/main/resources/static/admin

# Copy files
echo "📋 Copying admin dashboard files..."
cp -r admin-dashboard/* backend/src/main/resources/static/admin/

# Create responsive CSS
echo "📐 Creating responsive CSS..."
cat > backend/src/main/resources/static/admin/css/responsive.css << 'EOF'
/* Responsive Optimizations for Admin Dashboard */

/* Large Desktops (1920px and below) */
@media (max-width: 1920px) {
    aside {
        width: 240px !important;
    }
    
    main {
        margin-left: 240px !important;
    }
}

/* Standard Desktops (1440px and below) */
@media (max-width: 1440px) {
    /* Reduce sidebar width */
    aside {
        width: 200px !important;
    }
    
    main {
        margin-left: 200px !important;
        padding: 1rem !important;
    }
    
    /* Reduce header height */
    header {
        height: 56px !important;
    }
    
    /* Adjust top padding */
    .flex.pt-16 {
        padding-top: 56px !important;
    }
    
    /* Smaller headings */
    h2, .text-3xl {
        font-size: 1.5rem !important;
    }
    
    /* Reduce card gaps */
    .grid.gap-6 {
        gap: 1rem !important;
    }
}

/* Laptops (1024px and below) */
@media (max-width: 1024px) {
    /* Hide sidebar by default */
    aside {
        transform: translateX(-100%);
        transition: transform 0.3s ease;
        position: fixed;
        z-index: 40;
    }
    
    aside.open {
        transform: translateX(0);
    }
    
    main {
        margin-left: 0 !important;
    }
    
    /* Add hamburger menu button */
    .mobile-menu-btn {
        display: block !important;
    }
}

/* Tablets (768px and below) */
@media (max-width: 768px) {
    /* Stack grid items */
    .grid.grid-cols-4 {
        grid-template-columns: repeat(2, 1fr) !important;
    }
    
    .grid.grid-cols-2 {
        grid-template-columns: 1fr !important;
    }
}

/* Mobile (640px and below) */
@media (max-width: 640px) {
    /* Single column layout */
    .grid {
        grid-template-columns: 1fr !important;
    }
    
    /* Smaller padding */
    main {
        padding: 0.5rem !important;
    }
    
    /* Hide some columns in tables */
    table td:nth-child(n+4),
    table th:nth-child(n+4) {
        display: none;
    }
}

/* Scrollable tables */
.table-container {
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
}

table {
    min-width: 800px;
}

/* Reduce font sizes globally on smaller screens */
@media (max-width: 1440px) {
    body {
        font-size: 14px;
    }
    
    .text-sm {
        font-size: 0.8rem !important;
    }
    
    .text-xs {
        font-size: 0.7rem !important;
    }
}

/* Fix button sizes */
button, .btn {
    padding: 0.5rem 1rem !important;
    font-size: 0.875rem !important;
}

/* Compact cards */
.card {
    padding: 1rem !important;
}

/* Reduce spacing */
.space-y-6 > * + * {
    margin-top: 1rem !important;
}

.space-x-4 > * + * {
    margin-left: 0.75rem !important;
}
EOF

echo ""
echo "✅ Admin dashboard integrated successfully!"
echo ""
echo "📍 Access URLs:"
echo "   - Admin Dashboard: http://localhost:8080/admin/"
echo "   - API Endpoints: http://localhost:8080/api/v1/"
echo ""
echo "🔧 Next steps:"
echo "   1. Restart Spring Boot:"
echo "      cd backend && ./mvnw spring-boot:run"
echo ""
echo "   2. Open browser:"
echo "      http://localhost:8080/admin/"
echo ""
echo "   3. Add JavaScript files (see ADMIN_SPRING_BOOT_INTEGRATION.md)"
echo ""
