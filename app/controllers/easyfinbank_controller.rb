################################################################################
#
# 팝빌 계좌조회 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2020-01-07
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
################################################################################

require 'popbill/easyFinBank'

class EasyfinbankController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 계좌조회 API Service 초기화
  EasyFinBankInstance = EasyFinBankService.instance(
      EasyfinbankController::LinkID,
      EasyfinbankController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  EasyFinBankInstance.setIsTest(true)

  # 인증토큰 IP제한기능 사용여부, true-권장
  EasyFinBankInstance.setIpRestrictOnOff(true)


  ##############################################################################
  # 계좌 관리 팝업 URL을 반환합니다.
  ##############################################################################
  def getBankAccountMgtURL

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getBankAccountMgtURL(
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
  # 팝빌에 등록된 계좌 목록을 확인합니다.
  ##############################################################################
  def listBankAccount

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.listBankAccount(corpNum)
      render "easyfinbank/listBankAccount"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 계좌 거래내역 수집을 요청합니다
  ##############################################################################
  def requestJob

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 은행코드
    bankCode = "0048"

    # 계좌번호
    accountNumber = "131020538645"

    # 시작일자, 표시형식(yyyyMMdd)
    sDate = "20191101"

    # 종료일자, 표시형식(yyyyMMdd)
    eDate = "20200107"

    begin
      @value = EasyfinbankController::EasyFinBankInstance.requestJob(
          corpNum,
          bankCode,
          accountNumber,
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
  ##############################################################################
  def getJobState

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 수집 요청(RequestJob API) 호출시 반환반은 작업아이디(jobID)
    jobID = "020010711000000008"

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.getJobState(corpNum, jobID)
      render "easyfinbank/getJobState"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집 요청건들에 대한 상태 목록을 확인합니다.다.
  ##############################################################################
  def listActiveJob

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.listActiveJob(corpNum)
      render "easyfinbank/listActiveJob"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집이 완료된 계좌의 거래내역을 조회합니다.
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    # 작업아이디
    jobID = "020010711000000008"

    # 거래유형 배열, I-입금, O-출금
    tradeType = ["I", "O"]

    # 조회 검색어, 입금/출금액, 메모, 적요 like 검색
    searchString = ""

    # 페이지 번호, 기본값 '1'
    page = 1

    # 페이지당 검색개수, 기본값 '500', 최대 '1000'
    perPage = 10

    # 정렬 방향, D-내림차순, A-오름차순
    order = "D"

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.search(
          corpNum,
          jobID,
          tradeType,
          searchString,
          page,
          perPage,
          order,
          userID,
      )
      render "easyfinbank/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 거래내역 요약정보를 조회합니다.
  ##############################################################################
  def summary

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    # 작업아이디
    jobID = "020010711000000008"

    # 거래유형 배열, I-입금, O-출금
    tradeType = ["I", "O"]

    # 조회 검색어, 입금/출금액, 메모, 적요 like 검색
    searchString = ""

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.summary(
          corpNum,
          jobID,
          tradeType,
          searchString,
          userID,
      )
      render "easyfinbank/summary"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 거래내역에 메모를 저장합니다.
  ##############################################################################
  def saveMemo

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    # 거래내역 아이디
    tid = "01912181100000000120191231000001"

    # 메모
    memo = "ruby-test-02"

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.saveMemo(
          corpNum,
          tid,
          memo,
          userID
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 정액제 신청 팝업 URL을 반환합니다.
  ##############################################################################
  def getFlatRatePopUpURL

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getFlatRatePopUpURL(
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
    corpNum = EasyfinbankController::TestCorpNum

    # 은행코드
    bankCode = "0048"

    # 계좌번호
    accountNumber = "131020538645"

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.getFlatRateState(corpNum, bankCode, accountNumber)
      render "easyfinbank/getFlatRateState"
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
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getBalance(corpNum)
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
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getChargeURL(
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
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getPartnerBalance(corpNum)
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
    corpNum = EasyfinbankController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getPartnerURL(
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
  # 연동회원의 홈택스 전자세금계산서 연동 API 서비스 과금정보를 확인합니다.
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.getChargeInfo(corpNum)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 파트너 링크아이디
    linkID = EasyfinbankController::LinkID

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.checkIsMember(
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
    testID = "testkorea"

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.checkID(testID)
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

        # 아이디, 6자이상 50자미만
        "ID" => "testkorea",

        # 비밀번호, 6자이상 20자 미만
        "PWD" => "thisispassword",

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
      @Response = EasyfinbankController::EasyFinBankInstance.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getAccessURL(
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
  # 연동회원의 회사정보를 확인합니다.
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.getCorpInfo(corpNum)
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
    corpNum = EasyfinbankController::TestCorpNum

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
      @Response = EasyfinbankController::EasyFinBankInstance.updateCorpInfo(
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
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디, 6자 이상 50자 미만
        "id" => "testkorea20190121",

        # 비밀번호, 6자 이상 20자 미만
        "pwd" => "user_password",

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

        # 회사조회 권한여부, true(회사조회), false(개인조회)
        "searchAllAllowYN" => true,

        # 관리자 권한여부, true(관리자), false(사용자)
        "mgrYN" => false,
    }

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.registContact(
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
    corpNum = EasyfinbankController::TestCorpNum

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.listContact(corpNum)
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
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

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

        # 회사조회 권한여부, true(회사조회), false(개인조회)
        "searchAllAllowYN" => true,

        # 관리자 권한여부, true(관리자), false(사용자)
        "mgrYN" => false,
    }

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.updateContact(
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
