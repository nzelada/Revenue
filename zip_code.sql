SELECT ZipCodeNY, SUM(Revenue) AS Revenue, Months
FROM
(
SELECT json_extract(payment_data, '$.source.address_zip') AS
ZipCodeNY,ROUND((julianday(date(payment_at,'start of month','+1 month','0 day')) - julianday(payment_at))/strftime('%d',date(payment_at,'start of month','+1 month','-1 day'))*(payments.amount/100),2) AS "Revenue",
strftime("%m-%Y", payment_at) AS "Months"
FROM payments
JOIN school_plans
ON payments.plan_id = school_plans.plan_id
WHERE plan_interval = 'month' AND json_extract(payment_data, '$.source.address_state') =
"NY"
GROUP BY ZipCodeNY,Months

UNION 
SELECT json_extract(payment_data, '$.source.address_zip') AS ZipCodeNY, (ROUND((( julianday(date(payment_at,'start of month','0 month','0 day'))-julianday(payment_at))*-1) /strftime('%d',date(payment_at,'start of month','+1 month','-1 day'))*(payments.amount/100),2)) AS "Revenue",
strftime("%m-%Y", date(payment_at,'start of month','2 month','-1 day'))
FROM payments
JOIN school_plans
ON payments.plan_id = school_plans.plan_id
AS "Months"
WHERE plan_interval = 'month' AND json_extract(payment_data, '$.source.address_state') = "NY"
GROUP BY ZipCodeNY ,Months )

GROUP BY ZipCodeNY ,Months
ORDER BY ZipCodeNY ,Months
;
