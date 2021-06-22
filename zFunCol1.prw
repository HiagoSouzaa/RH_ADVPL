
/*{Protheus.doc} zModel1 
@description Fornece uma tela em MVC para cadastro de Fun��o

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
Static cTitulo  := "Fun��o"
Static cDefault := "CADASTRO DE FUN��O"

User Function zFunCol1()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	
    
    private cCadastro := "Fun��o"
    
    //Setando o nome da fun��o, para a fun��o customizada
    SetFunName("zFunCol1")
    
    //Inst�nciando FWMBrowse, setando a tabela, a descri��o e ativando a navega��o
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZCF")
    oBrowse:SetMenuDef("zFunCol1")
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
	
	ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"
	ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
	ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"

Return (aRot)

Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZCF := FWFormStruct( nModel, "ZCF" )	

	

	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZFUNCOL1", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gerenciamento de  Fun��o")
	
	oModel:AddFields("FORMZCF",/*cOwner*/,oStZCF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZCF_FILIAL"  } ) //Chave primaria

	//Setando a descri��o do formul�rio pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZCF"):SetDescription("Formul�rio do Cadastro "+cCadastro)
	
	
	
Return(oModel)


Static Function ViewDef()

	Local aStruZZ1	:= ZCF->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZFUNCOL1") 
	Local oStruZCF := FWFormStruct( nView, "ZCF" )

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZCF", oStruZCF, "FORMZCF")



	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZCF', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
