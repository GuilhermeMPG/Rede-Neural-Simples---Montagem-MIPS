		.data
		# Arreys declarados
		theArrey1:
				.space 40
		theArrey2:
				.space 40
		#floats ultlizados
		peso1: .float -1.0
		peso2: .float 1.0000
		taxadeaprendizado: .float 0.05
		erro:.float 0.0
		saidadoneuronio: .float 0.0
		entradaxp1: .float 0.0
		entradaxp2: .float 0.0
		auxiliar: .float 1.0
		auxiliar2: .float 0.0
		# menasgens que irao ser exibidas no lable IMPRIMIR
		mensagem1: .asciiz " A rede neural irá calcular a soma de  numeros iguais \n"
		mensagem2: .asciiz " + "
		mensagem3: .asciiz " = "
		mensagem4: .asciiz "\n"
		
	


		.text
		main:
			addi $t0,$zero,10# limite flag do for
			addi $t1,$zero,0 # flag do for
			addi $t4,$zero,0 #valor n para determinar a posição do vertor
			#carregando os floasts para os registradores
			lwc1 $f1, peso1
			lwc1 $f2, peso2
			lwc1 $f3, taxadeaprendizado
			lwc1 $f4, erro
			lwc1 $f5, saidadoneuronio
			lwc1 $f6, entradaxp1
			lwc1 $f7, entradaxp2
			lwc1 $f8, auxiliar
			lwc1 $f13, auxiliar2
			
	
			
			FOR: 
				# adicionando a valores aos vetores
				blt $t0,$t1,ZERAR
				add.s  $f9,$f9,$f8
				swc1 $f9,theArrey1($t4)
				swc1 $f9,theArrey2($t4)
				addi $t4,$t4,4
				addi $t1,$t1,1
				j FOR
			ZERAR:
				# zerando alguns valores nos registradores
				addi $t0,$zero,-1
				addi $t1,$zero,0 
				addi $t4,$zero,0 
				addi $s4,$zero,0
			WHILE:
				addi $t0,$t0,1
				slti $t1,$t0,1 # numero de epocas desejadas
				beqz $t1,IMPRIMIR
				FOR2:
					slti $t5,$t4,4 # numero de interações desejadas
					beqz $t5,WHILE
					#carregando Arreys para determinados resgistradores
					lwc1 $f9,theArrey1($s4)
					lwc1 $f10,theArrey1($s4)
					add.s $f11,$f9,$f10	#saida desejada				
					mul.s $f6,$f1,$f9 #multiplicação do peso1 X entrada
					mul.s $f7,$f2,$f10 #multiplicação do peso2 X entrada
					add.s $f5,$f6,$f7 #saida do neuronio 
					sub.s $f4,$f11,$f5 #calculo do erro
					# calculo do novo peso1
					add.s $f8,$f13,$f1 #salavando valor inicial do peso em outro resgistrador
					mul.s $f1,$f4,$f3 # multiplicando erro X taxa de aprendizado 
					mul.s $f1,$f1,$f9 # resulatado da taxa de aprendizado e erro X valor da entrada
					add.s $f1,$f1,$f8 # somando o resultado anterior com o valor inicial do peso
					# calculo do novo peso2
					add.s $f8,$f13,$f2 #salavando valor inicial do peso em outro resgistrador
					mul.s $f2,$f4,$f3 # multiplicando erro X taxa de aprendizado
					mul.s $f2,$f2,$f10 # resulatado da taxa de aprendizado e erro X valor da entrada
					add.s $f2,$f2,$f8 # somando o resultado anterior com o valor inicial do peso
					addi $s4,$s4,4 #adicionado valor para alterar o carregamento da entrada para outro espaço no Array
					addi $t4,$t4,1 # adicionado valor ao flag
					j FOR2
					
					
					
					
					
					
			IMPRIMIR:
		#zerando valores iniciais
		addi $t4,$zero,0
		addi $s4,$zero,0
		addi $v0,$zero,4
		#exibindo a primeira mensagem 
		la $a0, mensagem1
		syscall
		FOR3:
			 
			slti $t5,$t4,10 # flag do FOR3
			beqz $t5,END
			#carregando valor de entrada 
			lwc1 $f9,theArrey1($s4) 
			lwc1 $f10,theArrey1($s4)
			
			#imprimindo valaor de entrada
			add.s $f12,$f13,$f9
			addi $v0,$zero,2
			syscall	
			# imprimindo sinal de +
			addi $v0,$zero,4
			la $a0, mensagem2
			syscall 
			#imprimindo o segundo valor de entrada para a soma			
			add.s $f12,$f13,$f10
			addi $v0,$zero,2
			syscall	
			#imprimindo sinal de =
			addi $v0,$zero,4
			la $a0, mensagem3
			syscall 
			# calcculando resultado das somas usando os valores de peso encontrado apos o treinamento da rede neural
			mul.s $f6,$f1,$f9 #multiplicação do peso1 X entrada
			mul.s $f7,$f2,$f10 #multiplicação do peso2 X entrada
			add.s $f5,$f6,$f7 #saida do neuronio
			#imprimindo resultado
			add.s $f12,$f13,$f5
			addi $v0,$zero,2
			syscall	
			# imprimindo santo de linha \n
			addi $v0,$zero,4
			la $a0, mensagem4
			syscall
			
			addi $s4,$s4,4 #adicionado valor para alterar o carregamento da entrada para outro espaço no Array
			addi $t4,$t4,1 # adicionado valor ao flag 
			
			j FOR3
			
	END:	

		jr $ra
