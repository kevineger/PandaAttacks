---------------------------------------------------------------------------------
-- questions.lua
---------------------------------------------------------------------------------

a1 = {}
a1.questionString = "class ForDemo { %n %t public static void main (String () args){ %n %t %t for ( integer i=0; i<10; i += ) { %n %t %t System.out.println( \"i\" ); %n %t %t } %n %t } %n }"
a1.error = {"()", "integer", "+=", "\"i\"" }

a2 = {}
a2.questionString = "class Test { %n %t int x = 0; "
a2.error = {"class", "Test", "int", "x"}

--array holding finderrors game questions
errorCode = {
	a1,
	a2
}