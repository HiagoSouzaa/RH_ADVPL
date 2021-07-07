/*{Protheus.doc} zRhMain 
@description Fornece uma tela em MVC com dados do colaborador, 
			 historico de salário, historico de funcao e historico de exame.

@author  	Hiago   
@return 	Undefinied

*/
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Variáveis Estáticas
Static cTitulo := "Colaboradores"
 
User Function zRhMain()

	Local aArea   := GetArea()
	Local oBrowse
	Local cFunBkp := FunName()
	
	SetFunName("zRhMain")
	
	//Instânciando FWMBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZCO")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()
	
	SetFunName(cFunBkp)
	RestArea(aArea)

Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
	Local aRot := {}
	Local nAcessoTotal := 0

	
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Gerenciar Colaborador'       ACTION 'VIEWDEF.zRhMain' OPERATION MODEL_OPERATION_VIEW ACCESS nAcessoTotal
	ADD OPTION aRot TITLE "Incluir novo colaborador"    ACTION "VIEWDEF.zCadFun1" OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal

Return aRot

Static Function ModelDef()

    Local oModel := Nil 
    Local oStPai     := FWFormStruct(1, 'ZCO')
    Local oStFilho1  := FWFormStruct(1, 'ZHS')
    Local oStFilho2  := FWFormStruct(1, 'ZHF')
	Local oStFilho3  := FWFormStruct(1, 'ZHE')
    Local aRelFilho1 := {}
	Local aRelFilho2 := {}
	Local aRelFilho3 := {}

    //Criando o modelo
	oModel := MPFormModel():New('zRhMainM')
	oModel:AddFields('ZCO_MASTER', /*cOwner*/, oStPai)

	oStFilho2:SetProperty("ZHF_NOME",MODEL_FIELD_INIT,'')
	oStFilho2:SetProperty("ZHF_NOMEFU",MODEL_FIELD_INIT,{||POSICIONE("ZCF",1,FWXFILIAL("ZCF")+ZHF->ZHF_FUNCAO,"ZCF_DESC")})           
	
	oStFilho3:SetProperty("ZHE_NOME",MODEL_FIELD_INIT,'')
	oStFilho3:SetProperty("ZHE_NOMEXA",MODEL_FIELD_INIT, {||POSICIONE("SX5",1,FWXFILIAL("SX5")+"ZE"+ZHE->ZHE_TPEXAM,"X5_DESCRI")})
	
	
	
    //Criando as grids dos filhos
	oModel:AddGrid('ZHS_FILHO1', 'ZCO_MASTER', oStFilho1)
	oModel:AddGrid('ZHF_FILHO2', 'ZCO_MASTER', oStFilho2)
	oModel:AddGrid('ZHE_FILHO3', 'ZHS_FILHO1', oStFilho3)

    //Criando os relacionamentos dos pais e filhos
	aAdd(aRelFilho1, {'ZHS_FILIAL', 'ZCO_FILIAL'})
	aAdd(aRelFilho1, {'ZHS_CPF',    'ZCO_CPF'})
	aAdd(aRelFilho2, {'ZHF_FILIAL', 'ZCO_FILIAL'})
	aAdd(aRelFilho2, {'ZHF_CPF',    'ZCO_CPF'})
	aAdd(aRelFilho3,  {'ZHE_FILIAL','ZCO_FILIAL'})
	aAdd(aRelFilho3,  {'ZHE_CPF',    'ZCO_CPF'})
	

    //Criando o relacionamento do Filho 1 - HISTORICO DE SALARIO
	oModel:SetRelation('ZHS_FILHO1', aRelFilho1, ZHS->(IndexKey(1)))

    //Criando o relacionamento do Filho 2 -HISTORICO DE FUNÇÃO
	oModel:SetRelation('ZHF_FILHO2', aRelFilho2, ZHF->(IndexKey(1)))

	oModel:SetRelation('ZHE_FILHO3', aRelFILHO3, ZHE->(IndexKey(1)))
	oModel:GetModel('ZHE_FILHO3'):SetUniqueLine({"ZHE_FILIAL"})


    oModel:SetPrimaryKey({})
	oModel:SetDescription("Historico do Colaborador")
	oModel:GetModel('ZCO_MASTER'):SetDescription('Modelo Grupo')
	oModel:GetModel('ZHS_FILHO1'):SetDescription('Historico Salario')
	oModel:GetModel('ZHF_FILHO2'):SetDescription('Historico Funcao')
	
	Return oModel

 	Static Function ViewDef()

    Local oView     := Nil
    Local oModel    := FWLoadModel('zRhMain')
    Local oStPai    := FWFormStruct(2, 'ZCO')
    Local oStFilho1 := FWFormStruct(2, 'ZHS')
    Local oStFilho2 := FWFormStruct(2, 'ZHF')
	Local oStFilho3 := FWFormStruct(2, 'ZHE')


    //Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

    //Adicionando os campos do cabeçalho
	oView:AddField('VIEW_ZCO', oStPai, 'ZCO_MASTER')
	
	//Grids dos filhos
	oView:AddGrid('VIEW_FILHO1', oStFilho1, 'ZHS_FILHO1')
	oView:AddGrid('VIEW_FILHO2', oStFilho2, 'ZHF_FILHO2')
	oView:AddGrid('VIEW_FILHO3', oStFilho3, 'ZHE_FILHO3')
	
    //Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('SUPERIOR', 40)
	oView:CreateHorizontalBox('CENTRO', 30)
	oView:CreateHorizontalBox('INFERIOR', 30)

     //Criando a folder dos produtos (filhos)
	oView:CreateFolder('PASTA_FILHOS', 'CENTRO')
	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO01', "Histórico de Salário")
	oView:AddSheet('PASTA_FILHOS', 'ABA_FILHO02', "Histórico de Função")

   //Cria as caixas onde serão mostrados os dados dos filhos
	oView:CreateHorizontalBox('ITENS_FILHO01', 100,,, 'PASTA_FILHOS', 'ABA_FILHO01' )
	oView:CreateHorizontalBox('ITENS_FILHO02', 100,,, 'PASTA_FILHOS', 'ABA_FILHO02' )
	

	//oView:CreateHorizontalBox('NETOS_FILHO01', 100,,, 'PASTA_FILHOS', 'ABA_FILHO01' )
	oView:CreateFolder('PASTA_FILHO3', 'INFERIOR')	
	oView:AddSheet('PASTA_FILHO3', 'ABA_FILHO3', "Historico de exame")

	
	oView:CreateHorizontalBox('ITENS_FILHO3', 100,,, 'PASTA_FILHO3', 'ABA_FILHO3')


  //Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZCO',    'SUPERIOR')
	oView:SetOwnerView('VIEW_FILHO1', 'ITENS_FILHO01')
	oView:SetOwnerView('VIEW_FILHO2', 'ITENS_FILHO02')
	oView:SetOwnerView('VIEW_FILHO3', 'ITENS_FILHO3')

	//oView:SetViewAction( 'BUTTONCANCEL'    ,{ |oView|  u_fTeste(oView) } )	
	
	oStFilho1:RemoveField("ZHS_FILIAL")
	oStFilho1:RemoveField("ZHS_CPF")

	oStFilho2:RemoveField("ZHF_FILIAL")
	oStFilho2:RemoveField("ZHF_CPF")
	oStFilho2:RemoveField("ZHF_NOME")

					  
	oStFilho3:RemoveField("ZHE_NOME")
	oStFilho3:RemoveField("ZHE_CPF")
	oStFilho3:RemoveField("ZHE_FILIAL")

		

	
Return oView

