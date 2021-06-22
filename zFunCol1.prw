
/*{Protheus.doc} zModel1 
@description Fornece uma tela em MVC para cadastro de Função

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
Static cTitulo  := "Função"
Static cDefault := "CADASTRO DE FUNÇÃO"

User Function zFunCol1()

    Local aArea   := GetArea()
    Local cFunBkp := FunName()
    Local oBrowse := nil
	
    
    private cCadastro := "Função"
    
    //Setando o nome da função, para a função customizada
    SetFunName("zFunCol1")
    
    //Instânciando FWMBrowse, setando a tabela, a descrição e ativando a navegação
    oBrowse:= FWMBrowse():New()
    oBrowse:SetAlias("ZCF")
    oBrowse:SetMenuDef("zFunCol1")
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
	
	ADD OPTION aRot TITLE "Incluir"    ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal //"Incluir"
	ADD OPTION aRot TITLE "Visualizar" ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal //"Visualizar"
	ADD OPTION aRot TITLE "Excluir"	   ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_DELETE ACCESS nAcessoTotal //"Excluir"
	ADD OPTION aRot TITLE "Alterar"	   ACTION "VIEWDEF.zFunCol1" OPERATION MODEL_OPERATION_UPDATE ACCESS nAcessoTotal //"Alterar"

Return (aRot)

Static Function ModelDef()

	

	Local oModel   := Nil
	Local nModel   := 1
	Local oStZCF := FWFormStruct( nModel, "ZCF" )	

	

	//Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
	oModel := MPFormModel():New("MZFUNCOL1", Nil, Nil, Nil, Nil) 

	oModel:SetDescription("[Uso na webService] Gerenciamento de  Função")
	
	oModel:AddFields("FORMZCF",/*cOwner*/,oStZCF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )	
	oModel:SetPrimaryKey( { "ZCF_FILIAL"  } ) //Chave primaria

	//Setando a descrição do formulário pegando ZZ1 MASTER do AddFields 
	oModel:GetModel("FORMZCF"):SetDescription("Formulário do Cadastro "+cCadastro)
	
	
	
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



	//Colocando título do formulário
	oView:EnableTitleView('VIEW_ZCF', 'Dados - '+cTitulo )  
	
	//Força o fechamento da janela na confirmação
	oView:SetCloseOnOk({||.T.})
	
Return(oView)
