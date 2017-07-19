################################################################################
# 팜빌 홈택스 현금영수증 연계 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2017-07-19
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 22, 25번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
# 3) 홈택스 공인인증서를 등록합니다.
#    - 팝빌사이트 로그인 > [홈택스 연계] > [환경설정] > [공인인증서 관리]
#    - 홈택스 공인인증서 등록 팝업 URL (GetCertificatePopUpURL API)을 이용하여 등록
################################################################################

require 'popbill/htcashbill'

class HtcashbillController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 홈택스 현금영수증 연계 API Service 초기화
  HTCBService = HTCashbillService.instance(
    HtcashbillController::LinkID,
    HtcashbillController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  HTCBService.setIsTest(true)

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 파트너 링크아이디
    linkID = HtcashbillController::LinkID

    begin
      @Response = HtcashbillController::HTCBService.checkIsMember(
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
      @Response = HtcashbillController::HTCBService.checkID(testID)
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
      @Response = HtcashbillController::HTCBService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 홈택스 현금영수증 연계 API 서비스 과금정보를 확인합니다.
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.getChargeInfo(corpNum)
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
    corpNum = HtcashbillController::TestCorpNum

    begin
      @value = HtcashbillController::HTCBService.getBalance(corpNum)
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
    corpNum = HtcashbillController::TestCorpNum

    begin
      @value = HtcashbillController::HTCBService.getPartnerBalance(corpNum)
      @name = "remainPoint(파트너 잔여포인트)"
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
    corpNum = HtcashbillController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = HtcashbillController::HTCBService.getPopbillURL(
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
    corpNum = HtcashbillController::TestCorpNum

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
      @Response = HtcashbillController::HTCBService.registContact(
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
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.listContact(corpNum)
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
    corpNum = HtcashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = HtcashbillController::TestUserID


    # 담당자 정보
    contactInfo = {

      # 담당자 아이디
      "id" => userID,

      # 담당자명
      "personName" => "담당자명170131",

      # 연락처
      "tel" => "070-4304-2991",

      # 휴대폰버놓
      "hp" => "010-1111-2222",

      # 팩스번호
      "fax" => "070-1111-2222",

      # 메일주소
      "email" => "test@gmail.com",

      # 회사조회여부, true-회사조회, false-개인조회
      "searchAllAllowYN" => true,
    }

    begin
      @Response = HtcashbillController::HTCBService.updateContact(
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
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.getCorpInfo(corpNum)
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
    corpNum = HtcashbillController::TestCorpNum

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
      @Response = HtcashbillController::HTCBService.updateCorpInfo(
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
  # 현금영수증 매출/매입 내역 수집을 요청합니다
  # - 매출/매입 연계 프로세스는 "[홈택스 현금영수증 연계 API 연동매뉴얼]
  #   > 1.2. 프로세스 흐름도" 를 참고하시기 바랍니다.
  # - 수집 요청후 반환받은 작업아이디(JobID)의 유효시간은 1시간 입니다.
  ##############################################################################
  def requestJob

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 현금영수증 유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = KeyType::BUY

    # 시작일자, 표시형식(yyyyMMdd)
    sDate = "20160801"

    # 종료일자, 표시형식(yyyyMMdd)
    eDate = "20170201"

    begin
      @value = HtcashbillController::HTCBService.requestJob(
        corpNum,
        keyType,
        sDate,
        eDate,
      )
      @name = "jobID(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집 요청 상태를 확인합니다.
  # - 응답항목 관한 정보는 "[홈택스 현금영수증 연계 API 연동매뉴얼
  #   > 3.2.2. GetJobState (수집 상태 확인)" 을 참고하시기 바랍니다 .
  ##############################################################################
  def getJobState

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 수집 요청(RequestJob API) 호출시 반환반은 작업아이디(jobID)
    jobID = "017020711000000001"

    begin
      @Response = HtcashbillController::HTCBService.getJobState(corpNum, jobID)
      render "htcashbill/getJobState"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집 요청건들에 대한 상태 목록을 확인합니다.
  # - 수집 요청 작업아이디(JobID)의 유효시간은 1시간 입니다.
  # - 응답항목에 관한 정보는 "[홈택스 현금영수증 연계 API 연동매뉴얼]
  #   > 3.2.3. ListActiveJob (수집 상태 목록 확인)" 을 참고하시기 바랍니다.
  ##############################################################################
  def listActiveJob

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.listActiveJob(corpNum)
      render "htcashbill/listActiveJob"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 수집결과를 조회합니다.
  # - 응답항목에 관한 정보는 "[홈택스 현금영수증 연계 API 연동매뉴얼]
  #   > 3.3.1. Search (수집 결과 조회)" 을 참고하시기 바랍니다.
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 작업아이디
    jobID = "017020711000000001"

    # 현금영수증 형태 배열, N-일반현금영수증, C-취소현금영수증
    tradeType = ["N", "M"]

    # 거래용도 배열, P-소득공제용, C-지출증빙용
    tradeUsage = ["P", "C"]

    # 페이지 번호
    page = 1

    # 페이지당 검색개수, 최대 1000건
    perPage = 10

    # 정렬방향, D-내림차순, A-오름차순
    order = "D"

    begin
      @Response = HtcashbillController::HTCBService.search(
        corpNum,
        jobID,
        tradeType,
        tradeUsage,
        page,
        perPage,
        order,
      )
      render "htcashbill/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 수집 결과 요약정보를 조회합니다.
  # - 응답항목에 관한 정보는 "[홈택스 현금영수증 연계 API 연동매뉴얼]
  #   > 3.3.2. Summary (수집 결과 요약정보 조회)" 을 참고하시기 바랍니다.
  ##############################################################################
  def summary

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 작업아이디
    jobID = "017020711000000001"

    # 현금영수증 형태 배열, N-일반현금영수증, C-취소현금영수증
    tradeType = ["N", "M"]

    # 거래용도 배열, P-소득공제용, C-지출증빙용
    tradeUsage = ["P", "C"]

    begin
      @Response = HtcashbillController::HTCBService.summary(
        corpNum,
        jobID,
        tradeType,
        tradeUsage,
      )
      render "htcashbill/summary"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 정액제 신청 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getFlatRatePopUpURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @value = HtcashbillController::HTCBService.getFlatRatePopUpURL(
        corpNum,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 정액제 서비스 이용상태를 확인합니다.
  ##############################################################################
  def getFlatRateState

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.getFlatRateState(corpNum)
      render "htcashbill/getFlatRateState"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 홈택스 공인인증서 등록 팝업 URL을 반환합니다.
  # - 반환된 URL은 보안정책에 따라 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getCertificatePopUpURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @value = HtcashbillController::HTCBService.getCertificatePopUpURL(
        corpNum,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 등록된 홈택스 공인인증서의 만료일자를 확인합니다.
  ##############################################################################
  def getCertificateExpireDate

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @value = HtcashbillController::HTCBService.getCertificateExpireDate(
        corpNum,
      )
      @name = "ExpireDate(홈택스 공인인증서 만료일시)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end
end
