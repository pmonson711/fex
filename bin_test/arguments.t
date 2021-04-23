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

  $ fex "a" ./data.json | column -t -s '|'
  name      age  prop.a  prop.b.c  
  person a  50   1       d         

  $ fex "a" -f"b"  ./data.json
  Can't have the `--fex-string b` and `a` set
  [124]

  $ fex "a" ./data.json -j ./data.json
  Can't have both `--json-file ./data.json` and `./data.json` set
  [124]
