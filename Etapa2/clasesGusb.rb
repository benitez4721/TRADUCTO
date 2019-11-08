# Autores: Marco Benitez 13-10137
#          Orlando Chaparro 12-11499

# -- Descripcion --
#
# Archivo que contiene todas las clases que representan al
# Arbol Sintactico Abstracto (AST)


# -- Clase Programa --
#
# Representa el nodo de la estructura principal programa
class Programa

	# -- Atributos --
	# 
	# cuerpo : contiene el cuerpo del programa
	attr_accessor :cuerpo

	def initialize(cuerpo)
		@cuerpo = cuerpo
	end

	# -- Funcion de impresion --
	# Imprime una de las siguientes estructuras:
	#
	# Block			|	Block
	#    <CUERPO>	|	

	# def <CUERPO> en clase Cuerpo.
	def to_s()
		s = ""
		if @cuerpo != nil
			s << @cuerpo.to_s(0) + "\n"

		else
			s = "Block"
		end
		return s
	end

end

# -- Class Cuerpo --
#
# Representa el nodo del cuerpo de un programa
class Cuerpo

	# -- Atributos --
	#
	# l_declaraciones : contiene una lista de declaraciones
	# l_instrucciones : contiene una lista de instrucciones
	attr_accessor :l_declaraciones, :l_instrucciones

	def initialize(l_declaraciones,l_instrucciones)
		@l_declaraciones = l_declaraciones
		@l_instrucciones = l_instrucciones
	end

	# -- Funcion de impresion --
	# Imprime una de las siguientes estructuras:
	#
	# Block						|	Block				
	#  Declare					|	 <INSTRUCTION_LIST>
	#   <DECLARE_LIST>			|	  
	#  <INSTRUCTION_LIST> 	    |	
	#   	                    |		
	# 
	#
	# def <DECLARE_LIST> en clase ListaDeclaracion.
	# def <INSTRUCTION_LIST> en clase Instrucciones.
	def to_s(tab)
		s = (" "*tab) + "Block\n"
		if @l_declaraciones != nil
			s << (" "*(tab+1))+"Declare\n" + @l_declaraciones.to_s(tab+1) + @l_instrucciones.to_s(tab+2)

		elsif
			s << @l_instrucciones.to_s(tab+1)
		end

		return s
	end

end

# -- Clase ListaDeclaracion --
#
# Representa el nodo de una lista de declaraciones
class ListaDeclaracion

	# -- Atributos --
	#
	# l_declaraciones : contiene una lista de declaraciones
	# declaracion     : contiene una declaracion
	attr_accessor :l_declaraciones, :declaracion

	def initialize(l_declaraciones,declaracion)
		@l_declaraciones = l_declaraciones
		@declaracion = declaracion
	end

	# -- Funcion de impresion --
	# Imprime una estructura de la forma:
	#
	# Declare
	#    .    
	#    .    
	#    .    
	# 
	#
	# def <DECLARE> en clase Declaracion.
	def to_s(tab)
		s = ""
		if @l_declaraciones != nil
			s << @l_declaraciones.to_s(tab) + (" "*(tab+1))+"Sequencing\n" + @declaracion.to_s(tab+1) 

		else
			s << @declaracion.to_s(tab)
		end

		return s
	end

end

# -- Clase Declaracion --
#
# Representa el nodo de una declaracion
class Declaracion


	attr_accessor :tipo, :l_identificadores, :asignacion

	def initialize(l_identificadores,sequencing)
		@l_identificadores = l_identificadores
		@sequencing = sequencing
	end

	# -- Funcion de impresion --
	# Imprime una de las siguientes estructuras:
	#
	# Declare                       |	Declare
	#  <LISTA_IDENTIFICADORES>      |	  <LISTA_IDENTIFICADORES>
	#   sequencing
	#
	# def <LISTA_IDENTIFICADORES> en clase ListaId.
	def to_s(tab)
		s = ""
		if @l_identificadores != nil
			s <<  @l_identificadores.to_s(tab+1)
		else
			s << @l_identificadores.to_s(tab+1)
		end

		return s
	end

end

# -- Clase ListaId -- 
#
# Representa el nodo de una lista de identificadores
class ListaId

	# -- Atributos --
	#
	# lista_identificador : contiene una lista de identificadores
	# identificador       : contiene un identificador 
	attr_accessor :lista_identificador, :identificador

	def initialize(lista_identificador,identificador)
		@lista_identificador = lista_identificador
		@identificador = identificador
	end

	# -- Funcion de impresion --
	# Imprime una estructura de la forma:
	#
	# <IDENTIFICADOR>
	#        .
	#        .
	#        .
	# <IDENTIFICADOR>
	#
	# def <IDENTIFICADOR> en clase Identificador.
	def to_s(tab)
		s = ""
		if @lista_identificador != nil
			s << @lista_identificador.to_s(tab) + @identificador.to_s(tab)

		else
			s << @identificador.to_s(tab)
		end

		return s
	end

end
# -- Clase Identificador --
#
# Representa el nodo de un identificador
class Identificador

	# -- Atributos --
	#
	# id       : contiene un identificador

	attr_accessor :id

	def initialize(id)
		@id = id
		
	end

	# -- Funcion de impresion --
	# Imprime una de las siguientes estructuras:
	#
	# ident: id		
	#
	def to_s(tab)
		
		return (" "*tab) + "ident: " + @id.to_s() + "\n"
		
		
	end

end

# -- Clase Instrucciones --
#
# Representa el nodo de una lista de instrucciones
class Instrucciones

	# -- Atributos --
	#
	# instrucciones : contiene una lista de instrucciones
	# instruccion   : contiene una instruccion
	attr_accessor :instrucciones, :instruccion

	def initialize(instrucciones,instruccion)
		@instrucciones = instrucciones
		@instruccion = instruccion
	end

	# -- Funcion de impresion --
	# Imprime una estructura de la forma:
	# 
	# <INSTRUCTION>
	#       .
	#       .
	#       .	      
	# <INSTRUCTION>
	#
	# def <INSTRUCTION> en clase Instruccion.
	def to_s(tab)
		s = ""
		if @instrucciones != nil
			s << @instrucciones.to_s(tab) + (" "*(tab))+"Sequencing\n" + @instruccion.to_s(tab+1)
		
		else
			s << @instruccion.to_s(tab)
		end

		return s
	end

end


# -- Clase Instruccion --
#
# Representa el nodo de una instruccion
class Instruccion

	# -- Atributos --
	#
	# instruccion : contiene una instruccion
	attr_accessor :instruccion

	def initialize(instruccion)
		@instruccion = instruccion
	end


	def to_s(tab)
		s = ""
		s << @instruccion.to_s(tab)
		return s
	end

end

# -- Clase Asignacion
#
# Representa el nodo de una asignacion
class Asignacion

	# -- Atributos --
	#
	# identificador : contiene un identificador
	# expresion     : contiene una expresion
	attr_accessor :identificador, :expresion

	def initialize(identificador,expresion)
		@identificador = identificador
		@expresion = expresion
	end

	def to_s(tab) 
		return (" "*tab) + "Asig\n " + @identificador.to_s(tab) + (" "*(tab+1)) + "Exp\n" + @expresion.to_s(tab+2) 
	end
end

# -- Clase Entrada --
#
# Representa el nodo de la entrada estandar
class Entrada

	# -- Atributos --
	#
	# identificador : contiene un identficador
	attr_accessor :identificador

	def initialize(identificador)
		@identificador = identificador
	end

	def to_s(tab)
		return (" "*tab) + "Read\n" + @identificador.to_s(tab+1)
	end

end

# -- Clase Salida --
#
# Representa el nodo de la salida estandar
class Salida

	# -- Atributos --
	#
	# l_imprimir : contiene una lista de identificador a imprimir
	# salto      : contiene si debe imprimir o no un salto
	attr_accessor :l_imprimir, :salto

	def initialize(l_imprimir,salto)
		@l_imprimir = l_imprimir
		@salto = salto
	end

	def to_s(tab)
		if @salto == "SALTO"
			return (" "*tab) + "Println\n" + @l_imprimir.to_s(tab+1) 

		else
			return (" "*tab) + "Print\n" + @l_imprimir.to_s(tab+1)
		end
	end 

end

class Imprimir

	# -- Atributos --
	#
	# lista_impresion : contiene una lista de impresion
	# impresion       : contiene un elemento a imprimir
	attr_accessor :lista_impresion, :impresion

	def initialize(lista_impresion,impresion)
		@lista_impresion = lista_impresion
		@impresion = impresion
	end

	def to_s(tab)
		s = ""
		if @lista_impresion != nil
			s << (" "*(tab))+"Concat\n" + @lista_impresion.to_s(tab+1) + @impresion.to_s(tab+1)

		else
			s << @impresion.to_s(tab)
		end
		return s
	end

end

# -- Clase String --
#
# Representa el nodo de un string
class Str

	attr_accessor :string

	def initialize(string)
		@string = string
	end

	# -- Funcion de impresion --
	def to_s(tab)
		return (" "*tab) + @string.to_s() + "\n"
	end

end

class Condicional

	attr_accessor :condicion, :lista_instrucciones1, :lista_instrucciones2

	def initialize(condicion,lista_instrucciones1,lista_instrucciones2)
		@condicion = condicion
		@lista_instrucciones1 = lista_instrucciones1
		@lista_instrucciones2 = lista_instrucciones2
	end

	# -- Funcion de impresion --
	def to_s(tab)
		s =(" "*(tab)) + "If\n"
		if @lista_instrucciones2 != nil
			s << (" "*(tab+1)) + "Guard\n" +(" "*(tab+2)) + "Exp\n" +  @condicion.to_s(tab+3) + @lista_instrucciones1.to_s(tab+2) + @lista_instrucciones2.to_s(tab+1)

		else
			s << (" "*(tab+1)) + "Guard\n" +(" "*(tab+2)) + "Exp\n"+ @condicion.to_s(tab+3) + @lista_instrucciones1.to_s(tab+2)
		end

		return s
	end

end

class IteradorFor

	attr_accessor :id, :exp1, :exp2, :cuerpo

	def initialize(id,exp1,exp2,cuerpo)
		@id = id
		@exp1 = exp1
		@exp2 = exp2
		@cuerpo = cuerpo
	end

	# -- Funcion de impresion --
	def to_s(tab)
		s = (" "*tab) + "For\n"
		s << (" "*(tab+1)) + "In\n" + @id.to_s(tab+2) +(" "*(tab+2))+"Exp\n" + @exp1.to_s(tab+3) +(" "*(tab+2))+"Exp\n" + @exp2.to_s(tab+3) + @cuerpo.to_s(tab+1)
		return s
	end

end

class IteratorDo

	attr_accessor :condicion, :lista_instrucciones1, :lista_instrucciones2

	def initialize(condicion,lista_instrucciones1,lista_instrucciones2)
		@condicion = condicion
		@lista_instrucciones1 = lista_instrucciones1
		@lista_instrucciones2 = lista_instrucciones2
	end

	# -- Funcion de impresion --
	def to_s(tab)
		s =(" "*(tab)) + "Do\n"
		if @lista_instrucciones2 != nil
			s << (" "*(tab+1)) + "Guard\n" +(" "*(tab+2)) + "Exp\n" +  @condicion.to_s(tab+3) + @lista_instrucciones1.to_s(tab+2) + @lista_instrucciones2.to_s(tab+1)

		else
			s << (" "*(tab+1)) + "Guard\n" +(" "*(tab+2)) + "Exp\n"+ @condicion.to_s(tab+3) + @lista_instrucciones1.to_s(tab+2)
		end

		return s
	end

end

class Guardia

	attr_accessor :condicion, :lista_instrucciones1, :lista_instrucciones2

	def initialize(condicion,lista_instrucciones1,lista_instrucciones2)
		@condicion = condicion
		@lista_instrucciones1 = lista_instrucciones1
		@lista_instrucciones2 = lista_instrucciones2
	end

	#-- Funcion de impresion --
	def to_s(tab)
		s = ""
		if @lista_instrucciones2 != nil
			s << (" "*tab) +"Guard\n" +(" "*(tab+1)) + "Exp\n"+ @condicion.to_s(tab+2) + @lista_instrucciones1.to_s(tab+1) + @lista_instrucciones2.to_s(tab)
		else
			s << (" "*tab) +"Guard\n" +(" "*(tab+1)) + "Exp\n"+ @condicion.to_s(tab+2) + @lista_instrucciones1.to_s(tab+1)
		end
		
		return s
	end
end

class ListArrayAsig
	
	attr_accessor :identificador, :exp1, :exp2, :lista_exp

	def initialize(identificador,exp1,exp2,lista_exp) 
		@exp1 = exp1
		@exp2 = exp2
		@lista_exp = lista_exp
	end
	
	def to_s(tab,id)
		s =""
		if @lista_exp != nil
			s << (" "*tab) + "ArrayAsig\n" + lista_exp.to_s(tab+1,id) + @exp1.to_s(tab) + @exp2.to_s(tab)  
		else
			s << id.to_s(tab)+ @exp1.to_s(tab) + @exp2.to_s(tab) 
		end
		
		return s
	end	
end			

class ArrayAsig
	
	attr_accessor :Identificador, :ListArrayAsig

	def initialize(identificador,listArrayAsig)
		@identificador = identificador
		@listArrayAsig = listArrayAsig
	end
	
	def to_s(tab)
		
		return (" "*tab) +"ArrayAsig\n" + @listArrayAsig.to_s(tab+1,@identificador)
	end
end	

class ArrayConsult

	attr_accessor :identificador, :exp

	def initialize(identificador,exp)
		@identificador = identificador
		@exp = exp
	end
	
	def to_s(tab)
		
		return (" "*tab) +"EvalArray\n" + @identificador.to_s(tab+1) + (" "*(tab+1)) +"Exp\n"+ @exp.to_s(tab+2)
	end
end			

class Literal

	attr_accessor :valor, :tipo

	def initialize(valor,tipo)
		@valor = valor
		@tipo = tipo
	end

	# -- Funcion de impresion --
	# Imprime una estructura de la forma:
	def to_s(tab)
		return (" "*tab) + "Literal " + ": " + @valor.to_s() + "\n"
	end

end

class Conversion

	attr_accessor :op, :identificador

	def initialize(op,identificador)
		@op = op
		@identificador = identificador
	end
	
	#Funcion de impresion
	def to_s(tab)
		return (" "*tab) + @op.to_s() + @identificador.to_s(tab+1)
	end	
end

class Min < Conversion

	def initialize(identificador)
		super("Min\n",identificador)
	end
end	

class Max < Conversion

	def initialize(identificador)
		super("Max\n",identificador)
	end
end

class Atoi < Conversion

	def initialize(identificador)
		super("Atoi\n",identificador)
	end
end

class Size < Conversion

	def initialize(identificador)
		super("Size\n",identificador)
	end
end


class LiteralNumerico < Literal

	def initialize(valor)
		super(valor,"int")
	end

end

class LiteralBooleano < Literal

	def initialize(valor)
		super(valor,"bool")
	end

end

class ExpresionBinaria

	attr_accessor :oper1, :op, :oper2

	def initialize(oper1,op,oper2)
		@oper1 = oper1
		@op = op
		@oper2 = oper2
	end

	# -- Funcion de impresion --
	# Imprime una estructura de la forma:
	def to_s(tab) 
		return (" "*tab) + @op.to_s + "\n" + @oper1.to_s(tab+1) + @oper2.to_s(tab+1)
	end

end

class OpSuma < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Plus",oper2)
	end

end

class OpResta < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Minus",oper2)
	end

end

class OpMultiplicacion < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Mult",oper2)
	end

end

class OpDivisionE < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Div",oper2)
	end

end

class OpModE < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Mod",oper2)
	end

end

class OpEquivalente < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Equal",oper2)
	end

end

class OpDesigual < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Nequal",oper2)
	end

end

class OpMayorIgual < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Geq",oper2)
	end

end

class OpMenorIgual < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Leq",oper2)
	end

end

class OpMenor < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Less",oper2)
	end

end

class OpMayor < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Greater",oper2)
	end

end

class OpAnd < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"And",oper2)
	end

end

class OpOr < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"Or",oper2)
	end

end

class ExpresionUnaria

	# -- Atributos -- 
	# 
	# op : operador
	# oper : operando
	attr_accessor :op, :oper

	def initialize(op,oper)
		@op = op
		@oper = oper
	end

	# -- Funcion de impresion --
	def to_s(tab) 
		return (" "*tab) + @op.to_s() +"\n"+ @oper.to_s(tab+1)  
	end

end

class OpExclamacion < ExpresionUnaria

	def initialize(op)
		super("Not",op)
	end

end

class OpUMINUS < ExpresionUnaria

	def initialize(op)
		super("Uminus",op)
	end

end

class OpComa < ExpresionBinaria

	def initialize(oper1,oper2)
		super(oper1,"ArrayInit",oper2)
	end
end