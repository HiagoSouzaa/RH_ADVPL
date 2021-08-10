#Include "Protheus.ch"
#Include "TopConn.ch"
	
/*/{Protheus.doc} zRelCol
Relat�rio - Gera informac�es sobre o Direito de F�rias
    --------------------------------------------------------------------------------------------    	
/*/	
User Function zRelDir()

	Local aArea   := GetArea()
	Local oReport := Nil
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	cPerg := "ZRELDIR "
	
	//Cria as defini��es do relat�rio
	oReport := fReportDef()
	  
	//Carrega conteudo das perguntas na mem�ra
	Pergunte(cPerg, .F.)
	
	//Ser� enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Sen�o, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Fun��o que monta a defini��o do relat�rio                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()

	Local oReport
	Local oSectDad := Nil
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"zRelDir",;		//Nome do Relat�rio
								"Direito de F�rias",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								"Relatorios tras informa��es de direito de f�rias")		//Descri��o
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .T.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a se��o de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a se��o pertence
									"Dados",;		//Descri��o da se��o
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira ser� considerada como principal da se��o
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores ser�o impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relat�rio
	TRCell():New(oSectDad, "XX_NOME"   ,  "QRY_AUX", "Nome"                  , GetSx3Cache("ZDF_NOME","X3_Picture")  , 50, /*lPixel*/,{||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+QRY_AUX->ZDF_CPF,"ZCO_NOME")} ,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	TRCell():New(oSectDad, "ZDF_CPF"    , "QRY_AUX", "Cpf"                   , GetSx3Cache("ZDF_CPF","X3_Picture")   , 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_INIAQ"  , "QRY_AUX", "Inicio Aquisitivo"	 , GetSx3Cache("ZDF_INIAQ","X3_Picture") , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_FIMAQ"  , "QRY_AUX", "Fim Aquisitivo"        , GetSx3Cache("ZDF_FIMAQ","X3_Picture") , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_VENFE"  , "QRY_AUX", "Vencimento de F�rias"  , GetSx3Cache("ZDF_VENFE","X3_Picture") ,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZDF_DIASAL" , "QRY_AUX", "Dias de saldo"	     , GetSx3Cache("ZDF_DIASAL","X3_Picture") ,15, /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	

	aAdd(oSectDad:Cell("ZDF_VENFE"):aFormatCond, {"ZDF_VENFE < DATE() ",,CLR_RED})

	
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
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
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	oReport:SetMsgPrint("Montando consulta do relat�rio...")

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

	
	//Executando consulta e setando o total da r�gua
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
		//Incrementando a r�gua
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

