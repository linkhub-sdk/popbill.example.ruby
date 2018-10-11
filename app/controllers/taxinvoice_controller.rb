################################################################################
# 팜빌 전자세금계산서 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2018-06-25
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 22, 25번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
# 3) 전자세금계산서 발행을 위해 공인인증서를 등록합니다.
#    - 팝빌사이트 로그인 > [전자세금계산서] > [환경설정] > [공인인증서 관리]
#    - 공인인증서 등록 팝업 URL (GetPopbillURL API)을 이용하여 등록
################################################################################

require 'popbill/taxinvoice'

class TaxinvoiceController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 전자세금계산서 API Service 초기화
  TIService = TaxinvoiceService.instance(
      TaxinvoiceController::LinkID,
      TaxinvoiceController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  TIService.setIsTest(true)


  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 파트너 링크아이디
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
  # 팝빌 회원아이디 중복여부를 확인합니다.
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea0131"

    begin
      @Response = TaxinvoiceController::TIService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end


  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  ##############################################################################
  def joinMember

    # 연동회원 가입정보
    joinInfo = {

        # 링크아이디
        "LinkID" => "TESTER",

        # 아이디, 6자이상 20자미만
        "ID" => "testkorea20170131",

        # 비밀번호, 6자이상 20자 미만
        "PWD" => "thisispassword",

        # 사업자번호, '-' 제외 10자리
        "CorpNum" => "8888888888",

        # 대표자명
        "CEOName" => "대표자성명",

        # 상호명
        "CorpName" => "상호명",

        # 주소
        "Addr" => "주소",

        # 업태
        "BizType" => "업태",

        # 종목
        "BizClass" => "종목",

        # 담당자명
        "ContactName" => "담당자 성명",

        # 담당자 메일
        "ContactEmail" => "test@test.com",

        # 담당자 연락처
        "ContactTEL" => "담당자 연락처",
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
  # 연동회원의 전자세금계산서 API 서비스 과금정보를 확인합니다.
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
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
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
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
  # 파트너의 잔여포인트를 확인합니다.
  # - 과금방식이 연동과금인 경우 연동회원 잔여포인트(GetBalance API)를 이용하시기 바랍니다.
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
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
  # 파트너 포인트충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # CHRG-포인트충전
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
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getPopbillURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전, CERT-공인인증서등록
    togo = "CHRG"

    begin
      @value = TaxinvoiceController::TIService.getPopbillURL(
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
  # 연동회원의 담당자를 신규로 등록합니다.
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 담당자 정보
    contactInfo = {
        # 아이디
        "id" => "testkorea1701313",

        # 비밀번호
        "pwd" => "test05028342",

        # 담당자명
        "personName" => "담당자명170116",

        # 연락처
        "tel" => "070-4304-2991",

        # 휴대폰번호
        "hp" => "010-1111-2222",

        # 팩스번호
        "fax" => "070-1111-2222",

        # 메일주소
        "email" => "test@gmail.com",

        # 회사조회 권한여부, true-회사조회, false-개인조회
        "searchAllAllowYN" => true,
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
  # 연동회원의 담당자 목록을 확인합니다.
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
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
  # 연동회원의 담당자 정보를 수정합니다.
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = TaxinvoiceController::TestUserID


    # 담당자 정보
    contactInfo = {

        # 담당자 아이디
        "id" => userID,

        # 담당자명
        "personName" => "담당자명170131",

        # 연락처
        "tel" => "070-4304-2991",

        # 휴대폰번호
        "hp" => "010-1111-2222",

        # 팩스번호
        "fax" => "070-1111-2222",

        # 메일주소
        "email" => "test@gmail.com",

        # 회사조회여부, true-회사조회, false-개인조회
        "searchAllAllowYN" => true,
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


  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
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
  # 연동회원의 회사정보를 수정합니다
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 회사정보
    corpInfo = {

        # 대표자명
        "ceoname" => "대표자명170116",

        # 상호명
        "corpName" => "상호170116",

        # 주소
        "addr" => "주소170116",

        # 업태
        "bizType" => "업태170116",

        # 업종
        "bizClass" => "종목170116",
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
  # 세금계산서 문서관리번호 중복여부를 확인합니다.
  # - 관리번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.
  ##############################################################################
  def checkMgtKeyInUse

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 문서관리번호
    mgtKey = "20170207-01"

    # 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    begin
      @response = TaxinvoiceController::TIService.checkMgtKeyInUse(
          corpNum,
          keyType,
          mgtKey,
      )

      if @response
        @value = "사용중"
      else
        @value = "미사용중"
      end

      @name = "문서관리번호(mgtKey) 사용여부 확인"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 1건의 세금계산서를 즉시발행 처리합니다.
  # - 세금계산서 항목별 정보는 "[전자세금계산서 API 연동매뉴얼] > 4.1. (세금)계산서 구성"을
  # 참조하시기 바랍니다.
  ##############################################################################
  def registIssue

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 문서관리번호
    mgtKey = "20170207-09"

    # 거래명세서 동시작성여부
    writeSpecification = false

    # 지연발행 강제여부
    # - 발행마감일이 지난 세금계산서를 발행하는 경우, 가산세가 부과될 수 있습니다.
    # - 가산세가 부과되더라도 발행을 해야하는 경우에는 forceIssue의 값을
    # - true로 선언하여 발행(Issue API)를 호출하시면 됩니다.
    forceIssue = false

    # 거래명세서 동시작성시 거래명세서 관리번호, 미기재시 세금계산서 관리번호로 자동작성
    dealInvoiceMgtKey = ''

    # 메모
    memo = ''

    # 발행안내메일 제목, 미기재시 기본양식으로 전송됨
    emailSubject = ''

    # 세금계산서 정보
    taxinvoice = {

        # [필수] 작성일자, 표시형식 (yyyyMMdd) ex)20170203
        "writeDate" => "20170203",

        # [필수] 발행형태, [정발행, 역발행, 위수탁] 중 기재
        "issueType" => "정발행",

        # [필수] 과세형태, [과세, 영세, 면세] 중 기재
        "taxType" => "과세",

        # [필수] 발행시점, [직접발행, 승인시자동발행] 중 기재
        # - 발행예정(Send API) 프로세스를 구현하지 않는경우 '직접발행' 기재
        "issueTiming" => "직접발행",

        # [필수] {정과금, 역과금} 중 기재, '역과금'은 역발행 프로세스에서만 이용가능
        # - 정과금(공급자 과금), 역과금(공급받는자 과금)
        "chargeDirection" => "정과금",

        # [필수] 영수/청구, [영수, 청구] 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # [필수] 합계금액, 공급가액 합계 + 세액합계
        "totalAmount" => "22000",

        # 기재 상 '일련번호' 항목
        "serialNum" => "",

        # 기재 상 '권' 항목, 숫자만 입력(0~32767)
        "kwon" => nil,

        # 기재 상 '호' 항목, 숫자만 입력(0~32767)
        "ho" => nil,

        # 기재 상 '현금' 항목
        "cash" => "",

        # 기재 상 '수표' 항목
        "chkBill" => "",

        # 기재 상 '어음' 항목
        "note" => "",

        # 기재 상 '외상미수금' 항목
        "credit" => "",

        # 기재 상 '비고' 항목
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,


        ######################### 수정세금계산서 정보 ##########################
        # - 수정세금계산서 관련 정보는 연동매뉴얼 또는 개발가이드 링크 참조
        # - [참고] 수정세금계산서 작성방법 안내 - http://blog.linkhub.co.kr/650

        # 수정사유코드, 수정사유에 따라 1~6중 선택기재, 미기재시 nil 로 처리
        "modifyCode" => nil,

        # 원본세금계산서의 ItemKey, 문서확인 (GetInfo API)의 응답결과(ItemKey 항목) 확인
        "originalTaxinvoiceKey" => "",


        ######################### 공급자정보 #########################

        # [필수] 공급자 사업자번호, '-' 제외 10자리
        "invoicerCorpNum" => corpNum,

        # 공급자 종사업장 식별번호, 필요시 숫자 4자리 기재
        "invoicerTaxRegID" => "",

        # [필수] 공급자 상호
        "invoicerCorpName" => "상호명",

        # [필수] 공급자 대표자 성명
        "invoicerCEOName" => "대표자명",

        # [필수] 공급자 문서관리번호, 1~24자리 (숫자, 영문, '-', '_') 조합으로
        # 사업자 별로 중복되지 않도록 구성
        "invoicerMgtKey" => mgtKey,

        # 공급자 주소
        "invoicerAddr" => "공급자 주소",

        # 공급자 업태
        "invoicerBizType" => "공급자 업태",

        # 공급자 종목
        "invoicerBizClass" => "공급자 종목",

        # 공급자 담당자명
        "invoicerContactName" => "공급자 담당자명",

        # 공급자 담당자 메일주소
        "invoicerEmail" => "test@test.com",

        # 공급자 담당자 휴대폰번호
        "invoicerHP" => "010-111-222",

        # 공급자 담당자 연락처
        "invoicerTEL" => "070-4304-2991",

        # 발행안내문자 전송여부
        "invoicerSMSSendYN" => false,


        ######################### 공급받는자정보 #########################

        # [필수] 공급받는자 구분, [사업자, 개인, 외국인] 중 기재
        "invoiceeType" => "사업자",

        # [필수] 공급받는자 사업자번호, '-' 제외 10자리
        "invoiceeCorpNum" => "8888888888",

        # 공급받는자 종사업장 식별번호, 필요시 숫자 4자리 기재
        "invoiceeTaxRegId" => "",

        # [필수] 공급받는자 종사업자 식별번호. 필요시 숫자 4자리 기재
        "invoiceeCorpName" => "공급받는자 상호",

        # [필수] 공급받는자 대표자 성명
        "invoiceeCEOName" => "대표자 성명",

        # 공급받는자 문서관리번호
        "invoiceeMgtKey" => "",

        # 공급받는자 주소
        "invoiceeAddr" => "공급받는자 주소",

        # 공급받는자 종목
        "invoiceeBizClass" => "공급받는자 종목",

        # 공급받는자 업태
        "invoiceeBizType" => "공급받는자 업태",

        # 공급받는자 담당자명
        "invoiceeContactName1" => "공급받는자담당자명",

        # 공급받는자 담당자 메일주소
        "invoiceeEmail1" => "test@test.com",

        # 공급받는자 담당자 연락처
        "invoiceeTEL1" => "070-1234-1234",

        # 공급받는자 담당자 휴대폰번호
        "invoiceeHP1" => "010-123-1234",

        # 역발행시 발행안내문자 전송여부
        "invoiceeSMSSendYN" => false,


        ######################### 상세항목(품목) 정보 #########################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20170203", # 거래일자, yyyyMMdd
                "itemName" => "테스트1", # 품목명
                "spec" => "규격", # 규격
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20170203", # 거래일자, yyyyMMdd
                "itemName" => "테스트2", # 품목명
                "spec" => "규격", # 규격
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],


        ######################### 추가담당자정보 #########################
        # 세금계산서 발행안내 메일을 수신받을 공급받는자의 담당자가 다수인 경우 담당자 정보를
        # 추가하여 발행안내메일을 다수에게 전송할 수 있습니다.
        ##############################################################

        "addContactList" => [
            {
                "serialNum" => 1, # 일련번호, 1부터 순차기재
                "contactName" => "담당자01", # 담당자명
                "email" => "test@test.com", # 담당자 메일주소
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "contactName" => "담당자02", # 담당자명
                "email" => "test@test.com", # 담당자 메일주소
            }
        ],
    }

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


  ##############################################################################
  # 1건의 세금계산서를 임시저장 합니다.
  # - 세금계산서 임시저장(Register API) 호출후에는 발행(Issue API)을 호출해야만 국세청으로 전송됩니다.
  # - 임시저장과 발행을 한번의 호출로 처리하는 즉시발행(RegistIssue API) 프로세스 연동을 권장합니다.
  # - 세금계산서 항목별 정보는 "[전자세금계산서 API 연동매뉴얼] > 4.1. (세금)계산서 구성"을
  #   참조하시기 바랍니다.
  ##############################################################################
  def register

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 거래명세서 동시작성여부
    writeSpecification = false

    # 세금계산서 정보
    taxinvoice = {

        # [필수] 작성일자, 표시형식 (yyyyMMdd) ex)20170203
        "writeDate" => "20170207",

        # [필수] 발행형태, [정발행, 역발행, 위수탁] 중 기재
        "issueType" => "정발행",

        # [필수] 과세형태, [과세, 영세, 면세] 중 기재
        "taxType" => "과세",

        # [필수] 발행시점, [직접발행, 승인시자동발행] 중 기재
        # - 발행예정(Send API) 프로세스를 구현하지 않는경우 '직접발행' 기재
        "issueTiming" => "직접발행",

        # [필수] {정과금, 역과금} 중 기재, '역과금'은 역발행 프로세스에서만 이용가능
        # - 정과금(공급자 과금), 역과금(공급받는자 과금)
        "chargeDirection" => "정과금",

        # [필수] 영수/청구, [영수, 청구] 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # [필수] 합계금액, 공급가액 합계 + 세액합계
        "totalAmount" => "22000",

        # 기재 상 '일련번호' 항목
        "serialNum" => "",

        # 기재 상 '권' 항목, 숫자만 입력(0~32767)
        "kwon" => nil,

        # 기재 상 '호' 항목, 숫자만 입력(0~32767)
        "ho" => nil,

        # 기재 상 '현금' 항목
        "cash" => "",

        # 기재 상 '수표' 항목
        "chkBill" => "",

        # 기재 상 '어음' 항목
        "note" => "",

        # 기재 상 '외상미수금' 항목
        "credit" => "",

        # 기재 상 '비고' 항목
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,

        ######################### 수정세금계산서 정보 ##########################
        # - 수정세금계산서 관련 정보는 연동매뉴얼 또는 개발가이드 링크 참조
        # - [참고] 수정세금계산서 작성방법 안내 - http://blog.linkhub.co.kr/650

        # 수정사유코드, 수정사유에 따라 1~6중 선택기재, 미기재시 nil 로 처리
        "modifyCode" => nil,

        # 원본세금계산서의 ItemKey, 문서확인 (GetInfo API)의 응답결과(ItemKey 항목) 확인
        "originalTaxinvoiceKey" => "",


        ######################### 공급자정보 #########################

        # [필수] 공급자 사업자번호, '-' 제외 10자리
        "invoicerCorpNum" => corpNum,

        # 공급자 종사업장 식별번호, 필요시 숫자 4자리 기재
        "invoicerTaxRegID" => "",

        # [필수] 공급자 상호
        "invoicerCorpName" => "상호명",

        # [필수] 공급자 대표자 성명
        "invoicerCEOName" => "대표자명",

        # [필수] 공급자 문서관리번호, 1~24자리 (숫자, 영문, '-', '_') 조합으로
        # 사업자 별로 중복되지 않도록 구성
        "invoicerMgtKey" => mgtKey,

        # 공급자 주소
        "invoicerAddr" => "공급자 주소",

        # 공급자 업태
        "invoicerBizType" => "공급자 업태",

        # 공급자 종목
        "invoicerBizClass" => "공급자 종목",

        # 공급자 담당자명
        "invoicerContactName" => "공급자 담당자명",

        # 공급자 담당자 메일주소
        "invoicerEmail" => "test@test.com",

        # 공급자 담당자 휴대폰번호
        "invoicerHP" => "010-111-222",

        # 공급자 담당자 연락처
        "invoicerTEL" => "070-4304-2991",

        # 발행안내문자 전송여부
        "invoicerSMSSendYN" => false,


        ######################### 공급받는자정보 #########################

        # [필수] 공급받는자 구분, [사업자, 개인, 외국인] 중 기재
        "invoiceeType" => "사업자",

        # [필수] 공급받는자 사업자번호, '-' 제외 10자리
        "invoiceeCorpNum" => "8888888888",

        # 공급받는자 종사업장 식별번호, 필요시 숫자 4자리 기재
        "invoiceeTaxRegId" => "",

        # [필수] 공급받는자 종사업자 식별번호. 필요시 숫자 4자리 기재
        "invoiceeCorpName" => "공급받는자 상호",

        # [필수] 공급받는자 대표자 성명
        "invoiceeCEOName" => "대표자 성명",

        # 공급받는자 문서관리번호
        "invoiceeMgtKey" => "",

        # 공급받는자 주소
        "invoiceeAddr" => "공급받는자 주소",

        # 공급받는자 종목
        "invoiceeBizClass" => "공급받는자 종목",

        # 공급받는자 업태
        "invoiceeBizType" => "공급받는자 업태",

        # 공급받는자 담당자명
        "invoiceeContactName1" => "공급받는자담당자명",

        # 공급받는자 담당자 메일주소
        "invoiceeEmail1" => "test@test.com",

        # 공급받는자 담당자 연락처
        "invoiceeTEL1" => "070-1234-1234",

        # 공급받는자 담당자 휴대폰번호
        "invoiceeHP1" => "010-123-1234",

        # 역발행시 발행안내문자 전송여부
        "invoiceeSMSSendYN" => false,


        ######################### 상세항목(품목) 정보 #########################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20170203", # 거래일자, yyyyMMdd
                "itemName" => "테스트1", # 품목명
                "spec" => "규격", # 규격
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20170203", # 거래일자, yyyyMMdd
                "itemName" => "테스트2", # 품목명
                "spec" => "규격", # 규격
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],


        ######################### 추가담당자정보 #########################
        # 세금계산서 발행안내 메일을 수신받을 공급받는자의 담당자가 다수인 경우 담당자 정보를
        # 추가하여 발행안내메일을 다수에게 전송할 수 있습니다.
        ##############################################################

        "addContactList" => [
            {
                "serialNum" => 1, # 일련번호, 1부터 순차기재
                "contactName" => "담당자01", # 담당자명
                "email" => "test@test.com", # 담당자 메일주소
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "contactName" => "담당자02", # 담당자명
                "email" => "test@test.com", # 담당자 메일주소
            }
        ],
    }

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
  # [임시저장] 상태의 세금계산서의 항목을 수정합니다.
  # - 세금계산서 항목별 정보는 "[전자세금계산서 API 연동매뉴얼] > 4.1. (세금)계산서 구성"을
  #   참조하시기 바랍니다.
  ##############################################################################
  def update

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

    # 세금계산서 정보
    taxinvoice = {

        # [필수] 작성일자, 표시형식 (yyyyMMdd) ex)20170203
        "writeDate" => "20170203",

        # [필수] 발행형태, [정발행, 역발행, 위수탁] 중 기재
        "issueType" => "정발행",

        # [필수] 과세형태, [과세, 영세, 면세] 중 기재
        "taxType" => "과세",

        # [필수] 발행시점, [직접발행, 승인시자동발행] 중 기재
        # - 발행예정(Send API) 프로세스를 구현하지 않는경우 '직접발행' 기재
        "issueTiming" => "직접발행",

        # [필수] {정과금, 역과금} 중 기재, '역과금'은 역발행 프로세스에서만 이용가능
        # - 정과금(공급자 과금), 역과금(공급받는자 과금)
        "chargeDirection" => "정과금",

        # [필수] 영수/청구, [영수, 청구] 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # [필수] 합계금액, 공급가액 합계 + 세액합계
        "totalAmount" => "22000",

        # 기재 상 '일련번호' 항목
        "serialNum" => "",

        # 기재 상 '권' 항목, 숫자만 입력(0~32767)
        "kwon" => nil,

        # 기재 상 '호' 항목, 숫자만 입력(0~32767)
        "ho" => nil,

        # 기재 상 '현금' 항목
        "cash" => "",

        # 기재 상 '수표' 항목
        "chkBill" => "",

        # 기재 상 '어음' 항목
        "note" => "",

        # 기재 상 '외상미수금' 항목
        "credit" => "",

        # 기재 상 '비고' 항목
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,


        ######################### 공급자정보 #########################

        # [필수] 공급자 사업자번호, '-' 제외 10자리
        "invoicerCorpNum" => corpNum,

        # 공급자 종사업장 식별번호, 필요시 숫자 4자리 기재
        "invoicerTaxRegID" => "",

        # [필수] 공급자 상호
        "invoicerCorpName" => "상호명_수정",

        # [필수] 공급자 대표자 성명
        "invoicerCEOName" => "대표자명_수정",

        # [필수] 공급자 문서관리번호, 1~24자리 (숫자, 영문, '-', '_') 조합으로
        # 사업자 별로 중복되지 않도록 구성
        "invoicerMgtKey" => mgtKey,

        # 공급자 주소
        "invoicerAddr" => "공급자 주소",

        # 공급자 업태
        "invoicerBizType" => "공급자 업태",

        # 공급자 종목
        "invoicerBizClass" => "공급자 종목",

        # 공급자 담당자명
        "invoicerContactName" => "공급자 담당자명",

        # 공급자 담당자 메일주소
        "invoicerEmail" => "test@test.com",

        # 공급자 담당자 휴대폰번호
        "invoicerHP" => "010-111-222",

        # 공급자 담당자 연락처
        "invoicerTEL" => "070-4304-2991",

        # 발행안내문자 전송여부
        "invoicerSMSSendYN" => false,


        ######################### 공급받는자정보 #########################

        # [필수] 공급받는자 구분, [사업자, 개인, 외국인] 중 기재
        "invoiceeType" => "사업자",

        # [필수] 공급받는자 사업자번호, '-' 제외 10자리
        "invoiceeCorpNum" => "8888888888",

        # 공급받는자 종사업장 식별번호, 필요시 숫자 4자리 기재
        "invoiceeTaxRegId" => "",

        # [필수] 공급받는자 종사업자 식별번호. 필요시 숫자 4자리 기재
        "invoiceeCorpName" => "공급받는자 상호",

        # [필수] 공급받는자 대표자 성명
        "invoiceeCEOName" => "대표자 성명",

        # 공급받는자 문서관리번호
        "invoiceeMgtKey" => "",

        # 공급받는자 주소
        "invoiceeAddr" => "공급받는자 주소",

        # 공급받는자 종목
        "invoiceeBizClass" => "공급받는자 종목",

        # 공급받는자 업태
        "invoiceeBizType" => "공급받는자 업태",

        # 공급받는자 담당자명
        "invoiceeContactName1" => "공급받는자담당자명",

        # 공급받는자 담당자 메일주소
        "invoiceeEmail1" => "test@test.com",

        # 공급받는자 담당자 연락처
        "invoiceeTEL1" => "070-1234-1234",

        # 공급받는자 담당자 휴대폰번호
        "invoiceeHP1" => "010-123-1234",

        # 역발행시 발행안내문자 전송여부
        "invoiceeSMSSendYN" => false,


        ######################### 상세항목(품목) 정보 #########################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20170203", # 거래일자, yyyyMMdd
                "itemName" => "테스트1", # 품목명
                "spec" => "규격", # 규격
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20170203", # 거래일자, yyyyMMdd
                "itemName" => "테스트2", # 품목명
                "spec" => "규격", # 규격
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],


        ######################### 추가담당자정보 #########################
        # 세금계산서 발행안내 메일을 수신받을 공급받는자의 담당자가 다수인 경우 담당자 정보를
        # 추가하여 발행안내메일을 다수에게 전송할 수 있습니다.
        ##############################################################

        "addContactList" => [
            {
                "serialNum" => 1, # 일련번호, 1부터 순차기재
                "contactName" => "담당자01", # 담당자명
                "email" => "test@test.com", # 담당자 메일주소
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "contactName" => "담당자02", # 담당자명
                "email" => "test@test.com", # 담당자 메일주소
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

  ##############################################################################
  # 1건의 세금계산서 상태/요약 정보를 확인합니다.
  # - 세금계산서 상태정보(GetInfo API) 응답항목에 대한 자세한 정보는 "[전자세금계산서 API 연동매뉴얼]
  # > 4.2. (세금)계산서 상태정보 구성" 을 참조하시기 바랍니다.
  ##############################################################################
  def getInfo

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

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
  # 다량의 세금계산서 상태/요약 정보를 확인합니다. (최대 1000건)
  # - 세금계산서 상태정보(GetInfos API) 응답항목에 대한 자세한 정보는 "[전자세금계산서 API 연동매뉴얼]
  # > 4.2. (세금)계산서 상태정보 구성" 을 참조하시기 바랍니다.
  ##############################################################################
  def getInfos

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호 배열
    mgtKeyList = ["20170131-01", "20170131-02"]

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
  # 1건의 세금계산서 상세항목을 확인합니다.
  # - 응답항목에 대한 자세한 사항은 "[전자세금계산서 API 연동매뉴얼] > 4.1 (세금)계산서 구성" 을
  # 참조하시기 바랍니다.
  ##############################################################################
  def getDetailInfo

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-01"

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
  # 1건의 전자세금계산서를 삭제합니다.
  # - 세금계산서를 삭제해야만 문서관리번호(mgtKey)를 재사용할 수 있습니다.
  # - 삭제가능한 문서 상태 : [임시저장], [발행취소], [발행예정 취소], [발행예정 거부]
  ##############################################################################
  def delete

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

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
  #' 세금계산서 상태 변경이력을 확인합니다.
  # - 상태 변경이력 확인(GetLogs API) 응답항목에 대한 자세한 정보는
  #   "[전자세금계산서 API 연동매뉴얼] > 3.6.4 상태 변경이력 확인"을 참조하시기 바랍니다.
  ##############################################################################
  def getLogs

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-01"

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
  # 검색조건을 사용하여 세금계산서 목록을 조회합니다.
  # - 응답항목에 대한 자세한 사항은 "[전자세금계산서 API 연동매뉴얼] > 4.2. (세금)계산서 상태정보 구성"
  #   을 참조하시기 바랍니다.
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = TaxinvoiceController::TestUserID

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # [필수] 일자유형, R-등록일시 W-작성일자 I-발행일시 중 택1
    dType = "W"

    # [필수] 시작일자, yyyyMMdd
    sDate = "20171101"

    # [필수] 종료일자, yyyyMMdd
    eDate = "20171231"

    # 전송상태값 배열, 미기재시 전체상태조회, 문서상태값 3자리숫자 작성, 2,3번째 와일드카드 가능
    state = ["3**", "6**"]

    # 문서유형 배열, N-일반 M-수정 중 선택, 미기재시 전체조회
    type = ["N", "M"]

    # 과세형태 배열, T-과세, N-면세 Z-영세 중 선택, 미기재시 전체조회
    taxType = ["T", "N", "Z"]

    # 발행형태 배열, N-정발행, R-역발행, T-위수탁
    issueType = ["N", "R", "T"]

    # 지연발행 여부, 0-정상발행분만 조회 1-지연발행분만조회, 공백처리시 전체조회
    lateOnly = ''

    # 종사업장 유무, 공백-전체조회, 0-종사업장번호 없는경우만 조회, 1-종사업장번호 조건 조회
    taxRegIDYN = ''

    # 종사업장번호 유형 S-공급자, B-공급받는자, T-수탁자
    taxRegIDType = ''

    # 종사업장번호, 콤마(,)로 구분하여 구성 ex) 0001,0002
    taxRegID = ''

    # 페이지 번호
    page = 1

    # 페이지 목록개수, 최대 1000건
    perPage = 25

    # 정렬방향, D-내림차순(기본값), A-오름차순
    order = "D"

    # 거래처 조회, 거래처 상호 또는 거래처 사업자등록번호 조회, 공백처리시 전체조회
    queryString = ""

    # 연동문서 조회여부, 공백-전체조회, 0-일반문서 조회, 1-연동문서 조회
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
  # 세금계산서에 첨부파일을 등록합니다.
  # - [임시저장] 상태의 세금계산서만 파일을 첨부할수 있습니다.
  # - 첨부파일은 최대 5개까지 등록할 수 있습니다.
  ##############################################################################
  def attachFile

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

    # 첨부파일경로
    filePath = "/Users/John/Documents/WorkSpace/ruby project/ruby_popbill_example/test.pdf"

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
  # 세금계산서에 첨부된 파일의 목록을 확인합니다.
  # - 응답항목 중 파일아이디(AttachedFile) 항목은 파일삭제(DeleteFile API) 호출시 이용할 수 있습니다.
  ##############################################################################
  def getFiles

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

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
  # 세금계산서에 첨부된 파일을 삭제합니다.
  # - 파일을 식별하는 파일아이디는 첨부파일 목록(GetFiles API) 의 응답항목
  #   중 파일아이디(AttachedFile) 값을 통해 확인할 수 있습니다.
  ##############################################################################
  def deleteFile

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

    # 파일아이디, GetFiles API 응답항목 중 파일아이디 (AttachedFile) 값 기재
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
  # 1건의 [임시저장] 상태의 세금계산서를 [발행예정] 처리합니다.
  # - 발행예정이란 공급자와 공급받는자 사이에 세금계산서 확인 후 발행하는 방법입니다.
  # - "[전자세금계산서 API 연동매뉴얼] > 1.3.1. 정발행 프로세스 흐름도
  #   > 다. 임시저장 발행예정" 의 프로세스를 참조하시기 바랍니다.
  ##############################################################################
  def sendTI

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

    # 메모
    memo = "발행예정 메모"

    # 발행예정 안내메일 제목, 미기재시 기본양식으로 전송됨.
    emailSubject = ""

    begin
      @Response = TaxinvoiceController::TIService.send(
          corpNum,
          keyType,
          mgtKey,
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
  # 발행예정 세금계산서를 [취소] 처리 합니다.
  # - [취소]된 세금계산서를 삭제(Delete API)하면 등록된 문서관리번호를 재사용할 수 있습니다.
  ##############################################################################
  def cancelSend

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-02"

    # 메모
    memo = "발행예정 취소 메모"

    begin
      @Response = TaxinvoiceController::TIService.cancelSend(
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
  # 발행예정 세금계산서를 [승인]처리합니다.
  ##############################################################################
  def accept

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

    begin
      @Response = TaxinvoiceController::TIService.accept(
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
  # 발행예정 세금계산서를 [거부]처리 합니다.
  # - [거부]처리된 세금계산서를 삭제(Delete API)하면 등록된 문서관리번호를 재사용할 수 있습니다.
  ##############################################################################
  def deny

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

    begin
      @Response = TaxinvoiceController::TIService.deny(
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
  # [임시저장] 상태의 세금계산서를 [발행]처리 합니다.
  # - 발행(Issue API)를 호출하는 시점에서 포인트가 차감됩니다.
  # - [발행완료] 세금계산서는 연동회원의 국세청 전송설정에 따라 익일/즉시전송 처리됩니다. 기본설정(익일전송)
  # - 국세청 전송설정은 "팝빌 로그인" > [전자세금계산서] > [환경설정] > [전자세금계산서 관리]
  #   > [국세청 전송 및 지연발행 설정] 탭에서 확인할 수 있습니다.
  # - 국세청 전송정책에 대한 사항은 "[전자세금계산서 API 연동매뉴얼] > 1.4. 국세청 전송 정책" 을 참조하시기 바랍니다
  ##############################################################################
  def issue

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 지연발행 강제여부
    # - 발행마감일이 지난 세금계산서를 발행하는 경우, 가산세가 부과될 수 있습니다.
    # - 지연발행 세금계산서를 신고해야 하는 경우 forceIssue 값을 true로 선언하여
    #   발행(Issue API)을 호출할 수 있습니다.
    forceIssue = false

    # 메모
    memo = ''

    # 발행안내메일 제목, 미기재시 기본양식으로 전송
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
  # [발행완료] 상태의 세금계산서를 [발행취소] 처리합니다.
  # - [발행취소]는 국세청 전송전에만 가능합니다.
  # - 발행취소된 세금계산서는 국세청에 전송되지 않습니다.
  # - 발행취소 세금계산서에 기재된 문서관리번호를 재사용 하기 위해서는 삭제(Delete API)를
  #   호출하여 [삭제] 처리 하셔야 합니다.
  ##############################################################################
  def cancelIssue

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 메모
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
  # 공급받는자가 공급자에게 1건의 역발행 세금계산서를 요청합니다.
  # - 역발행 세금계산서 프로세스를 구현하기 위해서는 공급자/공급받는자가 모두 팝빌에 회원이여야 합니다.
  # - 역발행 요청후 공급자가 [발행] 처리시 포인트가 차감되며 역발행 세금계산서 항목중
  #   과금방향(ChargeDirection) 에 기재한 값에 따라 정과금(공급자과금) 또는 역과금(공급받는자과금)
  #   처리됩니다.
  ##############################################################################
  def requestTI

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

    # 메모
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
  # 역발행 세금계산서를 [취소] 처리합니다.
  # - [취소]한 세금계산서의 문서관리번호를 재사용하기 위해서는 삭제 (Delete API)를 호출해야 합니다.
  ##############################################################################
  def cancelRequest

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

    # 메모
    memo = ''

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
  # 공급받는자에게 요청받은 역발행 세금계산서를 [거부]처리 합니다.
  # - 세금계산서의 문서관리번호를 재사용하기 위해서는 삭제 (Delete API)를 호출하여 [삭제] 처리해야 합니다.
  ##############################################################################
  def refuse
    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

    # 메모
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
  # [발행완료] 상태의 세금계산서를 국세청으로 즉시전송합니다.
  # - 국세청 즉시전송을 호출하지 않은 세금계산서는 발행일 기준 익일 오후 3시에
  #   팝빌 시스템에서 일괄적으로 국세청으로 전송합니다.
  # - 익일전송시 전송일이 법정공휴일인 경우 다음 영업일에 전송됩니다.
  # - 국세청 전송에 관한 사항은 "[전자세금계산서 API 연동매뉴얼] > 1.4 국세청 전송 정책" 을
  #   참조하시기 바랍니다.
  ##############################################################################
  def sendToNTS

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

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
  # 발행 안내메일을 재전송합니다.
  ##############################################################################
  def sendEmail

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 공급받는자 담당자 메일주소
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
  # 알림문자를 전송합니다. (단문/SMS- 한글 최대 45자)
  # - 알림문자 전송시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [전송내역] 탭에서 전송결과를 확인할 수 있습니다.
  ##############################################################################
  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 발신번호
    sendNum = "07043042991"

    # 수신번호
    receiveNum = "010-111-222"

    # 메시지 내용, 90byte 초과한 내용은 삭제되어 전송됩니다.
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
  # 전자세금계산서를 팩스전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역] 메뉴에서 전송결과를
  #   확인할 수 있습니다.
  ##############################################################################
  def sendFax

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 발신번호
    sendNum = "07043042991"

    # 수신 팩스번호
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
  # 1건의 전자명세서를 세금계산서에 첨부합니다.
  ##############################################################################
  def attachStatement

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 첨부할 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 관리번호
    stmtMgtKey = "20161130-05"

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
  # 세금계산서에 첨부된 전자명세서 1건을 첨부해제합니다.
  ##############################################################################
  def detachStatement

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

    # 첨부해제할 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 관리번호
    stmtMgtKey = "20161130-05"

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
  # 팝빌 전자세금계산서 문서함 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 매출문서함-SBOX, 매입문서함-PBOX, 임시문서함-TBOX, 매출작성-WRITE
    togo = "SBOX"

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
  # 1건의 전자세금계산서 보기 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getPopUpURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

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
  # 1건의 전자세금계산서 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getPrintURL
    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170203-01"

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
  # 세금계산서 인쇄(공급받는자) URL을 반환합니다.
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getEPrintURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-05"

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
  # 다수건의 전자세금계산서 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getMassPrintURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호 배열, 최대 100건
    mgtKeyList = ["20170131-01", "20170131-02"]

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
  # 공급받는자 메일링크 URL을 반환합니다.
  # - 메일링크 URL은 유효시간이 존재하지 않습니다.
  ##############################################################################
  def getMailURL

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 발행유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 문서관리번호
    mgtKey = "20170207-01"

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
  # 전자세금계산서 발행단가를 확인합니다.
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
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
  # 팝빌에 등록되어 있는 공인인증서의 만료일자를 확인합니다.
  # - 공인인증서가 갱신/재발급/비밀번호 변경이 되는 경우 해당 인증서를
  #   재등록 하셔야 정상적으로 API를 이용하실 수 있습니다.
  ##############################################################################
  def getCertificateExpireDate

    # 팝빌회원 사업자번호
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
  # 대용량 연계사업자 메일주소 목록을 반환합니다.
  ##############################################################################
  def getEmailPublicKeys

    # 팝빌회원 사업자번호
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
  # 팝빌 사이트에서 작성한 세금계산서에 파트너의 문서관리번호를 할당합니다.
  ##############################################################################
  def assignMgtKey

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 세금계산서 유형 SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = MgtKeyType::SELL

    # 세금계산서 아이템키, 목록조회(Search) API의 반환항목중 ItemKey 참조
    itemKey = "018062516505300001"

    # 할당할 문서관리번호, 숫자, 영문, '-', '_' 조합으로
    # 1~24자리까지 사업자번호별 중복없는 고유번호 할당
    mgtKey = "20180625165253"

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
  # 전자세금계산서 메일전송 항목에 대한 전송여부를 목록으로 반환한다.
  ##############################################################################
  def listEmailConfig

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
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
  # 전자세금계산서 메일전송 항목에 대한 전송여부를 수정한다.
  # 메일전송유형
  # [정발행]
  # TAX_ISSUE : 공급받는자에게 전자세금계산서 발행 메일 입니다.
  # TAX_ISSUE_INVOICER : 공급자에게 전자세금계산서 발행 메일 입니다.
  # TAX_CHECK : 공급자에게 전자세금계산서 수신확인 메일 입니다.
  # TAX_CANCEL_ISSUE : 공급받는자에게 전자세금계산서 발행취소 메일 입니다.
  #
  # [발행예정]
  # TAX_SEND : 공급받는자에게 [발행예정] 세금계산서 발송 메일 입니다.
  # TAX_ACCEPT : 공급자에게 [발행예정] 세금계산서 승인 메일 입니다.
  # TAX_ACCEPT_ISSUE : 공급자에게 [발행예정] 세금계산서 자동발행 메일 입니다.
  # TAX_DENY : 공급자에게 [발행예정] 세금계산서 거부 메일 입니다.
  # TAX_CANCEL_SEND : 공급받는자에게 [발행예정] 세금계산서 취소 메일 입니다.
  #
  # [역발행]
  # TAX_REQUEST : 공급자에게 세금계산서를 발행요청 메일 입니다.
  # TAX_CANCEL_REQUEST : 공급받는자에게 세금계산서 취소 메일 입니다.
  # TAX_REFUSE : 공급받는자에게 세금계산서 거부 메일 입니다.
  #
  # [위수탁발행]
  # TAX_TRUST_ISSUE : 공급받는자에게 전자세금계산서 발행 메일 입니다.
  # TAX_TRUST_ISSUE_TRUSTEE : 수탁자에게 전자세금계산서 발행 메일 입니다.
  # TAX_TRUST_ISSUE_INVOICER : 공급자에게 전자세금계산서 발행 메일 입니다.
  # TAX_TRUST_CANCEL_ISSUE : 공급받는자에게 전자세금계산서 발행취소 메일 입니다.
  # TAX_TRUST_CANCEL_ISSUE_INVOICER : 공급자에게 전자세금계산서 발행취소 메일 입니다.
  #
  # [위수탁 발행예정]
  # TAX_TRUST_SEND : 공급받는자에게 [발행예정] 세금계산서 발송 메일 입니다.
  # TAX_TRUST_ACCEPT : 수탁자에게 [발행예정] 세금계산서 승인 메일 입니다.
  # TAX_TRUST_ACCEPT_ISSUE : 수탁자에게 [발행예정] 세금계산서 자동발행 메일 입니다.
  # TAX_TRUST_DENY : 수탁자에게 [발행예정] 세금계산서 거부 메일 입니다.
  # TAX_TRUST_CANCEL_SEND : 공급받는자에게 [발행예정] 세금계산서 취소 메일 입니다.
  #
  # [처리결과]
  # TAX_CLOSEDOWN : 거래처의 휴폐업 여부 확인 메일 입니다.
  # TAX_NTSFAIL_INVOICER : 전자세금계산서 국세청 전송실패 안내 메일 입니다.
  #
  # [정기발송]
  # TAX_SEND_INFO : 전월 귀속분 [매출 발행 대기] 세금계산서 발행 메일 입니다.
  # ETC_CERT_EXPIRATION : 팝빌에서 이용중인 공인인증서의 갱신 메일 입니다.
  ##############################################################################
  def updateEmailConfig

    # 팝빌회원 사업자번호
    corpNum = TaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = TaxinvoiceController::TestUserID

    # 메일 전송 유형
    emailType = "TAX_ISSUE"

    # 메일 전송 여부 (true-전송, false-미전송)
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
  # 팝빌에 등록된 공인인증서의 유효성을 확인합니다.
  ##############################################################################
  def checkCertValidation

    # 팝빌회원 사업자번호
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


end
