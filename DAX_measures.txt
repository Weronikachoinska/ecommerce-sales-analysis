# DAX Measures

- Sales Metrics
- Customer Metrics
- Delivery Metrics
- Customer Satisfaction
- Dynamic Insight

## Sales Metrics

Total Revenue = 
SUM(orders[order_value]) 

Total Orders = 
COUNTROWS(orders)

Average Order Value = 
AVERAGE(orders[order_value]) 

Revenue per Customer = 
DIVIDE(
    [Total Revenue],
    [Total Customers]
)

## Customer Metrics 

Total Customers = 
DISTINCTCOUNT(customers[customer_unique_id])

Repeat Customers = 
COUNTROWS(
    FILTER(
        VALUES(customers[customer_unique_id]),
        CALCULATE([Total Orders]> 1)
    )
)

Repeat Customers Rate = 
DIVIDE(
    [Repeat Customers],
    [Total Customers]
)

## Delivery Metrics 

Delivered Orders = 
 CALCULATE([Total Orders],
 orders[order_status] = "delivered")
 
Delivery Rate =
DIVIDE(
    [Delivered Orders],
    [Total Orders]
)


Average Delivery Days = 
CALCULATE(
AVERAGE(orders[delivery_days]),
orders[order_status] = "delivered"
)
 
On-Time Deliveries = 
CALCULATE(
    [Delivered Orders],
    orders[delivery_status] = "On Time"
)

On-Time Delivery Rate = 
DIVIDE(
    [On-Time Deliveries],
    [Delivered Orders]
)

Early Deliveries = 
CALCULATE(
    [Delivered Orders],
    orders[delivery_status] = "Early"
)

Early Delivery Rate = 
 DIVIDE(
    [Early Deliveries],
    [Delivered Orders]
 )
 
Delayed Orders = 
 CALCULATE(
    [Delivered Orders],
    orders[delivery_status] = "Delayed")

	
Delay Delivery Rate = 
DIVIDE(
    [Delayed Orders],
    [Delivered Orders] 
)

Average Delay Days = 
CALCULATE(
    AVERAGE(orders[delay_days]),
    orders[delivery_status] = "Delayed")
	
## Customer Satisfaction

Average Review Score = 
AVERAGE(reviews[review_score]) 


## Dynamic Insight

Customer Insight =
VAR SelectedSegment =
    SELECTEDVALUE ( rfm[segment] )
VAR CustomerShare =
    DIVIDE (
        [Total Customers],
        CALCULATE ( [Total Customers], ALL ( rfm[segment] ) )
    )
VAR OverallRepeatRate =
    CALCULATE ( [Repeat Customers Rate], ALL ( rfm[segment] ) )
VAR SegmentDescription =
    SWITCH (
        SelectedSegment,
        "Champions", "Most valuable customers. They purchase regularly and generate high revenue.",
        "Big Spenders", "Customers who place high-value orders.",
        "Loyal Customers", "Customers who make repeat purchases and provide a stable source of revenue.",
        "Regular", "Customers with average purchasing behavior.",
        "New Customers", "Recently acquired customers who are making their first purchase.",
        "Lost Customers", "Customers who have not returned for a long time."
    )
RETURN
    IF (
        NOT HASONEVALUE ( rfm[segment] ),
        "Overall Customer Summary" & UNICHAR ( 10 ) & UNICHAR ( 10 ) & "• Total customers: "
            & FORMAT ( [Total Customers], "#,##0" )
            & UNICHAR ( 10 ) & "• Repeat purchase rate: "
            & FORMAT ( [Repeat Customers Rate], "0.00%" )
            & UNICHAR ( 10 ) & "• Average order value: "
            & FORMAT ( [Average Order Value], "R$#,##0.00" )
            & UNICHAR ( 10 )
            & UNICHAR ( 10 ) & "Most customers purchased only once."
            & UNICHAR ( 10 )
            & UNICHAR ( 10 ) & "Select a single segment to view detailed insights.",
        SelectedSegment & UNICHAR ( 10 ) & UNICHAR ( 10 ) & SegmentDescription
            & UNICHAR ( 10 )
            & FORMAT ( CustomerShare, "0.00%" ) & " of all customers ("
            & FORMAT ( [Total Customers], "#,##0" ) & ") belong to this segment."
            & UNICHAR ( 10 ) & "The repeat purchase rate is "
            & FORMAT ( [Repeat Customers Rate], "0.00%" ) & " compared with an overall rate of "
            & FORMAT ( OverallRepeatRate, "0.00%" ) & "."
            & UNICHAR ( 10 ) & "The average order value is "
            & FORMAT ( [Average Order Value], "R$#,##0.00" ) & ", while revenue per customer is "
            & FORMAT ( [Revenue per Customer], "R$#,##0.00" ) & "."
    )
