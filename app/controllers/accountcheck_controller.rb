################################################################################
#
# 팝빌 예금주조회 API Ruby SDK Rails Example
# Rails 연동 튜토리얼 안내 : https://developers.popbill.com/guide/accountcheck/ruby/getting-started/tutorial
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

require 'popbill/accountCheck'

class AccountcheckController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 예금주조회 API Service 초기화
  ACService = AccountCheckService.instance(
      AccountcheckController::LinkID,
      AccountcheckController::SecretKey
  )

  # 연동환경 설정, true-테스트, false-운영(Production), (기본값:true)
  ACService.setIsTest(true)

  # 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
  ACService.setIpRestrictOnOff(true)

  # 통신 IP 고정, true-사용, false-미사용, (기본값:false)
  ACService.setUseStaticIP(false)

  # 로컬시스템 시간 사용여부, true-사용, false-미사용, (기본값:true)
  ACService.setUseLocalTimeYN(true)

  ##############################################################################
  # 1건의 예금주성명을 조회합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/check#CheckAccountInfo
  ##############################################################################
  def checkAccountInfo

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 기관코드
    bankCode = "0004"

    # 계좌번호
    accountNumber = ""

    begin
      @Response = AccountcheckController::ACService.checkAccountInfo(corpNum, bankCode, accountNumber)
      render "accountcheck/checkAccountInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 예금주실명을 조회합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/check#CheckDepositorInfo
  ##############################################################################
  def checkDepositorInfo

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 기관코드
    bankCode = "0004"

    # 계좌번호
    accountNumber = ""

    # 등록번호 유형 ( P / B 중 택 1 ,  P = 개인, B = 사업자)
    identityNumType = ""

    # 등록번호
    # - IdentityNumType 값이 "B" 인 경우 (하이픈 '-' 제외  사업자번호(10)자리 입력 )
    # - IdentityNumType 값이 "P" 인 경우 (생년월일(6)자리 입력 (형식 : YYMMDD))
    identityNum = ""

    begin
      @Response = AccountcheckController::ACService.checkDepositorInfo(corpNum, bankCode, accountNumber, identityNumType, identityNum)
      render "accountcheck/checkDepositorInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetBalance
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    begin
      @value = AccountcheckController::ACService.getBalance(corpNum)
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

    begin
      @value = AccountcheckController::ACService.getChargeURL(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

    begin
      @value = AccountcheckController::ACService.getPaymentURL(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

    begin
      @value = AccountcheckController::ACService.getUseHistoryURL(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetPartnerBalance
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    begin
      @value = AccountcheckController::ACService.getPartnerBalance(corpNum)
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = AccountcheckController::ACService.getPartnerURL(
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
  # 예금주 조회단가를 확인합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetUnitCost
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

    # 서비스 유형, 계좌성명조회 - 성명 , 계좌실명조회 - 실명
    serviceType = "성명"

    begin
      @value = AccountcheckController::ACService.getUnitCost(
          corpNum,
          userID,
          serviceType
      )
      @name = "unitCost(조회단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 예금주조회 API 서비스 과금정보를 확인합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/point#GetChargeInfo
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

    # 서비스 유형, 계좌성명조회 - 성명 , 계좌실명조회 - 실명
    serviceType = "성명"

    begin
      @Response = AccountcheckController::ACService.getChargeInfo(
            corpNum,
            userID,
            serviceType
          )
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 사업자번호를 조회하여 연동회원 가입여부를 확인합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#CheckIsMember
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 파트너 링크아이디
    linkID = AccountcheckController::LinkID

    begin
      @Response = AccountcheckController::ACService.checkIsMember(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = AccountcheckController::ACService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#JoinMember
  ##############################################################################
  def joinMember

    # 연동회원 가입정보
    joinInfo = {

        # 링크아이디
        "LinkID" => AccountcheckController::LinkID,

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
      @Response = AccountcheckController::ACService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#GetCorpInfo
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    begin
      @Response = AccountcheckController::ACService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

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
      @Response = AccountcheckController::ACService.updateCorpInfo(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디 (6자 이상 50자 미만)
        "id" => "testkorea20220121",

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
      @Response = AccountcheckController::ACService.registContact(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = AccountcheckController::ACService.getContactInfo(
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
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#ListContact
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    begin
      @Response = AccountcheckController::ACService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 담당자 정보를 수정합니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

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
      @Response = AccountcheckController::ACService.updateContact(
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
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/accountcheck/ruby/api/member#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = AccountcheckController::TestCorpNum

    # 팝빌회원 아이디
    userID = AccountcheckController::TestUserID

    begin
      @value = AccountcheckController::ACService.getAccessURL(
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

end
