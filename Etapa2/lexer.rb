# 03/10/2019
# Traductores e Interpretadores CI3527
# Proyecto, Etapa 1: Analizador Lexicográfico
#
# Autores: 	Marco Benitez, 13-10137
# 	   		Orlando Chaparro, 12-11499
#

# Variables utilizadas para detectar los tokens, con expresiones regulares
$identificador = /^[a-zA-Z_][a-z0-9A-Z_]*$/	
$string = /^".*"$/
$numero = /^\d+$/
$reservadas ={
				"declare" => "TkDeclare",
				"if" => "TkIf",
				"do" => "TkDo",
				"od" => "TkOd",
				"fi" => "TkFi",
				"for" => "TkFor",
				"rof" => "TkRof",
				"print" => "TkPrint",
				"println" => "TkPrintln",
				"read" => "TkRead",
				"int" => "Tkint",
				"bool" => "Tkbool",
				"array" => "Tkarray",
				"true" => "TkTrue",
				"false" => "TkFalse",
				"|[" => "Tk0Block",
				"]|" => "TkCBlock",
				".." => "TkSoForth",
				"," => "TkComma",
				"(" => "TkOpenPar",
				")" => "TkClosePar",
				":=" => "TkAsig",
				";" => "TkSemicolon",
				"-->" => "TkArrow",
				"+" => "TkPlus",
				"-" => "TkMinus",
				"*" => "TkMult",
				"/" => "TkDiv",
				"%" => "TkMod",
				"\\/" => "TkOr",
				"/\\" => "TkAnd",
				"!" => "TkNot",
				"<" => "TkLess",
				"<=" => "TkLeq",
				">=" => "TkGeq",
				">" => "TkGreater",
				"==" => "TkEqual",
				"!=" => "TkNEqual",
				"[" => "Tk0Bracket",
				"]" => "TkCBracket",
				":" => "TkTwoPoints",
				"||" => "TkConcat",
				"atoi" => "TkAtoi",
				"size" => "TkSize",
				"max" => "TkMax",
				"min" => "TkMin",
				"[]" => "TkGuard",
				"in" => "Tkin",
				"to" => "Tkto"


				}


class Token
	# Atributos del token
	# token: nombre del token
	# tipo: de que tipo es el token (palabra reservada, signo, numerico...)
	# fila: numero de fila en donde esta el token
	# columna: numero de columna en donde esta el token
	attr_accessor :token, :tipo, :fila, :columna

	# Funcion para inicializar el token
	def initialize(token, tipo, fila, columna)
		@token = token
		@tipo = tipo
		@fila = fila
		@columna = columna
		token = ""
		tipo = String.new
		fila = 0
		columna = 0
	end

	def to_s()
  		return "#{@token}"
  	end

end

# Clase Lexer
class Lexer

	# Atributos del lexer
	# tk: lista de tokens
	# err: lista de errores
	attr_accessor :tk, :err, :parserTk

	# Inicializador del lexer
	# Inicializa la lista de tokens y errores (vacias)
	def initialize programa
		@tk = []
		@err = []
		@parserTk = []
		lexer(programa)
	end

	# Lexer
	# Recibe una cadena de caracteres que representa el programa
	def lexer programa
		programa = programa.split("")
		lexema = ""

		#Posicion en el programa
		fila = 1
		columna = 1
		i = 0
		#Procesamiento de cada uno de los lexemas
		while i < programa.length
			#comentarios
			c = programa[i]
			if c == "/" && programa[i+1] == "/"
				while c != "\n" && not(c.nil?)
					i = i + 1
					c = programa[i]
					columna += 1
				end
				fila += 1
				columna = 1
		
			#Strings
			elsif c == "\""
				ini_string = i
				if not(lexema.empty?)
					self.crearToken(lexema,fila,columna)
					lexema = ""
					columna += lexema.length + 1
				end	
				lexema << c
				i += 1
				c = programa[i]
				while c != "\"" && not(c.nil?)
					if c == "\\"
						lexema << c
						i += 1
						c = programa[i]
					end	
					lexema << c
					i += 1
					c = programa[i]

				end
				if not(c.nil?)
					lexema << c
				else
					lexema = "\""
					i = ini_string
				end	



			#Espacios en blancos
			elsif c == " "
				if not(lexema.empty?)
					self.crearToken(lexema,fila,columna)
				end
				columna += lexema.length + 1
				lexema = ""
			elsif c == "\n"	
				if not(lexema.empty?)
					self.crearToken(lexema,fila,columna)
				end
				fila += 1
				columna = 1
				lexema = ""
			#tabuladores
			elsif c == "\t"
				if not(lexema.empty?)
					self.crearToken(lexema,fila,columna)
				end
				columna += lexema.length + 8
				lexema = ""
						
		
			#Caracter especial concatenados
			elsif ((c == ".") && (programa[i+1] == ".") || (c == ":") && (programa[i+1] == "=") || (c == "|") && (programa[i+1] == "[") || (c == "]") && (programa[i+1] == "|") || (c == "\\") && (programa[i+1] == "/") || (c == "/") && (programa[i+1] == "\\") || (c == ">") && (programa[i+1] == "=") || (c == "<") && (programa[i+1] == "=")||(c == "=") && (programa[i+1] == "=") || (c == "!") && (programa[i+1] == "=") || (c == "|") && (programa[i+1] == "|") || (c == "[") && (programa[i+1] == "]"))
				if not(lexema.empty?)
					self.crearToken(lexema,fila,columna)
					columna += lexema.length
				end
				lexema = c
				lexema << programa[i+1]
				self.crearToken(lexema,fila,columna)
				columna += lexema.length 
				lexema = ""
				i += 1
			#Caracter "-->"
			elsif c == "-" && programa[i+1] == "-" && programa[i+2] == ">"
				if not(lexema.empty?)
					self.crearToken(lexema,fila,columna)
					columna += lexema.length
				end 
				lexema = "-->"
				self.crearToken(lexema,fila,columna)
				columna += lexema.length
				lexema = ""
				i += 2
			#numeros
			elsif not((c =~ $numero).nil?)
				if not((lexema =~ $identificador).nil?)
					lexema << c
				elsif not((lexema =~ $numero).nil?)
					lexema << c
				else
					if not(lexema.empty?)
						self.crearToken(lexema,fila,columna)
					end
					columna += lexema.length 
					lexema = ""
					lexema << c		
				end						
			#identificadores y palabras reservadas
			elsif not((c =~ $identificador).nil?)
				if not((lexema =~ $identificador).nil?)
					lexema << c
				else
					if not(lexema.empty?)
						self.crearToken(lexema,fila,columna)
						columna += lexema.length 
					end
					lexema = c
						
				end
			
			#otros caracteres y operadores	
			else
				if not(lexema.empty?)
						self.crearToken(lexema,fila,columna)
						columna += lexema.length 
				end
				lexema = ""
				lexema << c
				



			end

			#fin del programa
			if i == programa.length-1
				if not(lexema.empty?)
						self.crearToken(lexema,fila,columna)
				end
					
			end
			i += 1
		end	
		for token in tk
			if token.tipo == "TkNum" || token.tipo == "TkId" || token.tipo == "TkString" 
				@parserTk << [token.tipo,token]
			else
				@parserTk << [token.token,token]
			end
		end
	end

	
	#Funcion que crea token 
	def crearToken lexema,fila,columna
		tipo = ""
		tipo = $reservadas.fetch(lexema,nil)
		#Revisa que tipo de token es
		if tipo == nil
			if lexema =~ $string
				tipo = "TkString"
		
			elsif lexema =~ $numero
				tipo = "TkNum"

			elsif lexema =~ $identificador
				tipo = "TkId"		
			
			else
				tipo = "Tkerror"
			end	
		end

		tok = Token.new(lexema,tipo,fila,columna)
		if tok.tipo == "Tkerror"
			@err << tok	
		else
			@tk << tok

		end
	end

end	



	
