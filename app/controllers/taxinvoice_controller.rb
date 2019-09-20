################################################################################
#
# POPBILL API Ruby On Rails SDK Example
#
# Updated : 2019-09-20
# Technical Support : 1600-9854 / 070-4304-2991~2 / code@linkhub.co.kr
#
# <Requirement>
# Change LinkID/SecretKey line 18, 21
#
################################################################################

require 'popbill/taxinvoice'

class TaxinvoiceController < ApplicationController

  # LinkID
  LinkID = "TESTER"

  # SecretKey
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # Business registration number of POPBILL user (10 digits except ‘-’)
  TestCorpNum = "1234567890"

  # POPBILL user ID
  TestUserID = "testkorea"

  # POPBILL e-Tax Invoice API Service Initialize
  TIService = TaxinvoiceService.instance(
      TaxinvoiceController::LinkID,
      TaxinvoiceController::SecretKey
  )

  # Configuration API Target, true-(POPBILL Test-bed), false-(POPBILL Real)
  TIService.setIsTest(true)

  ##############################################################################
  # Checking the availability of e-Tax invoice id
  ##############################################################################
  def checkMgtKeyInUse

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Invoice id assigned by partner    mgtKey = "20190917-01"

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    begin
      @response = TaxinvoiceController::TIService.checkMgtKeyInUse(
          corpNum,
          keyType,
          mgtKey,
      )

      if @response
        @value = "in use"
      else
        @value = "not use"
      end

      @name = "checkMgtKeyInUse"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Regist and issue the e-Tax invoice
  ##############################################################################
  def registIssue

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Seller invoice id (No redundancy)
    # - Combination of English letter, number, hyphen(‘-’) and underscore(‘_’)
    mgtKey = "20190917-01"

    # e-Tax Invoice object
    taxinvoice = {

        ######################### Seller Info #########################

        # Seller’s business registration number ( 10 digits except ‘-’ )
        "invoicerCorpNum" => corpNum,

        # [Seller] Identification number for minor place of business
        "invoicerTaxRegID" => "",

        # [Seller] Company name
        "invoicerCorpName" => "상호명",

        # [Seller] CEO’s name
        "invoicerCEOName" => "대표자명",

        # Seller invoice id (No redundancy)
        # - Combination of English letter, number, hyphen(‘-’) and underscore(‘_’)
        "invoicerMgtKey" => mgtKey,

        # [Seller] Company address
        "invoicerAddr" => "공급자 주소",

        # [Seller] Business type
        "invoicerBizType" => "공급자 업태",

        # [Seller] Business item
        "invoicerBizClass" => "공급자 종목",

        # [Seller] Name of the person in charge
        "invoicerContactName" => "공급자 담당자명",

        # [Seller] Email address of the person in charge
        "invoicerEmail" => "test@test.com",

        # [Seller] Mobile number of the person in charge
        "invoicerHP" => "010-111-222",

        # [Seller] Telephone number of the person in charge
        "invoicerTEL" => "070-4304-2991",

        # [Seller] Whether you send a notification SMS or not
        "invoicerSMSSendYN" => false,


        ######################### Buyer Info #########################

        # Put a KOREAN word [ “사업자(company)” or “개인(individual)” or “외국인(foreigner)” ]
        "invoiceeType" => "사업자",

        # [Buyer] Business registration number
        "invoiceeCorpNum" => "8888888888",

        # [Buyer] Identification number for minor place of business
        "invoiceeTaxRegId" => "",

        # [Buyer] Company name
        "invoiceeCorpName" => "공급받는자 상호",

        # [Buyer] CEO’s name
        "invoiceeCEOName" => "대표자 성명",

        # [Buyer] Invoice id (No redundancy)
        "invoiceeMgtKey" => "",

        # [Buyer] Company address
        "invoiceeAddr" => "공급받는자 주소",

        # [Buyer] Business type
        "invoiceeBizClass" => "공급받는자 종목",

        # [Buyer] Business item
        "invoiceeBizType" => "공급받는자 업태",

        # [Buyer] Name of the person in charge
        "invoiceeContactName1" => "공급받는자담당자명",

        # [Buyer] Email address of the person in charge
        "invoiceeEmail1" => "test@test.com",

        # [Buyer] Telephone number of the person in charge
        "invoiceeTEL1" => "070-1234-1234",

        # [Buyer] Mobile number of the person in charge
        "invoiceeHP1" => "010-123-1234",

        # Date of trading, Date format(yyyyMMdd) e.g. 20180509
        "writeDate" => "20190917",

        # Issuance type, Put a KOREAN word [ “정발행”(e-Tax invoice) or “역발행” (Requested e-Tax invoice) or “위수탁”(Delegated e-Tax invoice) ]
        "issueType" => "정발행",

        # Taxation type, Put a KOREAN word [ “과세” (Taxation) or “영세” (Zero-rate) or “면세” (Exemption) ]
        "taxType" => "과세",

        # Issuing Timing, Don't Change this field.
        "issueTiming" => "직접발행",

        # Charging direction
        # Put a KOREAN word[ “정과금(Charge to seller)” or “역과금(Charge to buyer” ]
        # (*Charge to buyer is only available in requested e-Tax invoice issuance process)
        "chargeDirection" => "정과금",

        # Receipt/Charge, Put a KOREAN word [ “영수”(Receipt) or “청구”(Charge)
        "purposeType" => "영수",

        # The sum of supply cost, Only numbers and – (hyphen) are acceptable
        "supplyCostTotal" => "20000",

        # The sum of tax amount	, Only numbers and - (minus) are acceptable
        "taxTotal" => "2000",

        # Total amount, Only numbers and – (hyphen) are acceptable
        "totalAmount" => "22000",

        # Serial number, One of e-Tax invoice’s items to manage document – ‘Serial number’
        "serialNum" => "",

        # Volume, One of e-Tax invoice’s items to manage document – ‘Volume’ for a book
        "kwon" => nil,

        # Number, One of e-Tax invoice’s items to manage document – ‘Number’ for a book
        "ho" => nil,

        # Cash, One of e-Tax invoice’s items – ‘cash’
        "cash" => "",

        # Check, One of e-Tax invoice’s items – ‘check’
        "chkBill" => "",

        # Note, One of e-Tax invoice’s items – ‘note’
        "note" => "",

        # Credit, One of e-Tax invoice’s litems – ‘credit’
        "credit" => "",

        # Remark
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # Attaching a business license, Prerequisite : Registration of a business license in advance
        "businessLicenseYN" => false,

        # Attaching a copy of bankbook, Prerequisite : Registration of a copy of bankbook in advance
        "bankBookYN" => false,


        ######################### for Modification ##########################



        # Modification code
        "modifyCode" => nil,

        # Original POPILL invoice id of e-Tax invoice
        "originalTaxinvoiceKey" => "",


        ######################### Detail List #########################

        ##################################################################

        "detailList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트1", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트2", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
        ],

        ######################### TaxinvoiceAdd Buyer Email #########################

        "addContactList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "contactName" => "담당자01", # Name of the person in charge
                "email" => "test@test.com", # Email
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "contactName" => "담당자02", # Name of the person in charge
                "email" => "test@test.com", # Email
            }
        ],
    }

    # Whether you want to write a transaction details or not [true-Yes / false-No]
    writeSpecification = false

    # Whether you force to issue an overdued e-Tax invoice or not [true-Yes / false-No]
    forceIssue = false

    #	- writeSpecification’s value = true : invoice id of transaction details
    # - writeSpecification’s value = false : invoice id of e-Tax invoice
    dealInvoiceMgtKey = ''

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = ''

    # A notification mail’s title sent to a person in charge of Buyer (If, you write nothing, a title set by POPBILL will be assigned)
    emailSubject = ''

    begin
      @Response = TaxinvoiceController::TIService.registIssue(
          corpNum,
          taxinvoice,
          writeSpecification,
          forceIssue,
          dealInvoiceMgtKey,
          memo,
          emailSubject,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  #################################################################################################################
  # Save the e-Tax invoice
  #  - Save the e-Tax invoice before issuing. Saved e-Tax invoice isn’t filed to NTS. Only after calling function ‘Issue API’, it would be filed.
  #################################################################################################################
  def register

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Seller invoice id (No redundancy)
    # - Combination of English letter, number, hyphen(‘-’) and underscore(‘_’)
    mgtKey = "20190917-03"

    # e-Tax Invoice object
    taxinvoice = {

        ######################### Seller Info #########################

        # Seller’s business registration number ( 10 digits except ‘-’ )
        "invoicerCorpNum" => corpNum,

        # [Seller] Identification number for minor place of business
        "invoicerTaxRegID" => "",

        # [Seller] Company name
        "invoicerCorpName" => "상호명",

        # [Seller] CEO’s name
        "invoicerCEOName" => "대표자명",

        # Seller invoice id (No redundancy)
        # - Combination of English letter, number, hyphen(‘-’) and underscore(‘_’)
        "invoicerMgtKey" => mgtKey,

        # [Seller] Company address
        "invoicerAddr" => "공급자 주소",

        # [Seller] Business type
        "invoicerBizType" => "공급자 업태",

        # [Seller] Business item
        "invoicerBizClass" => "공급자 종목",

        # [Seller] Name of the person in charge
        "invoicerContactName" => "공급자 담당자명",

        # [Seller] Email address of the person in charge
        "invoicerEmail" => "test@test.com",

        # [Seller] Mobile number of the person in charge
        "invoicerHP" => "010-111-222",

        # [Seller] Telephone number of the person in charge
        "invoicerTEL" => "070-4304-2991",

        # [Seller] Whether you send a notification SMS or not
        "invoicerSMSSendYN" => false,


        ######################### Buyer Info #########################

        # [Buyer] Buyer’s type, Put a KOREAN word [ “사업자(company)” or “개인(individual)” or “외국인(foreigner)” ]
        "invoiceeType" => "사업자",

        # [Buyer] Business registration number
        "invoiceeCorpNum" => "8888888888",

        # [Buyer] Identification number for minor place of business
        "invoiceeTaxRegId" => "",

        # [Buyer] Company name
        "invoiceeCorpName" => "공급받는자 상호",

        # [Buyer] CEO’s name
        "invoiceeCEOName" => "대표자 성명",

        # [Buyer] Invoice id
        "invoiceeMgtKey" => "",

        # [Buyer] Company address
        "invoiceeAddr" => "공급받는자 주소",

        # [Buyer] Business type
        "invoiceeBizClass" => "공급받는자 종목",

        # [Buyer] Business item
        "invoiceeBizType" => "공급받는자 업태",

        # [Buyer] Name of the person in charge
        "invoiceeContactName1" => "공급받는자담당자명",

        # [Buyer] Email address of the person in charge
        "invoiceeEmail1" => "test@test.com",

        # [Buyer] Telephone number of the person in charge
        "invoiceeTEL1" => "070-1234-1234",

        # [Buyer] Mobile number of the person in charge
        "invoiceeHP1" => "010-123-1234",

        # [Buyer] Whether you send a notification SMS or not to Seller
        "invoiceeSMSSendYN" => false,

        # Date of trading, Date format(yyyyMMdd) e.g. 20180509
        "writeDate" => "20190917",

        # Issuance type, Put a KOREAN word [ “정발행”(e-Tax invoice) or “역발행” (Requested e-Tax invoice) or “위수탁”(Delegated e-Tax invoice) ]
        "issueType" => "정발행",

        # Taxation type, Put a KOREAN word [ “과세” (Taxation) or “영세” (Zero-rate) or “면세” (Exemption) ]
        "taxType" => "과세",

        # Issuing Timing, Don't Change this field.
        "issueTiming" => "직접발행",

        # Charging direction
        # Put a KOREAN word[ “정과금(Charge to seller)” or “역과금(Charge to buyer” ]
        # (*Charge to buyer is only available in requested e-Tax invoice issuance process)
        "chargeDirection" => "정과금",

        # Receipt/Charge, Put a KOREAN word [ “영수”(Receipt) or “청구”(Charge)
        "purposeType" => "영수",

        # The sum of supply cost, Only numbers and - (minus) are acceptable
        "supplyCostTotal" => "20000",

        # The sum of tax amount	, Only numbers and - (minus) are acceptable
        "taxTotal" => "2000",

        # Total amount, Only numbers and – (minus) are acceptable
        "totalAmount" => "22000",


        # Serial number, One of e-Tax invoice’s items to manage document – ‘Serial number’
        "serialNum" => "",

        # Volume, One of e-Tax invoice’s items to manage document – ‘Volume’ for a book
        "kwon" => nil,

        # Number, One of e-Tax invoice’s items to manage document – ‘Number’ for a book
        "ho" => nil,

        # Cash, One of e-Tax invoice’s items – ‘cash’
        "cash" => "",

        # Check, One of e-Tax invoice’s items – ‘check’
        "chkBill" => "",

        # Note, One of e-Tax invoice’s items – ‘note’
        "note" => "",

        # Credit, One of e-Tax invoice’s litems – ‘credit’
        "credit" => "",

        # Remark
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # Attaching a business license, Prerequisite : Registration of a business license in advance
        "businessLicenseYN" => false,

        # Attaching a copy of bankbook, Prerequisite : Registration of a copy of bankbook in advance
        "bankBookYN" => false,

        ######################### for Modification ##########################
        # Modification code
        "modifyCode" => nil,

        # Original POPILL invoice id of e-Tax invoice
        "originalTaxinvoiceKey" => "",


        ######################### Detail List #########################

        "detailList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트1", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트2", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
        ],

        ######################### TaxinvoiceAdd Buyer Email #########################

        "addContactList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 5)
                "contactName" => "담당자01", # Name of the person in charge
                "email" => "test@test.com", # Email
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "contactName" => "담당자02", # Name of the person in charge
                "email" => "test@test.com", # Email
            }
        ],
    }

    # Whether you want to write a transaction details or not [true-Yes / false-No]
    writeSpecification = false

    begin
      @Response = TaxinvoiceController::TIService.register(
          corpNum,
          taxinvoice,
          writeSpecification,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Modify the e-Tax invoice. It is only available to saved e-Tax invoice.
  ##############################################################################
  def update

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # e-Tax Invoice object
    taxinvoice = {

        ######################### Seller Info #########################

        # Seller’s business registration number ( 10 digits except ‘-’ )
        "invoicerCorpNum" => corpNum,

        # [Seller] Identification number for minor place of business
        "invoicerTaxRegID" => "",

        # [Seller] Company name
        "invoicerCorpName" => "상호명_수정",

        # [Seller] CEO’s name
        "invoicerCEOName" => "대표자명_수정",

        # Seller invoice id (No redundancy)
        # - Combination of English letter, number, hyphen(‘-’) and underscore(‘_’)
        "invoicerMgtKey" => mgtKey,

        # [Seller] Company address
        "invoicerAddr" => "공급자 주소",

        # [Seller] Business type
        "invoicerBizType" => "공급자 업태",

        # [Seller] Business item
        "invoicerBizClass" => "공급자 종목",

        # [Seller] Name of the person in charge
        "invoicerContactName" => "공급자 담당자명",

        # [Seller] Email address of the person in charge
        "invoicerEmail" => "test@test.com",

        # [Seller] Mobile number of the person in charge
        "invoicerHP" => "010-111-222",

        # [Seller] Telephone number of the person in charge
        "invoicerTEL" => "070-4304-2991",

        # [Seller] Whether you send a notification SMS or not
        "invoicerSMSSendYN" => false,


        ######################### Buyer Info #########################

        # [Buyer] Buyer’s type, Put a KOREAN word [ “사업자(company)” or “개인(individual)” or “외국인(foreigner)” ]
        "invoiceeType" => "사업자",

        # [Buyer] Business registration number
        "invoiceeCorpNum" => "8888888888",

        # [Buyer] Identification number for minor place of business
        "invoiceeTaxRegId" => "",

        # [Buyer] Company name
        "invoiceeCorpName" => "공급받는자 상호",

        # [Buyer] CEO’s name
        "invoiceeCEOName" => "대표자 성명",

        # [Buyer] Invoice id
        "invoiceeMgtKey" => "",

        # [Buyer] Company address
        "invoiceeAddr" => "공급받는자 주소",

        # [Buyer] Business type
        "invoiceeBizClass" => "공급받는자 종목",

        # [Buyer] Business item
        "invoiceeBizType" => "공급받는자 업태",

        # [Buyer] Name of the person in charge
        "invoiceeContactName1" => "공급받는자담당자명",

        # [Buyer] Email address of the person in charge
        "invoiceeEmail1" => "test@test.com",

        # [Buyer] Telephone number of the person in charge
        "invoiceeTEL1" => "070-1234-1234",

        # [Buyer] Mobile number of the person in charge
        "invoiceeHP1" => "010-123-1234",

        # [Buyer] Whether you send a notification SMS or not to Seller
        "invoiceeSMSSendYN" => false,

        # Date of trading, Date format(yyyyMMdd) e.g. 20180509
        "writeDate" => "20190917",

        # Issuance type, Put a KOREAN word [ “정발행”(e-Tax invoice) or “역발행” (Requested e-Tax invoice) or “위수탁”(Delegated e-Tax invoice) ]
        "issueType" => "정발행",

        # Taxation type, Put a KOREAN word [ “과세” (Taxation) or “영세” (Zero-rate) or “면세” (Exemption) ]
        "taxType" => "과세",

        # Issuing Timing, Don't Change this field.
        "issueTiming" => "직접발행",

        # Charging direction
        # Put a KOREAN word[ “정과금(Charge to seller)” or “역과금(Charge to buyer” ]
        # (*Charge to buyer is only available in requested e-Tax invoice issuance process)
        "chargeDirection" => "정과금",

        # Receipt/Charge, Put a KOREAN word [ “영수”(Receipt) or “청구”(Charge)
        "purposeType" => "영수",

        # The sum of supply cost, Only numbers and – (hyphen) are acceptable
        "supplyCostTotal" => "20000",

        # The sum of tax amount	, Only numbers and - (minus) are acceptable
        "taxTotal" => "2000",

        # Total amount, Only numbers and – (hyphen) are acceptable
        "totalAmount" => "22000",

        # Serial number, One of e-Tax invoice’s items to manage document – ‘Serial number’
        "serialNum" => "",

        # Volume, One of e-Tax invoice’s items to manage document – ‘Volume’ for a book
        "kwon" => nil,

        # Number, One of e-Tax invoice’s items to manage document – ‘Number’ for a book
        "ho" => nil,

        # Cash, One of e-Tax invoice’s items – ‘cash’
        "cash" => "",

        # Check, One of e-Tax invoice’s items – ‘check’
        "chkBill" => "",

        # Note, One of e-Tax invoice’s items – ‘note’
        "note" => "",

        # Credit, One of e-Tax invoice’s litems – ‘credit’
        "credit" => "",

        # Remark
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # Attaching a business license, Prerequisite : Registration of a business license in advance
        "businessLicenseYN" => false,

        # Attaching a copy of bankbook, Prerequisite : Registration of a copy of bankbook in advance
        "bankBookYN" => false,

        ######################### Detail List #########################

        "detailList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트1", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트2", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
        ],

        ######################### TaxinvoiceAdd Buyer Email #########################

        "addContactList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "contactName" => "담당자01", # Name of the person in charge
                "email" => "test@test.com", # Email
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "contactName" => "담당자02", # Name of the person in charge
                "email" => "test@test.com", # Email
            }
        ],
    }

    begin
      @Response = TaxinvoiceController::TIService.update(
          corpNum,
          keyType,
          mgtKey,
          taxinvoice,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ######################################################################################
  # Issue saved e-Tax invoice or e-Tax invoice waiting for issuing by invoicer(seller) after invoicee(buyer)’s request.
  # -  When it is called, points(fee) is deducted and notification mail will be sent to e-mail address of a person in charge of buyer (Variable: invoiceeEmail1) based on e-Tax invoice’s information.
  ######################################################################################
  def issue

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190402-02"

    # Whether you force to issue an overdued e-Tax invoice or not [true-Yes / false-No]

    # Whether you force to issue an overdued e-Tax invoice or not [true-Yes / false-No]
    forceIssue = false

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = ''

    # A notification mail’s title sent to a person in charge of Buyer (If, you write nothing, a title set by POPBILL will be assigned)
    emailSubject = ''

    begin
      @Response = TaxinvoiceController::TIService.issue(
          corpNum,
          keyType,
          mgtKey,
          forceIssue,
          memo,
          emailSubject,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Cancel the issuance of e-Tax invoice in the state of ‘Issuance complete’ waiting for filing to NTS.
  # - Cancelled e-Tax invoice isn’t filed to NTS.
  # - If you delete cancelled e-Tax invoice calling function ‘Delete API’, invoice id that have been assigned to manage e-Tax invoice is going to be re-usable.
  # - An e-Tax invoice in the state of ‘filing’ or ‘Succeed’ isn’t available to cancel.
  ##############################################################################
  def cancelIssue

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = ''

    begin
      @Response = TaxinvoiceController::TIService.cancelIssue(
          corpNum,
          keyType,
          mgtKey,
          memo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Invoicee(Buyer) request for issuing e-Tax invoice to seller just after filling out it themselves
  # - If buyer use it successfully, a status of e-Tax invoice is going to be changed to ‘waiting for issuing’. When seller check this e-Tax invoice and issue, points(fee) is deducted and the status is changed to ‘Issuance complete’.
  # - An e-Tax invoice in the state of ‘waiting for issuing’ isn’t going to be filed to NTS. To complete the process, seller must issue it making an e-sign with certificate.
  # - Depends on value of ‘ChargeDirection’ in a list of e-Tax invoice, a fee will be charged. If the value is ‘to seller’, points(fee) is deducted from seller’s. If the value is ‘to buyer’, points is deducted from buyer’s
  ##############################################################################
  def registRequest

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    # Invoice id assigned by partner
    mgtKey = "20190917-03"

    # e-Tax Invoice object
    taxinvoice = {

        ######################### Seller Info #########################

        # Seller’s business registration number ( 10 digits except ‘-’ )
        "invoicerCorpNum" => "8888888888",

        # [Seller] Identification number for minor place of business
        "invoicerTaxRegID" => "",

        # [Seller] Company name
        "invoicerCorpName" => "상호명",

        # [Seller] CEO’s name
        "invoicerCEOName" => "대표자명",

        # 공급자 문서번호, 1~24자리 (숫자, 영문, '-', '_') 조합으로
        # 사업자 별로 중복되지 않도록 구성
        "invoicerMgtKey" => "",

        # [Seller] Company address
        "invoicerAddr" => "공급자 주소",

        # [Seller] Business type
        "invoicerBizType" => "공급자 업태",

        # [Seller] Business item
        "invoicerBizClass" => "공급자 종목",

        # [Seller] Name of the person in charge
        "invoicerContactName" => "공급자 담당자명",

        # [Seller] Email address of the person in charge
        "invoicerEmail" => "test@test.com",

        # [Seller] Mobile number of the person in charge
        "invoicerHP" => "010-111-222",

        # [Seller] Telephone number of the person in charge
        "invoicerTEL" => "070-4304-2991",


        ######################### Buyer Info #########################

        # [Buyer] Buyer’s type, Put a KOREAN word [ “사업자(company)” or “개인(individual)” or “외국인(foreigner)” ]
        "invoiceeType" => "사업자",

        # [Buyer] Business registration number
        "invoiceeCorpNum" => corpNum,

        # [Buyer] Identification number for minor place of business
        "invoiceeTaxRegId" => "",

        # [Buyer] Company name
        "invoiceeCorpName" => "공급받는자 상호",

        # [Buyer] CEO’s name
        "invoiceeCEOName" => "대표자 성명",

        # [Buyer] Invoice id	, 1~24자리 (숫자, 영문, '-', '_') 조합으로
        # 사업자 별로 중복되지 않도록 구성
        "invoiceeMgtKey" => mgtKey,

        # [Buyer] Company address
        "invoiceeAddr" => "공급받는자 주소",

        # [Buyer] Business type
        "invoiceeBizClass" => "공급받는자 종목",

        # [Buyer] Business item
        "invoiceeBizType" => "공급받는자 업태",

        # [Buyer] Name of the person in charge
        "invoiceeContactName1" => "공급받는자담당자명",

        # [Buyer] Email address of the person in charge
        "invoiceeEmail1" => "test@test.com",

        # [Buyer] Telephone number of the person in charge
        "invoiceeTEL1" => "070-1234-1234",

        # [Buyer] Mobile number of the person in charge
        "invoiceeHP1" => "010-123-1234",

        # [Buyer] Whether you send a notification SMS or not to Seller
        "invoiceeSMSSendYN" => false,

        # Date of trading, Date format(yyyyMMdd) e.g. 20180509
        "writeDate" => "20190917",

        # Issuance type, Put a KOREAN word [ “정발행”(e-Tax invoice) or “역발행” (Requested e-Tax invoice) or “위수탁”(Delegated e-Tax invoice) ]
        "issueType" => "역발행",

        # Taxation type, Put a KOREAN word [ “과세” (Taxation) or “영세” (Zero-rate) or “면세” (Exemption) ]
        "taxType" => "과세",

        # Issuing Timing, Don't Change this field.
        "issueTiming" => "직접발행",

        # Put a KOREAN word[ “정과금(Charge to seller)” or “역과금(Charge to buyer” ]
        # (*Charge to buyer is only available in requested e-Tax invoice issuance process)
        "chargeDirection" => "정과금",

        # Receipt/Charge, Put a KOREAN word [ “영수”(Receipt) or “청구”(Charge) ]
        "purposeType" => "영수",

        # The sum of supply cost, Only numbers and – (hyphen) are acceptable
        "supplyCostTotal" => "20000",

        # The sum of tax amount	, Only numbers and - (minus) are acceptable
        "taxTotal" => "2000",

        # Total amount, Only numbers and – (hyphen) are acceptable
        "totalAmount" => "22000",

        # Serial number, One of e-Tax invoice’s items to manage document – ‘Serial number’
        "serialNum" => "",

        # Volume, One of e-Tax invoice’s items to manage document – ‘Volume’ for a book
        "kwon" => nil,

        # Number, One of e-Tax invoice’s items to manage document – ‘Number’ for a book
        "ho" => nil,

        # Cash, One of e-Tax invoice’s items – ‘cash’
        "cash" => "",

        # Check, One of e-Tax invoice’s items – ‘check’
        "chkBill" => "",

        # Note, One of e-Tax invoice’s items – ‘note’
        "note" => "",

        # Credit, One of e-Tax invoice’s litems – ‘credit’
        "credit" => "",

        # Remark
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # Attaching a business license, Prerequisite : Registration of a business license in advance
        "businessLicenseYN" => false,

        # Attaching a copy of bankbook, Prerequisite : Registration of a copy of bankbook in advance
        "bankBookYN" => false,


        ######################### for Modification ##########################

        # Modification code
        "modifyCode" => nil,

        # Original POPILL invoice id of e-Tax invoice
        "originalTaxinvoiceKey" => "",


        ######################### Detail List #########################

        "detailList" => [
            {
                "serialNum" => 1, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트1", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
            {
                "serialNum" => 2, # Serial Number, Must write the number in a row starting from 1 (Maximum: 99)
                "purchaseDT" => "20190917", # Date of trading, Date of trading (of an e-Tax invoice) [ Format : yyyyMMdd, except ‘-’ ]
                "itemName" => "테스트2", # Item name
                "spec" => "규격", # Specification
                "qty" => "1", # Quantity
                "unitCost" => "10000", # Unit cost
                "supplyCost" => "10000", # Supply Cost
                "tax" => "1000", # Tax amount
                "remark" => "비고", # Remark
            },
        ],
    }

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = '즉시요청 메모'

    begin
      @Response = TaxinvoiceController::TIService.registRequest(
          corpNum,
          taxinvoice,
          memo,
          userID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Buyer request for issuing saved e-Tax invoice to Seller.
  # - We recommend usage of function ‘RegistRequest API’ to make it available to process ‘Regist API’ and ‘Request API’ at once.
  ##############################################################################
  def requestTI

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::BUY

    # Invoice id assigned by partner
    mgtKey = "20190917-03"

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = ''

    begin
      @Response = TaxinvoiceController::TIService.request(
          corpNum,
          keyType,
          mgtKey,
          memo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Buyer cancel to request for issuing an e-Tax invoice to seller.
  ##############################################################################
  def cancelRequest

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::BUY

    # Invoice id assigned by partner
    mgtKey = "20190917-03"

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = ""

    begin
      @Response = TaxinvoiceController::TIService.cancelRequest(
          corpNum,
          keyType,
          mgtKey,
          memo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Seller refuse to issue the e-Tax invoice requested by buyer.
  ##############################################################################
  def refuse

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Memo, Available to check a value of parameters ‘stateMemo’ of GetInfo API
    memo = ''

    begin
      @Response = TaxinvoiceController::TIService.refuse(
          corpNum,
          keyType,
          mgtKey,
          memo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Delete the e-Tax invoice only in deletable status. An invoice id that have been assigned to it is going to be re-usable.
  # - The deletable status: ‘Saved’, ‘Canceled the issuance’, ‘Refused the issuance(By seller)’, ‘Canceled the issuance request(By buyer)’, ‘Failed to file’
  ##############################################################################
  def delete

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-03"

    begin
      @Response = TaxinvoiceController::TIService.delete(
          corpNum,
          keyType,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # Seller files issued e-Tax invoice waiting for filing to NTS.
  # ㆍ After calling function ‘SendToNTS’, you can check the file result withing 20-30 min.
  #ㆍ In Test-bed, issued e-Tax invoice isn’t filed to NTS actually. Process ‘File to NTS’ is a kind of mock process so only file result is going to be changed to ‘Success’ after 5min from issuing.
  ##############################################################################
  def sendToNTS

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @Response = TaxinvoiceController::TIService.sendToNTS(
          corpNum,
          keyType,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the status of AN e-Tax invoice and summary of it.
  ##############################################################################
  def getInfo

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @Response = TaxinvoiceController::TIService.getInfo(
          corpNum,
          keyType,
          mgtKey,
      )
      render "taxinvoice/getInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the status of bulk e-Tax invoices and summary of it. (Maximum: 1000 counts)
  ##############################################################################
  def getInfos

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # The array of invoice id (Maximum: 1000 counts)
    mgtKeyList = ["20190917-01", "20190917-02"]

    begin
      @Response = TaxinvoiceController::TIService.getInfos(
          corpNum,
          keyType,
          mgtKeyList,
      )
      render "taxinvoice/getInfos"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the details of AN e-Tax invoice.
  ##############################################################################
  def getDetailInfo

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @Response = TaxinvoiceController::TIService.getDetailInfo(
          corpNum,
          keyType,
          mgtKey,
      )
      render "taxinvoice/taxinvoice"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Search the list of e-Tax invoices corresponding to the search criteria.
  ##############################################################################
  def search

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Date type [R-Date of registration, W-of trading, I-of issuance]
    dType = "W"

    # Start date of search scope (Format : yyyyMMdd)
    sDate = "20190701"

    # End date of search scope (Format : yyyyMMdd)
    eDate = "20191231"

    # [Array] Status code (Wild card(*) can be put on 2nd, 3rd letter – e.g. “3**”, “6**”)
    state = ["3**", "6**"]

    # [Array] Document type [N-General/ M-For modification]
    type = ["N", "M"]

    # [Array] Taxation Type [T-Taxation / N-Exemption / Z-Zero-rate]
    taxType = ["T", "N", "Z"]

    # [Array] Issuance type [N-e-Tax invoice/ R-Requested e-Tax invoice / T-Delegated e-Tax invoice]
    issueType = ["N", "R", "T"]

    # Whether an issuing is delayed or not [CHOOSE 1 : null-Search all / false-Search the case issued within a due-date / true-the case issued after a due-date]
    lateOnly = ''

    # Whether the business registration number of minor place is enrolled or not [CHOOSE 1 : blank-Search all / 0-None / 1-Enrolled]
    taxRegIDYN = ''

    # Type of the business registration number of minor place [CHOOSE 1 : S-Invoicer(Seller) / B-Invoicee(Buyer) / T-Trustee]
    taxRegIDType = ''

    # The business registration number of minor place: several search criteria of it must be recognized by comma(“,”) (e.g. 1234, 1110)
    taxRegID = ''

    # Page number (Default:’1’)
    page = 1

    # Available search number per page (Default: 500 / Maximum: 1000)
    perPage = 10

    # Sort direction (Default:’D’) [CHOOSE 1 : D-Descending / A-Ascending]
    order = "D"

    # Search for a company name or business registration number (Blank:Search all)
    queryString = ""

    # Whether a document registered by API is searched or not [CHOOSE 1 : blank-Search all / 0-Search for docu registered by Site UI / 1 – for docu registered by API]
    interOPYN = ""

    begin
      @Response = TaxinvoiceController::TIService.search(
          corpNum,
          keyType,
          dType,
          sDate,
          eDate,
          state,
          type,
          taxType,
          lateOnly,
          taxRegIDYN,
          taxRegIDType,
          taxRegID,
          page,
          perPage,
          order,
          queryString,
          userID,
          interOPYN,
          issueType,
      )
      render "taxinvoice/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the log of e-Tax invoice’s status change.
  ##############################################################################
  def getLogs

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @Response = TaxinvoiceController::TIService.getLogs(
          corpNum,
          keyType,
          mgtKey,
      )
      render "taxinvoice/taxinvoiceLogs"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return the URL to access the menu ‘e-Tax invoice list’ on POPBILL website in login status.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # TBOX(Draft list), SBOX(Sales list), PBOX(Purchase list), WRITE(Register sales invoice)
    togo = "PBOX"

    begin
      @value = TaxinvoiceController::TIService.getURL(
          corpNum,
          togo,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to view AN e-Tax invoice on POPBILL website.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getPopUpURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-01"

    begin
      @value = TaxinvoiceController::TIService.getPopUpURL(
          corpNum,
          keyType,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to print AN e-Tax invoice.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getPrintURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @value = TaxinvoiceController::TIService.getPrintURL(
          corpNum,
          keyType,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to print AN e-Tax invoice for buyer.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getEPrintURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @value = TaxinvoiceController::TIService.getEPrintURL(
          corpNum,
          keyType,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to print bulk e-Tax invoices.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getMassPrintURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner 배열, 최대 100건
    mgtKeyList = ["20190917-02", "20190917-01"]

    begin
      @value = TaxinvoiceController::TIService.getMassPrintURL(
          corpNum,
          keyType,
          mgtKeyList,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return URL of button located on bottom of a notification mail sent to buyer.
  # - There is no valid time about the URL returned by function ‘GetMailURL’.
  ##############################################################################
  def getMailURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @value = TaxinvoiceController::TIService.getMailURL(
          corpNum,
          keyType,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to access POPBILL website in login status.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getAccessURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    begin
      @value = TaxinvoiceController::TIService.getAccessURL(
          corpNum,
          userID,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  #  Return popup URL to register the seal, business license and copy of a bankbook to e-Tax invoice.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getSealURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    begin
      @value = TaxinvoiceController::TIService.getSealURL(
          corpNum,
          userID,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Attach the file to e-Tax invoice (Maximum: 5 files).
  # - It is only available to saved e-Tax invoice.
  ##############################################################################
  def attachFile

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Path of attached file
    filePath = "/Users/kimhyunjin/SDK/popbill.example.ruby/test.pdf"

    begin
      @Response = TaxinvoiceController::TIService.attachFile(
          corpNum,
          keyType,
          mgtKey,
          filePath,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Delete a file attached to e-Tax invoice.
  # - Check ‘FileID’ to recognize the attachment referring returned function GetFiles
  ##############################################################################
  def deleteFile

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # File ID (*Refer field ‘attachedFile’ – one of returned values of GetFiles API
    fileID = "6F4E5AA1-0B61-4775-A837-20E0D87C3010.PBF"

    begin
      @Response = TaxinvoiceController::TIService.deleteFile(
          corpNum,
          keyType,
          mgtKey,
          fileID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the file list attached to an e-Tax invoice.
  ##############################################################################
  def getFiles

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    begin
      @Response = TaxinvoiceController::TIService.getFiles(
          corpNum,
          keyType,
          mgtKey,
      )
      render "taxinvoice/getFiles"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Re-send a mail to notify that an e-Tax invoice is issued.
  ##############################################################################
  def sendEmail

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # [Buyer] Email address of the person in charge
    emailAddr = "test@test.com"

    begin
      @Response = TaxinvoiceController::TIService.sendEmail(
          corpNum,
          keyType,
          mgtKey,
          emailAddr,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  #  Send a SMS(Short message).
  # - Contents only within capacityare delivered. SMS’s capacity is 90byte and exceeded contents are deleted automatically when a SMS is delivered. (Maximum of Korean letters: 45)
  # - Points(Fee) are deducted when user send a SMS. If sending is failed, points are going to be refunded.
  # - Check sending result on POPBILL website [Messaging/FAX -> Messaging -> Sending log]
  ##############################################################################
  def sendSMS

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Sender’s Number
    sendNum = "07043042991"

    # Receiver’s Number
    receiveNum = "010-111-222"

    # Contents of SMS (*Exceeded contents are deleted automatically when a SMS is delivered.)
    contents = "문자메시지 전송을 확인합니다."

    begin
      @Response = TaxinvoiceController::TIService.sendSMS(
          corpNum,
          keyType,
          mgtKey,
          sendNum,
          receiveNum,
          contents,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Send an e-Tax invoice by fax.
  # - Points(Fee) are deducted when user send a fax. If sending is failed, points are going to be refunded.
  # - Check sending result on POPBILL website [Messaging/FAX -> FAX -> Sending log]
  ##############################################################################
  def sendFax

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Sender’s Number
    sendNum = "07043042991"

    # Receiver’s Number
    receiveNum = "070111222"

    begin
      @Response = TaxinvoiceController::TIService.sendFax(
          corpNum,
          keyType,
          mgtKey,
          sendNum,
          receiveNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Attach a statement to e-Tax invoice.
  ##############################################################################
  def attachStatement

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Statement’s type code, [121: Transaction details, 122: Bill, 123: Estimate, 124: Purchase order, 125: Deposit slip, 126: Receipt]
    itemCode = 121

    # Statement’s id required to be attached to e-Tax invoice
    stmtMgtKey = "20190121-01"

    begin
      @Response = TaxinvoiceController::TIService.attachStatement(
          corpNum,
          keyType,
          mgtKey,
          itemCode,
          stmtMgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Detach a statement from e-Tax invoice.
  ##############################################################################
  def detachStatement

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # Invoice id assigned by partner
    mgtKey = "20190917-02"

    # Statement’s type code, [121: Transaction details, 122: Bill, 123: Estimate, 124: Purchase order, 125: Deposit slip, 126: Receipt]
    itemCode = 121

    # Statement’s id required to be detached to e-Tax invoice
    stmtMgtKey = "20190121-01"

    begin
      @Response = TaxinvoiceController::TIService.detachStatement(
          corpNum,
          keyType,
          mgtKey,
          itemCode,
          stmtMgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the email list of e-Tax invoice service provider.
  ##############################################################################
  def getEmailPublicKeys

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @Response = TaxinvoiceController::TIService.getEmailPublicKeys(
          corpNum,
      )
      render "taxinvoice/emailPublicKeys"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Assign an invoice id to e-Tax invoice that was not assigned by partner.


  ##############################################################################
  def assignMgtKey

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Type of the e-Tax invoice [CHOOSE 1: SELL-e-Tax invoice/ BUY-Requested e-Tax invoice / TRUSTEE-Delegated e-Tax invoice]
    keyType = MgtKeyType::SELL

    # POPBILL invoice id (*Refer ‘ItemKey’ – one of returned values of Search API)
    itemKey = "019040209362600001"

    # Invoice id assigned by partner
    mgtKey = "20190402-005"

    begin
      @Response = TaxinvoiceController::TIService.assignMgtKey(
          corpNum,
          keyType,
          itemKey,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end

  end

  ##############################################################################
  # Return the outgoing mail list related to e-Tax invoice being sent to notify the issuance or cancellation etc..
  ##############################################################################
  def listEmailConfig

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    begin
      @Response = TaxinvoiceController::TIService.listEmailConfig(
          corpNum,
          userID,
      )
      render "taxinvoice/listEmailConfig"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  #[*Purpose of the outgoing mail]
  # e-Tax invoice issuance process
  # TAX_ISSUE : [to buyer] to notify the issuing an e-Tax invoice
  # TAX_ISSUE_INVOICER : [to seller] to notify the issuing an e-Tax invoice
  # TAX_CHECK : [to seller] to notify that buyer have checked an e-Tax invoice
  # TAX_CANCEL_ISSUE : [to buyer] to notify that seller have cancelled the issuing an e-Tax invoice

  # About e-tax invoice being ready to issue
  # TAX_SEND : [to buyer] to notify that an e-Tax invoice being ready to issue is sent
  # TAX_ACCEPT : [to seller] to notify that an e-Tax invoice being ready to issue is accepted
  # TAX_ACCEPT_ISSUE : [to seller] to notify that an e-Tax invoice being ready to issue is issued automatically
  # TAX_DENY : [to seller] to notify that an e-Tax invoice being ready to issue is refused
  # TAX_CANCEL_SEND : [to buyer] to notify that an e-Tax invoice being ready to issue is cancelled

  # Requested e-Tax invoice issuance process
  # TAX_REQUEST : [to seller] to request the issuing an e-Tax invoice with e-signature
  # TAX_CANCEL_REQUEST : [to buyer] to notify that the request for issuing an e-Tax invoice is cancelled
  # TAX_REFUSE : [to buyer] to notify that an e-Tax invoice requested for issuing is refused

  # Delegated e-Tax invoice issuance process
  # TAX_TRUST_ISSUE : [to buyer] to notify the issuing an e-Tax invoice
  # TAX_TRUST_ISSUE_TRUSTEE : [to trustee] to notify the issuing an e-Tax invoice
  # TAX_TRUST_ISSUE_INVOICER : [to seller] to notify the issuing an e-Tax invoice
  # TAX_TRUST_CANCEL_ISSUE : [to buyer] to notify that trustee have cancelled the issuing an e-Tax invoice
  # TAX_TRUST_CANCEL_ISSUE_INVOICER : [to seller] to notify that trustee have cancelled the issuing an e-Tax invoice

  # About delegated e-tax invoice being ready to issue [delegated e-Tax invoice issuance process]
  # TAX_TRUST_SEND : [to buyer] to notify that an e-Tax invoice being ready to issue is sent
  # TAX_TRUST_ACCEPT : [to trustee] to notify that an e-Tax invoice being ready to issue is accepted
  # TAX_TRUST_ACCEPT_ISSUE : [to trustee] to notify that an e-Tax invoice being ready to issue is issued automatically
  # TAX_TRUST_DENY : [to trustee] to notify that an e-Tax invoice being ready to issue is refused
  # TAX_TRUST_CANCEL_SEND : [to buyer] to notify that an e-Tax invoice being ready to issue is cancelled

  # About results
  # TAX_CLOSEDOWN : to notify a result of NTS business status check
  # TAX_NTSFAIL_INVOICER : to notify filing failure of e-Tax invoice

  # About regular mailing
  # TAX_SEND_INFO : to notify a e-Tax invoice belonged to last month is issued
  # ETC_CERT_EXPIRATION : to notify that a registered certificate on POPBILL is required to renew
  ##############################################################################
  def updateEmailConfig

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    # [*Purpose of the outgoing mail]
    emailType = "TAX_ISSUE_INVOICER"

    # Whether a mail will be sent or not.
    sendYN = false

    begin
      @Response = TaxinvoiceController::TIService.updateEmailConfig(
          corpNum,
          emailType,
          sendYN,
          userID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # URL to register the certificate
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getTaxCertURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    begin
      @value = TaxinvoiceController::TIService.getTaxCertURL(
          corpNum,
          userID,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return certificate’s expiration date of partner user registered in POPBILL website.
  ##############################################################################
  def getCertificateExpireDate

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @value = TaxinvoiceController::TIService.getCertificateExpireDate(
          corpNum,
      )
      @name = "expireDate(공인인증서 만료일시)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check certificate’s validity of partner user registered in POPBILL website.
  ##############################################################################

  def checkCertValidation

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @Response = TaxinvoiceController::TIService.checkCertValidation(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check point’s balance of partner user.
  # - Business registration number of POPBILL user (10 digits except ‘-’)
  ##############################################################################
  def getBalance

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @value = TaxinvoiceController::TIService.getBalance(corpNum)
      @name = "remainPoint(연동회원 잔여포인트)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to charge points of partner user.
  # - Returned URL is valid only during 30 seconds following the security policy. So when you call the URL after the valid time, page will not be opened at all.
  ##############################################################################
  def getChargeURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    begin
      @value = TaxinvoiceController::TIService.getChargeURL(
          corpNum,
          userID,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check point’s balance of partner.
  ##############################################################################
  def getPartnerBalance

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @value = TaxinvoiceController::TIService.getPartnerBalance(corpNum)
      @name = "remainPoint(파트너 잔여포인트)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Return popup URL to charge partner’s points.
  ##############################################################################
  def getPartnerURL

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # CHRG-Charging partner’s points
    togo = "CHRG"

    begin
      @value = TaxinvoiceController::TIService.getPartnerURL(
          corpNum,
          togo,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the charging information of POPBILL services.
  ##############################################################################
  def getChargeInfo

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @Response = TaxinvoiceController::TIService.getChargeInfo(corpNum)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the issuance unit cost per an e-Tax invoice.
  ##############################################################################
  def getUnitCost

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @value = TaxinvoiceController::TIService.getUnitCost(
          corpNum,
      )
      @name = "unitCost(발행단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # Check whether a user is a partner user or not.
  ##############################################################################
  def checkIsMember

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # LinkID
    linkID = TaxinvoiceController::LinkID

    begin
      @Response = TaxinvoiceController::TIService.checkIsMember(
          corpNum,
          linkID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check whether POPBILL member’s ID is in use or not.
  ##############################################################################
  def checkID

    # ID to be required to check the redundancy
    testID = "testkorea"

    begin
      @Response = TaxinvoiceController::TIService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # Join the POPBILL as a partner user.
  ##############################################################################
  def joinMember

    # Objects of partner user information
    joinInfo = {

        # LinkID
        "LinkID" => "TESTER",

        # ID, From 6 to 50 letters
        "ID" => "testkorea",

        # Password, From 6 to 20 letters
        "PWD" => "thisispassword",

        # Business registration number ( 10 digits except ‘-’ )
        "CorpNum" => "8888888888",

        # CEO’s name
        "CEOName" => "대표자성명",

        # Company name
        "CorpName" => "상호명",

        # Company address
        "Addr" => "주소",

        # Business type
        "BizType" => "업태",

        # Business item
        "BizClass" => "종목",

        # Name of the person in charge
        "ContactName" => "담당자 성명",

        # Email address of the person in charge
        "ContactEmail" => "test@test.com",

        # Telephone number of the person in charge
        "ContactTEL" => "010-111-222",

        # Mobile number of the person in charge
        "ContactHP" => "010-111-222",

        # Fax number of the person in charge
        "ContactFAX" => "02-111-222",
    }

    begin
      @Response = TaxinvoiceController::TIService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Check the company information of partner user.
  ##############################################################################
  def getCorpInfo

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @Response = TaxinvoiceController::TIService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Modify the company information of partner user.
  ##############################################################################
  def updateCorpInfo

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Objects of company information
    corpInfo = {

        # CEO’s name
        "ceoname" => "대표자명_수정",

        # Company name
        "corpName" => "상호_수정",

        # Company address
        "addr" => "주소_수정",

        # Business type
        "bizType" => "업태_수정",

        # Business item
        "bizClass" => "종목_수정",
    }

    begin
      @Response = TaxinvoiceController::TIService.updateCorpInfo(
          corpNum,
          corpInfo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # Add a contact of the person in charge(POPBILL account) of partner user.
  ##############################################################################
  def registContact

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # Objects of contact information
    contactInfo = {

        # ID, From 6 to 50 letters
        "id" => "testkorea20190121",

        # Password, From 6 to 20 letters
        "pwd" => "user_password",

        # Name of the person in charge
        "personName" => "루비담당자",

        # Telephone number of the person in charge
        "tel" => "070-4304-2992",

        # Mobile number of the person in charge
        "hp" => "010-111-222",

        # Fax number of the person in charge
        "fax" => "02-111-222",

        # Email address of the person in charge
        "email" => "ruby@linkhub.co.kr",

        # Configuration for search authorization
        "searchAllAllowYN" => true,

        # Whether an user is a administrator or not
        "mgrYN" => false,
    }

    begin
      @Response = TaxinvoiceController::TIService.registContact(
          corpNum,
          contactInfo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 연Check the list of persons in charge of partner user.
  ##############################################################################
  def listContact

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    begin
      @Response = TaxinvoiceController::TIService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # Modify the contact information of partner user.
  ##############################################################################
  def updateContact

    # Business registration number of POPBILL user (10 digits except ‘-’)
    corpNum = TaxinvoiceController::TestCorpNum

    # POPBILL user ID
    userID = TaxinvoiceController::TestUserID

    # Objects of contact information
    contactInfo = {

        # ID, From 6 to 50 letters
        "id" => userID,

        # Name of the person in charge
        "personName" => "Ruby(담당자)",

        # Telephone number of the person in charge
        "tel" => "070-4304-2992",

        # Mobile number of the person in charge
        "hp" => "010-111-222",

        # Fax number of the person in charge
        "fax" => "070-111-222",

        # Email address of the person in charge
        "email" => "code@linkhub.co.kr",

        # Configuration for search authorization
        "searchAllAllowYN" => true,

        # Whether an user is a administrator or not
        "mgrYN" => false,
    }

    begin
      @Response = TaxinvoiceController::TIService.updateContact(
          corpNum,
          contactInfo,
          userID
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
