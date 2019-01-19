RubyPopbillExample::Application.routes.draw do
  get "htcashbill/index"
  get "httaxinvoice/index"
  get "closedown/index"
  get "fax/index"
  get "message/index"
  get "cashbill/index"
  root :to => 'home#index'

  # 팝빌 전자세금계산서 API Service Route
  get "/TaxinvoiceExample" => 'taxinvoice#index'
  get "/TaxinvoiceExample/checkMgtKeyInUse" => 'taxinvoice#checkMgtKeyInUse', via: [:get]
  get "/TaxinvoiceExample/registIssue" => 'taxinvoice#registIssue', via: [:get]
  get "/TaxinvoiceExample/register" => 'taxinvoice#register', via: [:get]
  get "/TaxinvoiceExample/update" => 'taxinvoice#update', via: [:get]
  get "/TaxinvoiceExample/issue" => 'taxinvoice#issue', via: [:get]
  get "/TaxinvoiceExample/cancelIssue" => 'taxinvoice#cancelIssue', via: [:get]
  get "/TaxinvoiceExample/send" => 'taxinvoice#sendTI', via: [:get]
  get "/TaxinvoiceExample/cancelSend" => 'taxinvoice#cancelSend', via: [:get]
  get "/TaxinvoiceExample/accept" => 'taxinvoice#accept', via: [:get]
  get "/TaxinvoiceExample/deny" => 'taxinvoice#deny', via: [:get]
  get "/TaxinvoiceExample/delete" => 'taxinvoice#delete', via: [:get]
  get "/TaxinvoiceExample/registRequest" => 'taxinvoice#registRequest', via: [:get]
  get "/TaxinvoiceExample/request" => 'taxinvoice#requestTI', via: [:get]
  get "/TaxinvoiceExample/cancelRequest" => 'taxinvoice#cancelRequest', via: [:get]
  get "/TaxinvoiceExample/refuse" => 'taxinvoice#refuse', via: [:get]
  get "/TaxinvoiceExample/sendToNTS" => 'taxinvoice#sendToNTS', via: [:get]
  get "/TaxinvoiceExample/getInfo" => 'taxinvoice#getInfo', via: [:get]
  get "/TaxinvoiceExample/getInfos" => 'taxinvoice#getInfos', via: [:get]
  get "/TaxinvoiceExample/getDetailInfo" => 'taxinvoice#getDetailInfo', via: [:get]
  get "/TaxinvoiceExample/search" => 'taxinvoice#search', via: [:get]
  get "/TaxinvoiceExample/getLogs" => 'taxinvoice#getLogs', via: [:get]
  get "/TaxinvoiceExample/getURL" => 'taxinvoice#getURL', via: [:get]
  get "/TaxinvoiceExample/getPopUpURL" => 'taxinvoice#getPopUpURL', via: [:get]
  get "/TaxinvoiceExample/getPrintURL" => 'taxinvoice#getPrintURL', via: [:get]
  get "/TaxinvoiceExample/getMassPrintURL" => 'taxinvoice#getMassPrintURL', via: [:get]
  get "/TaxinvoiceExample/getEPrintURL" => 'taxinvoice#getEPrintURL', via: [:get]
  get "/TaxinvoiceExample/getMailURL" => 'taxinvoice#getMailURL', via: [:get]
  get "/TaxinvoiceExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/TaxinvoiceExample/getSealURL" => 'taxinvoice#getSealURL', via: [:get]
  get "/TaxinvoiceExample/attachFile" => 'taxinvoice#attachFile', via: [:get]
  get "/TaxinvoiceExample/deleteFile" => 'taxinvoice#deleteFile', via: [:get]
  get "/TaxinvoiceExample/getFiles" => 'taxinvoice#getFiles', via: [:get]
  get "/TaxinvoiceExample/sendEmail" => 'taxinvoice#sendEmail', via: [:get]
  get "/TaxinvoiceExample/sendSMS" => 'taxinvoice#sendSMS', via: [:get]
  get "/TaxinvoiceExample/sendFAX" => 'taxinvoice#sendFax', via: [:get]
  get "/TaxinvoiceExample/attachStatement" => 'taxinvoice#attachStatement', via: [:get]
  get "/TaxinvoiceExample/detachStatement" => 'taxinvoice#detachStatement', via: [:get]
  get "/TaxinvoiceExample/getEmailPublicKeys" => 'taxinvoice#getEmailPublicKeys', via: [:get]
  get "/TaxinvoiceExample/assignMgtKey" => 'taxinvoice#assignMgtKey', via: [:get]
  get "/TaxinvoiceExample/listEmailConfig" => 'taxinvoice#listEmailConfig', via: [:get]
  get "/TaxinvoiceExample/updateEmailConfig" => 'taxinvoice#updateEmailConfig', via: [:get]
  get "/TaxinvoiceExample/getTaxCertURL" => 'taxinvoice#getTaxCertURL', via: [:get]
  get "/TaxinvoiceExample/getCertificateExpireDate" => 'taxinvoice#getCertificateExpireDate', via: [:get]
  get "/TaxinvoiceExample/checkCertValidation" => 'taxinvoice#checkCertValidation', via: [:get]
  get "/TaxinvoiceExample/getBalance" => 'taxinvoice#getBalance', via: [:get]
  get "/TaxinvoiceExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/TaxinvoiceExample/getPartnerURL" => 'taxinvoice#getPartnerURL', via: [:get]
  get "/TaxinvoiceExample/getPartnerBalance" => 'taxinvoice#getPartnerBalance', via: [:get]
  get "/TaxinvoiceExample/getChargeInfo" => 'taxinvoice#getChargeInfo', via: [:get]
  get "/TaxinvoiceExample/getUnitCost" => 'taxinvoice#getUnitCost', via: [:get]
  get "/TaxinvoiceExample/checkIsMember" => 'taxinvoice#checkIsMember', via: [:get]
  get "/TaxinvoiceExample/checkID" => 'taxinvoice#checkID', via: [:get]
  get "/TaxinvoiceExample/joinMember" => 'taxinvoice#joinMember', via: [:get]
  get "/TaxinvoiceExample/getCorpInfo" => 'taxinvoice#getCorpInfo', via: [:get]
  get "/TaxinvoiceExample/updateCorpInfo" => 'taxinvoice#updateCorpInfo', via: [:get]
  get "/TaxinvoiceExample/registContact" => 'taxinvoice#registContact', via: [:get]
  get "/TaxinvoiceExample/listContact" => 'taxinvoice#listContact', via: [:get]
  get "/TaxinvoiceExample/updateContact" => 'taxinvoice#updateContact', via: [:get]


  # 팝빌 전자명세서 API Service route
  get "/StatementExample" => 'statement#index'
  get "/StatementExample/checkMgtKeyInUse" => 'statement#checkMgtKeyInUse', via: [:get]
  get "/StatementExample/registIssue" => 'statement#registIssue', via: [:get]
  get "/StatementExample/register" => 'statement#register', via: [:get]
  get "/StatementExample/update" => 'statement#update', via: [:get]
  get "/StatementExample/issue" => 'statement#issue', via: [:get]
  get "/StatementExample/cancelIssue" => 'statement#cancelIssue', via: [:get]
  get "/StatementExample/delete" => 'statement#delete', via: [:get]
  get "/StatementExample/getInfo" => 'statement#getInfo', via: [:get]
  get "/StatementExample/getInfos" => 'statement#getInfos', via: [:get]
  get "/StatementExample/getDetailInfo" => 'statement#getDetailInfo', via: [:get]
  get "/StatementExample/search" => 'statement#search', via: [:get]
  get "/StatementExample/getLogs" => 'statement#getLogs', via: [:get]
  get "/StatementExample/getURL" => 'statement#getURL', via: [:get]
  get "/StatementExample/getPopUpURL" => 'statement#getPopUpURL', via: [:get]
  get "/StatementExample/getPrintURL" => 'statement#getPrintURL', via: [:get]
  get "/StatementExample/getEPrintURL" => 'statement#getEPrintURL', via: [:get]
  get "/StatementExample/getMassPrintURL" => 'statement#getMassPrintURL', via: [:get]
  get "/StatementExample/getMailURL" => 'statement#getMailURL', via: [:get]
  get "/StatementExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/StatementExample/attachFile" => 'statement#attachFile', via: [:get]
  get "/StatementExample/deleteFile" => 'statement#deleteFile', via: [:get]
  get "/StatementExample/getFiles" => 'statement#getFiles', via: [:get]
  get "/StatementExample/sendEmail" => 'statement#sendEmail', via: [:get]
  get "/StatementExample/sendSMS" => 'statement#sendSMS', via: [:get]
  get "/StatementExample/sendFAX" => 'statement#sendFAX', via: [:get]
  get "/StatementExample/FAXSend" => 'statement#FAXSend', via: [:get]
  get "/StatementExample/attachStatement" => 'statement#attachStatement', via: [:get]
  get "/StatementExample/detachStatement" => 'statement#detachStatement', via: [:get]
  get "/StatementExample/listEmailConfig" => 'statement#listEmailConfig', via: [:get]
  get "/StatementExample/updateEmailConfig" => 'statement#updateEmailConfig', via: [:get]
  get "/StatementExample/getBalance" => 'statement#getBalance', via: [:get]
  get "/StatementExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/StatementExample/getPartnerBalance" => 'statement#getPartnerBalance', via: [:get]
  get "/StatementExample/getPartnerURL" => 'statement#getPartnerURL', via: [:get]
  get "/StatementExample/getUnitCost" => 'statement#getUnitCost', via: [:get]
  get "/StatementExample/getChargeInfo" => 'statement#getChargeInfo', via: [:get]
  get "/StatementExample/checkIsMember" => 'statement#checkIsMember', via: [:get]
  get "/StatementExample/checkID" => 'statement#checkID', via: [:get]
  get "/StatementExample/joinMember" => 'statement#joinMember', via: [:get]
  get "/StatementExample/getCorpInfo" => 'statement#getCorpInfo', via: [:get]
  get "/StatementExample/updateCorpInfo" => 'statement#updateCorpInfo', via: [:get]
  get "/StatementExample/listContact" => 'statement#listContact', via: [:get]
  get "/StatementExample/updateContact" => 'statement#updateContact', via: [:get]
  get "/StatementExample/registContact" => 'statement#registContact', via: [:get]


  # 팝빌 현금영수증 API Service route
  get "/CashbillExample" => 'cashbill#index'
  get "/CashbillExample/checkMgtKeyInUse" => 'cashbill#checkMgtKeyInUse', via: [:get]
  get "/CashbillExample/registIssue" => 'cashbill#registIssue', via: [:get]
  get "/CashbillExample/register" => 'cashbill#register', via: [:get]
  get "/CashbillExample/update" => 'cashbill#update', via: [:get]
  get "/CashbillExample/issue" => 'cashbill#issue', via: [:get]
  get "/CashbillExample/cancelIssue" => 'cashbill#cancelIssue', via: [:get]
  get "/CashbillExample/delete" => 'cashbill#delete', via: [:get]
  get "/CashbillExample/revokeRegistIssue" => 'cashbill#revokeRegistIssue', via: [:get]
  get "/CashbillExample/revokeRegistIssue_part" => 'cashbill#revokeRegistIssue_part', via: [:get]
  get "/CashbillExample/revokeRegister" => 'cashbill#revokeRegister', via: [:get]
  get "/CashbillExample/revokeRegister_part" => 'cashbill#revokeRegister_part', via: [:get]
  get "/CashbillExample/getInfo" => 'cashbill#getInfo', via: [:get]
  get "/CashbillExample/getInfos" => 'cashbill#getInfos', via: [:get]
  get "/CashbillExample/search" => 'cashbill#search', via: [:get]
  get "/CashbillExample/getDetailInfo" => 'cashbill#getDetailInfo', via: [:get]
  get "/CashbillExample/getLogs" => 'cashbill#getLogs', via: [:get]
  get "/CashbillExample/getURL" => 'cashbill#getURL', via: [:get]
  get "/CashbillExample/getPopUpURL" => 'cashbill#getPopUpURL', via: [:get]
  get "/CashbillExample/getPrintURL" => 'cashbill#getPrintURL', via: [:get]
  get "/CashbillExample/getEPrintURL" => 'cashbill#getEPrintURL', via: [:get]
  get "/CashbillExample/getMassPrintURL" => 'cashbill#getMassPrintURL', via: [:get]
  get "/CashbillExample/getMailURL" => 'cashbill#getMailURL', via: [:get]
  get "/CashbillExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/CashbillExample/sendEmail" => 'cashbill#sendEmail', via: [:get]
  get "/CashbillExample/sendSMS" => 'cashbill#sendSMS', via: [:get]
  get "/CashbillExample/sendFAX" => 'cashbill#sendFAX', via: [:get]
  get "/CashbillExample/listEmailConfig" => 'cashbill#listEmailConfig', via: [:get]
  get "/CashbillExample/updateEmailConfig" => 'cashbill#updateEmailConfig', via: [:get]
  get "/CashbillExample/getBalance" => 'cashbill#getBalance', via: [:get]
  get "/CashbillExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/CashbillExample/getPartnerBalance" => 'cashbill#getPartnerBalance', via: [:get]
  get "/CashbillExample/getPartnerURL" => 'cashbill#getPartnerURL', via: [:get]
  get "/CashbillExample/getChargeInfo" => 'cashbill#getChargeInfo', via: [:get]
  get "/CashbillExample/getUnitCost" => 'cashbill#getUnitCost', via: [:get]
  get "/CashbillExample/checkIsMember" => 'cashbill#checkIsMember', via: [:get]
  get "/CashbillExample/joinMember" => 'cashbill#joinMember', via: [:get]
  get "/CashbillExample/checkID" => 'cashbill#checkID', via: [:get]
  get "/CashbillExample/getCorpInfo" => 'cashbill#getCorpInfo', via: [:get]
  get "/CashbillExample/updateCorpInfo" => 'cashbill#updateCorpInfo', via: [:get]
  get "/CashbillExample/listContact" => 'cashbill#listContact', via: [:get]
  get "/CashbillExample/updateContact" => 'cashbill#updateContact', via: [:get]
  get "/CashbillExample/registContact" => 'cashbill#registContact', via: [:get]


  # 팝빌 문자 API Service route
  get "/MessageExample" => 'message#index'
  get "/MessageExample/getSenderNumberMgtURL" => 'message#getSenderNumberMgtURL', via: [:get]
  get "/MessageExample/getSenderNumberList" => 'message#getSenderNumberList', via: [:get]
  get "/MessageExample/sendSMS" => 'message#sendSMS', via: [:get]
  get "/MessageExample/sendSMS_Multi" => 'message#sendSMS_Multi', via: [:get]
  get "/MessageExample/sendLMS" => 'message#sendLMS', via: [:get]
  get "/MessageExample/sendLMS_Multi" => 'message#sendLMS_Multi', via: [:get]
  get "/MessageExample/sendXMS" => 'message#sendXMS', via: [:get]
  get "/MessageExample/sendXMS_Multi" => 'message#sendXMS_Multi', via: [:get]
  get "/MessageExample/sendMMS" => 'message#sendMMS', via: [:get]
  get "/MessageExample/sendMMS_Multi" => 'message#sendMMS_Multi', via: [:get]
  get "/MessageExample/cancelReserve" => 'message#cancelReserve', via: [:get]
  get "/MessageExample/cancelReserveRN" => 'message#cancelReserveRN', via: [:get]
  get "/MessageExample/getMessages" => 'message#getMessages', via: [:get]
  get "/MessageExample/getMessagesRN" => 'message#getMessagesRN', via: [:get]
  get "/MessageExample/search" => 'message#search', via: [:get]
  get "/MessageExample/getStates" => 'message#getStates', via: [:get]
  get "/MessageExample/getSentListURL" => 'message#getSentListURL', via: [:get]
  get "/MessageExample/getAutoDenyList" => 'message#getAutoDenyList', via: [:get]
  get "/MessageExample/getBalance" => 'message#getBalance', via: [:get]
  get "/MessageExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/MessageExample/getPartnerBalance" => 'message#getPartnerBalance', via: [:get]
  get "/MessageExample/getPartnerURL" => 'message#getPartnerURL', via: [:get]
  get "/MessageExample/getUnitCost" => 'message#getUnitCost', via: [:get]
  get "/MessageExample/getChargeInfo" => 'message#getChargeInfo', via: [:get]
  get "/MessageExample/checkIsMember" => 'message#checkIsMember', via: [:get]
  get "/MessageExample/checkID" => 'message#checkID', via: [:get]
  get "/MessageExample/joinMember" => 'message#joinMember', via: [:get]
  get "/MessageExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/MessageExample/getCorpInfo" => 'message#getCorpInfo', via: [:get]
  get "/MessageExample/updateCorpInfo" => 'message#updateCorpInfo', via: [:get]
  get "/MessageExample/registContact" => 'message#registContact', via: [:get]
  get "/MessageExample/listContact" => 'message#listContact', via: [:get]
  get "/MessageExample/updateContact" => 'message#updateContact', via: [:get]


  # 팝빌 팩스 API Service route
  get "/FaxExample" => 'fax#index'
  get "/FaxExample/getSenderNumberMgtURL" => 'fax#getSenderNumberMgtURL', via: [:get]
  get "/FaxExample/getSenderNumberList" => 'fax#getSenderNumberList', via: [:get]
  get "/FaxExample/sendFAX" => 'fax#sendFax', via: [:get]
  get "/FaxExample/sendFAX_Multi" => 'fax#sendFax_Multi', via: [:get]
  get "/FaxExample/resendFAX" => 'fax#resendFax', via: [:get]
  get "/FaxExample/resendFAXRN" => 'fax#resendFAXRN', via: [:get]
  get "/FaxExample/resendFAX_Multi" => 'fax#resendFax_Multi', via: [:get]
  get "/FaxExample/resendFAXRN_multi" => 'fax#resendFAXRN_multi', via: [:get]
  get "/FaxExample/cancelReserve" => 'fax#cancelReserve', via: [:get]
  get "/FaxExample/cancelReserveRN" => 'fax#cancelReserveRN', via: [:get]
  get "/FaxExample/getFaxDetail" => 'fax#getFaxDetail', via: [:get]
  get "/FaxExample/getFaxDetailRN" => 'fax#getFaxDetailRN', via: [:get]
  get "/FaxExample/search" => 'fax#search', via: [:get]
  get "/FaxExample/getSentListURL" => 'fax#getSentListURL', via: [:get]
  get "/FaxExample/getPreviewURL" => 'fax#getPreviewURL', via: [:get]
  get "/FaxExample/getBalance" => 'fax#getBalance', via: [:get]
  get "/FaxExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/FaxExample/getPartnerBalance" => 'fax#getPartnerBalance', via: [:get]
  get "/FaxExample/getPartnerURL" => 'fax#getPartnerURL', via: [:get]
  get "/FaxExample/getChargeInfo" => 'fax#getChargeInfo', via: [:get]
  get "/FaxExample/getUnitCost" => 'fax#getUnitCost', via: [:get]
  get "/FaxExample/checkIsMember" => 'fax#checkIsMember', via: [:get]
  get "/FaxExample/checkID" => 'fax#checkID', via: [:get]
  get "/FaxExample/joinMember" => 'fax#joinMember', via: [:get]
  get "/FaxExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/FaxExample/registContact" => 'fax#registContact', via: [:get]
  get "/FaxExample/listContact" => 'fax#listContact', via: [:get]
  get "/FaxExample/updateContact" => 'fax#updateContact', via: [:get]
  get "/FaxExample/getCorpInfo" => 'fax#getCorpInfo', via: [:get]
  get "/FaxExample/updateCorpInfo" => 'fax#updateCorpInfo', via: [:get]


  # 카카오톡 API Service route
  get "/KakaoExample" => 'kakao#index'
  get "/KakaoExample/getPlusFriendMgtURL" => 'kakao#getPlusFriendMgtURL', via: [:get]
  get "/KakaoExample/listPlusFriendID" => 'kakao#listPlusFriendID', via: [:get]
  get "/KakaoExample/getSenderNumberMgtURL" => 'kakao#getSenderNumberMgtURL', via: [:get]
  get "/KakaoExample/getSenderNumberList" => 'kakao#getSenderNumberList', via: [:get]
  get "/KakaoExample/getATSTemplateMgtURL" => 'kakao#getATSTemplateMgtURL', via: [:get]
  get "/KakaoExample/listATSTemplate" => 'kakao#listATSTemplate', via: [:get]
  get "/KakaoExample/sendATS_one" => 'kakao#sendATS_one', via: [:get]
  get "/KakaoExample/sendATS_same" => 'kakao#sendATS_same', via: [:get]
  get "/KakaoExample/sendATS_multi" => 'kakao#sendATS_multi', via: [:get]
  get "/KakaoExample/sendFTS_one" => 'kakao#sendFTS_one', via: [:get]
  get "/KakaoExample/sendFTS_same" => 'kakao#sendFTS_same', via: [:get]
  get "/KakaoExample/sendFTS_multi" => 'kakao#sendFTS_multi', via: [:get]
  get "/KakaoExample/sendFMS_one" => 'kakao#sendFMS_one', via: [:get]
  get "/KakaoExample/sendFMS_same" => 'kakao#sendFMS_same', via: [:get]
  get "/KakaoExample/sendFMS_multi" => 'kakao#sendFMS_multi', via: [:get]
  get "/KakaoExample/cancelReserve" => 'kakao#cancelReserve', via: [:get]
  get "/KakaoExample/cancelReserveRN" => 'kakao#cancelReserveRN', via: [:get]
  get "/KakaoExample/getMessages" => 'kakao#getMessages', via: [:get]
  get "/KakaoExample/getMessagesRN" => 'kakao#getMessagesRN', via: [:get]
  get "/KakaoExample/search" => 'kakao#search', via: [:get]
  get "/KakaoExample/getSentListURL" => 'kakao#getSentListURL', via: [:get]
  get "/KakaoExample/getUnitCost" => 'kakao#getUnitCost', via: [:get]
  get "/KakaoExample/getChargeInfo" => 'kakao#getChargeInfo', via: [:get]
  get "/KakaoExample/getBalance" => 'kakao#getBalance', via: [:get]
  get "/KakaoExample/getPartnerBalance" => 'kakao#getPartnerBalance', via: [:get]
  get "/KakaoExample/getPartnerURL" => 'kakao#getPartnerURL', via: [:get]
  get "/KakaoExample/checkIsMember" => 'kakao#checkIsMember', via: [:get]
  get "/KakaoExample/checkID" => 'kakao#checkID', via: [:get]
  get "/KakaoExample/joinMember" => 'kakao#joinMember', via: [:get]
  get "/KakaoExample/registContact" => 'kakao#registContact', via: [:get]
  get "/KakaoExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/KakaoExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/KakaoExample/listContact" => 'kakao#listContact', via: [:get]
  get "/KakaoExample/updateContact" => 'kakao#updateContact', via: [:get]
  get "/KakaoExample/getCorpInfo" => 'kakao#getCorpInfo', via: [:get]
  get "/KakaoExample/updateCorpInfo" => 'kakao#updateCorpInfo', via: [:get]

  # 팝빌 홈택스 전자세금계산서 연동 API Service route
  get "/HTTaxinvoiceExample" => 'httaxinvoice#index'
  get "/HTTaxinvoiceExample/requestJob" => 'httaxinvoice#requestJob', via: [:get]
  get "/HTTaxinvoiceExample/getJobState" => 'httaxinvoice#getJobState', via: [:get]
  get "/HTTaxinvoiceExample/listActiveJob" => 'httaxinvoice#listActiveJob', via: [:get]
  get "/HTTaxinvoiceExample/search" => 'httaxinvoice#search', via: [:get]
  get "/HTTaxinvoiceExample/summary" => 'httaxinvoice#summary', via: [:get]
  get "/HTTaxinvoiceExample/getTaxinvoice" => 'httaxinvoice#getTaxinvoice', via: [:get]
  get "/HTTaxinvoiceExample/getXML" => 'httaxinvoice#getXML', via: [:get]
  get "/HTTaxinvoiceExample/getPopUpURL" => 'httaxinvoice#getPopUpURL', via: [:get]
  get "/HTTaxinvoiceExample/getCertificatePopUpURL" => 'httaxinvoice#getCertificatePopUpURL', via: [:get]
  get "/HTTaxinvoiceExample/getCertificateExpireDate" => 'httaxinvoice#getCertificateExpireDate', via: [:get]
  get "/HTTaxinvoiceExample/checkCertValidation" => 'httaxinvoice#checkCertValidation', via: [:get]
  get "/HTTaxinvoiceExample/registDeptUser" => 'httaxinvoice#registDeptUser', via: [:get]
  get "/HTTaxinvoiceExample/checkDeptUser" => 'httaxinvoice#checkDeptUser', via: [:get]
  get "/HTTaxinvoiceExample/checkLoginDeptUser" => 'httaxinvoice#checkLoginDeptUser', via: [:get]
  get "/HTTaxinvoiceExample/deleteDeptUser" => 'httaxinvoice#deleteDeptUser', via: [:get]
  get "/HTTaxinvoiceExample/checkIsMember" => 'httaxinvoice#checkIsMember', via: [:get]
  get "/HTTaxinvoiceExample/checkID" => 'httaxinvoice#checkID', via: [:get]
  get "/HTTaxinvoiceExample/joinMember" => 'httaxinvoice#joinMember', via: [:get]
  get "/HTTaxinvoiceExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/HTTaxinvoiceExample/getCorpInfo" => 'httaxinvoice#getCorpInfo', via: [:get]
  get "/HTTaxinvoiceExample/updateCorpInfo" => 'httaxinvoice#updateCorpInfo', via: [:get]
  get "/HTTaxinvoiceExample/registContact" => 'httaxinvoice#registContact', via: [:get]
  get "/HTTaxinvoiceExample/listContact" => 'httaxinvoice#listContact', via: [:get]
  get "/HTTaxinvoiceExample/updateContact" => 'httaxinvoice#updateContact', via: [:get]
  get "/HTTaxinvoiceExample/getBalance" => 'httaxinvoice#getBalance', via: [:get]
  get "/HTTaxinvoiceExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/HTTaxinvoiceExample/getPartnerBalance" => 'httaxinvoice#getPartnerBalance', via: [:get]
  get "/HTTaxinvoiceExample/getPartnerURL" => 'httaxinvoice#getPartnerURL', via: [:get]
  get "/HTTaxinvoiceExample/getChargeInfo" => 'httaxinvoice#getChargeInfo', via: [:get]
  get "/HTTaxinvoiceExample/getFlatRatePopUpURL" => 'httaxinvoice#getFlatRatePopUpURL', via: [:get]
  get "/HTTaxinvoiceExample/getFlatRateState" => 'httaxinvoice#getFlatRateState', via: [:get]


  # 팝빌 홈택스 현금영수증 연동 API Service route
  get "/HTCashbillExample" => 'htcashbill#index'
  get "/HTCashbillExample/requestJob" => 'htcashbill#requestJob', via: [:get]
  get "/HTCashbillExample/getJobState" => 'htcashbill#getJobState', via: [:get]
  get "/HTCashbillExample/listActiveJob" => 'htcashbill#listActiveJob', via: [:get]
  get "/HTCashbillExample/search" => 'htcashbill#search', via: [:get]
  get "/HTCashbillExample/summary" => 'htcashbill#summary', via: [:get]
  get "/HTCashbillExample/getCertificatePopUpURL" => 'htcashbill#getCertificatePopUpURL', via: [:get]
  get "/HTCashbillExample/getCertificateExpireDate" => 'htcashbill#getCertificateExpireDate', via: [:get]
  get "/HTCashbillExample/checkCertValidation" => 'httaxinvoice#checkCertValidation', via: [:get]
  get "/HTCashbillExample/registDeptUser" => 'httaxinvoice#registDeptUser', via: [:get]
  get "/HTCashbillExample/checkDeptUser" => 'httaxinvoice#checkDeptUser', via: [:get]
  get "/HTCashbillExample/checkLoginDeptUser" => 'httaxinvoice#checkLoginDeptUser', via: [:get]
  get "/HTCashbillExample/deleteDeptUser" => 'httaxinvoice#deleteDeptUser', via: [:get]
  get "/HTCashbillExample/getBalance" => 'htcashbill#getBalance', via: [:get]
  get "/HTCashbillExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/HTCashbillExample/getPartnerBalance" => 'htcashbill#getPartnerBalance', via: [:get]
  get "/HTCashbillExample/getPartnerURL" => 'htcashbill#getPartnerURL', via: [:get]
  get "/HTCashbillExample/getChargeInfo" => 'htcashbill#getChargeInfo', via: [:get]
  get "/HTCashbillExample/getFlatRatePopUpURL" => 'htcashbill#getFlatRatePopUpURL', via: [:get]
  get "/HTCashbillExample/getFlatRateState" => 'htcashbill#getFlatRateState', via: [:get]
  get "/HTCashbillExample/checkIsMember" => 'htcashbill#checkIsMember', via: [:get]
  get "/HTCashbillExample/checkID" => 'htcashbill#checkID', via: [:get]
  get "/HTCashbillExample/joinMember" => 'htcashbill#joinMember', via: [:get]
  get "/HTCashbillExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
  get "/HTCashbillExample/getCorpInfo" => 'htcashbill#getCorpInfo', via: [:get]
  get "/HTCashbillExample/updateCorpInfo" => 'htcashbill#updateCorpInfo', via: [:get]
  get "/HTCashbillExample/registContact" => 'htcashbill#registContact', via: [:get]
  get "/HTCashbillExample/updateContact" => 'htcashbill#updateContact', via: [:get]
  get "/HTCashbillExample/listContact" => 'htcashbill#listContact', via: [:get]


  # 팝빌 휴폐업조회 API Service route
  get "/ClosedownExample" => 'closedown#index'
  get "/ClosedownExample/checkCorpNum" => 'closedown#checkCorpNum', via: [:get]
  get "/ClosedownExample/checkCorpNums" => 'closedown#checkCorpNums', via: [:get]
  get "/ClosedownExample/getBalance" => 'closedown#getBalance', via: [:get]
  get "/ClosedownExample/getChargeURL" => 'taxinvoice#getChargeURL', via: [:get]
  get "/ClosedownExample/getPartnerBalance" => 'closedown#getPartnerBalance', via: [:get]
  get "/ClosedownExample/getPartnerURL" => 'closedown#getPartnerURL', via: [:get]
  get "/ClosedownExample/getChargeInfo" => 'closedown#getChargeInfo', via: [:get]
  get "/ClosedownExample/getUnitCost" => 'closedown#getUnitCost', via: [:get]
  get "/ClosedownExample/checkIsMember" => 'closedown#checkIsMember', via: [:get]
  get "/ClosedownExample/checkID" => 'closedown#checkID', via: [:get]
  get "/ClosedownExample/joinMember" => 'closedown#joinMember', via: [:get]
  get "/ClosedownExample/updateCorpInfo" => 'closedown#updateCorpInfo', via: [:get]
  get "/ClosedownExample/registContact" => 'closedown#registContact', via: [:get]
  get "/ClosedownExample/listContact" => 'closedown#listContact', via: [:get]
  get "/ClosedownExample/updateContact" => 'closedown#updateContact', via: [:get]
  get "/ClosedownExample/getAccessURL" => 'taxinvoice#getAccessURL', via: [:get]
end