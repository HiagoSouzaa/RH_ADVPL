#Include "Protheus.ch"
#Include "TopConn.ch"
	
/*/{Protheus.doc} zRelCol
Relatório - Gera informacões sobre o Direito de Férias
    --------------------------------------------------------------------------------------------    	
/*/	
User Function zRelDir()

	Local aArea   := GetArea()
	Local oReport := Nil
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "ZRELDIR "
	
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
	oReport := TReport():New(	"zRelDir",;		//Nome do Relatório
								"Direito de Férias",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								"Relatorios tras informações de direito de férias")		//Descrição
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
	TRCell():New(oSectDad, "XX_NOME"   ,  "QRY_AUX", "Nome"                  , GetSx3Cache("ZDF_NOME","X3_Picture")  , 50, /*lPixel*/,{||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+QRY_AUX->ZDF_CPF,"ZCO_NOME")} ,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	TRCell():New(oSectDad, "ZDF_CPF"    , "QRY_AUX", "Cpf"                   , GetSx3Cache("ZDF_CPF","X3_Picture")   , 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_INIAQ"  , "QRY_AUX", "Inicio Aquisitivo"	 , GetSx3Cache("ZDF_INIAQ","X3_Picture") , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_FIMAQ"  , "QRY_AUX", "Fim Aquisitivo"        , GetSx3Cache("ZDF_FIMAQ","X3_Picture") , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_VENFE"  , "QRY_AUX", "Vencimento de Férias"  , GetSx3Cache("ZDF_VENFE","X3_Picture") ,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_DIASAL" , "QRY_AUX", "Dias de saldo"	     , GetSx3Cache("ZDF_DIASAL","X3_Picture") ,15, /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	

	aAdd(oSectDad:Cell("ZDF_VENFE"):aFormatCond, {"ZDF_VENFE < DATE() ",,CLR_RED})

	
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
	Local cNameZDF  := RetSqlName("ZDF")
	Local cDeIniAq  := dToS(MV_PAR01)
	Local cAteIniAq := dToS(MV_PAR02)
	Local cDeFimAq  := dToS(MV_PAR03)
	Local cAteFimAq := dToS(MV_PAR04)
	Local cDeVen    := dToS(MV_par05) 
	Local cAteVen   := dToS(MV_par06)
	Local cDeCol    := MV_PAR07
	Local cAteCol   := MV_PAR08
	Local cSaldo    := MV_PAR09
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	oReport:SetMsgPrint("Montando consulta do relatório...")

    cQryAux += " SELECT ZDF_CPF, "
    cQryAux += " ZDF_INIAQ , "
    cQryAux += " ZDF_FIMAQ ,"
	cQryAux += " ZDF_VENFE, "
	cQryAux += " ZDF_DIASAL "
    cQryAux += " FROM " +cNameZDF+ " ZDF "
    cQryAux += " WHERE ZDF_FILIAL =  '" + FWxFilial("ZDF")+ "' "
	cQryAux += " AND ZDF_INIAQ   BETWEEN '"+cDeIniAq+"' AND '"+cAteIniAq+"' "
	cQryAux += " AND ZDF_FIMAQ   BETWEEN '"+cDeFimAq+"' AND '"+cAteFimAq+"' "
	cQryAux += " AND ZDF_VENFE   BETWEEN '"+cDeVen+"'   AND '"+cAteVen+"' " 
	cQryAux += " AND ZDF_CPF     BETWEEN '"+cDeCol+"'   AND '"+cAteCol+"' " 

	IF(cSaldo == 01)
     	cQryAux += " AND ZDF_DIASAL > 0 "

	elseif(cSaldo == 02)
		cQryAux += " AND ZDF_DIASAL = 0 "

	Endif
     cQryAux += " AND ZDF.D_E_L_E_T_ = '' "
     cQryAux += " ORDER BY  ZDF_CPF,  ZDF_VENFE"

	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)


	TCSetField("QRY_AUX","ZDF_INIAQ ","D")
	TCSetField("QRY_AUX","ZDF_FIMAQ ","D")
	TCSetField("QRY_AUX","ZDF_VENFE ","D")
	
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

