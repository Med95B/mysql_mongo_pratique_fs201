use DBSportifs
db.createCollection("Sportif")
db.getCollection("Sportif").insertMany([
    {_id:"sp1",
 "nom":"Radi",
 "prenom":"Abdessalam",
 "genre":"homme",
 "sport":{"description":"marathon","olympique":"true"}
 },
 {_id:"sp2",
 "nom":"Larbi",
 "prenom":"Benmbarek",
 "genre":"homme",
 "sport":{"description":"football","olympique":"true"}
 },
  {_id:"sp3",
 "nom":"ELGourch",
 "prenom":"Mohamed",
 "genre":"homme",
 "sport":{"description":"cyclisme","olympique":"true"}
 },
 {_id:"sp4",
 "nom":"Bidouane",
 "prenom":"Nezha",
 "genre":"femme",
 "sport":{"description":"athletisme","olympique":"true"}
 },
 {_id:"sp5",
 "nom":"ELGaraa",
 "prenom":"Najat",
 "genre":"femme",
 "sport":{"description":"athletisme","olympique":"true"}
 },
  {_id:"sp6",
 "nom":"Rabii",
 "prenom":"Mohamed",
 "genre":"homme",
 "sport":{"description":"box","olympique":"true"}
 },
  {_id:"sp7",
 "nom":"elguerrouj",
 "prenom":"Hicham",
 "genre":"homme",
 "sport":{"description":"box","olympique":"true"}
 },
  {_id:"sp8",
 "nom":"Abissourour",
 "prenom":"Sara",
 "genre":"femme",
 "sport":{"description":"volley ball","olympique":"true"}
 },
  {_id:"sp9","nom":"Belafrikh",
 "prenom":"Amine",
 "genre":"homme",
 "sport":{"description":"Muay Thai","olympique":"false"}
 },
 {_id:"sp10",
 "nom":"Moutawakil",
 "prenom":"Naoual",
 "genre":"femme",
 "nbMedailles":4,
 "sport":{"description":"athletisme","olympique":"true"}
 }
])

db.Sportif.find()
db.Sportif.find({},{'_id':1,'nom':1,'prenom':1})
db.Sportif.find({'genre':'homme'},{'_id':1,'nom':1,'prenom':1,'genre':1})
db.Sportif.find({'sport.description':'cyclisme'},{'_id':1,'nom':1,'prenom':1,'genre':1,'sport.description':1})
db.Sportif.find({'sport.olympique':'false'},{'sport.description':1})
db.getCollection("Sportif").findOne({"sport.description":"football"})
db.getCollection("Sportif").find({},{'nom':1,'prenom':1}).sort({"nom":1})
db.getCollection("Sportif").find({},{'sport.description':1}).sort({'sport.description':-1})
db.getCollection("Sportif").find().count()
db.getCollection("Sportif").distinct("sport.description")
db.getCollection("Sportif").find({"genre":"femme"},{"nom":1}).limit(2)
db.getCollection("Sportif").find({"nbMedailles":{"$eq":3}},{"nom":1,"prenom":1})
db.getCollection("Sportif").find({"nbMedailles":{"$gte":2}},{"nom":1,"prenom":1})
db.getCollection("Sportif").find({"sport.description":{"$in":["athletisme","box","cyclisme"]}},{"nom":1,"prenom":1})
db.getCollection("Sportif").find({"nbMedailles":{$exists:false}},{"nom":1,"prenom":1})
db.getCollection("Sportif").aggregate([{$match:{"sport.description": "cyclisme" }}])
db.getCollection("Sportif").aggregate([{$group:{_id:"$sport.description",nombre:{$sum:"$nbMedailles"}}}])
db.getCollection("Sportif").aggregate([{$group:{_id:"$sport.description",maximum: {$max:"$nbMedailles"}}}])
db.getCollection("Sportif").updateOne({"nom":"Rabii","prenom":"Mohamed"},{$set:{"nbMedailles" :2}})
db.getCollection("Sportif").updateMany({},{$set:{"nationalite":"marocaine"}})
db.getCollection("Sportif").remove({"sport.description":"Muay Thai"})