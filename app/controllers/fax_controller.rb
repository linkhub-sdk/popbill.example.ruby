################################################################################
# 팜빌 팩스 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2019-01-20
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991
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
  # 발신번호 관리 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
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
  # - 팩스전송 문서 파일포맷 안내 : http://blog.linkhub.co.kr/2561
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
    filePath = ["/Users/kimhyunjin/SDK/popbill.example.ruby/test.pdf"]

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
  #   # - 팩스전송 문서 파일포맷 안내 : http://blog.linkhub.co.kr/2561
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
    filePath = ["/Users/kimhyunjin/SDK/popbill.example.ruby/test.pdf"]

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
  # 팩스를 재전송합니다.
  # - 접수일로부터 60일이 경과된 경우 재전송할 수 없습니다.
  # - 팩스 재전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
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
  # - 접수일로부터 60일이 경과된 경우 재전송할 수 없습니다.
  # - 팩스 재전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  ##############################################################################
  def resendFAXRN

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 원본 팩스 전송요청번호
    orgRequestNum = "20190121-001"

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
  # - 접수일로부터 60일이 경과된 경우 재전송할 수 없습니다.
  # - 팩스 재전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
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
  # - 접수일로부터 60일이 경과된 경우 재전송할 수 없습니다.
  # - 팩스 재전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  ##############################################################################
  def resendFAXRN_multi

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 아이디
    userID = FaxController::TestUserID

    # 원본 팩스 전송요청번호
    orgReceiptNum = "20190121-01"

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
  ##############################################################################
  def cancelReserveRN

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 전송요청번호
    requestNum = "20190121-01"

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
  # - 응답항목에 대한 자세한 사항은 "[팩스 API 연동매뉴얼] >  3.3.1 GetFaxDetail (전송내역 및 전송상태 확인)을 참조하시기 바랍니다.
  ##############################################################################
  def getFaxDetail

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 접수번호
    receiptNum = "018112714511700001"

    begin
      @Response = FaxController::FAXService.getFaxDetail(corpNum, receiptNum)
      render "fax/getFaxDetail"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팩스전송요청시 할당한 전송요청번호(requestNum)으로 전송결과를 확인합니다
  # - 응답항목에 대한 자세한 사항은 "[팩스 API 연동매뉴얼] >  3.3.2 GetFaxDetailRN (전송내역 및 전송상태 확인 - 요청번호 할당)을 참조하시기 바랍니다.
  ##############################################################################
  def getFaxDetailRN

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팩스전송 접수번호
    requestNum = "20180625fax"

    begin
      @Response = FaxController::FAXService.getFaxDetailRN(corpNum, requestNum)
      render "fax/getFaxDetail"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 팩스전송 내역을 조회합니다.
  # 최대 검색기간 : 6개월 이내
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 팝빌회원 사업자번호
    userID = FaxController::TestUserID

    # [필수] 시작일자, 형식(yyyyMMdd)
    sDate = "20190101"

    # [필수] 종료일자, 형식(yyyyMMdd)
    eDate = "20190121"

    # 전송상태 배열, 1(대기), 2(성공), 3(실패), 4(취소)
    state = [1, 2, 3, 4]

    # 예약전송 검색여부, 1-예약전송건 조회, 0-예약전송 아닌건만 조회, 공백-전체조회
    reserveYN = ''

    # 개인조회 여부, true-개인조회, false-회사조회
    senderYN = false

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
  # - 팩스 미리보기는 팩변환 완료후 가능합니다
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
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
  # 파트너 포인트충전 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
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
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = FaxController::TestCorpNum

    # 담당자 정보
    contactInfo = {

        # 담당자 아이디, 6자 이상 50자 미만
        "id" => "testkorea20190121",

        # 비밀번호, 6자 이상 20자 미만
        "pwd" => "user_password",

        # 담당자명 (최대 100자)
        "personName" => "코어담당자",

        # 담당자 연락처 (최대 20자)
        "tel" => "070-4304-2992",

        # 담당자 휴대폰번호 (최대 20자)
        "hp" => "010-111-222",

        # 담당자 팩스번호 (최대 20자)
        "fax" => "02-111-222",

        # 담당자 이메일 (최대 100자)
        "email" => "netcore@linkhub.co.kr",

        # 회사조회 권한여부, true(회사조회), false(개인조회)
        "searchAllAllowYN" => true,

        # 관리자 권한여부, true(관리자), false(사용자)
        "mgrYN" => false,
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
