/*{Protheus.doc} zAutDiss

@description Calculo automatico do dissidio dos colabores buscados pela query

@author  	Hiago   


*/
 
#include 'protheus.ch' 
#include 'parmtype.ch'
#include 'totvs.ch'
#Include "FWMVCDEF.ch"
#Include 'TopConn.ch'

User Function zAutDiss()

Local aArea     := GetArea()
Local cQUERY    := ' '
Local cNameZHS  := retSqlname("ZHS")
Local cAliasTmp := 'zAutDiss_'+FWTimeStamp()
Local aAutDiss  := {}
Local dDate
Local nVlrAum   := 0

Private oModel := StaticCall(zHisSal1, ModelDef)
private aRotina     := {}

 



    If Pergunte("ZHISSAL1")

        cQUERY := " SELECT ZHS_FILIAL, ZHS_CPF, MAX(ZHS_VLRATU) AS 'ZHS_VLRATU'  "
        cQUERY += " FROM " + cNameZHS + " AS ZHS "
        cQUERY += " WHERE  ZHS_FILIAL = '" + FWxFilial( "ZHS") + "' "
        cQUERY += "  AND ZHS.D_E_L_E_T_ = ' ' "  
        cQUERY += " GROUP BY ZHS_FILIAL, ZHS_CPF "
        cQUERY := changeQuery(cQUERY)

        VarInfo("zAutDiss - query - " , cQUERY )

        TcQuery cQuery New Alias (cAliasTmp) 

        dbSelectArea(cAliasTmp)

        dDate:= MV_PAR01

        While !(cAliasTmp)->(Eof())

            nVlrAum := ZHS_VLRATU * MV_PAR02 / 100

            aAdd(aAutDiss, {"ZHS_FILIAL",(cAliasTmp)->ZHS_FILIAL    ,Nil})
            aAdd(aAutDiss, {"ZHS_CPF",(cAliasTmp)->ZHS_CPF          ,Nil})
            aAdd(aAutDiss,  {"ZHS_DTREAJ",dDate                 ,Nil})
            aAdd(aAutDiss, {"ZHS_VLRREA",nVlrAum                  ,Nil})
            aAdd(aAutDiss, {"ZHS_TPAUME","1"                    ,Nil})

           
            
            FWMVCRotAuto(    oModel,;
                            "ZHS",;
                            MODEL_OPERATION_INSERT,;
                            {{"FORMZHS", aAutDiss}}  )
    
            
                
            (cAliasTmp)->(dbskip())

            aAutDiss:= {}
        EndDo 
        (cAliasTmp)->(dbCloseArea())
    
    EndIf
    RestArea(aArea)
return
