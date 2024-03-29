################################################################################
#
# 팝빌 현금영수증 API Ruby SDK Rails Example
# Rails 연동 튜토리얼 안내 : https://developers.popbill.com/guide/cashbill/ruby/getting-started/tutorial
#
# 업데이트 일자 : 2024-02-27
# 연동기술지원 연락처 : 1600-9854
# 연동기술지원 이메일 : code@linkhubcorp.com
#         
# <테스트 연동개발 준비사항>
# 1) API Key 변경 (연동신청 시 메일로 전달된 정보)
#     - LinkID : 링크허브에서 발급한 링크아이디
#     - SecretKey : 링크허브에서 발급한 비밀키
# 2) SDK 환경설정 옵션 설정
#     - IsTest : 연동환경 설정, true-테스트, false-운영(Production), (기본값:true)
#     - IPRestrictOnOff : 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
#     - UseStaticIP : 통신 IP 고정, true-사용, false-미사용, (기본값:false)
#     - UseLocalTimeYN : 로컬시스템 시간 사용여부, true-사용, false-미사용, (기본값:true)
#
################################################################################

require 'popbill/cashbill'

class CashbillController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 현금영수증 Service API 초기화
  CBService = CashbillService.instance(
      CashbillController::LinkID,
      CashbillController::SecretKey
  )

  # 연동환경 설정, true-테스트, false-운영(Production), (기본값:true)
  CBService.setIsTest(true)

  # 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
  CBService.setIpRestrictOnOff(true)

  # 통신 IP 고정, true-사용, false-미사용, (기본값:false)
  CBService.setUseStaticIP(false)

  # 로컬시스템 시간 사용여부, true-사용, false-미사용, (기본값:true)
  CBService.setUseLocalTimeYN(true)

  ##############################################################################
  # 현금영수증 문서번호 중복여부를 확인합니다.
  # - 문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/info#CheckMgtKeyInUse
  ##############################################################################
  def checkMgtKeyInUse

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호, 최대 24자리로 숫자, 영문 '-', '_' 조합하여 구성
    mgtKey = "20220101-01"

    begin
      @response = CashbillController::CBService.checkMgtKeyInUse(
          corpNum,
          mgtKey,
      )

      if @response
        @value = "사용중"
      else
        @value = "미사용중"
      end

      @name = "문서번호 사용여부 확인"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증을 즉시발행합니다.
  # - 현금영수증 국세청 전송 정책 : https://developers.popbill.com/guide/cashbill/ruby/introduction/policy-of-send-to-nts
  # - https://developers.popbill.com/reference/cashbill/ruby/api/issue#RegistIssue
  ##############################################################################
  def registIssue

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 현금영수증 문서번호 (문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.)
    mgtKey = "20220104-Rails004"

    # 메모
    memo = "메모"

    # 안내메일 제목, 미기재시 기본양식으로 전송.
    emailSubject = ""

    # 현금영수증 정보
    cashbill = {

        # [필수] 문서번호
        "mgtKey" => mgtKey,

        # [필수] 문서형태
        "tradeType" => "승인거래",

        # [필수] 거래구분, {소득공제용, 지출증빙용} 중 기재
        "tradeUsage" => "소득공제용",

        # [필수] 거래유형, {일반, 도서공연, 대중교통} 중 기재
        "tradeOpt" => "일반",

        # [필수] 식별번호
        # 거래구분(tradeUsage) - '소득공제용' 인 경우 주민등록/휴대폰/카드번호 기재 가능
        # 거래구분(tradeUsage) - '지출증빙용' 인 경우 사업자번호/주민등록/휴대폰/카드번호 기재 가능
        "identityNum" => "0100001234",

        # [필수] 과세형태, {과세, 비과세} 중 기재
        "taxationType" => "과세",

        # [필수] 공급가액
        "supplyCost" => "10000",

        # [필수] 부가세
        "tax" => "1000",

        # [필수] 봉사료
        "serviceFee" => "0",

        # [필수] 거래금액
        "totalAmount" => "11000",

        # [필수] 가맹점 사업자번호
        "franchiseCorpNum" => corpNum,

        # 가맹점 상호
        "franchiseCorpName" => "가맹점 상호",

        # 가맹점 종사업장 식별번호
        "franchiseTaxRegID" => "",

        # 가맹점 대표자 성명
        "franchiseCEOName" => "가맹점 대표자 성명",

        # 가맹점 주소
        "franchiseAddr" => "가맹점 주소",

        # 가맹점 연락처
        "franchiseTEL" => "가맹점 연락처",

        # 고객명
        "customerName" => "고객명",

        # 상품명
        "itemName" => "상품명",

        # 가맹점 주문번호
        "orderNumber" => "가맹점 주문번호",

        # 거래처 이메일
        # 팝빌 테스트 환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "email" => "code@test.com",

        # 거래처 휴대폰
        "hp" => "010-111-222",

        # 발행안내문자 전송여부
        "smssendYN" => false,
    } # end of cashbill hash

    begin
      @Response = CashbillController::CBService.registIssue(
          corpNum,
          cashbill,
          memo,
          userID,
          emailSubject,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증을 삭제합니다.
  # - 현금영수증을 삭제하면 사용된 문서번호(mgtKey)를 재사용할 수 있습니다.
  # - 삭제가능한 문서 상태 : [전송실패]
  # - https://developers.popbill.com/reference/cashbill/ruby/api/issue#Delete
  ##############################################################################
  def delete

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20220101-03"

    begin
      @Response = CashbillController::CBService.delete(
          corpNum,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 취소현금영수증을 즉시발행합니다.
  # - 현금영수증 국세청 전송 정책 : https://developers.popbill.com/guide/cashbill/ruby/introduction/policy-of-send-to-nts
  # - https://developers.popbill.com/reference/cashbill/ruby/api/issue#RevokeRegistIssue
  ##############################################################################
  def revokeRegistIssue

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 (문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.)
    mgtKey = "20220101-08"

    # [취소거래시 필수] 원본 현금영수증 국세청승인번호
    orgConfirmNum = "TB0000274"

    # [취소거래시 필수] 원본 현금영수증 거래일자
    orgTradeDate = "20220101"

    begin
      @Response = CashbillController::CBService.revokeRegistIssue(
          corpNum,
          mgtKey,
          orgConfirmNum,
          orgTradeDate,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 (부분) 취소현금영수증을 즉시발행합니다.
  # - 현금영수증 국세청 전송 정책 : https://developers.popbill.com/guide/cashbill/ruby/introduction/policy-of-send-to-nts
  # - https://developers.popbill.com/reference/cashbill/ruby/api/issue#RevokeRegistIssue
  ##############################################################################
  def revokeRegistIssue_part

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 현금영수증 문서번호, 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성
    mgtKey = "20220101-09"

    # 원본 현금영수증 국세청승인번호
    orgConfirmNum = "TB0000274"

    # 원본 현금영수증 거래일자
    orgTradeDate = "20220101"

    # 안내문자 전송여부
    smssendYN = false

    # 메모
    memo = "부분 취소현금영수증 메모"

    # 부분취소 여부, true-부분취소, false-전체취소
    isPartCancel = true

    # 취소사유, 1-거래취소, 2-오류발급취소, 3-기타
    cancelType = 1

    # [취소] 공급가액
    supplyCost = "9000"

    # [취소] 부가세
    tax = "900"

    # [취소] 봉사료
    serviceFee = "0"

    # [취소] 합계금액
    totalAmount = "9900"

    begin
      @Response = CashbillController::CBService.revokeRegistIssue(
          corpNum,
          mgtKey,
          orgConfirmNum,
          orgTradeDate,
          smssendYN,
          memo,
          userID,
          isPartCancel,
          cancelType,
          supplyCost,
          tax,
          serviceFee,
          totalAmount,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증 상태/요약 정보를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/info#GetInfo
  ##############################################################################
  def getInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20220101-11"

    begin
      @Response = CashbillController::CBService.getInfo(
          corpNum,
          mgtKey,
      )
      render "cashbill/getInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 다수건의 현금영수증 상태/요약 정보를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/info#GetInfos
  ##############################################################################
  def getInfos

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 배열, 최대 1000건
    mgtKeyList = Array.new
    mgtKeyList.push("20220101-01")
    mgtKeyList.push("20220101-06")
    mgtKeyList.push("20220101-07")
    mgtKeyList.push("20220101-08")
    mgtKeyList.push("20220101-09")
    mgtKeyList.push("20220101-10")

    begin
      @Response = CashbillController::CBService.getInfos(
          corpNum,
          mgtKeyList,
      )
      render "cashbill/getInfos"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 1건의 상세정보를 조회합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/info#GetDetailInfo
  ##############################################################################
  def getDetailInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20220104-Rails002"

    begin
      @Response = CashbillController::CBService.getDetailInfo(
          corpNum,
          mgtKey,
      )
      render "cashbill/cashbill"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 현금영수증 목록을 조회합니다. (조회기간 단위 : 최대 6개월)
  # - https://developers.popbill.com/reference/cashbill/ruby/api/info#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # [필수] 일자유형, R-등록일자, T-거래일자 I-발행일시
    dType = "R"

    # [필수] 시작일자, 날짜형식(yyyyMMdd)
    sDate = "20220101"

    # [필수] 종료일자, 날짜형식(yyyyMMdd)
    eDate = "20220104"

    # 전송상태코드 배열, 미기재시 전체조회, 2,3번째 자리 와일드카드(*) 가능
    state = ["1**", "3**"]

    # 문서형태 배열, N-일반 현금영수증, C-취소 현금영수증
    tradeType = ["N", "C"]

    # 거래구분 배열, P-소득공제용, C-지출증빙용
    tradeUsage = ["P", "C"]

    # 과세형태 배열, T-과세, N-비과세
    taxationType = ["T", "N"]

    # 페이지 번호, 기본값 1
    page = 1

    # 페이지당 목록갯수, 기본값 500
    perPage = 10

    # 정렬방향 D-내림차순(기본값), A-오름차순
    order = "D"

    # 거래처 조회, 거래처 상호 또는 거래처 사업자등록번호 조회, 공백처리시 전체조회
    queryString = ""

    # 거래유형 배열, N-일반, B-도서공연, T-대중교통
    tradeOpt = ["N", "B", "T"]

    # 가맹점 종사업장 번호
    # └ 다수건 검색시 콤마(",")로 구분. 예) 1234,1000
    franchiseTaxRegID = ""

    begin
      @Response = CashbillController::CBService.search(
          corpNum,
          dType,
          sDate,
          eDate,
          state,
          tradeType,
          tradeUsage,
          taxationType,
          page,
          perPage,
          order,
          queryString,
          userID,
          tradeOpt,
          franchiseTaxRegID
      )
      render "cashbill/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌 현금영수증 문서함 관련 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/info#GetURL
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # TBOX(임시문서함), PBOX(발행문서함), WRITE(현금영수증 작성)
    togo = "WRITE"

    begin
      @value = CashbillController::CBService.getURL(
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
  # 1건의 현금영수증 보기 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/view#GetPopUpURL
  ##############################################################################
  def getPopUpURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-11"

    begin
      @value = CashbillController::CBService.getPopUpURL(
          corpNum,
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
  # 1건의 현금영수증 보기 팝업 URL을 반환합니다. (메뉴/버튼 제외)
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/view#GetViewURL
  ##############################################################################
  def getViewURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영 문서번호
    mgtKey = "20220104-Rails004"

    begin
      @value = CashbillController::CBService.getViewURL(
          corpNum,
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
  # 1건의 현금영수증 PDF 다운로드 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getPDFURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20220101-01"

    begin
      @value = CashbillController::CBService.getPDFURL(
          corpNum,
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
  # 1건의 현금영수증 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/view#GetPrintURL
  ##############################################################################
  def getPrintURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-11"

    begin
      @value = CashbillController::CBService.getPrintURL(
          corpNum,
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
  # 현금영수증 인쇄(공급받는자) URL을 반환합니다.
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/view#GetPrintURL
  ##############################################################################
  def getEPrintURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-11"

    begin
      @value = CashbillController::CBService.getEPrintURL(
          corpNum,
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
  # 다수건의 현금영수증 인쇄팝업 URL을 반환합니다. (최대 100건)
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/view#GetMassPrintURL
  ##############################################################################
  def getMassPrintURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 배열, 최대 100건
    mgtKeyList = Array.new
    mgtKeyList.push(" 20220101-06")
    mgtKeyList.push(" 20220101-07")
    mgtKeyList.push(" 20220101-08")

    begin
      @value = CashbillController::CBService.getMassPrintURL(
          corpNum,
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
  # 현금영수증 수신메일 링크주소 URL을 반환합니다.
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/view#GetMailURL
  ##############################################################################
  def getMailURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-06"

    begin
      @value = CashbillController::CBService.getMailURL(
          corpNum,
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
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @value = CashbillController::CBService.getAccessURL(
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
  # 발행 안내메일을 재전송합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/etc#SendEmail
  ##############################################################################
  def sendEmail

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-11"

    # 이메일 주소
    # 팝빌 테스트 환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
    # 실제 거래처의 메일주소가 기재되지 않도록 주의
    emailAddr = "test@test.com"

    begin
      @Response = CashbillController::CBService.sendEmail(
          corpNum,
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
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [문자] > [전송내역] 탭에서 전송결과를 확인할 수 있습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/etc#SendSMS
  ##############################################################################
  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-11"

    # 발신번호
    sendNum = "07043042991"

    # 수신번호
    receiveNum = "010-111-222"

    # 문자메시지 내용, 90Byte 초과된 내용은 삭제되어 전송됨
    contents = "문자메시지 전송을 확인합니다."

    begin
      @Response = CashbillController::CBService.sendSMS(
          corpNum,
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
  # 현금영수증을 팩스전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역] 메뉴에서
  #   전송결과를 확인할 수 있습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/etc#SendFAX
  ##############################################################################
  def sendFAX

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = " 20220101-11"

    # 발신번호
    sendNum = "07043042991"

    # 수신팩스번호
    receiveNum = "070111222"

    begin
      @Response = CashbillController::CBService.sendFax(
          corpNum,
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
  # 현금영수증 메일전송 항목에 대한 전송여부를 목록으로 반환한다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/etc#ListEmailConfig
  ##############################################################################
  def listEmailConfig

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @Response = CashbillController::CBService.listEmailConfig(
          corpNum,
          userID,
      )
      render "cashbill/listEmailConfig"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 메일전송 항목에 대한 전송여부를 수정한다.
  # 메일전송유형
  # CSH_ISSUE : 고객에게 현금영수증이 발행 되었음을 알려주는 메일 입니다.
  # CSH_CANCEL : 고객에게 현금영수증 발행취소 되었음을 알려주는 메일 입니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/etc#UpdateEmailConfig
  ##############################################################################
  def updateEmailConfig

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 메일 전송 유형
    emailType = "CSH_ISSUE"

    # 메일 전송 여부 (true-전송, false-미전송)
    sendYN = true

    begin
      @Response = CashbillController::CBService.updateEmailConfig(
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
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetBalance
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @value = CashbillController::CBService.getBalance(corpNum)
      @name = "remainPoint(연동회원 잔여포인트)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌 연동회원 포인트 충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @value = CashbillController::CBService.getChargeURL(
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
  # 연동회원 포인트 결제내역 확인을 위한 페이지의 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @value = CashbillController::CBService.getPaymentURL(
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
  # 연동회원 포인트 사용내역 확인을 위한 페이지의 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @value = CashbillController::CBService.getUseHistoryURL(
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
  # 파트너의 잔여포인트를 확인합니다.
  # - 과금방식이 연동과금인 경우 연동회원 잔여포인트(GetBalance API)를 이용하시기 바랍니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetPartnerBalance
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @value = CashbillController::CBService.getPartnerBalance(corpNum)
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
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = CashbillController::CBService.getPartnerURL(
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
  # 현금영수증 발행단가를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetUnitCost
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @value = CashbillController::CBService.getUnitCost(
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
  # 연동회원의 현금영수증 API 서비스 과금정보를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/point#GetChargeInfo
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @Response = CashbillController::CBService.getChargeInfo(corpNum)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 사업자번호를 조회하여 연동회원 가입여부를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#CheckIsMember
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 파트너 링크아이디
    linkID = CashbillController::LinkID

    begin
      @Response = CashbillController::CBService.checkIsMember(
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
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = CashbillController::CBService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#JoinMember
  ##############################################################################
  def joinMember

    # 연동회원 가입정보
    joinInfo = {

        # 링크아이디
        "LinkID" => "TESTER",

        # 아이디, 6자이상 50자미만
        "ID" => "testkorea",

        # 비밀번호 (8자 이상 20자 미만)
        # 영문, 숫자, 특수문자 조합
        "Password" => "password123!@#",

        # 사업자번호, '-' 제외 10자리
        "CorpNum" => "8888888888",

        # 대표자 성명 (최대 100자)
        "CEOName" => "대표자성명",

        # 상호명 (최대 200자)
        "CorpName" => "상호명",

        # 주소 (최대 300자)
        "Addr" => "주소",

        # 업태 (최대 100자)
        "BizType" => "업태",

        # 종목 (최대 100자)
        "BizClass" => "종목",

        # 담당자 성명 (최대 100자)
        "ContactName" => "담당자 성명",

        # 담당자 메일 (최대 100자)
        "ContactEmail" => "test@test.com",

        # 담당자 연락처 (최대 20자)
        "ContactTEL" => "010-111-222",

        # 담당자 휴대폰번호 (최대 20자)
        "ContactHP" => "010-111-222",

        # 담당자 팩스번호 (최대 20자)
        "ContactFAX" => "02-111-222",
    }

    begin
      @Response = CashbillController::CBService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#GetCorpInfo
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @Response = CashbillController::CBService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 회사정보
    corpInfo = {

        # 대표자 성명 (최대 100자)
        "ceoname" => "대표자명_수정",

        # 상호 (최대 200자)
        "corpName" => "상호_수정",

        # 주소 (최대 300자)
        "addr" => "주소_수정",

        # 업태 (최대 100자)
        "bizType" => "업태_수정",

        # 종목 (최대 100자)
        "bizClass" => "종목_수정",
    }

    begin
      @Response = CashbillController::CBService.updateCorpInfo(
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
  # 연동회원의 담당자를 신규로 등록합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디 (6자 이상 50자 미만)
        "id" => "testkorea20220101",

        # 비밀번호 (8자 이상 20자 미만)
        # 영문, 숫자, 특수문자 조합
        "Password" => "password123!@#",

        # 담당자명 (최대 100자)
        "personName" => "루비담당자",

        # 담당자 연락처 (최대 20자)
        "tel" => "070-4304-2992",

        # 담당자 휴대폰번호 (최대 20자)
        "hp" => "010-111-222",

        # 담당자 팩스번호 (최대 20자)
        "fax" => "02-111-222",

        # 담당자 이메일 (최대 100자)
        "email" => "ruby@linkhub.co.kr",

        #담당자 권한, 1(개인) 2(읽기) 3(회사)
        "searchRole"=>3,

    }

    begin
      @Response = CashbillController::CBService.registContact(
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
  # 연동회원 사업자번호에 등록된 담당자(팝빌 로그인 계정) 정보를 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = CashbillController::CBService.getContactInfo(
          corpNum,
          contactID,
      )
      render "home/contactInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원 사업자번호에 등록된 담당자(팝빌 로그인 계정) 목록을 확인합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#ListContact
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @Response = CashbillController::CBService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 담당자 정보를 수정합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/member#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디
        "id" => userID,

        # 담당자명 (최대 100자)
        "personName" => "Ruby(담당자)",

        # 담당자 연락처 (최대 20자)
        "tel" => "070-4304-2992",

        # 담당자 휴대폰번호 (최대 20자)
        "hp" => "010-111-222",

        # 담당자 팩스번호 (최대 20자)
        "fax" => "070-111-222",

        # 담당자 이메일 (최대 100자)
        "email" => "code@linkhub.co.kr",

        #담당자 권한, 1(개인) 2(읽기) 3(회사)
        "searchRole"=>3,

    }

    begin
      @Response = CashbillController::CBService.updateContact(
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
  # 팝빌 사이트에서 작성한 현금영수증에 파트너 문서번호를 할당합니다.
  # - https://developers.popbill.com/reference/cashbill/ruby/api/etc#AssignMgtKey
  ##############################################################################
  def assignMgtKey

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 아이템키, 목록조회(Search) API의 반환항목중 ItemKey 참조
    itemKey = "020021713524200001"

    # 할당할 문서번호, 숫자, 영문, '-', '_' 조합으로
    # 최대 24자리까지 사업자번호별 중복없는 고유번호 할당
    mgtKey = "20220101-05"

    begin
      @Response = CashbillController::CBService.assignMgtKey(
          corpNum,
          itemKey,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end

  end

end
