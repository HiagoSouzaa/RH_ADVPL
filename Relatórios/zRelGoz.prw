 #Include "Protheus.ch"
#Include "TopConn.ch"
	
/*/{Protheus.doc} zRelCol
Relat�rio - Gera informac�es sobre o Gozo de F�rias
    --------------------------------------------------------------------------------------------    	
/*/	
User Function zRelGoz()

	Local aArea   := GetArea()
	Local oReport := Nil
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	cPerg := "ZRELGOZ "
	
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
	oReport := TReport():New(	"zRelGoz",;		//Nome do Relat�rio
								"Gozo das F�rias",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								"Relatorios tras informa��es de gozo das f�rias")		//Descri��o
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
	TRCell():New(oSectDad, "XX_NOME"    , "QRY_AUX", "Nome"                  , GetSx3Cache("ZGF_NOME","X3_Picture")  , 50, /*lPixel*/,{||POSICIONE("ZCO",1,FWXFILIAL("ZCO")+QRY_AUX->ZGF_CPF,"ZCO_NOME")} ,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)	
	TRCell():New(oSectDad, "ZGF_CPF"    , "QRY_AUX", "Cpf"                   , GetSx3Cache("ZGF_CPF","X3_Picture")   , 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZGF_DTINI"  , "QRY_AUX", "Inicio das f�rias"	 , GetSx3Cache("ZGF_DTINI","X3_Picture") ,  /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZGF_DTFIM"  , "QRY_AUX", "Fim das f�rias"        , GetSx3Cache("ZGF_DTFIM","X3_Picture") , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZGF_DIGOZO" , "QRY_AUX", "Dias gozados"          , GetSx3Cache("ZGF_DIGOZO","X3_Picture"), /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

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
	Local cNameZGF  := RetSqlName("ZGF")
	Local cIniFer  := dToS(MV_PAR01)
	Local cFimFer := dToS(MV_PAR02)
	Local cDeCol    := MV_PAR03
	Local cAteCol   := MV_PAR04
	
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	oReport:SetMsgPrint("Montando consulta do relat�rio...")

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
	
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)


	TCSetField("QRY_AUX","ZGF_DTINI ","D")
	TCSetField("QRY_AUX","ZGF_DTFIM ","D")
	
	
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

