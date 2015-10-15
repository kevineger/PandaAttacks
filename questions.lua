---------------------------------------------------------------------------------
-- questions.lua
---------------------------------------------------------------------------------

a1 = {}
a1.questionString = "class ForDemo {\n\tpublic static void main(String[] args){\n\t\tfor(int i=0; i<10; i++);{\n\t\t\t System.out.println(\"Count is: \" + i);\n\t\t}\n\t}\n}"
a1.error = {"for", "int" }

a2 = {}
a2.questionString = "class Test { %n %t int x = 0; "
a2.error = {"class", "Test", "int", "x"}


errorCode = {
	a1,
	a2
}