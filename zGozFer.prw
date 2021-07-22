/*{Protheus.doc} zGozFer 
@description Fornece uma tela em MVC para visualiza��o ou altera��o(adm) para Gozo de ferias

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
Static cTitulo  := "Gozo de F�rias  "
Static cDefault := "Gozo de F�rias "

User Function zGozFer()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	
    
    private cCadastro := "Gozo de F�rias"
    
    //Setando o nome da fun��o, para a fun��o customizada
    SetFunName("zGozFer")
    
    //Inst�nciando FWMBrowse, setando a tabela, a descri��o e ativando a navega��o
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZGF")
    oBrowse:SetMenuDef("zGozFer")
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

	   
            ADD  OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zGozFer" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
    	    ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zGozFer" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"	
	        ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zGozFer" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	        ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zGozFer" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"
     
Return (aRot)


Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZGF := FWFormStruct( nModel, "ZGF" )	

	

	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZGOZFER", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gozo das f�rias ")
	
	oModel:AddFields("FORMZGF",/*cOwner*/,oStZGF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZGF_FILIAL"  } ) //Chave primaria

	//Setando a descri��o do formul�rio pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZGF"):SetDescription("Formul�rio do Cadastro "+cCadastro)
	
	
	
Return(oModel)


Static Function ViewDef()

	Local aStruZZ1	:= ZGF->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZGOZFER") 
	Local oStruZGF := FWFormStruct( nView, "ZGF")

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZGF", oStruZGF, "FORMZGF")



	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZGF', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
