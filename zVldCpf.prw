/*{Protheus.doc} zVldCpf

@description funcao que inibe o usuario de tentar cadastrar CPF com numeros igual 

@author  	Hiago   


*/
#Include 'protheus.ch'



User Function zVldCpf(cCpf)

    
     Local lRet := .T.    

     If ( cCpf $ "00000000000" .OR.; 
          cCpf $ "11111111111" .OR.; 
          cCpf $ "22222222222" .OR.; 
          cCpf $ "33333333333" .OR.; 
          cCpf $ "44444444444" .OR.; 
          cCpf $ "55555555555" .OR.; 
          cCpf $ "66666666666" .OR.; 
          cCpf $ "77777777777" .OR.; 
          cCpf $ "88888888888" .OR.; 
          cCpf $ "99999999999"     )

         lRet := .F.

         Help(NIL, NIL, "CPF invalido ", NIL,"cpf invalido :" +  cCpf, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Digite um CPF válido"})
     EndIf

Return  lRet                                                         


      