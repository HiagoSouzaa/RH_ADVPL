/*{Protheus.doc} zModel1 
@description Fornece uma tela em MVC para cadastro de Colaboradores

@author  	Hiago   
@return 	Undefinied

*/

#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'parmtype.ch'
#Include 'msobject.ch'
#include 'FWMBrowse.ch'
#Include "FWMVCDEF.CH"


//Vari�veis Est�ticas
Static cTitulo  := "Colaborador"
Static cDefault := "NOME DO COLABORADOR"

User Function zCadFun1()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	
    
    private cCadastro := "Colaborador"
    
    //Setando o nome da fun��o, para a fun��o customizada
    SetFunName("zCadFun1")
    
    //Inst�nciando FWMBrowse, setando a tabela, a descri��o e ativando a navega��o
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZCO")
    oBrowse:SetMenuDef("ZCADFUN1")
    oBrowse:SetDescription(cCadastro)
    oBrowse:DisableDetails()
    
    oBrowse:Activate()
             
    //Destr�i a classe      
    oBrowse:DeActivate()
    oBrowse:Destroy()
    
    //Voltando o nome da fun��o
    SetFunName(cFunBkp)
       
    FreeObj( oBrowse )    
    RestArea(aArea)
return

Static Function MenuDef()
	Local aRot		   := {}
	Local nAcessoTotal := 0	
	
	ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zCadFun1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"
	ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zCadFun1" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
	ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zCadFun1" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zCadFun1" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"
Return (aRot)

Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZCO := FWFormStruct( nModel, "ZCO" )	


	Default cCadastro := "Colaborador"
	

	//Innstaciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZCADFUN1", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gerenciamento de  Colaborador")
	
	oModel:AddFields("FORMZCO",/*cOwner*/,oStZCO, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZCO_FILIAL"  } ) //Chave primaria

	//Setando a descri��o do formul�rio pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZCO"):SetDescription("Formul�rio do Cadastro "+cCadastro)
	
	
	
Return(oModel)


Static Function ViewDef()

	Local aStruZZ1	:= ZCO->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZCADFUN1") 
	Local oStruZCO := FWFormStruct( nView, "ZCO" )

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZCO", oStruZCO, "FORMZCO")



	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZCO', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
