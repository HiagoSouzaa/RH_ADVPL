#Include "Protheus.ch"
#Include "TopConn.ch"
	
/*/{Protheus.doc} zRelCol
Relat�rio - Comprado no periodo por produto / Utilizado para envio de informa��es ao IBAMA anualmente.          
@author S�livan Sim�es Silva - sulivansimoes@gmail.com
@since 19/02/2019 [Data da cria��o]
@version 1.1

@obs : MANUTEN��ES FEITAS NO C�DIGO:
     --------------------------------------------------------------------------------------------					
     Vers�o gerada: 1.1
     Data: 20/08/2020
     Respons�vel: S�livan
     Log:* Ajustes na escrita do c�digo, como tirar parametros chumbados direto na query
     	 * Melhorado a escrita da query
         * Trocado fun��es antigas por novas.
    --------------------------------------------------------------------------------------------    	
/*/	
User Function zRelCol()

	Local aArea   := GetArea()
	Local oReport := Nil
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Defini��es da pergunta
	cPerg := "ZRELCOL "
	
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
	
	//Cria��o do componente de impress�o
	oReport := TReport():New(	"zRelCol",;		//Nome do Relat�rio
								"colaboradores",;		//T�tulo
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, ser� impresso uma p�gina com os par�metros, conforme privil�gio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de c�digo que ser� executado na confirma��o da impress�o
								"Relatorios tras informa��es dos Colaboradores")		//Descri��o
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
	TRCell():New(oSectDad, "ZCO_NOME"   , "QRY_AUX", "Nome"          , GetSx3Cache("ZCO_NOME","X3_Picture")  , 50, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZCO_CPF"    , "QRY_AUX", "Cpf"           , GetSx3Cache("ZCO_CPF","X3_Picture")   , 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZCO_RG"     , "QRY_AUX", "Rg"	         , /*cPicture*/                          , GetSx3Cache("ZCO_RG"   ,"X3_TAMANHO"), /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "XX_FUNCAO"  , "QRY_AUX","funcao"         , GetSx3Cache("ZCO_FUNCAO","X3_Picture"),  30                                  , /*lPixel*/,{|| QRY_AUX->ZCO_FUNCAO + " - " + POSICIONE("ZCF",1,FWXFILIAL("ZCF")+QRY_AUX->ZCO_FUNCAO,"ZCF_DESC")  },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZCO_DTADMI" , "QRY_AUX", "Data admissao" , /*cPicture*/                          , GetSx3Cache("ZCO_DTADMI","X3_TAMANHO"), /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ZCO_PIS"    , "QRY_AUX", "PIS"	         , GetSx3Cache("ZCO_PIS","X3_Picture")   , 15, /*lPixel*/,/*{|| code-block de impressao },/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "XX_MUN"    , "QRY_AUX", "Municipio"	 , GetSx3Cache("ZCO_MUN","X3_Picture")   , 30, /*lPixel*/,{|| QRY_AUX->ZCO_ESTADO + " - "+  POSICIONE("CC2",1,FWXFILIAL("CC2")+ QRY_AUX->ZCO_ESTADO+QRY_AUX->ZCO_MUN,"CC2_MUN")},/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
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
	Local nTodos   := MV_PAR01
	Local cMunic   := MV_PAR02
	Local cDatDe   := dToS(MV_par03) 
	Local cDatAte  := dToS(MV_par04)
	Local cFunDe   := MV_PAR05
	Local cFunPa   := MV_PAR06
	
	
		
	
	//Pegando as se��es do relat�rio
	oSectDad := oReport:Section(1)
	
	oReport:SetMsgPrint("Montando consulta do relat�rio...")

    

    cQryAux += " SELECT ZCO_NOME, "
    cQryAux += " ZCO_CPF , "
    cQryAux += " ZCO_RG  ,"
	cQryAux += " ZCO_DTADMI,"
	cQryAux += " ZCO_FUNCAO,"
	cQryAux += " ZCO_PIS ,"
	cQryAux += " ZCO_ESTADO ,"
	cQryAux += " ZCO_MUN "
    cQryAux += " FROM " +cNameZCO+ " ZCO "
    cQryAux += " WHERE ZCO_FILIAL =  '" + FWxFilial("ZCO")+ "' "
	cQryAux += " AND  ZCO_DTADMI BETWEEN '"+cDatDe+"' AND '"+cDatAte+"' "	
	cQryAux += " AND  ZCO_FUNCAO BETWEEN '"+cFunDe+"' AND '"+cFunPa +"' "	

	IF( nTodos == 02)
     	cQryAux += " AND ZCO_MUN = '" +cMunic+ "'  "
     endif
        cQryAux += " AND ZCO.D_E_L_E_T_ = '' "
	
	//Executando consulta e setando o total da r�gua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)


	TCSetField("QRY_AUX","ZCO_DTADMI","D")
	
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
