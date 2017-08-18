################################################################################
# 팜빌 휴폐업조회 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2017-08-18
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 19, 22번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
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

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
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
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea0131"

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
      @Response = ClosedownController::CDService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 휴폐업조회 API 서비스 과금정보를 확인합니다.
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
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
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
  # 파트너의 잔여포인트를 확인합니다.
  # - 과금방식이 연동과금인 경우 연동회원 잔여포인트(GetBalance API)를 이용하시기 바랍니다.
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
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getPopbillURL

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = ClosedownController::CDService.getPopbillURL(
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
    corpNum = ClosedownController::TestCorpNum

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
  # 연동회원의 담당자 목록을 확인합니다.
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
  # 연동회원의 회사정보를 확인합니다.
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
  # 연동회원의 회사정보를 수정합니다
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

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
  # 1건의 사업자에 대한 휴폐업여부를 조회합니다.
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
  ##############################################################################
  def checkCorpNums

    # 팝빌회원 사업자번호
    corpNum = ClosedownController::TestCorpNum

    # 조회할 사업자번호 배열, 최대 1000건
    targetCorpNumList = ["1234567890", "6798700433"]

    begin
      @Response = ClosedownController::CDService.checkCorpNums(corpNum, targetCorpNumList)
      puts @Response
      render "closedown/checkCorpNums"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
