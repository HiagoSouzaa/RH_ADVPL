/*{Protheus.doc} zHSSal 
@description Query que retorna a data do ultimo vencimento de férias 

@author  	Hiago   
@return 	Undefinied

*/
#include 'Protheus.ch'
#Include 'TopConn.ch'

User function zVenFer(cCpf,dDiaVen)

    Local aArea     := GetArea()
    Local cQUERY    :=  ' ' 
    Local cNameZDF  := retSqlname("ZDF") 
    Local cAliasTmp := 'zVenFer' + FWTimeStamp()
    

    Local dData    :=  YearSum(dDiaVen,1)

      // SELECT * FROM ZHS990
        cQUERY := " SELECT ZDF_CPF,  MAX(ZDF_VENFE) AS 'ZDF_VENFE' "
        cQUERY += " FROM " + cNameZDF + " AS ZDF "
        cQUERY += " WHERE  ZDF_FILIAL = '" + FWxFilial( "ZDF" ) +" '"
        cQUERY += " AND ZDF_CPF = '" + cCpf + "' "     
        cQUERY += " AND ZDF.D_E_L_E_T_ = ' ' "
        cQUERY += " GROUP BY ZDF_CPF" 
        cQUERY := changeQuery(cQUERY) 
        
      

        TcQuery cQuery New Alias (cAliasTmp)

        TCSetField((cAliasTmp),"ZDF_VENFE","D")
        
        dbSelectArea(cAliasTmp)
        
        If !((cAliasTmp)->(EOF()))

            dData := YearSum((cAliasTmp)->ZDF_VENFE,1) 
            
        EndIf


        ConOut(cValToChar(dData) )
        
        (cAliasTmp)->(dbCloseArea())

       

    RestArea(aArea) 

Return(dData)
