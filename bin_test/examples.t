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
             name : person a
              age : 50
           prop.a : 1
         prop.b.c : d
  -------

Finds person b
  $ fex "b" data.json
             name : person b
              age : 51
           prop.a : 2
         prop.b.d : f
  -------

Finds person nested c exists
  $ fex "c:" data.json
             name : person a
              age : 50
           prop.a : 1
         prop.b.c : d
  -------

Finds person nested c exists
  $ fex "d:" data.json
             name : person b
              age : 51
           prop.a : 2
         prop.b.d : f
  -------

Finds person nested b and value exists
  $ fex "b:d" data.json
             name : person a
              age : 50
           prop.a : 1
         prop.b.c : d
  -------

Finds person nested c and value exists
  $ fex "b:f" data.json
             name : person b
              age : 51
           prop.a : 2
         prop.b.d : f
  -------

Finds person nested c and value exists
  $ fex "b:f,abc" data.json
