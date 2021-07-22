#include 'Protheus.ch'
#Include 'TopConn.ch'


User Function zDiaSal(cCpf) 

Local aArea    := GetArea()
Local cNameZDF := RetSqlName("ZDF")
Local cQryAux  := ""
Local cAliasTmp := 'zDiaSal_' + FWTimeStamp()
local nFerias := 0;

Default cCpf := ' '


cQryAux += " SELECT SUM(ZDF_DIASAL) AS ZDF_DIASAL "
cQryAux += " FROM " +cNameZDF+ " AS ZDF "
cQryAux += " WHERE  ZDF_FILIAL = '" + FWxFilial("ZDF") +"' "
cQryAux += " AND ZDF_CPF = '" + cCpf + "' " 
cQryAux += " AND ZDF.D_E_L_E_T_ = '' "

 TcQuery cQryAux New Alias (cAliasTmp)

    dbSelectArea(cAliasTmp)

     If !((cAliasTmp)->(EOF()))

        nFerias := (cAliasTmp)->ZDF_DIASAL
            
     EndIf

       (cAliasTmp)->(dbCloseArea())
        
      

RestArea(aArea)

Return(nFerias)  
