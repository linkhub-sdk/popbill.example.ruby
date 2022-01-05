###################################################################################
#
# 팝빌 문자 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2020-07-23
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 23, 26번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 문자를 전송을 위한 발신번호 사전등록을 합니다. (등록방법은 사이트/API 두가지 방식이 있습니다.)
#    - 1. 팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 메뉴에서 등록
#    - 2. getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
#
###################################################################################

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

  # 인증토큰 IP제한기능 사용여부, true-사용, false-미사용, 기본값(true)
  MSGService.setIpRestrictOnOff(true)

  # 팝빌 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  MSGService.setUseStaticIP(false)

  #로컬시스템 시간 사용여부, true-사용, false-미사용, 기본값(false)
  MSGService.setUseLocalTimeYN(false)

  ##############################################################################
  # 발신번호 관리 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/message/ruby/api#GetSenderNumberMgtURL
  ##############################################################################
  def getSenderNumberMgtURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    begin
      @value = MessageController::MSGService.getSenderNumberMgtURL(
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
  # 팝빌에 등록된 문자 발신번호 목록을 반환합니다.
  # - https://docs.popbill.com/message/ruby/api#GetSenderNumberList
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

  ##############################################################################
  # SMS(단문)를 전송합니다.
  # - 메시지 길이가 90 byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - https://docs.popbill.com/message/ruby/api#SendSMS
  ##############################################################################
  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 수신번호
    receiver = "010000111"

    # 수신자명
    receiverName = "수신자명"

    # 메시지내용, 90byte초과된 내용은 삭제되어 전송됨..
    contents = "message send Test"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # [대량전송] SMS(단문)를 전송합니다.
  # - 메시지 길이가 90 byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - https://docs.popbill.com/message/ruby/api#SendSMS_Multi
  ##############################################################################
  def sendSMS_Multi

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 메시지 내용, 90byte 초과된 내용은 삭제되어 전송됨.
    contents = "message send Test"

    # 수신자정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명01", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명02", # 수신자명
        },
    ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # LMS(장문)를 전송합니다.
  # - 메시지 길이가 2,000Byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - https://docs.popbill.com/message/ruby/api#SendLMS
  ##############################################################################
  def sendLMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 수신번호
    receiver = "010000111"

    # 수신자명
    receiverName = "수신자명"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨
    contents = "message send Test"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # [대량전송] LMS(장문)를 전송합니다.
  # - 메시지 길이가 2,000Byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - https://docs.popbill.com/message/ruby/api#SendLMS_Multi
  ##############################################################################
  def sendLMS_Multi

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨
    contents = "message send Test LMS Multi"

    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명01", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명02", # 수신자명
        },
    ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # MMS(포토)를 전송합니다.
  # - 메시지 길이가 2,000Byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - 이미지 파일의 크기는 최대 300Kbtye (JPEG), 가로/세로 1000px 이하 권장
  # - https://docs.popbill.com/message/ruby/api#SendMMS
  ##############################################################################
  def sendMMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 수신번호
    receiver = "010111222"

    # 수신자명
    receiverName = "수신자명"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨.
    contents = "message send XMS Test"

    # 첨부파일 경로
    filePath = "/Users/John/Desktop/test.jpg"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # [대랑전송] MMS(포토)를 전송합니다.
  # - 메시지 길이가 2,000Byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - 이미지 파일의 크기는 최대 300Kbtye (JPEG), 가로/세로 1000px 이하 권장
  # - https://docs.popbill.com/message/ruby/api#SendMMS_Multi
  ##############################################################################
  def sendMMS_Multi
    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 최대 2000byte 초과된 내용은 삭제되어 전송됨.
    contents = "message send Test XMS Multi"

    # 수신정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명01", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명02", # 수신자명
        },
    ]

    # 첨부파일 경로
    filePath = "/Users/John/Desktop/test.jpg"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # XMS(단문/장문 자동인식)를 전송합니다.
  # - 메시지 내용의 길이(90byte)에 따라 SMS/LMS(단문/장문)를 자동인식하여 전송합니다.
  # - 90byte 초과시 LMS(장문)으로 인식 합니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - https://docs.popbill.com/message/ruby/api#SendXMS
  ##############################################################################
  def sendXMS

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 수신번호
    receiver = "010000111"

    # 수신자명
    receiverName = "수신자명"

    # 메시지 제목
    subject = "This is subject"

    # 메시지 내용, 메시지 내용의 길이(90byte)에 따라 SMS/LMS(단문/장문)를 자동인식하여 전송됨.
    contents = "message send XMS Test"

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # [대량전송] XMS(단문/장문 자동인식)를 전송합니다.
  # - 메시지 내용의 길이(90byte)에 따라 SMS/LMS(단문/장문)를 자동인식하여 전송합니다.
  # - 90byte 초과시 LMS(장문)으로 인식 합니다.
  # - 팝빌에 등록되지 않은 발신번호로 메시지를 전송하는 경우 발신번호 미등록 오류로 처리됩니다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - https://docs.popbill.com/message/ruby/api#SendXMS_Multi
  ##############################################################################
  def sendXMS_Multi

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 메시지 제목
    subject = "메시지제목"

    # 메시지 내용, 메시지 내용의 길이(90byte)에 따라 SMS/LMS(단문/장문)를 자동인식하여 전송됨.
    contents = "message send Test XMS Multi"

    # 수신자 정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명01", # 수신자명
        },
        {
            "rcv" => "010000111", # 수신번호
            "rcvnm" => "수신자명02", # 수신자명
        },
    ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고문자 전송여부
    adsYN = false

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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

  ##############################################################################
  # 문자전송요청시 발급받은 접수번호(receiptNum)로 예약문자 전송을 취소합니다.
  # - 예약취소는 예약전송시간 10분전까지만 가능합니다.
  # - https://docs.popbill.com/message/ruby/api#CancelReserve
  ##############################################################################
  def cancelReserve

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 예약문자 접수번호
    receiptNum = "019040317000000014"

    begin
      @Response = MessageController::MSGService.cancelReserve(corpNum, receiptNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 문자전송요청시 할당한 전송요청번호(requestNum)로 예약문자 전송을 취소합니다.
  # - 예약취소는 예약전송시간 10분전까지만 가능합니다.
  # - https://docs.popbill.com/message/ruby/api#CancelReserveRN
  ##############################################################################
  def cancelReserveRN

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 전송요청시 할당한 전송요청 관리번호
    requestNum = '20190917-001'

    begin
      @Response = MessageController::MSGService.cancelReserveRN(corpNum, requestNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 문자전송요청시 발급받은 접수번호(receiptNum)로 전송상태를 확인합니다
    # - https://docs.popbill.com/message/ruby/api#GetMessages
  ##############################################################################
  def getMessages

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 문자전송 접수번호
    receiptNum = "019040317000000014"

    begin
      @Response = MessageController::MSGService.getMessages(corpNum, receiptNum)
      render "message/getMessages"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 문자전송요청시 할당한 전송요청번호(requestNum)로 전송상태를 확인합니다
    # - https://docs.popbill.com/message/ruby/api#GetMessagesRN
  ##############################################################################
  def getMessagesRN

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 전송요청시 할당한 전송요청 관리번호
    requestNum = "20190917-01"

    begin
      @Response = MessageController::MSGService.getMessagesRN(corpNum, requestNum)
      render "message/getMessages"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 문자 전송내역 요약정보를 확인합니다. (최대 1000건)
  # - https://docs.popbill.com/message/ruby/api#GetStates
  ##############################################################################
  def getStates
    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 문자전송 접수번호 배열, 최대 1000건
    reciptNumList = ["019040317000000015", "019040317000000014"]

    begin
      @Response = MessageController::MSGService.getStates(corpNum, reciptNumList)
      render "message/getStates"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 문자전송 내역을 조회합니다. (조회기간 단위 : 최대 2개월)
  # - 문자 접수일시로부터 6개월 이내 접수건만 조회할 수 있습니다.
  # - https://docs.popbill.com/message/ruby/api#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    # [필수] 시작일자, 날짜형식(yyyyMMdd)
    sDate = "20190701"

    # [필수] 종료일자, 날짜형식(yyyyMMdd)
    eDate = "20191231"

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
    perPage = 10

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
  # 문자 전송내역 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/message/ruby/api#GetSentListURL
  ##############################################################################
  def getSentListURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    begin
      @value = MessageController::MSGService.getSentListURL(
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
  # 080 서비스 수신거부 목록을 확인합니다.
  # - https://docs.popbill.com/message/ruby/api#GetAutoDenyList
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
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  # - https://docs.popbill.com/message/ruby/api#GetBalance
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
  # 팝빌 연동회원 포인트 충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/message/ruby/api#GetChargeURL
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
  # 연동회원 포인트 결제내역 확인을 위한 페이지의 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/message/ruby/api#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    begin
      @value = MessageController::MSGService.getPaymentURL(
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
  # - https://docs.popbill.com/message/ruby/api#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 팝빌회원 아이디
    userID = MessageController::TestUserID

    begin
      @value = MessageController::MSGService.getUseHistoryURL(
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
  # - https://docs.popbill.com/message/ruby/api#GetPartnerBalance
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
  # - https://docs.popbill.com/message/ruby/api#GetPartnerBalance
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
  # 문자 API 서비스 전송단가를 확인합니다.
  # - https://docs.popbill.com/message/ruby/api#GetUnitCost
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
  # 연동회원의 문자 API 서비스 과금정보를 확인합니다.
  # - https://docs.popbill.com/message/ruby/api#GetChargeInfo
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
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  # - https://docs.popbill.com/message/ruby/api#CheckIsMember
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
  # - https://docs.popbill.com/message/ruby/api#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

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
  # - https://docs.popbill.com/message/ruby/api#JoinMember
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
      @Response = MessageController::MSGService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/message/ruby/api#GetAccessURL
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
  # 연동회원의 회사정보를 확인합니다.
  # - https://docs.popbill.com/message/ruby/api#GetCorpInfo
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
  # - https://docs.popbill.com/message/ruby/api#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

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

  ##############################################################################
  # 연동회원의 담당자를 신규로 등록합니다.
  # - https://docs.popbill.com/message/ruby/api#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디 (6자 이상 50자 미만)
        "id" => "testkorea20190121",

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
  # 연동회원 사업자번호에 등록된 담당자(팝빌 로그인 계정) 정보를 확인합니다.
  # - https://docs.popbill.com/message/ruby/api#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = MessageController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = MessageController::MSGService.getContactInfo(
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
  # - https://docs.popbill.com/message/ruby/api#ListContact
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
  # - https://docs.popbill.com/message/ruby/api#UpdateContact
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

end
