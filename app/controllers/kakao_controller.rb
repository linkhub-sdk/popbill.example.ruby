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

  ##############################################################################
  # 플러스친구 계정관리 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
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

  ##############################################################################
  # 팝빌에 등록된 플러스친구 목록을 반환합니다.
  ##############################################################################
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

  ##############################################################################
  # 발신번호 관리 팝업 URL을 반환 합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
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
  # 팝빌에 등록된 발신번호 목록을 반환합니다.
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

  ##############################################################################
  # 팝빌에 등록된 플러스친구 목록을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
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
  # (주)카카오로부터 심사후 승인된 알림톡 템플릿 목록을 반환합니다.
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

  ##############################################################################
  # 단건의 알림톡을 전송합니다.
  ##############################################################################
  def sendATS_one
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018060000156'

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

  ##############################################################################
  # 개별 내용의 알림톡을 대량 전송 합니다.
  ##############################################################################
  def sendATS_multi
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018060000156'

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

  ##############################################################################
  # 동일한 내용의 알림톡을 대량 전송 합니다.
  ##############################################################################
  def sendATS_same
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018060000156'

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

  ##############################################################################
  # 단건의 친구톡 텍스트를 전송합니다.
  ##############################################################################
  def sendFTS_one
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 팝빌에 등록된 플러스 친구
    plusFriendID = '@팝빌'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 친구톡 내용 (최대 1000 자)
    content = "친구톡 내용 입니다."

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''

    # 수신자명
    receiverName = '루비'

    # [필수] 수신번호
    receiver = '01083490706'

    # 광고 전송여부
    adsYN = false

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기",
            "t" => "WL",
            "u1" => "http://www.popbill.com",
            "u2" => "http://www.popbill.com",
        }
    ]

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = KakaoController::KakaoService.sendFTS_one(
          corpNum,
          plusFriendID,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          receiver,
          receiverName,
          btns,
          adsYN,
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

  ##############################################################################
  # 개별 내용의 친구톡 텍스트를 대량 전송 합니다.
  ##############################################################################
  def sendFTS_multi
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 팝빌에 등록된 플러스 친구
    plusFriendID = '@팝빌'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''

    # 광고 전송여부
    adsYN = false

    # 친구톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
            "msg" => "친구톡 다량 내용 입니다. [Ruby]", # 친구톡 내용 (최대 1000 자)
            "altmsg" => "대체문자1", # 대체문자 내용 (최대 2000byte)
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
            "msg" => "친구톡 다량 내용 입니다. [Rails]", # 친구톡 내용 (최대 1000 자)
            "altmsg" => "대체문자2", # 대체문자 내용 (최대 2000byte)
        },
    ]

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기",
            "t" => "WL",
            "u1" => "http://www.popbill.com",
            "u2" => "http://www.popbill.com",
        }
    ]

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = KakaoController::KakaoService.sendFTS_multi(
          corpNum,
          plusFriendID,
          snd,
          altSendType,
          sndDT,
          msg,
          btns,
          adsYN,
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

  ##############################################################################
  # 동일한 내용의 친구톡 텍스트를 대량 전송 합니다.
  ##############################################################################
  def sendFTS_same
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 팝빌에 등록된 플러스 친구
    plusFriendID = '@팝빌'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 친구톡 내용 (최대 1000 자)
    content = '친구톡 동보 내용 입니다.';

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''

    # 광고 전송여부
    adsYN = false

    # 친구톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
        },
    ]

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기",
            "t" => "WL",
            "u1" => "http://www.popbill.com",
            "u2" => "http://www.popbill.com",
        }
    ]

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = KakaoController::KakaoService.sendFTS_same(
          corpNum,
          plusFriendID,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          msg,
          btns,
          adsYN,
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

  ##############################################################################
  # 단건의 친구톡 이미지를 전송합니다.
  ##############################################################################
  def sendFMS_one
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 팝빌에 등록된 플러스 친구
    plusFriendID = '@팝빌'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 친구톡 내용 (최대 1000 자)
    content = "친구톡 내용 입니다."

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''

    # 수신자명
    receiverName = '루비'

    # [필수] 수신번호
    receiver = '01083490706'

    # 친구톡 이미지 링크 URL (수신자가 친구톡 상단 이미지 선택시 호출되는 URL)
    imageURL = 'https://www.popbill.com'

    # filePath (전송포맷:jpg파일 & 용량제한 최대:500Kbyte & 이미지 높이/너비 비율: 1.333이하, 1/2이상)
    filePath = '/Users/kimhyunjin/SDK/popbill.example.ruby/test.jpg'

    # 광고 전송여부
    adsYN = false

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기",
            "t" => "WL",
            "u1" => "http://www.popbill.com",
            "u2" => "http://www.popbill.com",
        }
    ]

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = ''

    begin
      @value = KakaoController::KakaoService.sendFMS_one(
          corpNum,
          plusFriendID,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          filePath,
          imageURL,
          receiver,
          receiverName,
          btns,
          adsYN,
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

  ##############################################################################
  # 개별 내용의 친구톡 이미지를 대량 전송 합니다.
  ##############################################################################
  def sendFMS_multi
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 팝빌에 등록된 플러스 친구
    plusFriendID = '@팝빌'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = '20180725143059'

    # 친구톡 이미지 링크 URL (수신자가 친구톡 상단 이미지 선택시 호출되는 URL)
    imageURL = 'https://www.popbill.com'

    # filePath (전송포맷:jpg파일 & 용량제한 최대:500Kbyte & 이미지 높이/너비 비율: 1.333이하, 1/2이상)
    filePath = '/Users/kimhyunjin/SDK/popbill.example.ruby/test.jpg'

    # 광고 전송여부
    adsYN = false

    # 친구톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
            "msg" => "친구톡 다량 내용 입니다. [Ruby]", # 친구톡 내용 (최대 1000 자)
            "altmsg" => "대체문자1", # 대체문자 내용 (최대 2000byte)
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
            "msg" => "친구톡 다량 내용 입니다. [Rails]", # 친구톡 내용 (최대 1000 자)
            "altmsg" => "대체문자2", # 대체문자 내용 (최대 2000byte)
        },
    ]

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기",
            "t" => "WL",
            "u1" => "http://www.popbill.com",
            "u2" => "http://www.popbill.com",
        }
    ]

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = '20180725143406'

    begin
      @value = KakaoController::KakaoService.sendFMS_multi(
          corpNum,
          plusFriendID,
          snd,
          altSendType,
          sndDT,
          filePath,
          imageURL,
          msg,
          btns,
          adsYN,
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

  ##############################################################################
  # 동일한 내용의 친구톡 이미지를 대량 전송 합니다.
  ##############################################################################
  def sendFMS_same
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 팝빌에 등록된 플러스 친구
    plusFriendID = '@팝빌'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 친구톡 내용 (최대 1000 자)
    content = '친구톡 동보 내용 입니다.';

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20180622140517 yyyyMMddHHmmss)
    sndDT = ''

    # 친구톡 이미지 링크 URL (수신자가 친구톡 상단 이미지 선택시 호출되는 URL)
    imageURL = 'https://www.popbill.com'

    # filePath (전송포맷:jpg파일 & 용량제한 최대:500Kbyte & 이미지 높이/너비 비율: 1.333이하, 1/2이상)
    filePath = '/Users/kimhyunjin/SDK/popbill.example.ruby/test.jpg'

    # 광고 전송여부
    adsYN = false

    # 친구톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
        },
    ]

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기",
            "t" => "WL",
            "u1" => "http://www.popbill.com",
            "u2" => "http://www.popbill.com",
        }
    ]

    # 전송요청번호 (팝빌회원별 비중복 번호 할당 - 영문,숫자,'-','_' 조합, 최대 36자)
    requestNum = '20180625'

    begin
      @value = KakaoController::KakaoService.sendFMS_same(
          corpNum,
          plusFriendID,
          snd,
          content,
          altContent,
          altSendType,
          sndDT,
          filePath,
          imageURL,
          msg,
          btns,
          adsYN,
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

  ##############################################################################
  # 알림톡/친구톡 예약전송을 취소합니다.
  # - 예약전송 취소는 예약전송시간 10분전까지만 가능하다.
  ##############################################################################
  def cancelReserve
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 예약전송 요청시 발급 받은 접수번호
    receiptNum = '018062514310600001'

    begin
      @Response = KakaoController::KakaoService.cancelReserve(
          corpNum,
          receiptNum,
          userID
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전송요청번호를 할당한 알림톡/친구톡 예약전송을 취소합니다.
  # - 예약전송 취소는 예약전송시간 10분전까지만 가능하다.
  ##############################################################################
  def cancelReserveRN
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 전송요청시 할당한 전송요청 관리번호
    requestNum = '20180725143406'

    begin
      @Response = KakaoController::KakaoService.cancelReserveRN(
          corpNum,
          requestNum,
          userID
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 알림톡/친구톡 전송내역 및 전송상태를 확인한다.
  ##############################################################################
  def getMessages
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 예약전송 요청시 발급 받은 접수번호
    receiptNum = '018062516235600001'

    begin
      @Response = KakaoController::KakaoService.getMessages(
          corpNum,
          receiptNum,
          userID
      )
      render "kakao/getMessages"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전송요청번호를 할당한 알림톡/친구톡 전송내역 및 전송상태를 확인한다.
  ##############################################################################
  def getMessagesRN
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 전송요청시 할당한 전송요청 관리번호
    requestNum = '20180725143406'

    begin
      @Response = KakaoController::KakaoService.getMessagesRN(
          corpNum,
          requestNum,
          userID
      )
      render "kakao/getMessages"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 카카오톡 전송내역 목록을 조회한다.
  # - 버튼정보를 확인하는 경우는 GetMessages API 사용
  ##############################################################################
  def search
    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # [필수] 시작일자, 날자형식(yyyyMMdd)
    sDate = "20180625"

    # [필수] 종료일자, 날자형식(yyyyMMdd)
    eDate = "20180625"

    # 전송상태값 배열 [0-대기, 1-전송중, 2-성공, 3-대체, 4-실패, 5-취소]
    state = [0, 1, 2, 3, 4, 5]

    # 검색대상 배열 [ATS-알림톡, FTS-친구톡, FMS-친구톡이미지]
    item = ["FTS"]

    # 예약여부 1(예약전송조회), 0(즉시전송조회), 공백(전체조회)
    reserveYN = ''

    # 개인조회여부 1(개인조회), 0(전체조회)
    senderYN = ''

    # 페이지 번호, 기본값 1
    page = 1

    # 페이지당 검색개수 최대값1000 기본값 500
    perPage = 10

    # 정렬방향, D-내림차순, A-오름차순 기본값 'D'
    order = "D"

    begin
      @Response = KakaoController::KakaoService.search(
          corpNum,
          sDate,
          eDate,
          state,
          item,
          reserveYN,
          senderYN,
          page,
          perPage,
          order
      )
      render "kakao/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 카카오톡 전송내역 팝업 URL을 반환한다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
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
  # 카카오톡 API 서비스 전송단가를 확인합니다.
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # [ATS-알림톡, FTS-친구톡, FMS-친구톡이미지]
    msgType = KakaoMsgType::ATS

    begin
      @value = KakaoController::KakaoService.getUnitCost(
          corpNum,
          msgType,
      )['unitCost']
      @name = "unitCost(#{msgType} 전송단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 카카오톡 API 서비스 과금정보를 확인합니다.
  ##############################################################################
  def getChargeInfo
    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # [ATS-알림톡, FTS-친구톡, FMS-친구톡이미지]
    msgType = KakaoMsgType::ATS

    begin
      @Response = KakaoController::KakaoService.getChargeInfo(corpNum, msgType)
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
    corpNum = KakaoController::TestCorpNum

    begin
      @value = KakaoController::KakaoService.getBalance(corpNum)
      @name = "remainPoint(연동회원 잔여포인트)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원 포인트 충전 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getPopbillURL_CHRG
    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = KakaoController::KakaoService.getPopbillURL(
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
  # 파트너의 잔여포인트를 확인합니다.
  # - 과금방식이 연동과금인 경우 연동회원 잔여포인트(GetBalance API)를 이용하시기 바랍니다.
  ##############################################################################
  def getPartnerBalance
    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    begin
      @value = KakaoController::KakaoService.getPartnerBalance(corpNum)
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
    corpNum = KakaoController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = KakaoController::KakaoService.getPartnerURL(
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

  ##############################################################################
  # 팝빌 회원아이디 중복여부를 확인합니다.
  ##############################################################################
  def checkID
    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = KakaoController::KakaoService.checkID(testID)
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
        "ID" => "testkorea[Ruby]",

        # 비밀번호, 6자이상 20자 미만
        "PWD" => "thisispassword",

        # 사업자번호, '-' 제외 10자리
        "CorpNum" => "0000004301",

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
      @Response = KakaoController::KakaoService.joinMember(joinInfo)
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
  def getPopbillURL_LOGIN
    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전
    togo = "LOGIN"

    # 팝빌회원 아이디
    userID = "testkorea"

    begin
      @value = KakaoController::KakaoService.getPopbillURL(
          corpNum,
          togo,
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
    corpNum = KakaoController::TestCorpNum

    # 담당자 정보
    contactInfo = {
        # 아이디
        "id" => "testRuby",

        # 비밀번호
        "pwd" => "testRuby20180625",

        # 담당자명
        "personName" => "담당자명Ruby",

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
      @Response = KakaoController::KakaoService.registContact(
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
    corpNum = KakaoController::TestCorpNum

    begin
      @Response = KakaoController::KakaoService.listContact(corpNum)
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
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = KakaoController::TestUserID

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디
        "id" => userID,

        # 담당자명
        "personName" => "담당자명[Ruby]",

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
      @Response = KakaoController::KakaoService.updateContact(
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
    corpNum = KakaoController::TestCorpNum

    begin
      @Response = KakaoController::KakaoService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다.
  ##############################################################################
  def updateCorpInfo
    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 회사정보
    corpInfo = {

        # 대표자명
        "ceoname" => "대표자명[ruby]",

        # 상호명
        "corpName" => "상호[ruby]",

        # 주소
        "addr" => "주소[ruby]",

        # 업태
        "bizType" => "업태[ruby]",

        # 종목
        "bizClass" => "종목[ruby]",
    }

    begin
      @Response = KakaoController::KakaoService.updateCorpInfo(
          corpNum,
          corpInfo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

end
