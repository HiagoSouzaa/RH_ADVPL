/*{Protheus.doc} zDirFer

@description Fornece uma tela em MVC para visualização ou alteração(adm) para Direito de ferias
@author  	Hiago   
@return 	Undefinied

*/


#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'parmtype.ch'
#Include 'msobject.ch'
#include 'FWMBrowse.ch'
#Include "FWMVCDEF.CH"


//Variáveis Estáticas
Static cTitulo  := "Direito de Férias "
Static cDefault := "Direito de Férias"

User Function zDirFer()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	Local nOffWaring := 1
	
    
    private cCadastro := "Direito de Férias"
    
    //Setando o nome da função, para a função customizada
    SetFunName("zDirFer")
    
    //Instânciando FWMBrowse, setando a tabela, a descrição e ativando a navegação
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZDF")
    oBrowse:SetMenuDef("zDirFer")
    oBrowse:SetDescription(cCadastro)
    oBrowse:DisableDetails()
    
    oBrowse:Activate()
             
    //Destrói a classe      
    oBrowse:DeActivate()
    oBrowse:Destroy()
    
    //Voltando o nome da função
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

	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZDIRFER", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Direito de férias")
	
	oModel:AddFields("FORMZDF",/*cOwner*/,oStZDF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZDF_FILIAL"  } ) //Chave primaria

	//Setando a descrição do formulário pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZDF"):SetDescription("Formulário do Cadastro "+cCadastro)
	
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

	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZDF', 'Dados - '+cTitulo )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
