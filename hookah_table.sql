SELECT "workshifts_fact".id_workshift,
			 "workshifts_plan"."start_date" as "Дата", 
			 to_char(workshifts_plan.start_date,'day') as "День недели",
			 concat(3600::numeric,' ₽') as "Микро",
       concat("workshifts_plan".income::numeric*0.8,' ₽') as "Минимум",
       concat("workshifts_plan".income::numeric,' ₽') as "План",
       concat("workshifts_plan".income::numeric*1.4,' ₽') as "Сверхплан",
       ("passport"."_name" || ' ' || "passport".surname) AS "Имя сотрудника",
			 CASE WHEN "workshifts_fact".staff_type <> 'Стажер' THEN '+' ELSE '-' END AS "Стаж",
			 CASE WHEN "workshifts_fact".staff_type <> 'Стажер' THEN 800 ELSE 500 END AS "Выход",
			 sum(case when sales.id_promotion=1 then sales.promotion_amount end) AS "Арабский",
       sum(case when sales.id_promotion=2 then sales.promotion_amount end) AS "Jagermeister",
			 sum(case when sales.id_promotion=3 then sales.promotion_amount end) AS "Третий в подарок",
			 sum(case when sales.id_filler=1 then sales.promotion_amount end) AS "Дух свободы",
			 sum(case when sales.id_filler=2 then sales.promotion_amount end) AS "Luxury",
			 sum(case when sales.id_filler=3 then sales.promotion_amount end) AS "Патриотичный",
			 sum(case when sales.id_filler=4 then sales.promotion_amount end) AS "Мужской",
			 sum(case when sales.id_filler=5 then sales.promotion_amount end) AS "Женский",
			 sum(case when sales.id_filler=6 then sales.promotion_amount end) AS "Luxury"
			 
FROM workshifts_plan 
JOIN workshifts_fact ON (workshifts_fact.id_workshift=workshifts_plan.id_workshift) 
JOIN staff_workshifts ON (workshifts_fact.id_workshift=staff_workshifts.id_workshift) 
JOIN staff ON (staff_workshifts.id_staff=staff.id_staff) 
JOIN passport ON (staff.passport_data=passport.id_passport_data)
JOIN sales ON (workshifts_fact.id_workshift=sales.id_workshift)
JOIN promotions ON (sales.id_promotion=promotions.id_promotion)
GROUP BY workshifts_fact.id_workshift, 
				 workshifts_plan.start_date, 
         workshifts_plan.income, 
         passport."_name",
         passport.surname