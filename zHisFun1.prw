/*{Protheus.doc} zHisExa1 
@description Fornece uma tela em MVC para visualização ou alteração(adm) para historico de Função 

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
Static cTitulo  := "Historico da Função"
Static cDefault := "Historico DE FUNÇÃO"

User Function zHisFun1()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	Local nOffWaring := 1
	
    
    private cCadastro := "Histórico de função "
    
    //Setando o nome da função, para a função customizada
    SetFunName("zHisFun1")
    
    //Instânciando FWMBrowse, setando a tabela, a descrição e ativando a navegação
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZHF")
    oBrowse:SetMenuDef("zHisFun1")
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

	    ADD  OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zHisFun1" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
		ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zHisFun1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"	
	    ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zHisFun1" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	        
       If  FWIsAdmin()  

    	    ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zHisFun1" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"
      EndIf
Return (aRot)


Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZHF := FWFormStruct( nModel, "ZHF" )	

	Default cCadastro := "função do Colaborador"

	

	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZHISFUN1", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gerenciamento de  Função")
	
	oModel:AddFields("FORMZHF",/*cOwner*/,oStZHF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZHF_FILIAL"  } ) //Chave primaria

	//Setando a descrição do formulário pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZHF"):SetDescription("Formulário do Cadastro "+cCadastro)
	
	
	
Return(oModel)


Static Function ViewDef()

	Local aStruZHF	:= ZHF->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZHISFUN1") 
	Local oStruZHF := FWFormStruct( nView, "ZHF")

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZHF", oStruZHF, "FORMZHF")



	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZHF', 'Dados - '+cTitulo )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
