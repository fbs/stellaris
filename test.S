	.text
	.global IncOne
IncOne:
	add R0, R0, #1
	BX LR
	.type IncOne, function
	.size IncOne, .-IncOne
