SELECT TOP 10 
    VendorName, 
    COUNT(*) AS CategoryCount
FROM Final_Summary_Table
GROUP BY VendorName
ORDER BY CategoryCount DESC;



SELECT TOP 10 
    Description, 
    COUNT(*) AS CategoryCount
FROM Final_Summary_Table
GROUP BY Description
ORDER BY CategoryCount DESC;
