/*{Protheus.doc} zGozFer_Pe 

@description Ponto de entrada da função zGozFer que faz o calculo do saldo de férias do colaborador
@author  	Hiago   
@return 	Undefinied

*/
#include 'protheus.ch'
#include 'parmtype.ch'
#include 'totvs.ch'
#Include "FWMVCDEF.ch"
#Include 'TopConn.ch'

#define PE_OBJETO_FORM 		1 	//Objeto do formulÃ¡rio ou do modelo, conforme o caso
#define PE_ID_PONTO_EXEC	2   //ID do local de execuÃ§Ã£o do ponto de entrada
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
Local oModel := Nil
local oZDFMod := NIL


private aRotina     := {}

    cQryAux += " SELECT ZDF_FILIAL AS ZDF_FILIAL, "
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

    
    //subtrai os dias gozados de ferias
    
    While ( !(cAliasTmp)->(Eof()) .And.  nDGozo > 0)

      nDiaSal := (cAliasTmp)->ZDF_DIASAL

       If(nDGozo > nDiaSal)

            nDGozo -=  nDiaSal

            nDiaSal := 0
       Else

            nDiaSal -= nDGozo

            nDGozo := 0 

       EndIf

            oModel := FWLoadModel("zDirFer")

            dbSelectArea("ZDF")
            DbSetOrder(2)
            DbGoTop()
            MsSeek((cAliasTmp)->ZDF_FILIAL + (cAliasTmp)->ZDF_CPF + DTos((cAliasTmp)->ZDF_INIAQ) )
            
            oModel:SetOperation(MODEL_OPERATION_UPDATE)
            oModel:Activate()
            oZDFMod := oModel:GetModel("FORMZDF")

            oZDFMod:SetValue("ZDF_FILIAL", (cAliasTmp)->ZDF_FILIAL)
            oZDFMod:SetValue("ZDF_CPF",    (cAliasTmp)->ZDF_CPF)
            oZDFMod:SetValue("ZDF_NOME",    "XXX")
            oZDFMod:SetValue("ZDF_INIAQ",  (cAliasTmp)->ZDF_INIAQ)
            oZDFMod:SetValue("ZDF_FIMAQ",  (cAliasTmp)->ZDF_FIMAQ)
            oZDFMod:SetValue("ZDF_VENFE",  (cAliasTmp)->ZDF_VENFE)
            oZDFMod:SetValue("ZDF_LIMIGO", (cAliasTmp)->ZDF_LIMIGO)
            oZDFMod:SetValue("ZDF_DIASAL",  nDiaSal)
           

            If oModel:VldData()
                oModel:CommitData()
            Else
                VarInfo("Erro ao incluir",oModel:GetErrorMessage())
                 Help(NIL, NIL, "Erro ao alterar direito de férias ", NIL,"Erro : " + oModel:GetErrorMessage(), 1, 0, NIL, NIL, NIL, NIL, NIL, {"Preencha Corretamente os campos  "})
  
            EndIf

            oModel:DeActivate()
            oModel:Destroy()
            oModel := NIL

      (cAliasTmp)-> (dbskip())
         
    enddo
   
    (cAliasTmp)->(dbCloseArea())

Return
