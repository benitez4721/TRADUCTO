# Autores: Marco Benitez 13-10137
#          Orlando Chaparro 12-11499
#
# -- Descripcion -- 
#
# Programa main para la interpretacion del lenguaje GuardedUsb


require_relative 'lexer'
require_relative 'parserGusb'


#--MAIN--
def main
	ARGV[0] =~ /\w+\.gusb/
	if $&.nil?
		puts $&.nil?
		puts "Extension desconocida en el programa de entrada. Debe ser de la forma .gusb"
		return
	end
	begin
		File::read(ARGV[0])
	rescue
		puts "Archivo no encontrado. Debe ser de la forma .gusb"
	end

	# Leer file y almacenarlo
	programa = ""
	File.foreach(ARGV[0]) do |line|
		programa = programa + line
	end

	lex = Lexer.new(programa)
	#impresion de tokens
	if lex.err.length > 0
		lex.err.each do |error|
			puts "Error: Unexpected character #{error.token} in row #{error.fila}, colum #{error.columna} "
			return
		end			
						
	end
	#for token in lex.parserTk
	#	puts ("#{token[0]}")
	#end	
	pars = ParserGusb.new(lex.parserTk)
	ast = pars.parse
	puts ast.to_s()
end	

main				