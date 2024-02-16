from pymongo import MongoClient
client=MongoClient()
#print(client)
#print('===============================================')

db=client['DBSportifs']
sportif = db['Sportif']
#print(db)
#print('===============================================')

#resultat=db.Sportif.find()
#for r in resultat:
#    print(r)
#print('===============================================')
#selection={}
#selection['genre']='homme'
#resultat=db.Sportif.find(selection)
#for r in resultat:
#    print (r)
#print('===============================================')
#r=db.Sportif.find().sort('nom',-1)
#for i in r:
#   print(i)
#print('===============================================')

#res=db.Sportif.find({},{'_id':0,'nom':1,'prenom':1})
#for i in res:
#    print(i)
#print('===============================================')

#res=sportif.aggregate([{'$group':{'_id':'$sport.description','moyenne':{'$avg':'$nbMedailles'}}}])
#for i in res:
#    print(i['_id'],i['moyenne'])
#print('===============================================')

#res=sportif.delete_many({'sport.description':'athletisme'})
#res=sportif.find({},{'sport.description':1})
#for i in res:
#    print(i)
#print('===============================================')
#res=sportif.find_one({'_id':'sp1'})
#print(res)
#res=sportif.update_one({'_id':'sp1'},{'$set':{'nbMedailles':2}})
#res=sportif.find_one({'_id':'sp1'})
#print(res)
