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

	Local aAutSal := {}
	Local oModelAux := FWModelActive()

	private aRotina     := {}
	Private cCadastro   := ""
	Private oModel := StaticCall(zHisSal1, ModelDef)

        If Pergunte("ZRHMANSA", .T., "Incluir Salario",.T.)

		   aAdd(aAutSal, {"ZHS_FILIAL",fwFldGet("ZCO_FILIAL")    ,Nil})
 		   aAdd(aAutSal, {"ZHS_CPF"   ,fwFldGet("ZCO_CPF")       ,Nil})
	       aAdd(aAutSal, {"ZHS_DTREAJ" ,MV_PAR01                 ,Nil})
		   aAdd(aAutSal, {"ZHS_VLRREA" ,MV_PAR02                 ,Nil})
		   aAdd(aAutSal, {"ZHS_TPAUME", cValToChar(MV_PAR03)     ,Nil})
		   



		  FWMVCRotAuto(    oModel,;
                            "ZHS",;
                            MODEL_OPERATION_INSERT,;
                            {{"FORMZHS", aAutSal}}  )
		EndIf		

		oModelAux:DeActivate()
	    oModelaux:Activate()  			

Return

User Function ExViewFU()

	Local aAutFu := {}
	Local oModelAux := FWModelActive()

	private aRotina     := {}
	Private cCadastro   := ""
	Private oModel := StaticCall(zHisFun1, ModelDef)

        If Pergunte("ZRHMANFU", .T., "Incluir Função",.T.)

		   aAdd(aAutFu, {"ZHF_FILIAL" ,fwFldGet("ZCO_FILIAL")  ,Nil})
 		   aAdd(aAutFu, {"ZHF_CPF"    ,fwFldGet("ZCO_CPF")     ,Nil})
	       aAdd(aAutFu, {"ZHF_FUNCAO" ,MV_PAR01   			   ,Nil})
		   aAdd(aAutFu, {"ZHF_DTINI"  ,MV_PAR02                ,Nil})
		   
		   



		  FWMVCRotAuto(    oModel,;
                            "ZHF",;
                            MODEL_OPERATION_INSERT,;
                            {{"FORMZHF", aAutFu}}  )
		EndIf			

	oModelAux:DeActivate()
	oModelaux:Activate()			


Return

User Function ExViewEX()

	Local aAutExa := {}
	Local oModelAux := FWModelActive()

	private aRotina     := {}
	Private cCadastro   := ""
	private oModel := StaticCall(zHisExa1, ModelDef)


        If Pergunte("ZRHMANPE", .T., "Incluir Exame",.T.)

		   aAdd(aAutExa, {"ZHE_FILIAL",fwFldGet("ZCO_FILIAL")  ,Nil})
 		   aAdd(aAutExa, {"ZHE_CPF"   ,fwFldGet("ZCO_CPF")     ,Nil})
	       aAdd(aAutExa, {"ZHE_DTREA" ,MV_PAR02   			   ,Nil})
		   aAdd(aAutExa, {"ZHE_FREQU" ,MV_PAR03                ,Nil})
		   aAdd(aAutExa, {"ZHE_TPEXAM",MV_PAR01                ,Nil})
		   



		  FWMVCRotAuto(    oModel,;
                            "ZHE",;
                            MODEL_OPERATION_INSERT,;
                            {{"FORMZHE", aAutExa}}  )
		EndIf	

	//Atualiza a tela 
	oModelAux:DeActivate()
	oModelaux:Activate()

    
Return
