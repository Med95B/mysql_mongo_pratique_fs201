from pymongo import MongoClient
client=MongoClient()
print(client)
db=client['DBSportifs']
print(db)
resultat=db.Sportif.find()
for r in resultat:
    print(r)
print('===============================================')
selection={}
selection['genre']='homme'
resultat=db.Sportif.find(selection)
for r in resultat:
    print (r)
