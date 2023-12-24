We create a test file
  $ cat > data.json <<EOF
  > [
  > 	{
  > 		"name": "person a",
  > 		"age": 50,
  > 		"prop": {
  > 			"a": 1,
  > 			"b": { "c": "d" }
  > 		}
  > 	},
  > 	{
  > 		"name": "person b",
  > 		"age": 51,
  > 		"prop": {
  > 			"a": 2,
  > 			"b": { "d": "f" }
  > 		}
  > 	}
  > ]
  > EOF

Finds person a
  $ fex "a" data.json
  name|age|prop.a|prop.b.c|
  person a|50|1|d|

Finds person b
  $ fex "b" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person nested c exists
  $ fex "c:" data.json
  name|age|prop.a|prop.b.c|
  person a|50|1|d|

Finds person nested c exists
  $ fex "\-c:" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person nested c exists
  $ fex "d:" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person nested b and value exists
  $ fex "b:d" data.json
  name|age|prop.a|prop.b.c|
  person a|50|1|d|

Finds person nested c and value exists
  $ fex "b:f" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person nested c and value exists
  $ fex "b:f,abc" data.json
  name|age|prop.a|prop.b.c|

Finds person over 50
  $ fex "age:>50" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person under 51
  $ fex "age:<51" data.json
  name|age|prop.a|prop.b.c|
  person a|50|1|d|

Finds person betwen 49 and 51
  $ fex "age:=49..51" data.json
  name|age|prop.a|prop.b.c|
  person a|50|1|d|

Finds person betwen 50 and 52
  $ fex "age:=50..52" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person betwen 40 and 60
  $ fex "age:=40..60" data.json
  name|age|prop.a|prop.b.c|
  person a|50|1|d|
  person b|51|2|f|

Finds person with prop.a > 1
  $ fex "prop a:> 1" data.json
  name|age|prop.a|prop.b.c|
  person b|51|2|f|

Finds person nested c and value exists
  $ fex ":+" data.json
  name|age|prop.a|prop.b.c|
