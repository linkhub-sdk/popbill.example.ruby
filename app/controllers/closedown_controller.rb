################################################################################
#
# 팝빌 휴폐업조회 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2021-07-23
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 20, 23번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
#
################################################################################

require 'popbill/closedown'

class ClosedownController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 휴폐업조회 API Service 초기화
  CDService = ClosedownService.instance(
      ClosedownController::LinkID,
      ClosedownController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  CDService.setIsTest(true)

  # 인증토큰 IP제한기능 사용여부, true-권장
  CDService.setIpRestrictOnOff(true)

  # 팝빌 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  CDService.setUseStaticIP(false)

  ##############################################################################
  # 1건의 사업자에 대한 휴폐업여부를 조회합니다.
  # - https://docs.popbill.com/closedown/ruby/api#CheckCorpNum
  ##############################################################################
  def checkCorpNum

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 조회할 사업자번호
    targetCorpNum = "6798700433"

    begin
      @Response = ClosedownController::CDService.checkCorpNum(corpNum, targetCorpNum)
      puts @Response
      render "closedown/checkCorpNum"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 다수의 사업자에 대한 휴폐업여부를 조회합니다.
  # - https://docs.popbill.com/closedown/ruby/api#CheckCorpNums
  ##############################################################################
  def checkCorpNums

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 조회할 사업자번호 배열, 최대 1000건
    targetCorpNumList = Array.new
    targetCorpNumList.push("1234567890")
    targetCorpNumList.push("6798700433")

    begin
      @Response = ClosedownController::CDService.checkCorpNums(corpNum, targetCorpNumList)
      puts @Response
      render "closedown/checkCorpNums"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  # - https://docs.popbill.com/closedown/ruby/api#GetBalance
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    begin
      @value = ClosedownController::CDService.getBalance(corpNum)
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
  # - https://docs.popbill.com/closedown/ruby/api#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 팝빌회원 아이디
    userID = ClosedownController::TestUserID

    begin
      @value = ClosedownController::CDService.getChargeURL(
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
  # - https://docs.popbill.com/closedown/ruby/api#GetPartnerBalance
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    begin
      @value = ClosedownController::CDService.getPartnerBalance(corpNum)
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
  # - https://docs.popbill.com/closedown/ruby/api#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = ClosedownController::CDService.getPartnerURL(
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
  # 휴폐업 조회단가를 확인합니다.
  # - https://docs.popbill.com/closedown/ruby/api#GetUnitCost
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    begin
      @value = ClosedownController::CDService.getUnitCost(
          corpNum,
      )
      @name = "unitCost(조회단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 휴폐업조회 API 서비스 과금정보를 확인합니다.
  # - https://docs.popbill.com/closedown/ruby/api#GetChargeInfo
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    begin
      @Response = ClosedownController::CDService.getChargeInfo(corpNum)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  # - https://docs.popbill.com/closedown/ruby/api#MemberManage
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 파트너 링크아이디
    linkID = ClosedownController::LinkID

    begin
      @Response = ClosedownController::CDService.checkIsMember(
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
  # - https://docs.popbill.com/closedown/ruby/api#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = ClosedownController::CDService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  # - https://docs.popbill.com/closedown/ruby/api#JoinMember
  ##############################################################################
  def joinMember

    # 연동회원 가입정보
    joinInfo = {

        # 링크아이디
        "LinkID" => ClosedownController::LinkID,

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
      @Response = ClosedownController::CDService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
  # - https://docs.popbill.com/closedown/ruby/api#GetCorpInfo
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    begin
      @Response = ClosedownController::CDService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다.
  # - https://docs.popbill.com/closedown/ruby/api#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

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
      @Response = ClosedownController::CDService.updateCorpInfo(
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
  # - https://docs.popbill.com/closedown/ruby/api#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

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

    }

    begin
      @Response = ClosedownController::CDService.registContact(
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
  # - https://docs.popbill.com/closedown/ruby/api#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = ClosedownController::CDService.getContactInfo(
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
  # - https://docs.popbill.com/closedown/ruby/api#ListContact
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    begin
      @Response = ClosedownController::CDService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 담당자 정보를 수정합니다.
  # - https://docs.popbill.com/closedown/ruby/api#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 팝빌회원 아이디
    userID = ClosedownController::TestUserID

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

    }

    begin
      @Response = ClosedownController::CDService.updateContact(
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
  # - https://docs.popbill.com/closedown/ruby/api#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 팝빌회원 아이디
    userID = ClosedownController::TestUserID

    begin
      @value = ClosedownController::CDService.getAccessURL(
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
