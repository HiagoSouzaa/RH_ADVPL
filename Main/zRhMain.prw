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

	Local aArea  	 := GetArea()
	Local oBrowse
	Local cFunBkp 	 := FunName()
	Local nOffWaring := 1
	
	SetFunName("zRhMain")
	
	//Instânciando FWMBrowse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZCO")
	oBrowse:SetDescription(cTitulo)
	oBrowse:Activate()
	
	//Trata warning que ocorre com os fontes mvc
	If( nOffWaring == 0 )
		MenuDef()
		ModelDef()
		ViewDef()
	EndIf

	SetFunName(cFunBkp)
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()

	Local aRot := {}
	Local aSubRot := {}
	Local nAcessoTotal := 0	
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Gerenciar Colaborador'       ACTION 'VIEWDEF.zRhMain' OPERATION MODEL_OPERATION_VIEW   ACCESS nAcessoTotal
	ADD OPTION aRot TITLE "Incluir novo colaborador"    ACTION "VIEWDEF.zCadFun1"OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal
	
	ADD OPTION aSubRot TITLE "Relatório colaboradores"  	  ACTION "u_zRelCol"OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal
	ADD OPTION aSubRot TITLE "Relatório de exames "     	  ACTION "u_zRelExa"OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal
	ADD OPTION aSubRot TITLE "Relatório de salários "   	  ACTION "u_zRelSal"OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal
	ADD OPTION aSubRot TITLE "Relatório de direito de gozo"   ACTION "u_zRelGoz"OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal
	ADD OPTION aSubRot TITLE "Relatório de gozo de férias "   ACTION "u_zRelDir"OPERATION MODEL_OPERATION_INSERT ACCESS nAcessoTotal
	
	ADD OPTION aRot    TITLE 'Relatórios'               ACTION aSubRot OPERATION MODEL_OPERATION_VIEW ACCESS nAcessoTotal
	
Return aRot

Static Function ModelDef()

    Local oModel := Nil 
    Local oStPai     := FWFormStruct(1, 'ZCO')
    Local oStFilho1  := FWFormStruct(1, 'ZHS')
    Local oStFilho2  := FWFormStruct(1, 'ZHF')
	Local oStFilho3  := FWFormStruct(1, 'ZHE')
	Local oStFilho4  := FWFormStruct(1, 'ZDF')
	Local oStFilho5  := FWFormStruct(1, 'ZGF')
    Local aRelFilho1 := {}
	Local aRelFilho2 := {}
	Local aRelFilho3 := {}
	Local aRelFilho4 := {}
	Local aRelFilho5 := {}

    //Criando o modelo
	oModel := MPFormModel():New('zRhMainM')
	oModel:AddFields('ZCO_MASTER', /*cOwner*/, oStPai)

	oStFilho1:SetProperty("ZHS_NOME",MODEL_FIELD_INIT,'')
	oStFilho1:SetProperty("ZHS_NOME",MODEL_FIELD_INIT, {||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+ZHS->ZHS_CPF,"ZCO_NOME")})
	

	oStFilho2:SetProperty("ZHF_NOME",MODEL_FIELD_INIT,'')
	oStFilho2:SetProperty("ZHF_NOMEFU",MODEL_FIELD_INIT,{||POSICIONE("ZCF",1,FWXFILIAL("ZCF")+ZHF->ZHF_FUNCAO,"ZCF_DESC")})           
	
	oStFilho3:SetProperty("ZHE_NOME",MODEL_FIELD_INIT,'')
	oStFilho3:SetProperty("ZHE_NOMEXA",MODEL_FIELD_INIT, {||POSICIONE("SX5",1,FWXFILIAL("SX5")+"ZE"+ZHE->ZHE_TPEXAM,"X5_DESCRI")})
	
	oStFilho4:SetProperty("ZDF_NOME",MODEL_FIELD_INIT,'')
	oStFilho4:SetProperty("ZDF_NOME",MODEL_FIELD_INIT, {||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+ZDF->ZDF_CPF,"ZCO_NOME")})
	
	oStFilho5:SetProperty("ZGF_NOME",MODEL_FIELD_INIT,'')
	oStFilho5:SetProperty("ZGF_NOME",MODEL_FIELD_INIT, {||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+ZGF->ZGF_CPF,"ZCO_NOME")})
	
    //Criando as grids dos filhos
	oModel:AddGrid('ZHS_FILHO1', 'ZCO_MASTER', oStFilho1)
	oModel:AddGrid('ZHF_FILHO2', 'ZCO_MASTER', oStFilho2)
	oModel:AddGrid('ZHE_FILHO3', 'ZHS_FILHO1', oStFilho3)
	oModel:AddGrid('ZDF_FILHO4', 'ZCO_MASTER', oStFilho4)
	oModel:AddGrid('ZGF_FILHO5', 'ZCO_MASTER', oStFilho5)
    //Criando os relacionamentos dos pais e filhos
	aAdd(aRelFilho1, {'ZHS_FILIAL', 'ZCO_FILIAL'})
	aAdd(aRelFilho1, {'ZHS_CPF',    'ZCO_CPF'})
	aAdd(aRelFilho2, {'ZHF_FILIAL', 'ZCO_FILIAL'})
	aAdd(aRelFilho2, {'ZHF_CPF',    'ZCO_CPF'})
	aAdd(aRelFilho3,  {'ZHE_FILIAL','ZCO_FILIAL'})
	aAdd(aRelFilho3,  {'ZHE_CPF',    'ZCO_CPF'})
	aAdd(aRelFilho4,  {'ZDF_FILIAL',   'ZCO_FILIAL'})
	aAdd(aRelFilho4,  {'ZDF_CPF',    'ZCO_CPF'})
	aAdd(aRelFilho5,  {'ZGF_FILIAL',  'ZCO_FILIAL'})
	aAdd(aRelFilho5,  {'ZGF_CPF',    'ZCO_CPF'})
	

    //Criando o relacionamento do Filho 1 - HISTORICO DE SALARIO
	oModel:SetRelation('ZHS_FILHO1', aRelFilho1, ZHS->(IndexKey(1)))

    //Criando o relacionamento do Filho 2 -HISTORICO DE FUNÇÃO
	oModel:SetRelation('ZHF_FILHO2', aRelFilho2, ZHF->(IndexKey(1)))

	oModel:SetRelation('ZHE_FILHO3', aRelFILHO3, ZHE->(IndexKey(1)))
	oModel:GetModel('ZHE_FILHO3'):SetUniqueLine({"ZHE_FILIAL"})

	oModel:SetRelation('ZDF_FILHO4', aRelFilho4, ZDF->(IndexKey(1)))

	oModel:SetRelation('ZGF_FILHO5', aRelFilho5, ZGF->(IndexKey(1)))


    oModel:SetPrimaryKey({})
	oModel:SetDescription("Historico do Colaborador")
	oModel:GetModel('ZCO_MASTER'):SetDescription('Modelo Grupo')
	oModel:GetModel('ZHS_FILHO1'):SetDescription('Historico Salario')
	oModel:GetModel('ZHF_FILHO2'):SetDescription('Historico Funcao')
	
	oModel:GetModel('ZDF_FILHO4'):SetDescription('Direito de Férias')
	oModel:GetModel('ZGF_FILHO5'):SetDescription('Gozo das Férias')
	
Return oModel

 Static Function ViewDef()

    Local oView     := Nil
    Local oModel    := FWLoadModel('zRhMain')
    Local oStPai    := FWFormStruct(2, 'ZCO')
    Local oStFilho1 := FWFormStruct(2, 'ZHS')
    Local oStFilho2 := FWFormStruct(2, 'ZHF')
	Local oStFilho3 := FWFormStruct(2, 'ZHE')
	Local oStFilho4 := FWFormStruct(2, 'ZDF')
	Local oStFilho5 := FWFormStruct(2, 'ZGF')


    //Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)

    //Adicionando os campos do cabeçalho
	oView:AddField('VIEW_ZCO', oStPai, 'ZCO_MASTER')
	
	//Grids dos filhos
	oView:AddGrid('VIEW_FILHO1', oStFilho1, 'ZHS_FILHO1')
	oView:AddGrid('VIEW_FILHO2', oStFilho2, 'ZHF_FILHO2')
	oView:AddGrid('VIEW_FILHO3', oStFilho3, 'ZHE_FILHO3')
	oView:AddGrid('VIEW_FILHO4', oStFilho4, 'ZDF_FILHO4')
	oView:AddGrid('VIEW_FILHO5', oStFilho5, 'ZGF_FILHO5')
	
    //Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('COLABOADOR', 25)
	oView:CreateHorizontalBox('SALARIO', 25)
	oView:CreateHorizontalBox('FERIAS', 25)
	oView:CreateHorizontalBox('EXAME', 25)

     //Criando a folder dos produtos (filhos)
	oView:CreateFolder('PASTA_FILHO_SALARIO', 'SALARIO')
	oView:AddSheet('PASTA_FILHO_SALARIO', 'ABA_FILHO01', "Histórico de Salário")
	oView:AddSheet('PASTA_FILHO_SALARIO', 'ABA_FILHO02', "Histórico de Função")

	oView:CreateFolder('PASTA_FILHO_EXAME', 'EXAME')	
	oView:AddSheet('PASTA_FILHO_EXAME', 'ABA_FILHO03', "Historico de exame")

	oView:CreateFolder('PASTA_FILHO_FERIAS', 'FERIAS')
	oView:AddSheet('PASTA_FILHO_FERIAS', 'ABA_FILHO04', "Direito de férias")
	oView:AddSheet('PASTA_FILHO_FERIAS', 'ABA_FILHO05', "Gozo das Férias")

   //Cria as caixas onde serão mostrados os dados dos filhos
	oView:CreateHorizontalBox('ITENS_FILHO01', 100,,, 'PASTA_FILHO_SALARIO', 'ABA_FILHO01' )
	oView:CreateHorizontalBox('ITENS_FILHO02', 100,,, 'PASTA_FILHO_SALARIO', 'ABA_FILHO02' )

	oView:CreateHorizontalBox('ITENS_FILHO03', 100,,, 'PASTA_FILHO_EXAME', 'ABA_FILHO03')

	oView:CreateHorizontalBox('ITENS_FILHO04', 100,,, 'PASTA_FILHO_FERIAS', 'ABA_FILHO04' )
	oView:CreateHorizontalBox('ITENS_FILHO05', 100,,, 'PASTA_FILHO_FERIAS', 'ABA_FILHO05' )
	
  //Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZCO',    'COLABOADOR')
	oView:SetOwnerView('VIEW_FILHO1', 'ITENS_FILHO01')
	oView:SetOwnerView('VIEW_FILHO2', 'ITENS_FILHO02')
	oView:SetOwnerView('VIEW_FILHO3', 'ITENS_FILHO03')
	oView:SetOwnerView('VIEW_FILHO4', 'ITENS_FILHO04')
	oView:SetOwnerView('VIEW_FILHO5', 'ITENS_FILHO05')
	//oView:SetViewAction( 'BUTTONCANCEL'    ,{ |oView|  u_fTeste(oView) } )	
	
	oStFilho1:RemoveField("ZHS_FILIAL")
	oStFilho1:RemoveField("ZHS_CPF")
	oStFilho1:RemoveField("ZHS_NOME")

	oStFilho2:RemoveField("ZHF_FILIAL")
	oStFilho2:RemoveField("ZHF_CPF")
	oStFilho2:RemoveField("ZHF_NOME")

	oStFilho3:RemoveField("ZHE_NOME")
	oStFilho3:RemoveField("ZHE_CPF")
	oStFilho3:RemoveField("ZHE_FILIAL")

	oStFilho4:RemoveField("ZDF_FILIAL")
	oStFilho4:RemoveField("ZDF_CPF")
	oStFilho4:RemoveField("ZDF_NOME")

	oStFilho5:RemoveField("ZGF_FILIAL")
	oStFilho5:RemoveField("ZGF_CPF")
	oStFilho5:RemoveField("ZGF_NOME")
	
Return oView

