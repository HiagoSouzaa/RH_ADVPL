
/*{Protheus.doc} zHSSal 
@description Query que retorna o salario atual do colaborador 

@author  	Hiago   
@return 	Undefinied

*/
#include 'Protheus.ch'
#Include 'TopConn.ch'

User function ZHSSal(cCpf)

    Local aArea     := GetArea()
    Local cQUERY    :=  ' ' 
    Local cNameZHS  := retSqlname("ZHS") 
    Local cAliasTmp := 'ZHSSal_' + FWTimeStamp()

    Local nValor    := 0

    Default cCpf := ' ' 

     
         
        // SELECT * FROM ZHS990
        cQUERY := " SELECT ZHS_CPF,  MAX(ZHS_DTREAJ) AS 'ZHS_DTREAJ' ,  MAX(ZHS_VLRATU) AS 'ZHS_VLRATU' "
        cQUERY += " FROM " + cNameZHS + " AS ZHS "
        cQUERY += " WHERE  ZHS_FILIAL = '" + FWxFilial( "ZHS" ) +" '"
        cQUERY += " AND ZHS_CPF = '" + cCpf + "' "     
        cQUERY += " AND ZHS.D_E_L_E_T_ = ' ' "
        cQUERY += " GROUP BY ZHS_CPF" 
        cQUERY := changeQuery(cQUERY) 
        
       VarInfo("zAutDiss - query - " , cQUERY )

        TcQuery cQuery New Alias (cAliasTmp)

        dbSelectArea(cAliasTmp)

        If !((cAliasTmp)->(EOF()))

            nValor := (cAliasTmp)->ZHS_VLRATU
            
        EndIf


        ConOut(cValToChar(nValor) )
        
        (cAliasTmp)->(dbCloseArea())

       

    RestArea(aArea) 
Return(nValor)
