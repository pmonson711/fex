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
  $ fex "a" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person a  50   1       d         

Finds person b
  $ fex "b" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person b  51   2       f         

Finds person nested c exists
  $ fex "c:" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person a  50   1       d         

Finds person nested c exists
  $ fex "\-c:" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person b  51   2       f         

Finds person nested c exists
  $ fex "d:" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person b  51   2       f         

Finds person nested b and value exists
  $ fex "b:d" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person a  50   1       d         

Finds person nested c and value exists
  $ fex "b:f" data.json | column -t -s'|'
  name      age  prop.a  prop.b.c  
  person b  51   2       f         

Finds person nested c and value exists
  $ fex "b:f,abc" data.json | column -t -s'|'
  name  age  prop.a  prop.b.c  

Finds person nested c and value exists
  $ fex ":+" data.json
  name|age|prop.a|prop.b.c|
  Syntax error 5 on line 1, character 2: The `+` (plus) operator can not directly follow a `:` (colon) operator.
  
