/*{Protheus.doc} zDirFer

@description Fornece uma tela em MVC para visualiza��o ou altera��o(adm) para Direito de ferias
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
Static cTitulo  := "Direito de F�rias "
Static cDefault := "Direito de F�rias"

User Function zDirFer()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	Local nOffWaring := 1
	
    
    private cCadastro := "Direito de F�rias"
    
    //Setando o nome da fun��o, para a fun��o customizada
    SetFunName("zDirFer")
    
    //Inst�nciando FWMBrowse, setando a tabela, a descri��o e ativando a navega��o
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZDF")
    oBrowse:SetMenuDef("zDirFer")
    oBrowse:SetDescription(cCadastro)
    oBrowse:DisableDetails()
    
    oBrowse:Activate()
             
    //Destr�i a classe      
    oBrowse:DeActivate()
    oBrowse:Destroy()
    
    //Voltando o nome da fun��o
    SetFunName(cFunBkp)

	If( nOffWaring == 0 )
		MenuDef()
		ModelDef()
		ViewDef()
	EndIf

    FreeObj( oBrowse )    
    RestArea(aArea)
return

Static Function MenuDef()
	Local aRot		   := {}
	Local nAcessoTotal := 0

	 If  FWIsAdmin()
			ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zDirFer" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"
	 EndIf
            ADD  OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zDirFer" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
    	    ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zDirFer" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"	
	        ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zDirFer" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	        
			
Return (aRot)


Static Function ModelDef()

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZDF := FWFormStruct( nModel, "ZDF" )	

	//Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZDIRFER", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Direito de f�rias")
	
	oModel:AddFields("FORMZDF",/*cOwner*/,oStZDF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZDF_FILIAL"  } ) //Chave primaria

	//Setando a descri��o do formul�rio pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZDF"):SetDescription("Formul�rio do Cadastro "+cCadastro)
	
Return(oModel)


Static Function ViewDef()

	Local aStruZZ1	:= ZDF->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZDIRFER") 
	Local oStruZDF := FWFormStruct( nView, "ZDF")

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZDF", oStruZDF, "FORMZDF")

	//Colocando t�tulo do formul�rio
	oView:EnableTitleView('VIEW_ZDF', 'Dados - '+cTitulo )  
	
	//For�a o fechamento da janela na confirma��o
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
