################################################################################
# 팜빌 카카오톡 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2019-02-12
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 25, 28번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
# 3) 친구톡/알림톡 전송하기 위해 발신번호 사전등록을 합니다. (등록방법은 사이트/API 두가지 방식이 있습니다.)
#   - 팝빌 사이트 로그인 > [문자/팩스] > [카카오톡] > [발신번호 사전등록] 메뉴에서 등록
#   - getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
# 4) 문자를 전송하기 위해 발신번호 사전등록을 합니다. (등록방법은 사이트/API 두가지 방식이 있습니다.)
#   - 팝빌 사이트 로그인 > [문자/팩스] > [문자] > [발신번호 사전등록] 메뉴에서 등록
#   - getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
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
  def getPlusFriendMgtURL

    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    begin
      @value = KakaoController::KakaoService.getPlusFriendMgtURL(
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
  def getSenderNumberMgtURL

    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    begin
      @value = KakaoController::KakaoService.getSenderNumberMgtURL(
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
  # 알림톡 템플릿관리 팝업 URL 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getATSTemplateMgtURL

    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    begin
      @value = KakaoController::KakaoService.getATSTemplateMgtURL(
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
  # (주)카카오로부터 심사후 승인된 알림톡 템플릿 목록을 반환합니다.
  # - 반환항목중 템플릿코드(templateCode)는 알림톡 전송시 사용됩니다.
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
  # 알림톡 전송을 요청합니다.
  # - 사전에 승인된 템플릿의 내용과 알림톡 전송내용(content)이 다를 경우 전송실패 처리된다.
  # - 알림톡 템플릿 등록방법.  (사이트/API 등록방법 제공)
  #     1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [카카오톡 관리] > 알림톡 템플릿 관리
  #     2.getATSTemplateMgtURL API를 통해 반환된 URL을 이용하여 템플릿 관리
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  ##############################################################################
  def sendATS_one

    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018110000047'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 알림톡 내용 (최대 1000자)
    content = '테스트 템플릿 입니다.'

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
    sndDT = ''

    # 수신자명
    receiverName = '루비'

    # [필수] 수신번호
    receiver = '010111222'

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # [대량전송] 알림톡 전송을 요청합니다.
  # - 사전에 승인된 템플릿의 내용과 알림톡 전송내용(msg)이 다를 경우 전송실패 처리된다.
  # - 알림톡 템플릿 등록방법.  (사이트/API 등록방법 제공)
  #     1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [카카오톡 관리] > 알림톡 템플릿 관리
  #     2.getATSTemplateMgtURL API를 통해 반환된 URL을 이용하여 템플릿 관리
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  ##############################################################################
  def sendATS_multi

    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018110000047'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
    sndDT = ''

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    # 알림톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
            "msg" => "테스트 템플릿 [루비님] 입니다.", # 알림톡 내용 (최대 1000자)
            "altmsg" => "대체문자1", # 대체문자 내용 (최대 2000byte)
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
            "msg" => "테스트 템플릿 [레일즈] 입니다.", # 알림톡 내용 (최대 1000자)
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
  # [동보전송] 알림톡 전송을 요청합니다.
  # - 사전에 승인된 템플릿의 내용과 알림톡 전송내용(content)이 다를 경우 전송실패 처리된다.
  # - 알림톡 템플릿 등록방법.  (사이트/API 등록방법 제공)
  #     1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [카카오톡 관리] > 알림톡 템플릿 관리
  #     2.getATSTemplateMgtURL API를 통해 반환된 URL을 이용하여 템플릿 관리
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  ##############################################################################
  def sendATS_same

    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 알림톡 템플릿코드 (ListATSTemplate API의 반환 항목 중 templateCode 기재)
    templateCode = '018110000047'

    # [필수] 발신번호 (팝빌에 등록된 발신번호만 이용가능)
    snd = '070-4304-2991'

    # 알림톡 내용 (최대 1000자)
    content = '테스트 템플릿 입니다.'

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-알림톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
    sndDT = ''

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # 친구톡(텍스트) 전송을 요청합니다.
  # - 친구톡은 심야 전송(20:00~08:00)이 제한됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신 번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
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

    # 친구톡 내용 (최대 1000자)
    content = '친구톡 내용 입니다.'

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
    sndDT = ''

    # 수신자명
    receiverName = '루비'

    # [필수] 수신번호
    receiver = '010111222'

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

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # [대량전송] 친구톡(텍스트) 전송을 요청합니다.
  # - 친구톡은 심야 전송(20:00~08:00)이 제한됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신 번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
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

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
    sndDT = ''

    # 광고 전송여부
    adsYN = false

    # 친구톡 전송정보 (최대 1000 개)
    msg = [
        {
            "rcv" => "010123456", # [필수] 수신번호
            "rcvnm" => "ruby", # 수신자명
            "msg" => "친구톡 대량전송 내용 입니다. [Ruby]", # 친구톡 내용 (최대 1000자)
            "altmsg" => "대체문자1", # 대체문자 내용 (최대 2000byte)
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
            "msg" => "친구톡 대량전송  내용 입니다. [Rails]", # 친구톡 내용 (최대 1000자)
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

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # [동보전송] 친구톡(텍스트) 전송을 요청합니다.
  # - 친구톡은 심야 전송(20:00~08:00)이 제한됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신 번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
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

    # 친구톡 내용 (최대 1000자)
    content = '친구톡 동보 내용 입니다.'

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
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

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # 친구톡(이미지) 전송을 요청합니다.
  # - 친구톡은 심야 전송(20:00~08:00)이 제한됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신 번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - 이미지 전송규격 / jpg 포맷, 용량 최대 500KByte, 이미지 높이/너비 비율 1.333 이하, 1/2 이상
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

    # 친구톡 내용 (최대 400자)
    content = '친구톡 내용 입니다.'

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
    sndDT = ''

    # 수신자명
    receiverName = '루비'

    # [필수] 수신번호
    receiver = '010111222'

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
            "t" => "AL", #버튼유형, (DS-배송조회 / WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기", #버튼
            "t" => "WL", #버튼유형, (DS-배송조회 / WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        }
    ]

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
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
  # [대량전송] 친구톡(이미지) 전송을 요청합니다.
  # - 친구톡은 심야 전송(20:00~08:00)이 제한됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신 번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - 이미지 전송규격 / jpg 포맷, 용량 최대 500KByte, 이미지 높이/너비 비율 1.333 이하, 1/2 이상
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

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
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
            "msg" => "친구톡 다량 내용 입니다. [Ruby]", # 친구톡 내용 (최대 400자)
            "altmsg" => "대체문자1", # 대체문자 내용 (최대 2000byte)
        },
        {
            "rcv" => "010890456", # [필수] 수신번호
            "rcvnm" => "rails", # 수신자명
            "msg" => "친구톡 다량 내용 입니다. [Rails]", # 친구톡 내용 (최대 400자)
            "altmsg" => "대체문자2", # 대체문자 내용 (최대 2000byte)
        },
    ]

    # 버튼 목록 (최대 5개)
    btns = [
        {
            "n" => "앱링크", #버튼
            "t" => "AL", #버튼유형, (DS-배송조회 / WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기", #버튼
            "t" => "WL", #버튼유형, (DS-배송조회 / WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        }
    ]

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

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
  # [동보전송] 친구톡(이미지) 전송을 요청합니다.
  # - 친구톡은 심야 전송(20:00~08:00)이 제한됩니다.
  # - 팝빌에 등록되지 않은 발신번호로 알림톡 메시지를 전송하는 경우 발신 번호 미등록 오류로 처리된다.
  # - 발신번호 사전등록 방법. (사이트/API 등록방법 제공)
  #    1.팝빌 사이트 로그인 [문자/팩스] > [카카오톡] > [발신번호 사전등록] 에서 등록
  #    2.getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
  # - 이미지 전송규격 / jpg 포맷, 용량 최대 500KByte, 이미지 높이/너비 비율 1.333 이하, 1/2 이상
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

    # 친구톡 내용 (최대 400자)
    content = '친구톡 동보 내용 입니다.'

    # 대체문자 내용 (최대 2000byte)
    altContent = '대체문자 내용 입니다'

    # 대체문자 유형 (공백-미전송 / C-친구톡내용 / A-대체문자내용)
    altSendType = 'A'

    # 예약일시 (작성형식: 20190120012753 yyyyMMddHHmmss)
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
            "t" => "AL", #버튼유형, (DS-배송조회 / WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        },
        {
            "n" => "팝빌 바로가기", #버튼
            "t" => "WL", #버튼유형, (DS-배송조회 / WL-웹링크 / AL-앱링크 / MD-메시지전달 / BK-봇키워드)
            "u1" => "http://www.popbill.com", #[앱링크] Android [웹링크] Mobile
            "u2" => "http://www.popbill.com", #[앱링크] IOS [웹링크] PC URL
        }
    ]

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

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
  # 알림톡/친구톡 전송요청시 발급받은 접수번호(receiptNum)로 예약전송건을 취소합니다.
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
  # 전송요청번호(requestNum)를 할당한 알림톡/친구톡 예약전송건을 취소합니다.
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
  # 알림톡/친구톡 전송요청시 발급받은 접수번호(receiptNum)로 전송결과를 확인합니다.
  ##############################################################################
  def getMessages

    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 예약전송 요청시 발급 받은 접수번호
    receiptNum = '018062817583800001'

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
  # 전송요청번호(requestNum)를 할당한 알림톡/친구톡 전송내역 및 전송상태를 확인합니다.
  ##############################################################################
  def getMessagesRN

    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    # [필수] 전송요청시 할당한 전송요청 관리번호
    requestNum = '20190120-001'

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
  # - 최대 검색기간 : 6개월 이내
  ##############################################################################
  def search

    # [필수] 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 사업자번호
    userID = KakaoController::TestUserID

    # [필수] 시작일자, 날자형식(yyyyMMdd)
    sDate = "20190101"

    # [필수] 종료일자, 날자형식(yyyyMMdd)
    eDate = "20190121"

    # 전송상태값 배열 [0-대기, 1-전송중, 2-성공, 3-대체, 4-실패, 5-취소]
    state = [0, 1, 2, 3, 4, 5]

    # 검색대상 배열 [ATS-알림톡, FTS-친구톡, FMS-친구톡이미지]
    item = ["ATS", "FTS", "FMS"]

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

    # 조회 검색어, 카카오톡 전송시 기재한 수신자명 입력
    qString = ""

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
          order,
          userID,
          qString,
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
  def getSentListURL

    # 펍빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = 'testkorea'

    begin
      @value = KakaoController::KakaoService.getSentListURL(
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
  # 팝빌 연동회원 포인트 충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = KakaoController::TestUserID

    begin
      @value = KakaoController::KakaoService.getChargeURL(
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
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

    # 팝빌회원 아이디
    userID = KakaoController::TestUserID

    begin
      @value = KakaoController::KakaoService.getAccessURL(
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

  ##############################################################################
  # 연동회원의 담당자를 신규로 등록합니다.
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = KakaoController::TestCorpNum

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

        # 관리자 권한여부, true(관리자), false(사용자)
        "mgrYN" => false,
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

        # 관리자 권한여부, true(관리자), false(사용자)
        "mgrYN" => false,
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

end