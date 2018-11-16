################################################################################
# 팜빌 문자 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2018-06-25
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 19, 22번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
################################################################################

require 'popbill/message'

class MessageController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 문자 API Service 초기화
  MSGService = MessageService.instance(
      MessageController::LinkID,
      MessageController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  MSGService.setIsTest(true)

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 파트너 링크아이디
    linkID = MessageController::LinkID

    begin
      @Response = MessageController::MSGService.checkIsMember(
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
      @Response = MessageController::MSGService.checkID(testID)
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
      @Response = MessageController::MSGService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 문자 API 서비스 과금정보를 확인합니다.
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # SMS-단문, LMS-장문, MMS-포토
    msgType = MsgType::SMS


    begin
      @Response = MessageController::MSGService.getChargeInfo(corpNum, msgType)
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
    corpNum = MessageController::TestCorpNum

    begin
      @value = MessageController::MSGService.getBalance(corpNum)
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
    corpNum = MessageController::TestCorpNum

    begin
      @value = MessageController::MSGService.getPartnerBalance(corpNum)
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
    corpNum = MessageController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = MessageController::MSGService.getPartnerURL(
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
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    begin
      @value = MessageController::MSGServiceCBService.getAccessURL(
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
  # 팝빌 연동회원 포인트 충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    begin
      @value = MessageController::MSGService.getChargeURL(
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
  # 연동회원의 담당자를 신규로 등록합니다.
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

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
      @Response = MessageController::MSGService.registContact(
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
    corpNum = MessageController::TestCorpNum

    begin
      @Response = MessageController::MSGService.listContact(corpNum)
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
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

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
      @Response = MessageController::MSGService.updateContact(
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
    corpNum = MessageController::TestCorpNum

    begin
      @Response = MessageController::MSGService.getCorpInfo(corpNum)
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
    corpNum = MessageController::TestCorpNum

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

        # 종목
        "bizClass" => "종목170116",
    }

    begin
      @Response = MessageController::MSGService.updateCorpInfo(
          corpNum,
          corpInfo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 수신번호
    receiver = "010000111"

    # 수신자명
    receiverName = "MyPhone"

    # 메시지내용, 90Byte 초과시 내용이 삭제되어 전송됨
    contents = "message send Test"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendSMS(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          contents,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  def sendSMS_Multi

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 메시지 내용, 90Byte 초과된 내용은 삭제되어 전송됨
    contents = "message send Test"

    # 수신자정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "John", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "John2", # 수신자명
        },
    ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendSMS_multi(
          corpNum,
          sender,
          senderName,
          contents,
          receivers,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendLMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 수신번호
    receiver = "010000111"

    # 수신자명
    receiverName = "MyPhone"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨
    contents = "message send Test"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendLMS(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          subject,
          contents,
          reserveDT,
          adsYN,
          userID,
          requestNum,

      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendLMS_Multi

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨
    contents = "message send Test LMS Multi"

    receivers = [
        {
            "rcv" => "010111222",
            "rcvnm" => "John",
        },
        {
            "rcv" => "010000111",
            "rcvnm" => "John2",
        },
    ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendLMS_multi(
          corpNum,
          sender,
          senderName,
          subject,
          contents,
          receivers,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendXMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 수신번호
    receiver = "010000111"

    # 수신자명
    receiverName = "MyPhone"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 길이가 90Byte 초과시 LMS으로 자동 인식되어 전송됨
    contents = "message send XMS Test"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendXMS(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          subject,
          contents,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendXMS_Multi

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 길이가 90Byte 초과시 LMS으로 자동 인식되어 전송됨
    contents = "message send Test XMS Multi"

    # 수신자 정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "John", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "John2", # 수신자명
        },
    ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendXMS_multi(
          corpNum,
          sender,
          senderName,
          subject,
          contents,
          receivers,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendMMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 수신번호
    receiver = "010111222"

    # 수신자명
    receiverName = "MyPhone"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용
    contents = "message send XMS Test"

    # 첨부파일 경로
    filePath = "/Users/kimhyunjin/SDK/popbill.example.ruby/test.jpg"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendMMS(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          subject,
          contents,
          filePath,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendMMS_Multi
    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "John"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨
    contents = "message send Test XMS Multi"

    # 수신정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "John", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "John2", # 수신자명
        },
    ]

    # 첨부파일 경로
    filePath = "/Users/kimhyunjin/SDK/popbill.example.ruby/test.jpg"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = MessageController::MSGService.sendMMS_multi(
          corpNum,
          sender,
          senderName,
          subject,
          contents,
          receivers,
          filePath,
          reserveDT,
          adsYN,
          userID,
          requestNum,
      )
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 문자 전송결과를 확인합니다.
  ##############################################################################
  def getMessages

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 문자전송 접수번호
    receiptNum = "018062818000000011"

    begin
      @Response = MessageController::MSGService.getMessages(corpNum, receiptNum)
      render "message/getMessages"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전송요청번호를 할당한 문자 전송결과를 확인합니다.
  ##############################################################################
  def getMessagesRN

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 전송요청시 할당한 전송요청 관리번호
    requestNum = "20180625171035"

    begin
      @Response = MessageController::MSGService.getMessagesRN(corpNum, requestNum)
      render "message/getMessages"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 문자 전송내역 요약정보를 확인합니다.
  ##############################################################################
  def getStates
    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 문자전송 접수번호 배열
    reciptNumList = %w(018062518000000016 018061814000000039 018062518000000017)

    begin
      @Response = MessageController::MSGService.getStates(corpNum, reciptNumList)
      render "message/getStates"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 문자전송 내역을 조회합니다.
  # 최대 검색기간 : 6개월 이내
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # [필수] 시작일자, 날자형식(yyyyMMdd)
    sDate = "20180628"

    # [필수] 종료일자, 날자형식(yyyyMMdd)
    eDate = "20180628"

    # 전송상태값 배열, 1-대기, 2-성공, 3-실패, 4-취소
    state = [1, 2, 3, 4]

    # 검색대상 배열, SMS(단문),LMS(장문),MMS(포토)
    item = ["SMS", "LMS", "MMS"]

    # 예약문자 검색여부, 1(예약문자만 조회), 0(예약문자 아닌건만 조회), 공백(전체조회)
    reserveYN = ''

    # 개인조회여부, 1(개인조회), 0 또는 공백(전체조회)
    senderYN = ''

    # 페이지 번호
    page = 1

    # 페이지당 목록개수
    perPage = 100

    # 정렬방향, D-내림차순, A-오름차순
    order = "D"

    # 조회 검색어, 문자 전송시 기재한 수신자명 또는 발신자명 기재
    qString = ""

    begin
      @Response = MessageController::MSGService.search(
          corpNum,
          sDate,
          eDate,
          state,
          item,
          reserveYN,
          senderYN,
          page,
          perPage,
          order,
          userID,
          qString,
      )
      render "message/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 예약문자전송을 취소합니다.
  # - 예약취소는 예약전송시간 10분전까지만 가능합니다.
  ##############################################################################
  def cancelReserve

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 예약문자 접수번호
    receiptNum = "017020210000000012"

    begin
      @Response = MessageController::MSGService.cancelReserve(corpNum, receiptNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 전송요청번호를 할당한 예약문자전송을 취소합니다.
  # - 예약취소는 예약전송시간 10분전까지만 가능합니다.
  ##############################################################################
  def cancelReserveRN

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 전송요청시 할당한 전송요청 관리번호
    requestNum = '20180625-sms001'

    begin
      @Response = MessageController::MSGService.cancelReserveRN(corpNum, requestNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 문자 서비스 관련 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # BOX-문자 전송내역 팝업 / SENDER-발신번호 관리 팝업
    togo = "SENDER"

    begin
      @value = MessageController::MSGService.getURL(
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
  # 문자 API 서비스 전송단가를 확인합니다.
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # SMS-단문, LMS-장문, MMS-포토
    msgType = MsgType::SMS

    begin
      @value = MessageController::MSGService.getUnitCost(
          corpNum,
          msgType,
      )
      @name = "unitCost(#{msgType} 전송단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 080 서비스 수신거부 목록을 확인합니다.
  ##############################################################################
  def getAutoDenyList

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    begin
      @Response = MessageController::MSGService.getAutoDenyList(
          corpNum,
      )
      render "message/autoDenyList"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 문자 발신번호 목록을 확인합니다.
  ##############################################################################
  def getSenderNumberList

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    begin
      @Response = MessageController::MSGService.getSenderNumberList(
          corpNum,
      )
      render "message/getSenderNumberList"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
