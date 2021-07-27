/*{Protheus.doc} zHisSal1 
@description Fornece uma tela em MVC para Historico de Salario 

@author  	Hiago   
@return 	Undefinied

*/

#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'parmtype.ch'
#Include 'msobject.ch'
#include 'FWMBrowse.ch'
#Include "FWMVCDEF.CH"



Static cTitulo  := "Historico da salario"
Static cDefault := "Historico DE SALARIO"

User Function zHisSal1()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	Local nOffWaring := 1
	
    
    private cCadastro := "Historico de Salario"
    
    //Setando o nome da função, para a função customizada
    SetFunName("zHisSal1")
    
    //Instânciando FWMBrowse, setando a tabela, a descrição e ativando a navegação
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZHS")
    oBrowse:SetMenuDef("zHisSal1")
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

    	    ADD OPTION aRot TITLE "Incluir"    			   ACTION "VIEWDEF.zHisSal1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"	
	        ADD OPTION aRot TITLE "Aumento dissidio"	   ACTION "u_zAutDiss" 	   OPERATION 6 ACCESS nAcessoTotal 
			ADD  OPTION aRot TITLE "Visualizar" 		   ACTION "VIEWDEF.zHisSal1" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
			ADD OPTION aRot TITLE "Excluir"	   				ACTION "VIEWDEF.zHisSal1" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	       
       If  FWIsAdmin()

    	  ADD OPTION aRot TITLE "Alterar"	    			ACTION "VIEWDEF.zHisSal1"  OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"
      EndIf

Return (aRot)


Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZHS := FWFormStruct( nModel, "ZHS" )	

	

	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZHISSAL1", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gerenciamento de  Função")
	
	oModel:AddFields("FORMZHS",/*cOwner*/,oStZHS, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZHS_FILIAL"  } ) //Chave primaria

	//Setando a descrição do formulário pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZHS"):SetDescription("Formulário do Cadastro "+cCadastro)
	
	
	
Return(oModel)


Static Function ViewDef()

	Local aStruZHS  := ZHS->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZHISSAL1") 
	Local oStruZHS := FWFormStruct( nView, "ZHS")

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZHS", oStruZHS, "FORMZHS")



	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZHS', 'Dados - '+cTitulo )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
