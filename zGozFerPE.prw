#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'
#Include "FWMVCDEF.ch"
#Include 'TopConn.ch'

#define PE_OBJETO_FORM 		1 	//Objeto do formulário ou do modelo, conforme o caso
#define PE_ID_PONTO_EXEC	2   //ID do local de execução do ponto de entrada
#define PE_ID_FORM

User Function MZGOZFER()

Local aArea      := GetArea()
Local aParam     := PARAMIXB
Local cIdModel   := ''
Local cIdPonto   := ''
Local oObj 		  := Nil
Local xRet 		:= .T.

//Default cCpf := ' ' 

    oObj 	 := aParam[PE_OBJETO_FORM  ]
 	cIdPonto := aParam[PE_ID_PONTO_EXEC]
 	cIdModel := aParam[PE_ID_FORM	   ] 


    IF(cIdPonto == 'MODELCOMMITNTTS')

    
    SubFer()


    EndIf

RestArea(aArea)

Return xRet 

Static Function SubFer()

Local cNameZDF  := RetSqlName("ZDF")
Local cQryAux   := ""
Local cAliasTmp := 'MZGOZFER_' + FWTimeStamp()
local nDGozo    := fwfldGet("ZGF_DIGOZO") 
Local cCpf      := fwfldGet("ZGF_CPF")
local nDiaSal   := 0
Local aDiaRes   := {}
local aAreaZDF  := {}

Private oModel := StaticCall(zDirFer, ModelDef)
private aRotina     := {}



    cQryAux += " SELECT ZDF_DIASAL AS ZDF_DIASAL, "
    cQryAux += " ZDF_FILIAL AS ZDF_FILIAL, "
    cQryAux += " ZDF_INIAQ AS ZDF_INIAQ, "
    cQryAux += " ZDF_FIMAQ AS ZDF_FIMAQ, "
    cQryAux += " ZDF_VENFE AS ZDF_VENFE, "
    cQryAux += " ZDF_LIMIGO AS ZDF_LIMIGO, "
    cQryAux += " ZDF_DIASAL AS ZDF_DIASAL, "
    cQryAux += " ZDF_CPF AS ZDF_CPF"
    cQryAux += " FROM " +cNameZDF+ " AS ZDF "
    cQryAux += " WHERE  ZDF_FILIAL = '" + FWxFilial("ZDF") +"' "
    cQryAux += " AND ZDF_CPF = '" + cCpf + "' " 
    cQryAux += " AND ZDF_DIASAL > 0 "
    cQryAux += " AND ZDF.D_E_L_E_T_ = '' "
    cQryAux += " ORDER BY ZDF_CPF, ZDF_INIAQ "

    

    TcQuery cQryAux New Alias (cAliasTmp)

    TCSetField((cAliasTmp),"ZDF_INIAQ","D")
    TCSetField((cAliasTmp),"ZDF_FIMAQ","D")
    TCSetField((cAliasTmp),"ZDF_VENFE","D")
    TCSetField((cAliasTmp),"ZDF_LIMIGO","D")

    dbSelectArea(cAliasTmp)

    

    While ( !(cAliasTmp)->(Eof()) .And.  nDGozo > 0)

      nDiaSal := (cAliasTmp)->ZDF_DIASAL

       If (nDGozo > nDiaSal)

       nDGozo -=  nDiaSal

       nDiaSal := 0


       Else

        nDiaSal -= nDGozo

        nDGozo := 0 

       EndIf

       

            aAdd(aDiaRes, {"ZDF_FILIAL",(cAliasTmp)->ZDF_FILIAL,Nil})
            aAdd(aDiaRes, {"ZDF_CPF",(cAliasTmp)->ZDF_CPF,Nil})
            aAdd(aDiaRes, {"ZDF_INIAQ",(cAliasTmp)->ZDF_INIAQ,Nil})
            // aAdd(aDiaRes, {"ZDF_FIMAQ",(cAliasTmp)->ZDF_FIMAQ,Nil})
            // aAdd(aDiaRes, {"ZDF_VENFE",(cAliasTmp)->ZDF_VENFE,Nil})
            // aAdd(aDiaRes, {"ZDF_LIMIGO",(cAliasTmp)->ZDF_LIMIGO,Nil})
            aAdd(aDiaRes, {"ZDF_DIASAL",nDiaSal,Nil})

            aAreaZDF:= ZDF->(GetArea())
            
            dbSelectArea("ZDF")
            DbSetOrder(2)
            DbGoTop()
            MsSeek((cAliasTmp)->ZDF_FILIAL + (cAliasTmp)->ZDF_CPF + DTos((cAliasTmp)->ZDF_INIAQ) )
            
            FWMVCRotAuto(    oModel,;
                            "ZDF",;
                            MODEL_OPERATION_UPDATE,;
                            {{"FORMZDF", aDiaRes}}  )
            RestArea(aAreaZDF)
            
      aDiaRes  := {}  
      (cAliasTmp)-> (dbskip())
       
        
    enddo
   
    (cAliasTmp)->(dbCloseArea())

Return
