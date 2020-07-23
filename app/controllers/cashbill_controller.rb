################################################################################
#
# 팝빌 현금영수증 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2020-07-23
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 20, 23번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
#
################################################################################

require 'popbill/cashbill'

class CashbillController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 현금영수증 Service API 초기화
  CBService = CashbillService.instance(
      CashbillController::LinkID,
      CashbillController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  CBService.setIsTest(true)

  # 인증토큰 IP제한기능 사용여부, true-권장
  CBService.setIpRestrictOnOff(true)

  # 팝빌 API 서비스 고정 IP 사용여부(GA), true-사용, false-미사용, 기본값(false)
  CBService.setUseStaticIP(false)

  ##############################################################################
  # 현금영수증 문서번호 중복여부를 확인합니다.
  # - 문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#CheckMgtKeyInUse
  ##############################################################################
  def checkMgtKeyInUse

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호, 최대 24자리로 숫자, 영문 '-', '_' 조합하여 구성
    mgtKey = "20190403-01"

    begin
      @response = CashbillController::CBService.checkMgtKeyInUse(
          corpNum,
          mgtKey,
      )

      if @response
        @value = "사용중"
      else
        @value = "미사용중"
      end

      @name = "문서번호 사용여부 확인"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증을 즉시발행합니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청 전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#RegistIssue
  ##############################################################################
  def registIssue

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 현금영수증 문서번호 (문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.)
    mgtKey = "20191031-04"

    # 메모
    memo = "메모"

    # 안내메일 제목, 미기재시 기본양식으로 전송.
    emailSubject = ""

    # 현금영수증 정보
    cashbill = {

        # [필수] 문서번호
        "mgtKey" => mgtKey,

        # [필수] 문서형태
        "tradeType" => "승인거래",

        # [필수] 거래구분, {소득공제용, 지출증빙용} 중 기재
        "tradeUsage" => "소득공제용",

        # [필수] 거래유형, {일반, 도서공연, 대중교통} 중 기재
        "tradeOpt" => "일반",

        # [필수] 식별번호
        # 거래구분(tradeUsage) - '소득공제용' 인 경우 주민등록/휴대폰/카드번호 기재 가능
        # 거래구분(tradeUsage) - '지출증빙용' 인 경우 사업자번호/주민등록/휴대폰/카드번호 기재 가능
        "identityNum" => "0100001234",

        # [필수] 과세형태, {과세, 비과세} 중 기재
        "taxationType" => "과세",

        # [필수] 공급가액
        "supplyCost" => "10000",

        # [필수] 부가세
        "tax" => "1000",

        # [필수] 봉사료
        "serviceFee" => "0",

        # [필수] 거래금액
        "totalAmount" => "11000",

        # [필수] 가맹점 사업자번호
        "franchiseCorpNum" => corpNum,

        # 가맹점 상호
        "franchiseCorpName" => "가맹점 상호",

        # 가맹점 대표자 성명
        "franchiseCEOName" => "가맹점 대표자 성명",

        # 가맹점 주소
        "franchiseAddr" => "가맹점 주소",

        # 가맹점 연락처
        "franchiseTEL" => "가맹점 연락처",

        # 고객명
        "customerName" => "고객명",

        # 상품명
        "itemName" => "상품명",

        # 가맹점 주문번호
        "orderNumber" => "가맹점 주문번호",

        # 거래처 이메일
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "email" => "code@linkhub.co.kr",

        # 거래처 휴대폰
        "hp" => "010-111-222",

        # 발행안내문자 전송여부
        "smssendYN" => false,
    } # end of cashbill hash

    begin
      @Response = CashbillController::CBService.registIssue(
          corpNum,
          cashbill,
          memo,
          userID,
          emailSubject,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증을 임시저장 합니다.
  # - [임시저장] 상태의 현금영수증은 발행(Issue API)을 호출해야만 국세청에 전송됩니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청 전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#Register
  ##############################################################################
  def register

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 (문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.)
    mgtKey = "20190403-03"

    # 현금영수증 정보
    cashbill = {

        # [필수] 문서번호
        "mgtKey" => mgtKey,

        # [필수] 문서형태
        "tradeType" => "승인거래",

        # [필수] 거래구분, {소득공제용, 지출증빙용} 중 기재
        "tradeUsage" => "소득공제용",

        # [필수] 거래유형, {일반, 도서공연, 대중교통} 중 기재
        "tradeOpt" => "일반",

        # [필수] 식별번호
        # 거래구분(tradeUsage) - '소득공제용' 인 경우 주민등록/휴대폰/카드번호 기재 가능
        # 거래구분(tradeUsage) - '지출증빙용' 인 경우 사업자번호/주민등록/휴대폰/카드번호 기재 가능
        "identityNum" => "0101112222",

        # [필수] 과세형태, {과세, 비과세} 중 기재
        "taxationType" => "과세",

        # [필수] 공급가액
        "supplyCost" => "20000",

        # [필수] 부가세
        "tax" => "2000",

        # [필수] 봉사료
        "serviceFee" => "0",

        # [필수] 거래금액
        "totalAmount" => "22000",

        # [필수] 가맹점 사업자번호
        "franchiseCorpNum" => corpNum,

        # 가맹점 상호
        "franchiseCorpName" => "가맹점 상호",

        # 가맹점 대표자 성명
        "franchiseCEOName" => "가맹점 대표자 성명",

        # 가맹점 주소
        "franchiseAddr" => "가맹점 주소",

        # 가맹점 연락처
        "franchiseTEL" => "가맹점 연락처",

        # 고객명
        "customerName" => "고객명",

        # 상품명
        "itemName" => "상품명",

        # 가맹점 주문번호
        "orderNumber" => "가맹점 주문번호",

        # 거래처 이메일
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "email" => "test@test.com",

        # 거래처 휴대폰
        "hp" => "010-111-222",

        # 발행안내문자 전송여부
        "smssendYN" => false,
    }

    begin
      @Response = CashbillController::CBService.register(
          corpNum,
          cashbill,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증을 수정합니다.
  # - [임시저장] 상태의 현금영수증만 수정할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#Update
  ##############################################################################
  def update

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-03"

    # 현금영수증 정보
    cashbill = {

        # [필수] 문서번호
        "mgtKey" => mgtKey,

        # [필수] 문서형태
        "tradeType" => "승인거래",

        # [필수] 거래구분, {소득공제용, 지출증빙용} 중 기재
        "tradeUsage" => "소득공제용",

        # [필수] 거래유형, {일반, 도서공연, 대중교통} 중 기재
        "tradeOpt" => "일반",

        # [필수] 식별번호
        # 거래구분(tradeUsage) - '소득공제용' 인 경우 주민등록/휴대폰/카드번호 기재 가능
        # 거래구분(tradeUsage) - '지출증빙용' 인 경우 사업자번호/주민등록/휴대폰/카드번호 기재 가능
        "identityNum" => "0101112222",

        # [취소거래시 필수] 원본 현금영수증 국세청승인번호
        "orgConfirmNum" => "",

        # [필수] 과세형태, {과세, 비과세} 중 기재
        "taxationType" => "과세",

        # [필수] 공급가액
        "supplyCost" => "20000",

        # [필수] 부가세
        "tax" => "2000",

        # [필수] 봉사료
        "serviceFee" => "0",

        # [필수] 거래금액
        "totalAmount" => "22000",

        # [필수] 가맹점 사업자번호
        "franchiseCorpNum" => corpNum,

        # 가맹점 상호
        "franchiseCorpName" => "가맹점 상호",

        # 가맹점 대표자 성명
        "franchiseCEOName" => "가맹점 대표자 성명",

        # 가맹점 주소
        "franchiseAddr" => "가맹점 주소",

        # 가맹점 연락처
        "franchiseTEL" => "가맹점 연락처",

        # 고객명
        "customerName" => "고객명",

        # 상품명
        "itemName" => "상품명",

        # 가맹점 주문번호
        "orderNumber" => "가맹점 주문번호",

        # 거래처 이메일
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "email" => "test@test.com",

        # 거래처 휴대폰
        "hp" => "010-111-222",

        # 발행안내문자 전송여부
        "smssendYN" => false,
    }

    begin
      @Response = CashbillController::CBService.update(
          corpNum,
          mgtKey,
          cashbill,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 임시저장 현금영수증을 발행처리합니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청
  #   전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#CBIssue
  ##############################################################################
  def issue

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-03"

    begin
      @Response = CashbillController::CBService.issue(
          corpNum,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # [발행완료] 상태의 현금영수증을 [발행취소] 합니다.
  # - 발행취소는 국세청 전송전에만 가능합니다.
  # - 발행취소된 형금영수증은 국세청에 전송되지 않습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#CancelIssue
  ##############################################################################
  def cancelIssue

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-03"

    begin
      @Response = CashbillController::CBService.cancelIssue(
          corpNum,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증을 삭제합니다.
  # - 현금영수증을 삭제하면 사용된 문서번호(mgtKey)를 재사용할 수 있습니다.
  # - 삭제가능한 문서 상태 : [임시저장], [발행취소]
  # - https://docs.popbill.com/cashbill/ruby/api#Delete
  ##############################################################################
  def delete

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-03"

    begin
      @Response = CashbillController::CBService.delete(
          corpNum,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 취소현금영수증을 즉시발행합니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청 전송결과를
  #   확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#RevokeRegistIssue
  ##############################################################################
  def revokeRegistIssue

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 (문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.)
    mgtKey = "20190403-08"

    # [취소거래시 필수] 원본 현금영수증 국세청승인번호
    orgConfirmNum = "569090041"

    # [취소거래시 필수] 원본 현금영수증 거래일자
    orgTradeDate = "20190327"

    begin
      @Response = CashbillController::CBService.revokeRegistIssue(
          corpNum,
          mgtKey,
          orgConfirmNum,
          orgTradeDate,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 (부분) 취소현금영수증을 즉시발행합니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청 전송결과를
  #   확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#RevokeRegistIssue
  ##############################################################################
  def revokeRegistIssue_part

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 현금영수증 문서번호, 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성
    mgtKey = "20190403-09"

    # 원본 현금영수증 국세청승인번호
    orgConfirmNum = "569090041"

    # 원본 현금영수증 거래일자
    orgTradeDate = "20190327"

    # 안내문자 전송여부
    smssendYN = false

    # 메모
    memo = "부분 취소현금영수증 메모"

    # 부분취소 여부, true-부분취소, false-전체취소
    isPartCancel = true

    # 취소사유, 1-거래취소, 2-오류발급취소, 3-기타
    cancelType = 1

    # [취소] 공급가액
    supplyCost = "9000"

    # [취소] 부가세
    tax = "900"

    # [취소] 봉사료
    serviceFee = "0"

    # [취소] 합계금액
    totalAmount = "9900"

    begin
      @Response = CashbillController::CBService.revokeRegistIssue(
          corpNum,
          mgtKey,
          orgConfirmNum,
          orgTradeDate,
          smssendYN,
          memo,
          userID,
          isPartCancel,
          cancelType,
          supplyCost,
          tax,
          serviceFee,
          totalAmount,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 취소현금영수증을 임시저장 합니다.
  # - [임시저장] 상태의 현금영수증은 발행(Issue API)을 호출해야만 국세청에 전송됩니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청 전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#RevokeRegister
  ##############################################################################
  def revokeRegister

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호, 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성
    mgtKey = "20190403-10"

    # [취소거래시 필수] 원본 현금영수증 국세청승인번호
    orgConfirmNum = "569090041"

    # [취소거래시 필수] 원본 현금영수증 거래일자
    orgTradeDate = "20190327"

    begin
      @Response = CashbillController::CBService.revokeRegister(
          corpNum,
          mgtKey,
          orgConfirmNum,
          orgTradeDate,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 (부분)취소현금영수증을 임시저장 합니다.
  # - [임시저장] 상태의 현금영수증은 발행(Issue API)을 호출해야만 국세청에 전송됩니다.
  # - 발행일 기준 오후 5시 이전에 발행된 현금영수증은 다음날 오후 2시에 국세청 전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#RevokeRegister
  ##############################################################################
  def revokeRegister_part

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 현금영수증 문서번호 (문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.)
    mgtKey = "20190403-11"

    # 원본 현금영수증 국세청승인번호
    orgConfirmNum = "569090041"

    # 원본 현금영수증 거래일자
    orgTradeDate = "20190327"

    # 안내문자 전송여부
    smssendYN = false

    # 부분취소 여부, true-부분취소, false-전체취소
    isPartCancel = true

    # 취소사유, 1-거래취소, 2-오류발급취소, 3-기타
    cancelType = 1

    # [취소] 공급가액
    supplyCost = "9000"

    # [취소] 부가세
    tax = "900"

    # [취소] 봉사료
    serviceFee = "0"

    # [취소] 합계금액
    totalAmount = "9900"

    begin
      @Response = CashbillController::CBService.revokeRegister(
          corpNum,
          mgtKey,
          orgConfirmNum,
          orgTradeDate,
          smssendYN,
          userID,
          isPartCancel,
          cancelType,
          supplyCost,
          tax,
          serviceFee,
          totalAmount,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증 상태/요약 정보를 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetInfo
  ##############################################################################
  def getInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    begin
      @Response = CashbillController::CBService.getInfo(
          corpNum,
          mgtKey,
      )
      render "cashbill/getInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 다수건의 현금영수증 상태/요약 정보를 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetInfos
  ##############################################################################
  def getInfos

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 배열, 최대 1000건
    mgtKeyList = Array.new
    mgtKeyList.push("20190403-01")
    mgtKeyList.push("20190403-06")
    mgtKeyList.push("20190403-07")
    mgtKeyList.push("20190403-08")
    mgtKeyList.push("20190403-09")
    mgtKeyList.push("20190403-10")

    begin
      @Response = CashbillController::CBService.getInfos(
          corpNum,
          mgtKeyList,
      )
      render "cashbill/getInfos"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 1건의 상세정보를 조회합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetDetailInfo
  ##############################################################################
  def getDetailInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-06"

    begin
      @Response = CashbillController::CBService.getDetailInfo(
          corpNum,
          mgtKey,
      )
      render "cashbill/cashbill"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 현금영수증 목록을 조회합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # [필수] 일자유형, R-등록일자, T-거래일자 I-발행일시
    dType = "R"

    # [필수] 시작일자, 날짜형식(yyyyMMdd)
    sDate = "20190101"

    # [필수] 종료일자, 날짜형식(yyyyMMdd)
    eDate = "20190121"

    # 전송상태코드 배열, 미기재시 전체조회, 2,3번째 자리 와일드카드(*) 가능
    # [참조] 현금영수증 API 연동매뉴열 "5.1. 현금영수증 상태코드"
    state = ["1**", "3**"]

    # 문서형태 배열, N-일반 현금영수증, C-취소 현금영수증
    tradeType = ["N", "C"]

    # 거래구분 배열, P-소득공제용, C-지출증빙용
    tradeUsage = ["P", "C"]

    # 과세형태 배열, T-과세, N-비과세
    taxationType = ["T", "N"]

    # 페이지 번호, 기본값 1
    page = 1

    # 페이지당 목록갯수, 기본값 500
    perPage = 10

    # 정렬방향 D-내림차순(기본값), A-오름차순
    order = "D"

    # 거래처 조회, 거래처 상호 또는 거래처 사업자등록번호 조회, 공백처리시 전체조회
    queryString = ""

    # 거래유형 배열, N-일반, B-도서공연, T-대중교통
    tradeOpt = ["N", "B", "T"]

    begin
      @Response = CashbillController::CBService.search(
          corpNum,
          dType,
          sDate,
          eDate,
          state,
          tradeType,
          tradeUsage,
          taxationType,
          page,
          perPage,
          order,
          queryString,
          userID,
          tradeOpt
      )
      render "cashbill/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 상태 변경이력을 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetLogs
  ##############################################################################
  def getLogs

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-09"

    begin
      @Response = CashbillController::CBService.getLogs(
          corpNum,
          mgtKey,
      )
      render "cashbill/cashbillLogs"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌 현금영수증 문서함 관련 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetURL
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # TBOX(임시문서함), PBOX(발행문서함), WRITE(현금영수증 작성)
    togo = "WRITE"

    begin
      @value = CashbillController::CBService.getURL(
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
  # 1건의 현금영수증 보기 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetPopUpURL
  ##############################################################################
  def getPopUpURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    begin
      @value = CashbillController::CBService.getPopUpURL(
          corpNum,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 현금영수증 PDF 다운로드 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getPDFURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20200722-01"

    begin
      @value = CashbillController::CBService.getPDFURL(
          corpNum,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 1건의 현금영수증 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetPrintURL
  ##############################################################################
  def getPrintURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    begin
      @value = CashbillController::CBService.getPrintURL(
          corpNum,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 인쇄(공급받는자) URL을 반환합니다.
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetPrintURL
  ##############################################################################
  def getEPrintURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    begin
      @value = CashbillController::CBService.getEPrintURL(
          corpNum,
          mgtKey,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 다수건의 현금영수증 인쇄팝업 URL을 반환합니다. (최대 100건)
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetMassPrintURL
  ##############################################################################
  def getMassPrintURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호 배열, 최대 100건
    mgtKeyList = Array.new
    mgtKeyList.push("20190403-06")
    mgtKeyList.push("20190403-07")
    mgtKeyList.push("20190403-08")

    begin
      @value = CashbillController::CBService.getMassPrintURL(
          corpNum,
          mgtKeyList,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 수신메일 링크주소 URL을 반환합니다.
  # - URL 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetMailURL
  ##############################################################################
  def getMailURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-06"

    begin
      @value = CashbillController::CBService.getMailURL(
          corpNum,
          mgtKey,
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
  # - https://docs.popbill.com/cashbill/ruby/api#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @value = CashbillController::CBService.getAccessURL(
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
  # 발행 안내메일을 재전송합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#SendEmail
  ##############################################################################
  def sendEmail

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    # 이메일 주소
    # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
    # 실제 거래처의 메일주소가 기재되지 않도록 주의
    emailAddr = "test@test.com"

    begin
      @Response = CashbillController::CBService.sendEmail(
          corpNum,
          mgtKey,
          emailAddr,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 알림문자를 전송합니다. (단문/SMS- 한글 최대 45자)
  # - 알림문자 전송시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [문자] > [전송내역] 탭에서 전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#SendSMS
  ##############################################################################
  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    # 발신번호
    sendNum = "07043042991"

    # 수신번호
    receiveNum = "010-111-222"

    # 문자메시지 내용, 90Byte 초과된 내용은 삭제되어 전송됨
    contents = "문자메시지 전송을 확인합니다."

    begin
      @Response = CashbillController::CBService.sendSMS(
          corpNum,
          mgtKey,
          sendNum,
          receiveNum,
          contents,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증을 팩스전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역] 메뉴에서
  #   전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/cashbill/ruby/api#SendFAX
  ##############################################################################
  def sendFAX

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 현금영수증 문서번호
    mgtKey = "20190403-11"

    # 발신번호
    sendNum = "07043042991"

    # 수신팩스번호
    receiveNum = "070111222"

    begin
      @Response = CashbillController::CBService.sendFax(
          corpNum,
          mgtKey,
          sendNum,
          receiveNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 메일전송 항목에 대한 전송여부를 목록으로 반환한다.
  # - https://docs.popbill.com/cashbill/ruby/api#ListEmailConfig
  ##############################################################################
  def listEmailConfig

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @Response = CashbillController::CBService.listEmailConfig(
          corpNum,
          userID,
      )
      render "cashbill/listEmailConfig"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 현금영수증 메일전송 항목에 대한 전송여부를 수정한다.
  # 메일전송유형
  # CSH_ISSUE : 고객에게 현금영수증이 발행 되었음을 알려주는 메일 입니다.
  # CSH_CANCEL : 고객에게 현금영수증 발행취소 되었음을 알려주는 메일 입니다.
  # - https://docs.popbill.com/cashbill/ruby/api#UpdateEmailConfig
  ##############################################################################
  def updateEmailConfig

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    # 메일 전송 유형
    emailType = "CSH_ISSUE"

    # 메일 전송 여부 (true-전송, false-미전송)
    sendYN = true

    begin
      @Response = CashbillController::CBService.updateEmailConfig(
          corpNum,
          emailType,
          sendYN,
          userID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetBalance
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @value = CashbillController::CBService.getBalance(corpNum)
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
  # - https://docs.popbill.com/cashbill/ruby/api#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

    begin
      @value = CashbillController::CBService.getChargeURL(
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
  # - https://docs.popbill.com/cashbill/ruby/api#GetPartnerBalance
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @value = CashbillController::CBService.getPartnerBalance(corpNum)
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
  # - https://docs.popbill.com/cashbill/ruby/api#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = CashbillController::CBService.getPartnerURL(
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
  # 현금영수증 발행단가를 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetUnitCost
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @value = CashbillController::CBService.getUnitCost(
          corpNum,
      )
      @name = "unitCost(발행단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 현금영수증 API 서비스 과금정보를 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetChargeInfo
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @Response = CashbillController::CBService.getChargeInfo(corpNum)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#CheckIsMember
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 파트너 링크아이디
    linkID = CashbillController::LinkID

    begin
      @Response = CashbillController::CBService.checkIsMember(
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
  # - https://docs.popbill.com/cashbill/ruby/api#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = CashbillController::CBService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#JoinMember
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
      @Response = CashbillController::CBService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#GetCorpInfo
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @Response = CashbillController::CBService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다
  # - https://docs.popbill.com/cashbill/ruby/api#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

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
      @Response = CashbillController::CBService.updateCorpInfo(
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
  # - https://docs.popbill.com/cashbill/ruby/api#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

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
      @Response = CashbillController::CBService.registContact(
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
  # - https://docs.popbill.com/cashbill/ruby/api#ListContact
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    begin
      @Response = CashbillController::CBService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 담당자 정보를 수정합니다.
  # - https://docs.popbill.com/cashbill/ruby/api#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = CashbillController::TestCorpNum

    # 팝빌회원 아이디
    userID = CashbillController::TestUserID

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
      @Response = CashbillController::CBService.updateContact(
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
