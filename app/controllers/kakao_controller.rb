################################################################################
# 팜빌 카카오톡 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2018-6-22
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 19, 22번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
################################################################################

require 'popbill/kakaotalk'

class KakaoController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 문자 API Service 초기화
  KakaoService = KakaoService.instance(
      KakaoController::LinkID,
      KakaoController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  KakaoService.setIsTest(true)


  def getURL_PLUSFRIEND
    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # PLUSFRIEND(플러스친구계정관리), SENDER(발신번호관리), TEMPLATE(알림톡템플릿관리), BOX(카카오톡전송내역)
    togo = "PLUSFRIEND"

    begin
      @value = KakaoController::KakaoService.getURL(
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

  def listPlusFriendID
    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    begin
      @Response = KakaoController::KakaoService.listPlusFriendID(
          corpNum,
          userID
      )
      render "kakao/listPlusFriendID"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def getURL_SENDER
    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # PLUSFRIEND(플러스친구계정관리), SENDER(발신번호관리), TEMPLATE(알림톡템플릿관리), BOX(카카오톡전송내역)
    togo = "SENDER"

    begin
      @value = KakaoController::KakaoService.getURL(
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
  # 문자 발신번호 목록을 확인합니다.
  ##############################################################################
  def getSenderNumberList

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    begin
      @Response = KakaoController::KakaoService.getSenderNumberList(
          corpNum,
      )
      render "kakao/getSenderNumberList"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def getURL_TEMPLATE
    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # PLUSFRIEND(플러스친구계정관리), SENDER(발신번호관리), TEMPLATE(알림톡템플릿관리), BOX(카카오톡전송내역)
    togo = "TEMPLATE"

    begin
      @value = KakaoController::KakaoService.getURL(
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
  # 알림톡 템플릿 목록을 확인합니다.
  ##############################################################################
  def listATSTemplate

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    begin
      @Response = KakaoController::KakaoService.listATSTemplate(
          corpNum,
      )
      render "kakao/listATSTemplate"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendATS_one
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum
    # 팝빌회원 아이디
    userID = 'testkorea'
    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018040000001'
    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'
    # 알림톡 내용 (최대 1000 자)
    content = "[링크허브] 루비님, 안녕하세요. 링크허브의 파트너 가입신청을 해주셔서 감사드립니다. 파트너 승인처리가 완료되어 팝빌 API 인증정보를 메일로 송부하였습니다. 관련문의는 링크허브로 편하게 연락주시기 바랍니다. 파트너센터 : 1600-8536 / sales@linkhub.co.kr 기술지원센터 : 1600-9854 /"
    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'
    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'
    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''
    # 수신자명
    receiverName = '루비'
    # [필수] 수신번호
    receiver = '01083490706'
    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = KakaoController::KakaoService.sendATS_one(
          corpNum,
          templateCode,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          receiver,
          receiverName,
          requestNum,
          userID,
      )['receiptNum']
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendATS_multi
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum
    # 팝빌회원 아이디
    userID = 'testkorea'
    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018040000001'
    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'
    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'
    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''
    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''
    # 알림톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
            "msg" => "[링크허브] 루비님, 안녕하세요. 링크허브의 파트너 가입신청을 해주셔서 감사드립니다. 파트너 승인처리가 완료되어 팝빌 API 인증정보를 메일로 송부하였습니다. 관련문의는 링크허브로 편하게 연락주시기 바랍니다. 파트너센터 : 1600-8536 / sales@linkhub.co.kr 기술지원센터 : 1600-9854 /", # 알림톡 내용 (최대 1000 자)
            "altmsg" => "대체문자1", # 대체문자 내용 (최대 2000byte)
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
            "msg" => "[링크허브] 레일즈님, 안녕하세요. 링크허브의 파트너 가입신청을 해주셔서 감사드립니다. 파트너 승인처리가 완료되어 팝빌 API 인증정보를 메일로 송부하였습니다. 관련문의는 링크허브로 편하게 연락주시기 바랍니다. 파트너센터 : 1600-8536 / sales@linkhub.co.kr 기술지원센터 : 1600-9854 /", # 알림톡 내용 (최대 1000 자)
            "altmsg" => "대체문자2", # 대체문자 내용 (최대 2000byte)
        },
    ]
    begin
      @value = KakaoController::KakaoService.sendATS_multi(
          corpNum,
          templateCode,
          snd,
          altSendType,
          sndDT,
          msg,
          requestNum,
          userID,
      )['receiptNum']
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendATS_same
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum
    # 팝빌회원 아이디
    userID = 'testkorea'
    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018040000001'
    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'
    # 알림톡 내용 (최대 1000 자)
    content = "[링크허브] 회원님, 안녕하세요. 링크허브의 파트너 가입신청을 해주셔서 감사드립니다. 파트너 승인처리가 완료되어 팝빌 API 인증정보를 메일로 송부하였습니다. 관련문의는 링크허브로 편하게 연락주시기 바랍니다. 파트너센터 : 1600-8536 / sales@linkhub.co.kr 기술지원센터 : 1600-9854 /"
    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'
    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'
    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''
    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''
    # 알림톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "popbill", # 수신자명
        },
        {
            "rcv" => "010333999", # [필수] 수신번호
            "rcvnm" => "linkhub", # 수신자명
        },
    ]
    begin
      @value = KakaoController::KakaoService.sendATS_same(
          corpNum,
          templateCode,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          msg,
          requestNum,
          userID,
      )['receiptNum']
      @name = "receiptNum(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  def sendFTS_one
  end

  def sendFTS_multi
  end

  def sendFTS_sama
  end

  def sendFMS_one
  end

  def sendFMS_multi
  end

  def sendFMS_same
  end

  def cancelReserve
  end

  def cancelReserveRN
  end

  def getMessages
  end

  def getMessagesRN
  end

  def search
  end

  def getURL_BOX
    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # PLUSFRIEND(플러스친구계정관리), SENDER(발신번호관리), TEMPLATE(알림톡템플릿관리), BOX(카카오톡전송내역)
    togo = "BOX"

    begin
      @value = KakaoController::KakaoService.getURL(
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
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 파트너 링크아이디
    linkID = KakaoController::LinkID

    begin
      @Response = KakaoController::KakaoService.checkIsMember(
          corpNum,
          linkID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
