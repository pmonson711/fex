# Fex ( Filter Expression )

## Examples

- `'title':'the right Way'`
  - a key term of exactly `/^title$/i`
  - a value term of exactly `/^the right way$/i`

- `title:'the right way', text:go`
	- a key term of contains i.e. `/title/i`
	- a value term of exactly `/^the right way$/i`
	- and
	- any value that contains `/go/i`

- `..title:the right way`
	- a key term that ends with `/title$/i`
	- a value term that contains `the` before it contains `right` before it contains `way` i.e. `/the.*right.*way/i`

- `title:right, title:way`
	- a key term that contains `/title/i`
	- a value term that contains `/right/i` or `/way/i`

- `title:a..`
	- a key term that contains `/title/i`
	- a value term that starts with `/^a/i`

- `title:..a`
	- a key term that contains `/title/i`
	- a value term that ends with `/a$/i`

- `ref title:..a`
	- a key term that contains `ref` before `title` i.e. `/ref.*title/i`
	- a value term that ends with `/a$/i`

- `'the right way'`
	- any value that contains `/the right way/i`

- `the right way`
	- any value that contains `the` before it contains `right` before it contains `way` i.e. `/the right way/i`

## Lexicon

Term:: TBD
Key Term:: TBD
Value Term:: TBD

### Inspiration

- https://support.google.com/mail/answer/7190?hl=en
- https://lucene.apache.org/core/3_1_0/queryparsersyntax.html
