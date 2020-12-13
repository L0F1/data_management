FIO = 'Сотников Иван Дмитриевич'

// загрузка данных в бд
// /usr/bin/mongoimport --host $APP_MONGO_HOST --port $APP_MONGO_PORT --db movie --collection tags --file /usr/share/data_store/raw_data/tags.json

count = db.tags.find().count()

print('tags count: ', count);
// output: tags count: 91106

count = db.tags.find({"tag_name": "Adventure"}).count()

print('Adventure tags count: ', count);
// output: Adventure tags count: 3496

printjson(
        db.tags.aggregate([
                {$group: {
                                "genre":"$tag_name",
                                "count": {$sum: 1}
                           }
                },
                {$sort: {count: -1}},
                {$limit: 3}
        ])['_batch']
);

/* output:
[
	{
		"genre" : "Thriller",
		"count" : 7624
	},
	{
		"genre" : "Comedy",
		"count" : 13182
	},
	{
		"genre" : "Drama",
		"count" : 20265
	}
]
*/
