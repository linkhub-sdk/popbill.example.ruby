################################################################################
#
# 팝빌 팩스 API Ruby SDK Rails Example
# Rails 연동 튜토리얼 안내 : https://developers.popbill.com/guide/fax/ruby/getting-started/tutorial
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
# 3) 발신번호 사전등록을 합니다. (등록방법은 사이트/API 두가지 방식이 있습니다.)
#    - 1. 팝빌 사이트 로그인 > [문자/팩스] > [팩스] > [발신번호 사전등록] 메뉴에서 등록
#    - 2. getSenderNumberMgtURL API를 통해 반환된 URL을 이용하여 발신번호 등록
#
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

  # 연동환경 설정, true-테스트, false-운영(Production), (기본값:true)
  FAXService.setIsTest(true)

  # 인증토큰 IP 검증 설정, true-사용, false-미사용, (기본값:true)
  FAXService.setIpRestrictOnOff(true)

  # 통신 IP 고정, true-사용, false-미사용, (기본값:false)
  FAXService.setUseStaticIP(false)

  # 로컬시스템 시간 사용여부, true-사용, false-미사용, (기본값:true)
  FAXService.setUseLocalTimeYN(true)

  ##############################################################################
  # 발신번호 관리 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/sendnum#GetSenderNumberMgtURL
  ##############################################################################
  def getSenderNumberMgtURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getSenderNumberMgtURL(
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
  # 팝빌에 등록된 팩스 발신번호 목록을 반환합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/sendnum#GetSenderNumberList
  ##############################################################################
  def getSenderNumberList

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    begin
      @Response = FaxController::FAXService.getSenderNumberList(
          corpNum,
      )
      render "fax/getSenderNumberList"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스를 전송합니다. (전송할 파일 개수는 최대 20개까지 가능)
  # - https://developers.popbill.com/reference/fax/ruby/api/send#SendFAX
  ##############################################################################
  def sendFax

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 발신번호
    sender = "07043042992"

    # 발신자명
    senderName = "발신자명"

    # 수신번호
    receiver = "070111222"

    # 수신자명
    receiverName = "수신자명"

    # 파일경로 배열, 최대 전송 파일개수 20개
    filePath = ["/Users/John/Desktop/test.jpg"]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고팩스 전송여부
    adsYN = false

    # 팩스제목
    title = "팩스전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.sendFax(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          filePath,
          reserveDT,
          userID,
          adsYN,
          title,
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
  # [대량전송] 팩스를 전송합니다. (전송할 파일 개수는 최대 20개까지 가능)
  # - https://developers.popbill.com/reference/fax/ruby/api/send#SendFAX_multi
  ##############################################################################
  def sendFax_Multi

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 발신번호
    sender = "07043042991"

    # 발신자명
    senderName = "발신자명"

    # 수신자 정보 배열, 최대 1000건
    receivers = [
        {
            "rcv" => "070111222", # 수신번호
            "rcvnm" => "수신자명", # 수신자명
        },
        {
            "rcv" => "070111222", # 수신번호
            "rcvnm" => "수신자명", # 수신자명
        },
    ]

    # 파일경로 배열, 최대 전송 파일개수 20개
    filePath = ["/Users/John/Desktop/test.jpg"]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고팩스 전송여부
    adsYN = false

    # 팩스제목
    title = "팩스 동보전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.sendFax_multi(
          corpNum,
          sender,
          senderName,
          receivers,
          filePath,
          reserveDT,
          userID,
          adsYN,
          title,
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
  # 파일의 바이너리 데이터를 팩스 전송하기 위해 팝빌에 접수합니다. (최대 전송파일 개수 : 20개)
  # - https://developers.popbill.com/reference/fax/ruby/api/send#SendFAXBinary
  ##############################################################################
  def sendFaxBinary

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 발신번호
    sender = "07043042992"

    # 발신자명
    senderName = "발신자명"

    # 수신번호
    receiver = "070111222"

    # 수신자명
    receiverName = "수신자명"

    # 전송파일 데이터
    file1 = File.open('./test.jpg', "rb")

    # 전송파일 정보 배열 (최대 20개)
    fileDatas = [
      {
        "fileName" => "test.jpg", #전송 파일명
        "fileData" => file1.read, #전송 파일 바이너리 데이터
      },
    ]

    file1.close

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고팩스 전송여부
    adsYN = false

    # 팩스제목
    title = "팩스전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.sendFaxBinary(
          corpNum,
          sender,
          senderName,
          receiver,
          receiverName,
          fileDatas,
          reserveDT,
          userID,
          adsYN,
          title,
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
  # 동일한 파일의 바이너리 데이터를 다수의 수신자에게 전송하기 위해 팝빌에 접수합니다. (최대 전송파일 개수 : 20개) (최대 1,000건)
  # - https://developers.popbill.com/reference/fax/ruby/api/send#SendFAXBinary_multi
  ##############################################################################
  def sendFaxBinary_Multi

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 발신번호
    sender = "07043042992"

    # 발신자명
    senderName = "발신자명"

    # 전송파일 데이터
    file1 = File.open('./test.jpg', "rb")

    # 전송파일 정보 배열 (최대 20개)
    fileDatas = [
      {
        "fileName" => "test.jpg", #전송 파일명
        "fileData" => file1.read, #전송 파일 바이너리 데이터
      },
    ]

    # 수신자 정보 배열 (최대 1000개)
    receivers = [
        {
            "rcv" => '070111222', # 수신번호
            "rcvnm" => '수신자명1' # 수신자명
        },
        {
            "rcv" => '070111333', # 수신번호
            "rcvnm" => '수신자명2' # 수신자명
        }
    ]

    file1.close

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 광고팩스 전송여부
    adsYN = false

    # 팩스제목
    title = "팩스전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.sendFaxBinary_multi(
          corpNum,
          sender,
          senderName,
          receivers,
          fileDatas,
          reserveDT,
          userID,
          adsYN,
          title,
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
  # 팩스를 재전송합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/send#ResendFAX
  ##############################################################################
  def resendFax

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 팩스 접수번호
    receiptNum = "018062517381000001"

    # 발신번호, 공백처리시 기존전송정보로 전송
    sender = "07043042991"

    # 발신자명, 공백처리시 기존전송정보로 전송
    senderName = "발신자명"

    # 수신번호/수신자명 모두 공백처리시 기존전송정보로 전송
    # 수신번호
    receiver = ""

    # 수신자명
    receiverName = ""

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 팩스제목
    title = "팩스 재전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.resendFax(
          corpNum,
          receiptNum,
          sender,
          senderName,
          receiver,
          receiverName,
          reserveDT,
          userID,
          title,
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
  # 전송요청번호(requestNum)을 할당한 팩스를 재전송합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/send#ResendFAXRN
  ##############################################################################
  def resendFAXRN

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 원본 팩스 전송요청번호
    orgRequestNum = " 20220101-001"

    # 발신번호, 공백처리시 기존전송정보로 전송
    sender = "07043042991"

    # 발신자명, 공백처리시 기존전송정보로 전송
    senderName = "발신자명"

    # 수신번호/수신자명 모두 공백처리시 기존전송정보로 전송
    # 수신번호
    receiver = ""

    # 수신자명
    receiverName = ""

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 팩스제목
    title = "팩스 재전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.resendFAXRN(
          corpNum,
          orgRequestNum,
          sender,
          senderName,
          receiver,
          receiverName,
          reserveDT,
          userID,
          title,
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
  # [대량전송] 팩스를 재전송합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/send#ResendFAX_multi
  ##############################################################################
  def resendFax_Multi

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 팩스 접수번호
    receiptNum = "018120517165400001"

    # 발신번호, 공백처리시 기존전송정보로 전송
    sender = "07043042991"

    # 발신자명, 공백처리시 기존전송정보로 전송
    senderName = "발신자명"

    # 수신자 정보 배열, 기존전송정보와 재전송할 수신정보가 동일한 경우 nil 처리
    receivers = nil

    # 기존전송정보와 재전송할 수신정보가 다를 경우 아래의 코드 참조
    # 수신자 정보 배열, 최대 1000건
    # receivers = [
    #   {
    #     "rcv" => "010111222",   # 수신번호
    #     "rcvnm" => "수신자명",    # 수신자명
    #   },
    #   {
    #     "rcv" => "010111222",   # 수신번호
    #     "rcvnm" => "수신자명",   # 수신자명
    #   },
    # ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 팩스제목
    title = "팩스 동보 재전송제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.resendFax_multi(
          corpNum,
          receiptNum,
          sender,
          senderName,
          receivers,
          reserveDT,
          userID,
          title,
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
  # [대량전송] 전송요청번호(requestNum)을 할당한 팩스를 재전송합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/send#ResendFAXRN_multi
  ##############################################################################
  def resendFAXRN_multi

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 원본 팩스 전송요청번호
    orgReceiptNum = " 20220101-01"

    # 발신번호, 공백처리시 기존전송정보로 전송
    sender = "07043042991"

    # 발신자명, 공백처리시 기존전송정보로 전송
    senderName = "발신자명"

    # 수신자 정보 배열, 기존전송정보와 재전송할 수신정보가 동일한 경우 nil 처리
    receivers = nil

    # 기존전송정보와 재전송할 수신정보가 다를 경우 아래의 코드 참조
    # 수신자 정보 배열, 최대 1000건
    # receivers = [
    #   {
    #     "rcv" => "010111222",   # 수신번호
    #     "rcvnm" => "수신자명",    # 수신자명
    #   },
    #   {
    #     "rcv" => "010111222",   # 수신번호
    #     "rcvnm" => "수신자명",   # 수신자명
    #   },
    # ]

    # 예약전송일시(yyyyMMddHHmmss), 미기재시 즉시전송
    reserveDT = ""

    # 팩스제목
    title = "팩스 재전송 제목"

    # 전송요청번호, 파트너가 전송요청에 대한 관리번호를 직접 할당하여 관리하는 경우 기재
    # 최대 36자리, 영문, 숫자, 언더바('_'), 하이픈('-')을 조합하여 사업자별로 중복되지 않도록 구성
    requestNum = ''

    begin
      @value = FaxController::FAXService.resendFAXRN_multi(
          corpNum,
          orgReceiptNum,
          sender,
          senderName,
          receivers,
          reserveDT,
          userID,
          title,
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
  # 팩스전송요청시 발급받은 접수번호(receiptNum)로 팩스 예약전송건을 취소합니다.
  # - 예약전송 취소는 예약전송시간 10분전까지 가능합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/send#CancelReserve
  ##############################################################################
  def cancelReserve

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 접수번호
    receiptNum = "018120517184000001"

    begin
      @Response = FaxController::FAXService.cancelReserve(corpNum, receiptNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스전송요청시 할당한 전송요청번호(requestNum)로 팩스 예약전송건을 취소합니다.
  # - 예약전송 취소는 예약전송시간 10분전까지 가능합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/send#CancelReserveRN
  ##############################################################################
  def cancelReserveRN

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송시 할당한 전송요청번호
    requestNum = " 20220101-01"

    begin
      @Response = FaxController::FAXService.cancelReserveRN(corpNum, requestNum)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스 전송요청시 반환받은 접수번호(receiptNum)을 사용하여 팩스전송 결과를 확인합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/info#GetFaxResult
  ##############################################################################
  def getFaxDetail

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 접수번호
    receiptNum = "022010414311800001"

    begin
      @Response = FaxController::FAXService.getFaxDetail(corpNum, receiptNum)
      render "fax/getFaxDetail"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스전송요청시 할당한 요청번호(requestNum)로 전송결과를 확인합니다
    # - https://developers.popbill.com/reference/fax/ruby/api/info#GetFaxResultRN
  ##############################################################################
  def getFaxDetailRN

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송시 할당한 전송요청번호
    requestNum = "20220104_FAX003"

    begin
      @Response = FaxController::FAXService.getFaxDetailRN(corpNum, requestNum)
      render "fax/getFaxDetail"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 팩스전송 내역을 조회합니다. (조회기간 단위 : 최대 2개월)
  # - 팩스 접수일시로부터 2개월 이내 접수건만 조회할 수 있습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/info#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 사업자번호
    userID = FaxController::TestUserID

    # [필수] 시작일자, 형식(yyyyMMdd)
    sDate = "20220101"

    # [필수] 종료일자, 형식(yyyyMMdd)
    eDate = "20220110"

    # 전송상태 배열, 1(대기), 2(성공), 3(실패), 4(취소)
    state = [1, 2, 3, 4]

    # 예약전송 검색여부, "1"-예약전송건 조회, "0"-예약전송 아닌건만 조회, ""-전체조회
    reserveYN = ""

    # 개인조회 여부, "1"-개인조회, "0"-회사조회, ""-전체조회
    senderYN = ""

    # 페이지 번호
    page = 1

    # 페이지당 목록갯수
    perPage = 10

    # 정렬방향, D-내림차순, A-오름차순
    order = "D"

    # 조회 검색어, 팩스 전송시 기재한 수신자명 또는 발신자명 기재
    qString = ""

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
          userID,
          qString,
      )
      render "fax/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스 전송내역 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/info#GetSentListURL
  ##############################################################################
  def getSentListURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getSentListURL(
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
  # 팩스 미리보기 팝업 URL을 반환합니다.
  # - 팩스 미리보기는 변환완료후 가능합니다
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/info#GetPreviewURL
  ##############################################################################
  def getPreviewURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스 접수번호
    receiptNum = "018092922570100001"

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getPreviewURL(
          corpNum,
          receiptNum,
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
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetBalance
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
  # 팝빌 연동회원 포인트 충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getChargeURL(
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
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getPaymentURL(
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
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getUseHistoryURL(
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
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetPartnerBalance
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
  # 파트너 포인트충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = FaxController::FAXService.getPartnerURL(
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
  # 연동회원의 팩스 API 서비스 과금정보를 확인합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetChargeInfo
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
  # 팩스 전송단가를 확인합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/point#GetUnitCost
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

  ##############################################################################
  # 사업자번호를 조회하여 연동회원 가입여부를 확인합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/member#CheckIsMember
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
  # - https://developers.popbill.com/reference/fax/ruby/api/member#CheckID
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
  # - https://developers.popbill.com/reference/fax/ruby/api/member#JoinMember
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
      @Response = FaxController::FAXService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/member#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    begin
      @value = FaxController::FAXService.getAccessURL(
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
  # - https://developers.popbill.com/reference/fax/ruby/api/member#GetCorpInfo
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
  # - https://developers.popbill.com/reference/fax/ruby/api/member#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

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

  ##############################################################################
  # 연동회원의 담당자를 신규로 등록합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/member#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디 (6자 이상 50자 미만)
        "id" => "testkorea 20220101",

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
  # 연동회원 사업자번호에 등록된 담당자(팝빌 로그인 계정) 정보를 확인합니다.
  # - https://developers.popbill.com/reference/fax/ruby/api/member#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = FaxController::FAXService.getContactInfo(
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
  # - https://developers.popbill.com/reference/fax/ruby/api/member#ListContact
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
  # - https://developers.popbill.com/reference/fax/ruby/api/member#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID


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

end
