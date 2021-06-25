#Include "Protheus.ch"
#Include "FWMVCDef.ch"

User Function zRhMainM()

    Local aArea		:= GetArea()
    Local aParam     := PARAMIXB
	  Local xRet       := .T.
    Local cIdModel   := ''
   
    

    oObj     := aParam[1]
	cIdPonto := aParam[2]
	cIdModel := aParam[3]

 If cIdPonto == 'BUTTONBAR'

  

    xRet :=  {{'Salario', 'SALARIO', { || u_ExViewSA() }, 'Este botao inclui salario ' },;
             {'Funcao'  , 'FUNCAO',  { || u_ExViewFU() }, 'Este botao inclui Funcao  ' },;
             {'Exame'   , 'EXAME',   { || u_ExViewEX() }, 'Este botao inclui Exame   ' }}

            

 EndIf
   
            
     RestArea(aArea)


Return xRet


User Function ExViewSA()

	Private cCadastro   := ""
	
		FWExecView('','VIEWDEF.zHisSal1', MODEL_OPERATION_INSERT)
  

		

Return

User Function ExViewFU()

	Private cCadastro   := ""
	
		FWExecView('','VIEWDEF.zHisFun1', MODEL_OPERATION_INSERT)
		

Return

User Function ExViewEX()

  

	Private cCadastro   := ""
	
		FWExecView('','VIEWDEF.zHisExa1', MODEL_OPERATION_INSERT)


         
         FWFormView():Refresh([]) 
		
    
Return
