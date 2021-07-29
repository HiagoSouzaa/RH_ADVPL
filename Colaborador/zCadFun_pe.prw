
/*{Protheus.doc} zCadFun_pe 

@description Ponto de entrada que não permite a exclusam de colaborador com algum histórico,
			 Permite alterar o cargo do colaborador colocando o dia desejado e o cargo

@author  	Hiago   
*/

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'
#Include "FWMVCDEF.ch"

#define PE_OBJETO_FORM 		1 	//Objeto do formulário ou do modelo, conforme o caso
#define PE_ID_PONTO_EXEC	2   //ID do local de execução do ponto de entrada
#define PE_ID_FORM			3   //ID do formulário

Static cFunOld	:= ""

User Function MZCADFUN1() 


    Local aArea		:= GetArea()
    Local xRet 		:= .T.
	Local aParam    := PARAMIXB
	Local cIdPonto  := ''
	Local cIdModel  := ''
	Local nOpcao	:= 0
	Local oObj 		:= Nil
   
    private nInclui   := 3
    private nAltera   := 4
	private nExcluir  := 5 

    If( aParam == NIL )
		
		RestArea(aArea)
		Return xRet
	Endif
	
	oObj 	 := aParam[PE_OBJETO_FORM  ]
 	cIdPonto := aParam[PE_ID_PONTO_EXEC]
 	cIdModel := aParam[PE_ID_FORM	   ] 	
	nOpcao   := oObj:GetOperation()
    
	

	if cIdPonto == 'MODELPOS'

	  		cFunOld := ZCO->ZCO_FUNCAO

			If nOpcao == nExcluir	

					xRet := fVldDelet()

			endif
			
	ElseIf cIdPonto == 'MODELCOMMITTTS'

			If nOpcao == nInclui 

					xRet := fIncluiHistFun(nInclui)

			ElseIf nOpcao == nAltera .And. cFunOld != fwfldGet("ZCO_FUNCAO") 

					xRet := fIncluiHistFun(nAltera)


			EndIf 

    EndIf  

    RestArea(aArea)

Return xRet

Static Function fIncluiHistFun(nOpcao)

	Local aHistfun := {}
	Local aArea    := GetArea()
	Local dDate    :=  fwfldGet("ZCO_DTADMI")

	Private oModel      := StaticCall(zHisFun1, ModelDef)
	private lMsErroAuto := .F.
	private aRotina     := {}

	If  ( nOpcao == nAltera .Or. SuperGetMv("MV_X_COANT")) .And. Pergunte("MZCADFUN1", .T., "Alteração da Função",.T.) 

		dDate := MV_PAR01

	EndIf

	aAdd(aHistfun, {"ZHF_FILIAL", fwfldGet("ZCO_FILIAL") , Nil})
	aAdd(aHistfun, {"ZHF_CPF", fwfldGet("ZCO_CPF") , Nil})
	aAdd(aHistfun, {"ZHF_FUNCAO", fwfldGet("ZCO_FUNCAO"), Nil})
	aAdd(aHistfun, {"ZHF_DTINI",  dDate, Nil})

	FWMVCRotAuto(	oModel,;                        //Model
					"ZHF",;                         //Alias
					MODEL_OPERATION_INSERT,;        //Operacao
					{{"FORMZHF", aHistfun}})        //Dados
 	
	 If lMsErroAuto

	 	MostraErro()
	 
	EndIf

	RestArea(aArea)

Return !lMsErroAuto

Static Function fVldDelet()


Local lOk := .T.

/*	If (!Empty(Alltrim(Posicione("ZHF",1,FwxFilial("ZHF")+fwfldGet("ZCO_CPF"),"ZHF_CPF" ))))

		 Help(NIL, NIL, "Não pode excluir ", NIL,"Colaborador tem registro no historico de funcão " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de função"})
		Return !lOk
	EndIf
*/
	If(!Empty(Alltrim(Posicione("ZHS",1,FwxFilial("ZHS")+fwfldGet("ZCO_CPF"),"ZHS_CPF" ))))
	 	Help(NIL, NIL, "Não pode excluir ", NIL,"Colaborador tem registro no historico de salario " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de salario"})
		Return !lOk
	EndIf	

	If(!Empty(Alltrim(Posicione("ZHF",1,FwxFilial("ZHF")+fwfldGet("ZCO_CPF"),"ZHF_CPF" ))))
	 	Help(NIL, NIL, "Não pode excluir ", NIL,"Colaborador tem registro no historico de função " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de função"})
		Return !lOk
	EndIf	

	If(!Empty(Alltrim(Posicione("ZHE",1,FwxFilial("ZHE")+fwfldGet("ZCO_CPF"),"ZHE_CPF" ))))
	 	Help(NIL, NIL, "Não pode excluir ", NIL,"Colaborador tem registro no historico de exames " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de exame"})
		Return !lOk
	EndIf	

	If(!Empty(Alltrim(Posicione("ZDF",1,FwxFilial("ZDF")+fwfldGet("ZCO_CPF"),"ZDF_CPF" ))))
	 	Help(NIL, NIL, "Não pode excluir ", NIL,"Colaborador tem registro no direito de férias " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de direito de ferias"})
		Return !lOk
	EndIf	

	If(!Empty(Alltrim(Posicione("ZGF",1,FwxFilial("ZGF")+fwfldGet("ZCO_CPF"),"ZGF_CPF" ))))
	 	Help(NIL, NIL, "Não pode excluir ", NIL,"Colaborador tem registro no gozo de férias " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de gozo de ferias"})
		Return !lOk
	EndIf	
	
Return lOk 
