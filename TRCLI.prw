#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/*/{Protheus.doc} TRCLI
Relatório no modelo TReport que é responsável por imprimir os dados do cadatro de clientes, mais precisamente os campos CODIGO, LOJA e NOME
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

//Função responsável por chamar a pergunta criada na função ValidaPerg, a variável PRIVATE cPerg, é passada.
Pergunte(cPerg,.F.)

//CHAMAMOS AS FUNÇÕES QUE CONSTRUIRÃO O RELATÓRIO
ReportDef()
oReport:PrintDialog()

Return 



/*/{Protheus.doc} ReportDef
Função responsável por estruturar as seções e campos que darão forma ao relatório, bem como outras características.
Aqui os campos contidos na querie, que você quer que apareça no relatório, são adicionados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=H25BvYyPDDY
/*/Static Function ReportDef()

oReport := TReport():New("ZREL","Relatório - Cadastro de Clientes",cPerg,{|oReport| PrintReport(oReport)},"Relatório de impressão do cadastro de colaborador")
oReport:SetLandscape(.T.) // SIGNIFICA QUE O RELATÓRIO SERÁ EM PAISAGEM

//TrSection serve para constrole da seção do relatório, neste caso, teremos somente uma
oSecCab := TRSection():New( oReport , "CADASTRO DE COLABORADORES", {"SQL"} )

/*
TrCell serve para inserir os campos/colunas que você quer no relatório, lembrando que devem ser os mesmos campos que contém na QUERIE
Um detalhe importante, todos os campos contidos nas linhas abaixo, devem estar na querie, mas.. 
você pode colocar campos na querie e adcionar aqui embaixo, conforme a sua necessidade.
*/
TRCell():New( oSecCab, "ZCO_NOME"     , "SQL")
TRCell():New( oSecCab, "ZCO_CPF"      , "SQL")
TRCell():New( oSecCab, "ZCO_RG"       , "SQL")
 
//ESTA LINHA IRÁ CONTAR A QUANTIDADE DE REGISTROS LISTADOS NO RELATÓRIO PARA A ÚNICA SEÇÃO QUE TEMOS
TRFunction():New(oSecCab:Cell("ZCO_CPF"),,"COUNT"     ,,,,,.F.,.T.,.F.,oSecCab)

Return 




/*/{Protheus.doc} PrintReport
Nesta função é inserida a querie utilizada para exibição dos dados;
A função de PERGUNTAS  é chamada para que os filtros possam ser montados
@type function
@author SISTEMATIZEI
@since 24/06/2019
@version 1.0
@param oReport, objeto, (Descrição do parâmetro)
@see Com a tecla Ctrl PRESSIONADA clique --> https://www.youtube.com/watch?v=vSiJxbiSt8E
/*/Static Function PrintReport(oReport)
//VARIÁVEL responsável por armazenar o Alias que será utilizado pela querie 
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


oSecCab:BeginQuery() //Relatório começa a ser estruturado
oSecCab:EndQuery({{"SQL"},cAlias}) //Recebe a querie e constrói o relatório
oSecCab:Print() //É dada a ordem de impressão, visto os filtros selecionados

//O Alias utilizado para execução da querie é fechado.
(cAlias)->(DbCloseArea())

Return 

