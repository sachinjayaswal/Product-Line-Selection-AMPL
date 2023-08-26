#Name of Model file: model PLS.mod (Other Single-level Reformulation (a); refer to Table 3 in Section 3.3)
param N_Product;
param N_Segment;
set Product:= 1..N_Product;
set Segment:= 1..N_Segment;

param utility {Segment, Product}; #Utility of a product to a given customer segment
param seg_size {Segment} >=0; #Size of each customer segment
param reserv_util{Segment} >=0; #UReservation tility of a given customer segment
param dev_cost {Product} >=0; #Product Development Cost
param profit {Product} >=0; #Unit profit on each product
param M{s in Segment, p in Product, q in Product: q!=p}:= abs(utility[s, q])+ abs(utility[s, p]);#Large number
var Develop {Product} binary; #1 if the particular product is selected, 0 otherwise
var Buy {Segment, Product} binary; #1 if the product is chosen by the customer segment, 0 otherwise

maximize
Profit: sum {s in Segment, p in Product}profit[p]*seg_size[s]*Buy[s, p] - sum {p in Product}dev_cost[p]*Develop[p];
subject to
Buy_only_if_developed{s in Segment, p in Product}: Buy[s, p] <= Develop[p];
Buy_max_one_product{s in Segment}: sum {p in Product}Buy[s, p] <= 1;
Dont_buy_if_below_reserve_util{s in Segment, p in Product: utility[s, p] < reserv_util[s]}: Buy[s, p] <= 0;
Max_Util_Choice{s in Segment, p in Product, q in Product: q != p}:
utility[s, p] >= utility[s, q]*Develop[q] - M[s,p,q]*(1-Buy[s, p]);
