import Control.Exception
import Data.List
import Text.Printf

sz = 32
-- Avoiding typos and other evil stuff haunting us due to the lists being used as the primary data structure
ck l = assert (length l == sz) l

-- Put 'nan' when the value is unspecified or irrelevant in the target daily uptakes
nan = 0/0

-- TODO a better value that taints the calculation
idk :: Double
idk = 0

-- grams per 100g
-- nutrients:	[prote,	fat,	carbs,	fiber,
-- elements:	potass,	sodium,	calciu,	magnes,	phosph,	iron,	iodine,	zinc,	seleni,	copper,	chromi,	mangane,molybden,chloride,
-- vitamins:	a,	c,	d,	e,	k,	thiami,	ribofl,	niacin,	pantot,	b6,	biotin,	folate,	b12,
----aminoacids:	histid,	isoleu,	leucin,	lysine,	methio,	
-- misc:	price)
raisin = ck	[3,	0.5,	79,	5,
		0.773,	0.017,	0.044,	0.032,	0.097,	2.1e-3,	idk,	240e-6,	0.63e-6,328e-6,	idk,	0.29e-3,idk,	idk,
		0,	3.6e-3,	0,	120e-6,	3.5e-6,	75e-6,	166e-6,	1e-3,	93e-6,	228e-6,	idk,	3.7e-6,	0,
		13]
sunflkern = ck	[19,	53,	23,	11,
		0.608,	0.24,	0.071,	0.128,	1.2,	3.7e-3,	idk,	5e-3,	53e-6,	1.8e-3,	idk,	1.95e-3,idk,	idk,
		0,	0,	0,	25e-3,	0,	1.48e-3,355e-6,	8.33e-3,1.13e-3,1.34e-3,idk,	227e-6,	0,
		6.8]
oat = ck	[16.89,	6.9,	66.27,	10.6,
		429e-3,	2e-3,	54e-3,	177e-3,	523e-3,	4.72e-3,idk,	3.97e-3,4.3e-6,	626e-6,	idk,	4.91e-3,idk,	idk,
		99e-6,	33e-6,	0,	92e-6,	0.42e-6,256e-6,	137e-6,	1.6e-3,	419e-6,	160e-6,	idk,	37e-6,	0,
		2.7]

-- daily intakes, g
fdardi = ck	[50,	65,	300,	25,
		4.7,	2.4,	1,	0.4,	1,	0.018,	0.00015,0.015,	0.00007,0.0007,	120e-6,	2e-3,	75e-6,	3.4,
		0.0009,	0.06,	0.00001,0.015,	0.00008,0.0015,	0.0017,	0.02,	0.01,	0.002,	0.0003,	0.0004,	6e-6,
		1]
iomdrirda = ck	[nan,	nan,	nan,	nan,
		4.7,	1.5,	1,	0.4,	0.7,	15e-3,	150e-6,	11e-3,	55e-6,	0.9e-3,	35e-6,	2.3e-3,	45e-6,	2.3,
		0.9e-3,	0.09,	15e-6,	15e-3,	120e-6,	1.2e-3,	1.3e-3,	16e-3,	5e-3,	1.3e-3,	30e-6,	0.4e-3,	2.4e-6,
		nan]
iomdriul = ck	[nan,	nan,	nan,	nan,
		nan,	2.3,	2.5,	0.7,	4,	45e-3,	1.1e-3,	40e-3,	400e-6,	10e-3,	nan,	11e-3,	2e-3,	3.6,
		3e-3,	2,	100e-6,	1,	nan,	nan,	nan,	35e-3,	nan,	100e-3,	nan,	1e-3,	nan,
		nan]

-- Specify the mix
mix = map sum $ transpose $ map (\(frac, l) -> map (frac *) l) [
	(0.65, oat),
	(0.2, raisin),
	(0.15, sunflkern)]

-- Calculate the energetic value
cal x = 4 * x!!0 + 9 * x!!1 + 4 * x!!2

-- Compare the mix against the reference 2Mcal diet
calc p ref = zipWith (/) (map (* (2000 / (cal p))) p) ref

tbl = map (calc mix) [fdardi, iomdrirda, iomdriul]

-- Some pretty-printing
report = putStr $ let [pr, fa, carb, fib, k, na, ca, mg, ph, fe, i, zn, se, cu, cr, mn, mo, cl, vA, vC, vD, vE, vK, thi, rib, nia, pant, vB6, bio, fol, vB12, rur] = transpose $ map (map (* 100)) tbl in
	(printf "%-32s %7s %7s %7s\n" "" "FDA RDI" "DRI RDA" "DRI UL") ++
	concatMap (\(a, [b, c, d]) -> printf "%-32s %6.0f%% %6.0f%% %6.0f%%\n" a b c d) [
		("Protein", pr),
		("Fat", fa),
		("Carbohydrates", carb),
		("Dietary fiber", fib),
		("Potassium", k),
		("Sodium", na),
		("Calcium", ca),
		("Magnesium", mg),
		("Phosphorus", ph),
		("Iron", fe),
		--("Iodine", i),
		("Zinc", zn),
		("Selenium", se),
		("Copper", cu),
		--("Chromium", cr),
		("Manganese", mn),
		--("Molybdenum", mo),
		--("Chlorine", cl),
		("Vitamin A", vA),
		("Vitamin C", vC),
		("Vitamin D", vD),
		("Vitamin E", vE),
		("Vitamin K", vK),
		("Thiamin", thi),
		("Riboflavin", rib),
		("Niacin", nia),
		("Pantothenic acid", pant),
		("Vitamin B6", vB6),
		--("Biotin", bio),
		("Folate", fol),
		("Vitamin B12", vB12),
		("Roubles per 2MCal", rur)]

main = report