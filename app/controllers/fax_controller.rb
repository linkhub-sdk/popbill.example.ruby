################################################################################
# 팜빌 팩스 API Ruby On Rails SDK Example
#
# 업테이트 일자 : 2017-02-07
# 연동기술지원 연락처 : 1600-8539 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 19, 22번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
################################################################################

require 'popbill/fax'

class FaxController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 팩스 API Service 초기화
  FAXService = FaxService.instance(
    FaxController::LinkID,
    FaxController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  FAXService.setIsTest(true)

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 파트너 링크아이디
    linkID = FaxController::LinkID

    begin
      @Response = FaxController::FAXService.checkIsMember(
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
      @Response = FaxController::FAXService.checkID(testID)
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
      @Response = FaxController::FAXService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 팩스 API 서비스 과금정보를 확인합니다.
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    begin
      @Response = FaxController::FAXService.getChargeInfo(corpNum)
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
    corpNum = FaxController::TestCorpNum

    begin
      @value = FaxController::FAXService.getBalance(corpNum)
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
    corpNum = FaxController::TestCorpNum

    begin
      @value = FaxController::FAXService.getPartnerBalance(corpNum)
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
    corpNum = FaxController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = FaxController::FAXService.getPopbillURL(
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
    corpNum = FaxController::TestCorpNum

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
      @Response = FaxController::FAXService.registContact(
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
    corpNum = FaxController::TestCorpNum

    begin
      @Response = FaxController::FAXService.listContact(corpNum)
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
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 담당자 정보
    contactInfo = {
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
      @Response = FaxController::FAXService.updateContact(
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
    corpNum = FaxController::TestCorpNum

    begin
      @Response = FaxController::FAXService.getCorpInfo(corpNum)
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
    corpNum = FaxController::TestCorpNum

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
      @Response = FaxController::FAXService.updateCorpInfo(
        corpNum,
        corpInfo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendFax

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 수신번호
    receiver = "070111222"

    # 수신자명
    receiverName = "Receiver"

    # 파일경로 배열, 최대 전송 파일개수 5개
    filePath = ["/Users/John/Documents/WorkSpace/ruby project/ruby_popbill_example/test.pdf"]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    begin
      @value = FaxController::FAXService.sendFax(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          filePath,
          reserveDT,
        )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  def sendFax_Multi

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 수신자 정보 배열, 최대 1000건
    receivers = [
      {
        "rcv" => "010111222",   # 수신번호
        "rcvnm" => "John",    # 수신자명
      },
      {
        "rcv" => "010111222",   # 수신번호
        "rcvnm" => "John2",   # 수신자명
      },
    ]

    # 파일경로 배열, 최대 전송 파일개수 5개
    filePath = ["/Users/John/Documents/WorkSpace/ruby project/ruby_popbill_example/test.pdf"]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    begin
      @value = FaxController::FAXService.sendFax_multi(
          corpNum,
          sender,
          senderName,
          receivers,
          filePath,
          reserveDT,
        )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스 전송요청시 반환받은 접수번호(receiptNum)을 사용하여 팩스전송 결과를 확인합니다.
  ##############################################################################
  def getFaxDetail

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 접수번호
    receiptNum = "017020711364600001"

    begin
      @Response = FaxController::FAXService.getFaxDetail(corpNum, receiptNum)
      render "fax/getFaxDetail"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 팩스전송 내역을 조회합니다.
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # [필수] 시작일자, 형식(yyyyMMdd)
    sDate = "20170118"

    # [필수] 종료일자, 형식(yyyyMMdd)
    eDate = "20170207"

    # 전송상태 배열, 1(대기), 2(성공), 3(실패), 4(취소)
    state = [1, 2, 3, 4]

    # 예약전송 검색여부, 1-예약전송건 조회, 0-예약전송 아닌건만 조회, 공백-전체조회
    reserveYN = ''

    # 개인조회 여부, True-개인조회, False-회사조회
    senderYN = ''

    # 페이지 번호
    page = 1

    # 페이지당 목록갯수
    perPage = 100

    # 정렬방향, D-내림차순, A-오름차순
    order = "D"

    begin
      @Response = FaxController::FAXService.search(
        corpNum,
        sDate,
        eDate,
        state,
        reserveYN,
        senderYN,
        page,
        perPage,
        order,
      )
      render "fax/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 예약전송 팩스요청건을 취소합니다.
  # - 예약전송 취소는 예약전송시간 10분전까지 가능합니다.
  ##############################################################################
  def cancelReserve

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 접수번호
    receiptNum = "017020211012200001"

    begin
      @Response = FaxController::FAXService.cancelReserve(corpNum, receiptNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스 전송내역 목록 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 내역목록 팝업
    togo = "BOX"

    begin
      @value = FaxController::FAXService.getURL(
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
  # 팩스 전송단가를 확인합니다.
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    begin
      @value = FaxController::FAXService.getUnitCost(
        corpNum,
      )
      @name = "unitCost(전송단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
