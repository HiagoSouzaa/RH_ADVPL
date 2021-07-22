#Include "Protheus.ch"
#Include "TopConn.ch"
	
/*/{Protheus.doc} zRelCol
Relat�rio - Gera informacoes que gera os salarios dos colaboradores 
    --------------------------------------------------------------------------------------------    	
/*/	
User Function zRelSal()

	Local aArea   := GetArea()
	Local oReport := Nil
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	cPerg := "ZRELSAL"
	
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
	Local oFunTot1 := Nil
	Local oFunTot2 := Nil
    Local oBreak := Nil
	

	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"zRelExa",;		//Nome do Relat�rio
								"colaboradores",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								"Relatorios tras informa��es de Exames dos Colaboradores")		//Descri��o
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
	TRCell():New(oSectDad, "ZCO_NOME"   , "QRY_AUX", "Nome"             , GetSx3Cache("ZCO_NOME","X3_Picture")  , 40                                       , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZHS_CPF"    , "QRY_AUX", "Cpf"              , GetSx3Cache("ZHS_CPF","X3_Picture")   , 14                                       , /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZHS_DTREAJ" , "QRY_AUX", "Data reajuste"	, /*cPicture*/                           , GetSx3Cache("ZHS_DTREAJ","X3_TAMANHO")     , /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "XX_FUNCAO"  , "QRY_AUX","funcao"            , GetSx3Cache("ZCO_FUNCAO","X3_Picture"), 30                                      , /*lPixel*/,{|| QRY_AUX->ZCO_FUNCAO + " - " + POSICIONE("ZCF",1,FWXFILIAL("ZCF")+QRY_AUX->ZCO_FUNCAO,"ZCF_DESC")  },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,,/*lBold*/)
    TRCell():New(oSectDad, "ZHS_VLRATU" , "QRY_AUX", "Salario"	        , GetSx3Cache("ZHS_VLRATU","X3_Picture")  , GetSx3Cache("ZHS_VLRATU","X3_TAMANHO")     , /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZCF_VLPISO" , "QRY_AUX", "Valor piso"	    , GetSx3Cache("ZCF_VLPISO","X3_Picture")  , GetSx3Cache("ZCF_VLPISO","X3_TAMANHO")     , /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
    TRCell():New(oSectDad, "ZCF_VLTETO" , "QRY_AUX", "Valor teto"	    , GetSx3Cache("ZCF_VLTETO","X3_Picture")  ,    GetSx3Cache("ZCF_VLTETO","X3_TAMANHO")     , /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/) 


	aAdd(oSectDad:Cell("ZHS_VLRATU"):aFormatCond, {"ZHS_VLRATU < ZCF_VLPISO" ,,CLR_RED})
	aAdd(oSectDad:Cell("ZHS_VLRATU"):aFormatCond, {"ZHS_VLRATU > ZCF_VLTETO" ,,CLR_BLUE})


    //Definindo a quebra
	oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->(ZHS_CPF) },{|| "Total por colaborador" })
	oSectDad:SetHeaderBreak(.T.)
    /*Totalizadores
	oFunTot1 := TRFunction():New(oSectDad:Cell("QUANTIDADE"),,"SUM",,,"@E 99,999,999,999.999" )
	oFunTot1:SetEndReport(.F.)
	oFunTot2 := TRFunction():New(oSectDad:Cell("VLR_TOTAL"),,"SUM",,,"@E 99,999,999,999.99" )
	oFunTot2:SetEndReport(.F.)
    */
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Fun��o que imprime o relat�rio                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)

	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	Local cNameZCO := RetSqlName("ZCO")
    Local cNameZCF := RetSqlName("ZCF")
    Local cNameZHS := RetSqlName("ZHS")
    local nTodos   := MV_PAR01
	Local cDeRea   := dToS(MV_PAR02)
    Local cAteRea  := dToS(MV_PAR03)
    Local cDeFun   := MV_PAR04
    Local cAteFun  := MV_PAR05
    Local cDeCol   := MV_PAR06
    Local cAteCol  := MV_PAR07
    

	
	
		
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	oReport:SetMsgPrint("Montando consulta do relat�rio...")

    

    IF( nTodos == 01  )

        cQryAux += " SELECT ZCO_NOME, ZCO_FUNCAO, ZHS_CPF, ZHS_DTREAJ, ZHS_VLRATU, ZCF_VLPISO, ZCF_VLTETO  "
        cQryAux += " FROM "+cNameZCO+ " AS ZCO "
        cQryAux += " INNER JOIN "+cNameZHS+" AS ZHS "
        cQryAux += " ON ZCO_FILIAL = ZHS_FILIAL  AND ZCO_CPF = ZHS_CPF "
        cQryAux += " INNER JOIN "+cNameZCF+" AS ZCF "
        cQryAux += " ON ZCO_FILIAL = ZCF_FILIAL AND ZCO_FUNCAO = ZCF_ID "
        cQryAux += " WHERE ZCO_FILIAL = '" + FWxFilial( "ZCO" ) +"' "  
        cQryAux += " AND ZHS_DTREAJ  BETWEEN '"+cDeRea+"'  AND '"+cAteRea+"' "   
        cQryAux += " AND ZCO_FUNCAO  BETWEEN '"+cDeFun+"'  AND '"+cAteFun+"' "
        cQryAux += " AND ZHS_CPF     BETWEEN '"+cDeCol+"'  AND '"+cAteCol+"' "
        cQryAux += " AND ZCO.D_E_L_E_T_ = '' AND ZHS.D_E_L_E_T_ = '' AND ZCF.D_E_L_E_T_ = '' "
        cQryAux += " ORDER BY ZHS_CPF, ZCO_FUNCAO, ZHS_DTREAJ, ZHS_VLRATU "

    Else   

        cQryAux += " SELECT ZCO_NOME, ZCO_FUNCAO, ZHS_CPF, MAX(ZHS_DTREAJ) AS ZHS_DTREAJ,  MAX(ZHS_VLRATU) AS ZHS_VLRATU, ZCF_VLPISO, ZCF_VLTETO  "
        cQryAux += " FROM "+cNameZCO+ " AS ZCO "
        cQryAux += " INNER JOIN "+cNameZHS+" AS ZHS "
        cQryAux += " ON ZCO_FILIAL = ZHS_FILIAL  AND ZCO_CPF = ZHS_CPF "
        cQryAux += " INNER JOIN "+cNameZCF+" AS ZCF "
        cQryAux += " ON ZCO_FILIAL = ZCF_FILIAL AND ZCO_FUNCAO = ZCF_ID "
        cQryAux += " WHERE ZCO_FILIAL = '" + FWxFilial( "ZCO" ) +"' "  
        cQryAux += " AND ZHS_DTREAJ  BETWEEN '"+cDeRea+"'  AND '"+cAteRea+"' "   
        cQryAux += " AND ZCO_FUNCAO  BETWEEN '"+cDeFun+"'  AND '"+cAteFun+"' "
        cQryAux += " AND ZHS_CPF     BETWEEN '"+cDeCol+"'  AND '"+cAteCol+"' "
        cQryAux += " AND ZCO.D_E_L_E_T_ = '' AND ZHS.D_E_L_E_T_ = '' AND ZCF.D_E_L_E_T_ = '' "
        cQryAux += " GROUP BY ZHS_CPF, ZCO_NOME, ZCO_FUNCAO, ZCF_VLPISO, ZCF_VLTETO "




    EndIf 
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)


	TCSetField("QRY_AUX","ZHS_DTREAJ","D")
    
	
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




/*
  Descri��o: Pega origem do produto e retorna descri��o adequada para relat�rio.

static function fGetOrigem(cOrigem)
      
	 if(cOrigem $ "03458")
	     return "Nacional"
	 elseif(cOrigem $ "1267")
	     return "Extrangeira"
	 else
	     return "N�o encontrada"
	 endif	 
*/
return
