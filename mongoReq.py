from pymongo import MongoClient
client=MongoClient()
print(client)
print('===============================================')

db=client['DBSportifs']
print(db)
print('===============================================')

resultat=db.Sportif.find()
for r in resultat:
    print(r)
print('===============================================')
selection={}
selection['genre']='homme'
resultat=db.Sportif.find(selection)
for r in resultat:
    print (r)
print('===============================================')
r=db.Sportif.find().sort('nom',-1)
for i in r:
    print(i)
