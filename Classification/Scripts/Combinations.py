from itertools import combinations as comb

fusil = ['CL', 'DL', 'VN', 'VP', 'SV']

comblist = []
for i in fusil:
    nf = [f for f in fusil if f != i]
    co = list(comb(nf, 2))
    print(co)

print(comblist)
