################################################################################
#
# 팝빌 홈택스 현금영수증 API Ruby SDK Rails Example
# Rails 연동 튜토리얼 안내 : https://developers.popbill.com/guide/htcashbill/ruby/getting-started/tutorial
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
# 3) 홈택스 로그인 인증정보를 등록합니다. (부서사용자등록 / 공동인증서 등록)
#    - 팝빌로그인 > [홈택스연동] > [환경설정] > [인증 관리] 메뉴
#    - 홈택스연동 인증 관리 팝업 URL(GetCertificatePopUpURL API) 반환된 URL을 이용하여
#      홈택스 인증 처리를 합니다.
#
################################################################################

require 'popbill/htCashbill'

class HtcashbillController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "6798700433"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea_linkhub"

  # 팝빌 홈택스 현금영수증 연동 API Service 초기화
  HTCBService = HTCashbillService.instance(
      HtcashbillController::LinkID,
      HtcashbillController::SecretKey
  )

  # 연동환경 설정, true-테스트, false-운영(Production), (기본값:true)
  HTCBService.setIsTest(true)

  # 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
  HTCBService.setIpRestrictOnOff(true)

  # 통신 IP 고정, true-사용, false-미사용, (기본값:false)
  HTCBService.setUseStaticIP(false)

  # 로컬시스템 시간 사용여부, true-사용, false-미사용, (기본값:true)
  HTCBService.setUseLocalTimeYN(true)

  ##############################################################################
  # 현금영수증 매출/매입 내역 수집을 요청합니다. (조회기간 단위 : 최대 3개월)
  # - 수집 요청후 반환받은 작업아이디(JobID)의 유효시간은 1시간 입니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/job#RequestJob
  ##############################################################################
  def requestJob

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 현금영수증 유형, SELL-매출, BUY-매입
    keyType = KeyType::BUY

    # 시작일자, 표시형식(yyyyMMdd)
    sDate = "20220101"

    # 종료일자, 표시형식(yyyyMMdd)
    eDate = "20220110"

    begin
      @value = HtcashbillController::HTCBService.requestJob(
          corpNum,
          keyType,
          sDate,
          eDate,
      )
      @name = "jobID(작업아이디)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집 요청 상태를 확인합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/job#GetJobState
  ##############################################################################
  def getJobState

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 수집 요청(RequestJob API) 호출시 반환반은 작업아이디(jobID)
    jobID = "019040413000000006"

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
  #  - 수집 요청 작업아이디(JobID)의 유효시간은 1시간 입니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/job#ListActiveJob
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
  # 현금영수증 매입/매출 내역의 수집 결과를 조회합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/search#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 작업아이디
    jobID = "019040413000000006"

    # 현금영수증 형태 배열, N-일반현금영수증, C-취소현금영수증
    tradeType = ["N", "C"]

    # 거래용도 배열, P-소득공제용, C-지출증빙용
    tradeUsage = ["P", "C"]

    # 페이지 번호, 기본값 '1'
    page = 1

    # 페이지당 검색개수, 기본값 '500', 최대 '1000'
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
  # 현금영수증 매입/매출 내역의 수집결과 요약정보를 조회합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/search#Summary
  ##############################################################################
  def summary

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 작업아이디
    jobID = "019040413000000006"

    # 현금영수증 형태 배열, N-일반현금영수증, C-취소현금영수증
    tradeType = ["N", "C"]

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
  # 홈택스연동 인증관리를 위한 URL을 반환합니다.
  # - 반환된 URL은 보안정책에 따라 30초의 유효시간을 갖습니다.
  # - 부서사용자/공동인증서 인증 방식이 있습니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#GetCertificatePopUpURL
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
  # 팝빌에 등록된 홈택스 공동인증서의 만료일자를 반환합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#GetCertificateExpireDate
  ##############################################################################
  def getCertificateExpireDate

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @value = HtcashbillController::HTCBService.getCertificateExpireDate(
          corpNum,
      )
      @name = "ExpireDate(홈택스 공동인증서 만료일시)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 공동인증서의 홈택스 로그인을 테스트합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#CheckCertValidation
  ##############################################################################
  def checkCertValidation

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.checkCertValidation(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 홈택스 현금영수증 부서사용자 계정을 등록합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#RegistDeptUser
  ##############################################################################
  def registDeptUser

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 홈택스 부서사용자 계정아이디
    deptUserID = "deptuserid"

    # 홈택스 부서사용자 계정비밀번호
    deptUserPWD = "deptuserpwd"

    begin
      @Response = HtcashbillController::HTCBService.registDeptUser(
          corpNum,
          deptUserID,
          deptUserPWD
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 부서사용자 아이디를 확인합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#CheckDeptUser
  ##############################################################################
  def checkDeptUser

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.checkDeptUser(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 부서사용자 계정정보를 이용하여 홈택스 로그인을 테스트합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#CheckLoginDeptUser
  ##############################################################################
  def checkLoginDeptUser

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.checkLoginDeptUser(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 부서사용자 계정정보를 삭제합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/cert#DeleteDeptUser
  ##############################################################################
  def deleteDeptUser

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    begin
      @Response = HtcashbillController::HTCBService.deleteDeptUser(
          corpNum,
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetBalance
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
  # 팝빌 연동회원 포인트 충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = HtcashbillController::TestUserID

    begin
      @value = HtcashbillController::HTCBService.getChargeURL(
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = HtcashbillController::TestUserID

    begin
      @value = HtcashbillController::HTCBService.getPaymentURL(
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = HtcashbillController::TestUserID

    begin
      @value = HtcashbillController::HTCBService.getUseHistoryURL(
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetPartnerBalance
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
  # 파트너 포인트충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = HtcashbillController::HTCBService.getPartnerURL(
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
  # 연동회원의 홈택스 현금영수증 연동 API 서비스 과금정보를 확인합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetChargeInfo
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
  # 정액제 신청 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetFlatRatePopUpURL
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/point#GetFlatRateState
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
  # 사업자번호를 조회하여 연동회원 가입여부를 확인합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#CheckIsMember
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#JoinMember
  ##############################################################################
  def joinMember

    # 연동회원 가입정보
    joinInfo = {

        # 링크아이디
        "LinkID" => HtcashbillController::LinkID,

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
      @Response = HtcashbillController::HTCBService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = HtcashbillController::TestUserID

    begin
      @value = HtcashbillController::HTCBService.getAccessURL(
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#GetCorpInfo
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

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
  # 연동회원의 담당자를 신규로 등록합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디 (6자 이상 50자 미만)
        "id" => "testkorea 20220101",

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
  # 연동회원 사업자번호에 등록된 담당자(팝빌 로그인 계정) 정보를 확인합니다.
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = HtcashbillController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = HtcashbillController::HTCBService.getContactInfo(
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#ListContact
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
  # - https://developers.popbill.com/reference/htcashbill/ruby/api/member#UpdateContact
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

end
