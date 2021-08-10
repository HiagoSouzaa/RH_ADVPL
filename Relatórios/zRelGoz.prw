 #Include "Protheus.ch"
#Include "TopConn.ch"
	
/*/{Protheus.doc} zRelCol
Relatório - Gera informacões sobre o Gozo de Férias
    --------------------------------------------------------------------------------------------    	
/*/	
User Function zRelGoz()

	Local aArea   := GetArea()
	Local oReport := Nil
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "ZRELGOZ "
	
	//Cria as definições do relatório
	oReport := fReportDef()
	  
	//Carrega conteudo das perguntas na memóra
	Pergunte(cPerg, .F.)
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()

	Local oReport
	Local oSectDad := Nil

	//Criação do componente de impressão
	oReport := TReport():New(	"zRelGoz",;		//Nome do Relatório
								"Gozo das Férias",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								"Relatorios tras informações de gozo das férias")		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .T.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "XX_NOME"    , "QRY_AUX", "Nome"                  , GetSx3Cache("ZGF_NOME","X3_Picture")  , 50, /*lPixel*/,{||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+QRY_AUX->ZGF_CPF,"ZCO_NOME")} ,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	TRCell():New(oSectDad, "ZGF_CPF"    , "QRY_AUX", "Cpf"                   , GetSx3Cache("ZGF_CPF","X3_Picture")   , 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZGF_DTINI"  , "QRY_AUX", "Inicio das férias"	 , GetSx3Cache("ZGF_DTINI","X3_Picture") ,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZGF_DTFIM"  , "QRY_AUX", "Fim das férias"        , GetSx3Cache("ZGF_DTFIM","X3_Picture") , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZGF_DIGOZO" , "QRY_AUX", "Dias gozados"          , GetSx3Cache("ZGF_DIGOZO","X3_Picture"), /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)

	Local aArea     := GetArea()
	Local cQryAux   := ""
	Local oSectDad  := Nil
	Local nAtual    := 0
	Local nTotal    := 0
	Local cNameZGF  := RetSqlName("ZGF")
	Local cIniFer  := dToS(MV_PAR01)
	Local cFimFer := dToS(MV_PAR02)
	Local cDeCol    := MV_PAR03
	Local cAteCol   := MV_PAR04
	
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	oReport:SetMsgPrint("Montando consulta do relatório...")

    cQryAux += " SELECT ZGF_CPF, "
    cQryAux += " ZGF_DTINI , "
    cQryAux += " ZGF_DTFIM,  "
    cQryAux += " ZGF_DIGOZO "
    cQryAux += " FROM " +cNameZGF+ " ZGF "
    cQryAux += " WHERE ZGF_FILIAL =  '" + FWxFilial("ZGF")+ "' "
	cQryAux += " AND ZGF_DTINI   BETWEEN '"+cIniFer+"' AND '"+cFimFer+"' "
	cQryAux += " AND ZGF_CPF     BETWEEN '"+cDeCol+"'  AND '"+cAteCol+"' " 
    cQryAux += " AND ZGF.D_E_L_E_T_ = '' "
    cQryAux += " ORDER BY ZGF_CPF, ZGF_DTINI"
	
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)


	TCSetField("QRY_AUX","ZGF_DTINI ","D")
	TCSetField("QRY_AUX","ZGF_DTFIM ","D")
	
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("[Hora: "+Time()+"] Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return

