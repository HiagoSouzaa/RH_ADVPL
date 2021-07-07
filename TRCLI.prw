#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRCLI
Relat�rio no modelo TReport que � respons�vel por imprimir os dados do cadatro de clientes, mais precisamente os campos CODIGO, LOJA e NOME
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=jy-ocHaYIKs
/*/
User Function TRCLI()

//VARIAVEIS 
Private oReport  := Nil
Private oSecCab	 := Nil
Private cPerg 	 := "ZREL"

//Fun��o respons�vel por chamar a pergunta criada na fun��o ValidaPerg, a vari�vel PRIVATE cPerg, � passada.
Pergunte(cPerg,.F.)

//CHAMAMOS AS FUN��ES QUE CONSTRUIR�O O RELAT�RIO
ReportDef()
oReport:PrintDialog()

Return 



/*/{Protheus.doc} ReportDef
Fun��o respons�vel por estruturar as se��es e campos que dar�o forma ao relat�rio, bem como outras caracter�sticas.
Aqui os campos contidos na querie, que voc� quer que apare�a no relat�rio, s�o adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport():New("ZREL","Relat�rio - Cadastro de Clientes",cPerg,{|oReport| PrintReport(oReport)},"Relat�rio de impress�o do cadastro de colaborador")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELAT�RIO SER� EM PAISAGEM

//TrSection serve para constrole da se��o do relat�rio, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "CADASTRO DE COLABORADORES", {"SQL"} )

/*
TrCell serve para inserir os campos/colunas que voc� quer no relat�rio, lembrando que devem ser os mesmos campos que cont�m na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
voc� pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
*/
TRCell():New( oSecCab, "ZCO_NOME"     , "SQL")
TRCell():New( oSecCab, "ZCO_CPF"      , "SQL")
TRCell():New( oSecCab, "ZCO_RG"       , "SQL")
 
//ESTA LINHA IR� CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELAT�RIO PARA A �NICA SE��O QUE TEMOS
TRFunction():New(oSecCab:Cell("ZCO_CPF"),,"COUNT"     ,,,,,.F.,.T.,.F.,oSecCab)

Return 




/*/{Protheus.doc} PrintReport
Nesta fun��o � inserida a querie utilizada para exibi��o dos dados;
A fun��o de PERGUNTAS  � chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descri��o do par�metro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
//VARI�VEL respons�vel por armazenar o Alias que ser� utilizado pela querie 
Local cAlias := GetNextAlias()
local cQuery := ''

If (MV_PAR01 == "01")

    cQuery := " SELECT ZCO_FILIAL, ZCO_NOME, ZCO_CPF, ZCO_RG "
    cQuery += " FROM ZCO990"  
    cQuery += " WHERE ZCO_FILIAL = '01' AND ZCO990.D_E_L_E_T_ = ' ' "

Else 
    cQuery := " SELECT ZCO_FILIAL, ZCO_NOME, ZCO_CPF, ZCO_RG ,ZCO_MUN"
    cQuery += " FROM ZCO990"  
    cQuery += " WHERE ZCO_FILIAL = '01' AND ZCO_MUN = MV_PAR02 AND ZCO990.D_E_L_E_T_ = ' ' "
EndIf


oSecCab:BeginQuery() //Relat�rio come�a a ser estruturado
oSecCab:EndQuery({{"SQL"},cAlias}) //Recebe a querie e constr�i o relat�rio
oSecCab:Print() //� dada a ordem de impress�o, visto os filtros selecionados

//O Alias utilizado para execu��o da querie � fechado.
(cAlias)->(DbCloseArea())

Return 

