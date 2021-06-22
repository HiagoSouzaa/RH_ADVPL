/*{Protheus.doc} zHisExa1 
@description Fornece uma tela em MVC para visualização ou alteração(adm) para historico de Exames

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
Static cTitulo  := "Historico da Exame"
Static cDefault := "Historico DE EXAME"

User Function zHisExa1()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	
    
    private cCadastro := "Histórico de Exames "
    
    //Setando o nome da função, para a função customizada
    SetFunName("zHisExa1")
    
    //Instânciando FWMBrowse, setando a tabela, a descrição e ativando a navegação
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZHE")
    oBrowse:SetMenuDef("zHisExa1")
    oBrowse:SetDescription(cCadastro)
    oBrowse:DisableDetails()
    
    oBrowse:Activate()
             
    //Destrói a classe      
    oBrowse:DeActivate()
    oBrowse:Destroy()
    
    //Voltando o nome da função
    SetFunName(cFunBkp)
       
    FreeObj( oBrowse )    
    RestArea(aArea)
return

Static Function MenuDef()
	Local aRot		   := {}
	Local nAcessoTotal := 0

	    ADD  OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zHisExa1" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"

       If  FWIsAdmin()  

    	    ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zHisExa1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"	
	        ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zHisExa1" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	        ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zHisExa1" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"
      EndIf
Return (aRot)


Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZHE := FWFormStruct( nModel, "ZHE" )	

	

	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZHISEXA1", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gerenciamento de  Exames")
	
	oModel:AddFields("FORMZHE",/*cOwner*/,oStZHE, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZHE_FILIAL"  } ) //Chave primaria

	//Setando a descrição do formulário pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZHE"):SetDescription("Formulário do Cadastro "+cCadastro)
	
	
	
Return(oModel)


Static Function ViewDef()

	Local aStruZZ1	:= ZHE->(DbStruct())
	Local oView    := Nil
	Local nView    := 2
	Local oModel   := FWLoadModel("ZHISEXA1") 
	Local oStruZHE := FWFormStruct( nView, "ZHE")

	oView:= FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField( "VIEW_ZHE", oStruZHE, "FORMZHE")



	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZHE', 'Dados - '+cTitulo )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
