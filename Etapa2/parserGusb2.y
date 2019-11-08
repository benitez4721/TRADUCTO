
#
# Autores: Marco Benitez 13-10137
#          Orlando Chaparro 12-11499

# Archivo de gramatica libre de contexto
# Debe ser pasada por racc para generar el parser con el siguiente comando
# racc -o parserGusb.rb parserGusb2.y


class ParserGusb

	# Tokens a utilizar
	token 'TkString' 'TkNum' 'TkId' 

	# Precedencia de operadores

	prechigh
		left '[' right ']'
		right '!' UMINUS
		left '*' '/' '%'
		left '+' '-'
		nonassoc '>=' '<=' '>' '<'
		nonassoc '==' '!='
		left '||'
		left '/\\'
		left '\\/'
		left ':'
		left ','
	preclow


	# Comienzo de la gramatica.
	start PROGRAMA
	

	rule

	# Regla para reconocer codigos en programas
	PROGRAMA
		: '|[' CUERPO ']|'		{ result = Programa.new(val[1]) }
		| '|[' ']|'				{ result = Programa.new(nil) }
		;
		
	# Regla para reconocer el cuerpo en un programa	
	CUERPO
	    : 'declare' LISTA_DECLARACION INSTRUCCIONES   		{ result = Cuerpo.new(val[1], val[2]) }
		| INSTRUCCIONES 		     						{ result = Cuerpo.new(nil, val[0]) }
		;

	# Reglas para reconocer una lista de declaraciones
	LISTA_DECLARACION 							
		: DECLARACION							{ result = ListaDeclaracion.new(nil, val[0]) }
		| LISTA_DECLARACION ';' DECLARACION		{ result = ListaDeclaracion.new(val[0], val[2]) }	
		;

	# Reglas para reconocer una declaracion
	DECLARACION
		: LISTA_IDENTIFICADOR ':' LISTA_TIPO   { result = Declaracion.new(val[0],nil) } 
		;
	# Reglas para reconocer una lista de tipos
	LISTA_TIPO
		: TIPO
		| LISTA_TIPO ',' TIPO	

	# Reglas para reconocer un tipo
	TIPO
		: 'int' 		{ result = nil }
		| 'bool'    	{ result = nil }
		| 'array' '[' LITERAL_NUMERO '..' LITERAL_NUMERO ']'
		;

	# Reglas para reconocer asignaciones
	ASIGNACION
		: IDENTIFICADOR ':=' EXPRESION 		{ result = Asignacion.new(val[0], val[2]) }
		;

	# Reglas para reconocer una lista de identificadores
	LISTA_IDENTIFICADOR
		: IDENTIFICADOR									{ result = ListaId.new(nil, val[0]) }
		| LISTA_IDENTIFICADOR ',' IDENTIFICADOR 		{ result = ListaId.new(val[0], val[2]) }
		;

	# Regla para reconocer un identificador
	IDENTIFICADOR
		: 'TkId' 	                   { result = Identificador.new(val[0]) }
		;
	
	#Reglas para reconocer las expresiones enteras
	EXPRESION
		: LITERAL					{ result = val[0] }
		| IDENTIFICADOR 			{ result = val[0] }
		| EXP_ARRAY					{ result = val[0] }
		| 'atoi' '(' EXPRESION ')'	{ result = Atoi.new(val[2]) }
		| 'size' '(' EXPRESION ')'	{ result = Size.new(val[2]) }
		| 'min' '(' EXPRESION ')'	 { result = Min.new(val[2]) }
		| 'max' '(' EXPRESION ')'	 { result = Max.new(val[2]) }
		| EXPRESION '+' EXPRESION 	{result = OpSuma.new(val[0], val[2]) }
		| EXPRESION '-' EXPRESION 	{ result = OpResta.new(val[0], val[2]) }
		| EXPRESION '*' EXPRESION 	{ result = OpMultiplicacion.new(val[0], val[2]) }
		| EXPRESION '/' EXPRESION   { result = OpDivisionE.new(val[0], val[2]) }
		| EXPRESION '%' EXPRESION   { result = OpModE.new(val[0], val[2]) }
		| EXPRESION ',' EXPRESION   { result = OpComa.new(val[0],val[2])}
		| '(' EXPRESION ')'			{ result = val[1] }
		| '-' EXPRESION = UMINUS 	{ result = OpUMINUS.new(val[1]) }
		| EXPRESION '/\\' EXPRESION  { result = OpAnd.new(val[0], val[2]) }
		| EXPRESION '\\/' EXPRESION  { result = OpOr.new(val[0], val[2]) }
		| EXPRESION '==' EXPRESION   { result = OpEquivalente.new(val[0], val[2]) }
		| EXPRESION '!=' EXPRESION   { result = OpDesigual.new(val[0], val[2]) }
		| '!' EXPRESION 			 { result = OpExclamacion.new(val[1]) }
		| EXPRESION '<' EXPRESION 	 { result = OpMenor.new(val[0], val[2]) }
		| EXPRESION '<=' EXPRESION   { result = OpMenorIgual.new(val[0], val[2]) }
		| EXPRESION '>=' EXPRESION   { result = OpMayorIgual.new(val[0], val[2]) }
		| EXPRESION'>' EXPRESION   	 { result = OpMayor.new(val[0], val[2]) }
		;

	LITERAL
		: LITERAL_NUMERO
		| LITERAL_BOOLEANO
		;	
	

	#Reglas para reconoces expresiones de arreglos
	EXP_ARRAY
		: IDENTIFICADOR '[' EXPRESION ']' {result = ArrayConsult.new(val[0],val[2])}
		| IDENTIFICADOR EXP_ARRAY_REC {result = ArrayAsig.new(val[0],val[1])}
		;

	EXP_ARRAY_REC
		: '(' EXPRESION ':' EXPRESION ')' EXP_ARRAY_REC	{result = ListArrayAsig.new(nil,val[1],val[3],val[5])}
		| '(' EXPRESION ':' EXPRESION ')' 				{result = ListArrayAsig.new(nil,val[1],val[3],nil)}
		;	
	# Reglas de Literales Numericos
	LITERAL_NUMERO
		: 'TkNum' 	{ result = LiteralNumerico.new(val[0]) }
		;

	# Reglas de Literales Booleanos
	LITERAL_BOOLEANO
		: 'true'	{ result = LiteralBooleano.new("true") }
		| 'false'	{ result = LiteralBooleano.new("false") }
		;

	# Regla para reconocer una secuencia de instrucciones
	INSTRUCCIONES
		: INSTRUCCIONES ';' INSTRUCCION	{ result = Instrucciones.new(val[0], val[2]) }
		| INSTRUCCION			    	{ result = Instrucciones.new(nil, val[0]) }
		;


	# Reglas para reconocer una instruccion
	INSTRUCCION
	 	: ASIGNACION			{ result = Instruccion.new(val[0]) }
	  	| ENTRADA 				{ result = Instruccion.new(val[0]) }
	  	| SALIDA 				{ result = Instruccion.new(val[0]) }
	  	| 'if' CONDICIONAL 'fi' 			{ result = Instruccion.new(val[1]) }
	  	| ITERACION_FOR 		{ result = Instruccion.new(val[0]) }
	  	| 'do' ITERACION_DO 'od'  		{ result = Instruccion.new(val[1]) }
	  	| '|[' CUERPO ']|' 		{ result = Instruccion.new(val[1]) } #INSTRUCCION BLOQUE
	  	;

	# Reglas para reconocer la lectura por input
	ENTRADA
	 	: 'read' IDENTIFICADOR 	{ result = Entrada.new(val[1])}
	 	;

	# Reglas para reconocer el output de salida
	SALIDA
	 	: 'print' 	IMPRIMIR 		{ result = Salida.new(val[1], nil) }
	 	| 'println' IMPRIMIR  	    { result = Salida.new(val[1], "SALTO") }
	 	;

	# Reglas para imprimir expresiones o strings por la salida estandar
	IMPRIMIR 
	 	: EXPRESION 					{ result = Imprimir.new(nil, val[0]) }
	 	| STRING 						{ result = Imprimir.new(nil, val[0]) }
	 	| IMPRIMIR  '||' EXPRESION 		{ result = Imprimir.new(val[0], val[2]) }
	 	| IMPRIMIR  '||' STRING 		{ result = Imprimir.new(val[0], val[2]) }
	 	;

	# Regla para reconocer un string en la salida
	STRING 
	 	: 'TkString'	{ result = Str.new(val[0]) }
	 	;

	# Reglas para reconocer la instruccion condicional
	CONDICIONAL
	 	: EXPRESION '-->' INSTRUCCIONES GUARDIA 	{ result = Condicional.new(val[0],val[2],val[3]) }
	 	| EXPRESION '-->' INSTRUCCIONES 			{ result = Condicional.new(val[0],val[2],nil) }
	 	;

	#Reglas para reconocer una guardia 
	GUARDIA
		: '[]' EXPRESION '-->' INSTRUCCIONES GUARDIA {result = Guardia.new(val[1],val[3],val[4])}
		| '[]' EXPRESION '-->' INSTRUCCIONES		 {result = Guardia.new(val[1],val[3],nil)}
	# Reglas para reconocer las iteraciones for
	ITERACION_FOR
	 	: 'for' IDENTIFICADOR 'in' EXPRESION 'to' EXPRESION '-->' '|[' CUERPO ']|' 'rof'	{ result = IteradorFor.new(val[1], val[3], val[5], val[8]) }
	 	;

	# Reglas para reconocer las iteraciones do
	ITERACION_DO
		:  EXPRESION '-->' INSTRUCCIONES 		{ result = IteratorDo.new(val[0],val[2],nil) }
		|  EXPRESION '-->' INSTRUCCIONES GUARDIA { result = IteratorDo.new(val[0],val[2],val[3]) }

# Fin de las reglas

---- header ----

# Clases requeridas
require_relative 'lexer'
require_relative 'clasesGusb'

# Errores sintacticos
class ErrorSintactico < RuntimeError

	def initialize(token)
		@token = token
	end

	def to_s
		"ERROR: fila: " + @token.fila.to_s() + ", columna: " + @token.columna.to_s() + ", token inesperado: #{@token.token} \n"  
	end
end

# Main del Parser
---- inner ----
	
	def initialize(tokens)
		@tokens = tokens
		@yydebug = true
		super()
	end 

	def parse
		do_parse
	end

	def next_token
		@tokens.shift
	end

	def on_error(id, token, pila)
		raise ErrorSintactico.new(token)
	end