################################################################################
#
# 팝빌 계좌조회 API Ruby SDK Rails Example
# Rails 연동 튜토리얼 안내 : https://developers.popbill.com/guide/easyfinbank/ruby/getting-started/environment-set-up
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

  # 연동환경 설정, true-테스트, false-운영(Production), (기본값:true)
  EasyFinBankInstance.setIsTest(true)

  # 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
  EasyFinBankInstance.setIpRestrictOnOff(true)

  # 통신 IP 고정, true-사용, false-미사용, (기본값:false)
  EasyFinBankInstance.setUseStaticIP(false)

  # 로컬시스템 시간 사용여부, true-사용, false-미사용, (기본값:true)
  EasyFinBankInstance.setUseLocalTimeYN(true)


  ##############################################################################
  # 계좌조회 서비스를 이용할 은행계좌를 등록한다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#RegistBankAccount
  ##############################################################################
  def registBankAccount

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 은행계좌 정보
    accountInfo = {

      # [필수] 기관코드
      # 산업은행-0002 / 기업은행-0003 / 국민은행-0004 /수협은행-0007 / 농협은행-0011 / 우리은행-0020
      # SC은행-0023 / 대구은행-0031 / 부산은행-0032 / 광주은행-0034 / 제주은행-0035 / 전북은행-0037
      # 경남은행-0039 / 새마을금고-0045 / 신협은행-0048 / 우체국-0071 / KEB하나은행-0081 / 신한은행-0088 /씨티은행-0027
      "BankCode" => "",

      # [필수] 계좌번호 하이픈('-') 제외
      "AccountNumber" => "",

      # [필수] 계좌비밀번호
      "AccountPWD" => "",

      # [필수] 계좌유형, "법인" 또는 "개인" 입력
      "AccountType" => "",

      # [필수] 예금주 식별정보 (‘-‘ 제외)
      # 계좌유형이 “법인”인 경우 : 사업자번호(10자리)
      # 계좌유형이 “개인”인 경우 : 예금주 생년월일 (6자리-YYMMDD)
      "IdentityNumber" => "",

      # 계좌 별칭
      "AccountName" => "",

      # 인터넷뱅킹 아이디 (국민은행 필수)
      "BankID" => "",

      # 조회전용 계정 아이디 (대구은행, 신협, 신한은행 필수)
      "FastID" => "",

      # 조회전용 계정 비밀번호 (대구은행, 신협, 신한은행 필수)
      "FastPWD" => "",

      # 결제기간(개월), 1~12 입력가능, 미기재시 기본값(1) 처리
      # - 파트너 과금방식의 경우 입력값에 관계없이 1개월 처리
      "UsePeriod" => "1",

      # 메모
      "Memo" => "",
    }

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.registBankAccount(
          corpNum,
          accountInfo,
      )

      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 등록된 은행 계좌정보를 수정합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#UpdateBankAccount
  ##############################################################################
  def updateBankAccount

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 은행계좌 정보
    accountInfo = {

      # [필수] 기관코드
      # 산업은행-0002 / 기업은행-0003 / 국민은행-0004 /수협은행-0007 / 농협은행-0011 / 우리은행-0020
      # SC은행-0023 / 대구은행-0031 / 부산은행-0032 / 광주은행-0034 / 제주은행-0035 / 전북은행-0037
      # 경남은행-0039 / 새마을금고-0045 / 신협은행-0048 / 우체국-0071 / KEB하나은행-0081 / 신한은행-0088 /씨티은행-0027
      "BankCode" => "",

      # [필수] 계좌번호 하이픈('-') 제외
      "AccountNumber" => "",

      # [필수] 계좌비밀번호
      "AccountPWD" => "",

      # 계좌 별칭
      "AccountName" => "",

      # 인터넷뱅킹 아이디 (국민은행 필수)
      "BankID" => "",

      # 조회전용 계정 아이디 (대구은행, 신협, 신한은행 필수)
      "FastID" => "",

      # 조회전용 계정 비밀번호 (대구은행, 신협, 신한은행 필수)
      "FastPWD" => "",

      # 메모
      "Memo" => "",
    }

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.updateBankAccount(
          corpNum,
          accountInfo,
      )

      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 은행계좌의 정액제 해지를 요청한다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#CloseBankAccount
  ##############################################################################
  def closeBankAccount

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum


      # [필수] 기관코드
      # 산업은행-0002 / 기업은행-0003 / 국민은행-0004 /수협은행-0007 / 농협은행-0011 / 우리은행-0020
      # SC은행-0023 / 대구은행-0031 / 부산은행-0032 / 광주은행-0034 / 제주은행-0035 / 전북은행-0037
      # 경남은행-0039 / 새마을금고-0045 / 신협은행-0048 / 우체국-0071 / KEB하나은행-0081 / 신한은행-0088 /씨티은행-0027
      bankCode = ""

      # [필수] 계좌번호 하이픈('-') 제외
      accountNumber = ""

      # [필수] 해지유형, “일반”, “중도” 중 선택 기재
      # 일반해지 – 이용중인 정액제 사용기간까지 이용후 정지
      # 중도해지 – 요청일 기준으로 정지, 정액제 잔여기간은 일할로 계산되어 포인트 환불 (무료 이용기간 중 중도해지 시 전액 환불)
      closeType = "중도"

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.closeBankAccount(
          corpNum,
          bankCode,
          accountNumber,
          closeType,
      )

      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 은행계좌의 정액제 해지요청을 취소한다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#RevokeCloseBankAccount
  ##############################################################################
  def revokeCloseBankAccount

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # [필수] 기관코드
    # 산업은행-0002 / 기업은행-0003 / 국민은행-0004 /수협은행-0007 / 농협은행-0011 / 우리은행-0020
    # SC은행-0023 / 대구은행-0031 / 부산은행-0032 / 광주은행-0034 / 제주은행-0035 / 전북은행-0037
    # 경남은행-0039 / 새마을금고-0045 / 신협은행-0048 / 우체국-0071 / KEB하나은행-0081 / 신한은행-0088 /씨티은행-0027
    bankCode = ""

    # [필수] 계좌번호 하이픈('-') 제외
    accountNumber = ""

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.revokeCloseBankAccount(
          corpNum,
          bankCode,
          accountNumber,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 등록된 계좌를 삭제합니다.
  # - 정액제가 아닌 종량제 이용 시에만 등록된 계좌를 삭제할 수 있습니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#DeleteBankAccount
  ##############################################################################
  def deleteBankAccount

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # [필수] 기관코드
    # 산업은행-0002 / 기업은행-0003 / 국민은행-0004 /수협은행-0007 / 농협은행-0011 / 우리은행-0020
    # SC은행-0023 / 대구은행-0031 / 부산은행-0032 / 광주은행-0034 / 제주은행-0035 / 전북은행-0037
    # 경남은행-0039 / 새마을금고-0045 / 신협은행-0048 / 우체국-0071 / KEB하나은행-0081 / 신한은행-0088 /씨티은행-0027
    bankCode = ""

    # [필수] 계좌번호 하이픈('-') 제외
    accountNumber = ""

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.deleteBankAccount(
          corpNum,
          bankCode,
          accountNumber,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 은행계좌 정보를 확인한다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#GetBankAccountInfo
  ##############################################################################
  def getBankAccountInfo

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # [필수] 기관코드
    # 산업은행-0002 / 기업은행-0003 / 국민은행-0004 /수협은행-0007 / 농협은행-0011 / 우리은행-0020
    # SC은행-0023 / 대구은행-0031 / 부산은행-0032 / 광주은행-0034 / 제주은행-0035 / 전북은행-0037
    # 경남은행-0039 / 새마을금고-0045 / 신협은행-0048 / 우체국-0071 / KEB하나은행-0081 / 신한은행-0088 /씨티은행-0027
    bankCode = ""

    # [필수] 계좌번호 하이픈('-') 제외
    accountNumber = ""

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.getBankAccountInfo(corpNum, bankCode, accountNumber)
      render "easyfinbank/getBankAccountInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 계좌 관리 팝업 URL을 반환합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#GetBankAccountMgtURL
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/manage#ListBankAccount
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
  # 계좌 거래내역 수집을 요청합니다. (조회기간 단위 : 최대 1개월)
  # - 조회일로부터 최대 3개월 이전 내역까지 조회할 수 있습니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/job#RequestJob
  ##############################################################################
  def requestJob

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 기관코드
    bankCode = ""

    # 계좌번호
    accountNumber = ""

    # 시작일자, 표시형식(yyyyMMdd)
    sDate = ""

    # 종료일자, 표시형식(yyyyMMdd)
    eDate = ""

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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/job#GetJobState
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
  # 수집 요청건들에 대한 상태 목록을 확인합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/job#ListActiveJob
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/search#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    # 작업아이디
    jobID = "020072311000000002"

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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/search#Summary
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/search#SaveMemo
  ##############################################################################
  def saveMemo

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    # 거래내역 아이디
    tid = "02212181100000000120221231000001"

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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetFlatRatePopUpURL
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
  # 정액제 서비스 이용상태를 확인합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetFlatRateState
  ##############################################################################
  def getFlatRateState

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 기관코드
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetBalance
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetChargeURL
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
  # 연동회원 포인트 결제내역 확인을 위한 페이지의 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getPaymentURL(
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 팝빌회원 아이디
    userID = EasyfinbankController::TestUserID

    begin
      @value = EasyfinbankController::EasyFinBankInstance.getUseHistoryURL(
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetPartnerBalance
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetPartnerURL
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
  # 연동회원의 API 서비스 과금정보를 확인합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/point#GetChargeInfo
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
  # 사업자번호를 조회하여 연동회원 가입여부를 확인합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#CheckIsMember
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#CheckID
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#JoinMember
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#GetAccessURL
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#GetCorpInfo
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#UpdateCorpInfo
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

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
  # 연동회원 사업자번호에 등록된 담당자(팝빌 로그인 계정) 정보를 확인합니다.
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = EasyfinbankController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = EasyfinbankController::EasyFinBankInstance.getContactInfo(
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#ListContact
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
  # - https://developers.popbill.com/reference/easyfinbank/ruby/api/member#UpdateContact
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

        #담당자 권한, 1(개인) 2(읽기) 3(회사)
        "searchRole"=>3,
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
