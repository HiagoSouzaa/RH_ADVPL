/*{Protheus.doc} Ponto de Entrada na funcao FunCol1
@description Ponto de entrada para não permitir o cadastro do salario do teto menor que o piso e não deixa
excluir função que tenha colaborador cadastrado
@author  	Hiago   
@return 	Undefinied
*/

#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'
#Include "FWMVCDEF.ch"

#define PE_OBJETO_FORM 		1 	//Objeto do formulário ou do modelo, conforme o caso
#define PE_ID_PONTO_EXEC	2   //ID do local de execução do ponto de entrada
#define PE_ID_FORM			3   //ID do formulário

User Function MZFUNCOL1() 

    Local aArea		:= GetArea()
    Local xRet 		:= .T.
	Local aParam    := PARAMIXB
	Local cIdPonto  := ''
	Local cIdModel  := ''
	Local nOpcao	:= 0
	Local oObj 		:= Nil

	private nExcluir  := 5
	

    If( aParam == NIL )
		
		RestArea(aArea)
		Return xRet
	Endif
	
	oObj 	 := aParam[PE_OBJETO_FORM  ]
 	cIdPonto := aParam[PE_ID_PONTO_EXEC]
 	cIdModel := aParam[PE_ID_FORM	   ] 	
	nOpcao   := oObj:GetOperation()
    
    If cIdPonto == 'MODELPOS'

		If nOpcao == nExcluir

			xRet := fVldDel()

        ElseIf fwFldGet("ZCF_VLPISO") > fwFldGet("ZCF_VLTETO")

            Help(NIL, NIL, "Piso Invalido ", NIL,"Valor do Piso não pode ser maior que o valor do teto " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Digite um valor do piso menor que o do teto "})
  
       	    xRet := .F.

        EndIf

    EndIf  

    RestArea(aArea)
Return xRet

Static Function fVldDel()


Local lOk := .T.

	If(!Empty(Alltrim(Posicione("ZHF",2,FwxFilial("ZHF")+fwfldGet("ZCF_ID"),"ZHF_FUNCAO" ))))
	 Help(NIL, NIL, "Não pode excluir ", NIL,"Tem colaboradores cadastrados nessa função " , 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apague o registro do colaborador que deseja excluir no historico de funcao"})
		Return !lOk
	EndIf

Return lOk 

