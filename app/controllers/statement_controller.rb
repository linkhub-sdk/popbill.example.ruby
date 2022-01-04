################################################################################
#
# 팝빌 전자명세서 API Ruby On Rails SDK Example
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

require 'popbill/statement'

class StatementController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 전자명세서 API Service 초기화
  STMTService = StatementService.instance(
      StatementController::LinkID,
      StatementController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  STMTService.setIsTest(true)

  # 인증토큰 IP제한기능 사용여부, true-권장
  STMTService.setIpRestrictOnOff(true)

  # 팝빌 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  STMTService.setUseStaticIP(false)

  ##############################################################################
  # 전자명세서 문서번호 사용여부를 확인합니다.
  # - 문서번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#CheckMgtKeyInUse
  ##############################################################################
  def checkMgtKeyInUse

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-01"

    begin
      @response = StatementController::STMTService.checkMgtKeyInUse(
          corpNum,
          itemCode,
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
  # 1건의 전자명세서를 즉시발행 처리합니다.
  # - https://docs.popbill.com/statement/ruby/api#RegistIssue
  ##############################################################################
  def registIssue

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20220104-001"

    # 메모
    memo = "메모"

    # 안내메일 제목, 미기재시 기본양식으로 전송.
    emailSubject = ""

    # 전자명세서 정보
    statement = {

        # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
        "itemCode" => itemCode,

        # 맞춤양식코드, 공백처리시 기본양식으로 작성
        "formCode" => "",

        # [필수] 문서번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
        "mgtKey" => mgtKey,

        # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
        "writeDate" => "20220104",

        # [필수] 과세형태, {과세, 영세, 면세} 중 기재
        "taxType" => "과세",

        # [필수] {영수, 청구} 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # 합계금액, 공급가액 합계 + 세액 합계
        "totalAmount" => "22000",

        # 기재 상 일련번호
        "serialNum" => "",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,

        # 발행시 알림문자 전송여부
        "smssendYN" => false,

        # 비고
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",


        ######################### 발신자 정보 #########################

        # 발신자 사업자번호
        "senderCorpNum" => "1234567890",

        # 발신자 상호
        "senderCorpName" => "발신자 상호",

        # 발신자 대표자 성명
        "senderCEOName" => "발신자 대표자명",

        # 발신자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
        "senderTaxRegID" => "",

        # 발신자 주소
        "senderAddr" => "발신자 주소",

        # 발신자 종목
        "senderBizClass" => "발신자 종목",

        # 발신자 업태
        "senderBizType" => "발신자 업태",

        # 발신자 담당자 성명
        "senderContactName" => "발신자 담당자명",

        # 발신자 담당자 메일주소
        "senderEmail" => "test@test.com",

        # 발신자 담당자 연락처
        "senderTEL" => "070-4304-2991",

        # 발신자 담당자 휴대폰번호
        "senderHP" => "010-1234-1234",


        ######################### 수신자 정보 #########################

        # 수신자 사업자번호
        "receiverCorpNum" => "8888888888",

        # 수신자 상호
        "receiverCorpName" => "수신자 상호",

        # 수신자 대표자 성명
        "receiverCEOName" => "수신자 대표자 성명",

        # 수신자 주소
        "receiverAddr" => "수신자 주소",

        # 수신자 종목
        "receiverBizClass" => "종목",

        # 수신자 업태
        "receiverBizType" => "업태",

        # 수신자 담당자 성명
        "receiverContactName" => "수신자 담당자명",

        # 수신자 담당자 메일주소
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "receiverEmail" => "test@test.com",

        # 수신자 담당자 연락처
        "receiverTEL" => "070-4304-2999",

        # 수신자 담당자 휴대폰번호
        "receiverHP" => "010-4304-2991",


        ######################### 상세항목(품목) 정보 #########################
        # serialNum(일련번호) 1부터 순차기재 (배열 길이 제한 없음)
        ##################################################################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호 1부터 순차기재
                "purchaseDT" => "20220104", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20220104", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],

        ######################### 전자명세서 추가속성 #########################
        # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
        # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
        "propertyBag" => {
            "CBalance" => "15000",
            "Deposit" => "5000",
            "CBalance" => "20000",
        }
    } # end of statement Hash

    begin
      @Response = StatementController::STMTService.registIssue(
          corpNum,
          statement,
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
  # 1건의 전자명세서를 임시저장 합니다.
  # - [임시저장] 상태의 전자명세서는 Issue API(발행)를 호출해야만 수신자에게 메일로 전송됩니다.
  # - https://docs.popbill.com/statement/ruby/api#Register
  ##############################################################################
  def register

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-04"

    # 전자명세서 정보
    statement = {

        # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
        "itemCode" => itemCode,

        # 맞춤양식코드, 공백처리시 기본양식으로 작성
        "formCode" => "",

        # [필수] 문서번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
        "mgtKey" => mgtKey,

        # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
        "writeDate" => "20190917",

        # [필수] 과세형태, {과세, 영세, 면세} 중 기재
        "taxType" => "과세",

        # [필수] {영수, 청구} 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # 합계금액, 공급가액 합계 + 세액 합계
        "totalAmount" => "22000",

        # 기재 상 일련번호
        "serialNum" => "",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,

        # 발행시 알림문자 전송여부
        "smssendYN" => false,

        # 비고
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",


        ######################### 발신자 정보 #########################

        # 발신자 사업자번호
        "senderCorpNum" => "1234567890",

        # 발신자 상호
        "senderCorpName" => "발신자 상호",

        # 발신자 대표자 성명
        "senderCEOName" => "발신자 대표자명",

        # 발신자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
        "senderTaxRegID" => "",

        # 발신자 주소
        "senderAddr" => "발신자 주소",

        # 발신자 종목
        "senderBizClass" => "발신자 종목",

        # 발신자 업태
        "senderBizType" => "발신자 업태",

        # 발신자 담당자 성명
        "senderContactName" => "발신자 담당자명",

        # 발신자 담당자 메일주소
        "senderEmail" => "test@test.com",

        # 발신자 담당자 연락처
        "senderTEL" => "070-4304-2991",

        # 발신자 담당자 휴대폰번호
        "senderHP" => "010-1234-1234",


        ######################### 수신자 정보 #########################

        # 수신자 사업자번호
        "receiverCorpNum" => "8888888888",

        # 수신자 상호
        "receiverCorpName" => "수신자 상호",

        # 수신자 대표자 성명
        "receiverCEOName" => "수신자 대표자 성명",

        # 수신자 주소
        "receiverAddr" => "수신자 주소",

        # 수신자 종목
        "receiverBizClass" => "종목",

        # 수신자 업태
        "receiverBizType" => "업태",

        # 수신자 담당자 성명
        "receiverContactName" => "수신자 담당자명",

        # 수신자 담당자 메일주소
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "receiverEmail" => "test2@test.com",

        # 수신자 담당자 연락처
        "receiverTEL" => "070-4304-2999",

        # 수신자 담당자 휴대폰번호
        "receiverHP" => "010-4304-2991",


        ######################### 상세항목(품목) 정보 #########################
        # serialNum(일련번호) 1부터 순차기재 (배열 길이 제한 없음)
        ##################################################################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호 1부터 순차기재
                "purchaseDT" => "20190917", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20190917", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],

        ######################### 전자명세서 추가속성 #########################
        # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
        # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
        "propertyBag" => {
            "CBalance" => "15000",
            "Deposit" => "5000",
            "CBalance" => "20000",
        }
    } # end of statement Hash

    begin
      @Response = StatementController::STMTService.register(
          corpNum,
          statement,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 전자명세서를 수정합니다.
  # - [임시저장] 상태의 전자명세서만 수정할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#Update
  ##############################################################################
  def update

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-04"

    # 전자명세서 정보
    statement = {

        # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
        "itemCode" => itemCode,

        # 맞춤양식코드, 공백처리시 기본양식으로 작성
        "formCode" => "",

        # [필수] 문서번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
        "mgtKey" => mgtKey,

        # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
        "writeDate" => "20190917",

        # [필수] 과세형태, {과세, 영세, 면세} 중 기재
        "taxType" => "과세",

        # [필수] {영수, 청구} 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # 합계금액, 공급가액 합계 + 세액 합계
        "totalAmount" => "22000",

        # 기재 상 일련번호
        "serialNum" => "",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,

        # 발행시 알림문자 전송여부
        "smssendYN" => false,

        # 비고
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",


        ######################### 발신자 정보 #########################

        # 발신자 사업자번호
        "senderCorpNum" => corpNum,

        # 발신자 상호
        "senderCorpName" => "발신자 상호_수정",

        # 발신자 대표자 성명
        "senderCEOName" => "발신자 대표자명_수정",

        # 발신자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
        "senderTaxRegID" => "",

        # 발신자 주소
        "senderAddr" => "발신자 주소",

        # 발신자 종목
        "senderBizClass" => "발신자 종목",

        # 발신자 업태
        "senderBizType" => "발신자 업태",

        # 발신자 담당자 성명
        "senderContactName" => "발신자 담당자명",

        # 발신자 담당자 메일주소
        "senderEmail" => "test@test.com",

        # 발신자 담당자 연락처
        "senderTEL" => "070-4304-2991",

        # 발신자 담당자 휴대폰번호
        "senderHP" => "010-1234-1234",


        ######################### 수신자 정보 #########################

        # 수신자 사업자번호
        "receiverCorpNum" => "8888888888",

        # 수신자 상호
        "receiverCorpName" => "수신자 상호",

        # 수신자 대표자 성명
        "receiverCEOName" => "수신자 대표자 성명",

        # 수신자 주소
        "receiverAddr" => "수신자 주소",

        # 수신자 종목
        "receiverBizClass" => "종목",

        # 수신자 업태
        "receiverBizType" => "업태",

        # 수신자 담당자 성명
        "receiverContactName" => "수신자 담당자명",

        # 수신자 담당자 메일주소
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "receiverEmail" => "test2@test.com",

        # 수신자 담당자 연락처
        "receiverTEL" => "070-4304-2999",

        # 수신자 담당자 휴대폰번호
        "receiverHP" => "010-4304-2991",

        ######################### 상세항목(품목) 정보 #########################
        # serialNum(일련번호) 1부터 순차기재 (배열 길이 제한 없음)
        ##################################################################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호 1부터 순차기재
                "purchaseDT" => "20190917", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20190917", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],

        ######################### 전자명세서 추가속성 #########################
        # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
        # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
        "propertyBag" => {
            "CBalance" => "15000",
            "Deposit" => "5000",
            "CBalance" => "20000",
        }
    } # end of statement Hash

    begin
      @Response = StatementController::STMTService.update(
          corpNum,
          itemCode,
          mgtKey,
          statement,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 1건의 [임시저장] 상태의 전자명세서를 발행처리합니다.
  # - https://docs.popbill.com/statement/ruby/api#StmIssue
  ##############################################################################
  def issue

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-01"

    # 메모
    memo = ""

    # 발행 안내메일 제목, 미기재시 기본양식으로 전송됨
    emailSubject = ""

    begin
      @Response = StatementController::STMTService.issue(
          corpNum,
          itemCode,
          mgtKey,
          memo,
          emailSubject,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 전자명세서를 [발행취소] 처리합니다.
  # - https://docs.popbill.com/statement/ruby/api#Cancel
  ##############################################################################
  def cancelIssue

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    # 메모
    memo = ""

    begin
      @Response = StatementController::STMTService.cancel(
          corpNum,
          itemCode,
          mgtKey,
          memo,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 전자명세서를 삭제합니다.
  # - 삭제시 해당 문서에 할단된 문서번호(mgtKey)를 재사용할 수 있습니다.
  # - 삭제가능한 문서 상태 : [임시저장], [거부], [발행취소]
  # - https://docs.popbill.com/statement/ruby/api#Delete
  ##############################################################################
  def delete

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @Response = StatementController::STMTService.delete(
          corpNum,
          itemCode,
          mgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 1건의 전자명세서 상태/요약 정보를 확인합니다.
  # - 응답항목에 대한 자세한 정보는 "[전자명세서 API 연동매뉴얼] > 3.2.1.
  #   GetInfo (상태 확인)"을 참조하시기 바랍니다.
  # - https://docs.popbill.com/statement/ruby/api#GetInfo
  ##############################################################################
  def getInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @Response = StatementController::STMTService.getInfo(
          corpNum,
          itemCode,
          mgtKey,
      )
      render "statement/getInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 다수건의 전자명세서 상태/요약 정보를 확인합니다.
  # - 응답항목에 대한 자세한 정보는 "[전자명세서 API 연동매뉴얼] > 3.2.1. GetInfos
  #   (상태 대량 확인)"을 참조하시기 바랍니다.
  # - https://docs.popbill.com/statement/ruby/api#GetInfos
  ##############################################################################
  def getInfos

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호 배열, 최대 1000건
    mgtKeyList = ["20190917-01", "20190917-02"]

    begin
      @Response = StatementController::STMTService.getInfos(
          corpNum,
          itemCode,
          mgtKeyList,
      )
      render "statement/getInfos"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서 1건의 상세정보를 조회합니다.
  # - 응답항목에 대한 자세한 사항은 "[전자명세서 API 연동매뉴얼] > 4.1. 전자명세서 구성" 을
  #   참조하시기 바랍니다.
  # - https://docs.popbill.com/statement/ruby/api#GetDetailInfo
  ##############################################################################
  def getDetailInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-01"

    begin
      @Response = StatementController::STMTService.getDetailInfo(
          corpNum,
          itemCode,
          mgtKey,
      )
      puts @Response
      render "statement/statement"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 검색조건을 사용하여 전자명세서 목록을 조회합니다. (조회기간 단위 : 최대 6개월)
  # - https://docs.popbill.com/statement/ruby/api#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # [필수] 일자유형, R-등록일시 W-작성일자 I-발행일시 중 택1
    dType = "W"

    # [필수] 시작일자, 날짜형식(yyyyMMdd)
    sDate = "20190701"

    # [필수] 종료일자, 날짜형식(yyyyMMdd)
    eDate = "20191231"

    # 전송상태값 배열, 미기재시 전체상태조회, 문서상태값 3자리숫자 작성
    # 2,3번째 와일드카드 가능 ex) 1**, 2**
    # 상태코드에 대한 자세한 사항은 "[전자명세서 API 연동매뉴얼] > 5.1 전자명세서 상태코드" 를 참조하시기 바랍니다.
    state = ["2**", "4**"]

    # 명세서 종류코드 배열, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = [121, 122, 123, 124, 125, 126]

    # 페이지 번호
    page = 1

    # 페이지당 목록개수, 최대 1000건
    perPage = 10

    # 정렬방향, D-내림차순(기본값), A-오름차순
    order = "D"

    # 거래처 정보, 거래처 상호 또는 거래처 사업자등록번호 기재, 미기재시 전체조회
    queryString = ""

    begin
      @Response = StatementController::STMTService.search(
          corpNum,
          dType,
          sDate,
          eDate,
          state,
          itemCode,
          page,
          perPage,
          order,
          queryString,
      )
      render "statement/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서 상태 변경이력을 확인합니다.
  # - 상태 변경이력 확인(GetLogs API) 응답항목에 대한 자세한 정보는 "[전자명세서 API 연동매뉴얼]
  #   > 3.2.5 GetLogs (상태 변경이력 확인)" 을 참조하시기 바랍니다.
  # - https://docs.popbill.com/statement/ruby/api#GetLogs
  ##############################################################################
  def getLogs

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @Response = StatementController::STMTService.getLogs(
          corpNum,
          itemCode,
          mgtKey,
      )
      render "statement/statementLogs"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌 전자명세서 관련 문서함 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/statement/ruby/api#GetURL
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 임시문서함(TBOX), 발행문서함(SBOX)
    togo = "SBOX"

    begin
      @value = StatementController::STMTService.getURL(
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
  # 1건의 전자명세서 보기 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/statement/ruby/api#GetPopUpURL
  ##############################################################################
  def getPopUpURL
    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @value = StatementController::STMTService.getPopUpURL(
          corpNum,
          itemCode,
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
  # 1건의 전자명세서 보기 팝업 URL을 반환합니다. (메뉴, 버튼 제외)
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getViewURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20200720-01"

    begin
      @value = StatementController::STMTService.getViewURL(
          corpNum,
          itemCode,
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
  # 1건의 전자명세서 인쇄팝업 URL을 반환합니다. (발신자/수신자용 인쇄 팝업)
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/statement/ruby/api#GetPrintURL
  ##############################################################################
  def getPrintURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @value = StatementController::STMTService.getPrintURL(
          corpNum,
          itemCode,
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
  # 1건의 전자명세서 인쇄팝업 URL을 반환합니다. (수신자용 인쇄 팝업)
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/statement/ruby/api#GetEPrintURL
  ##############################################################################
  def getEPrintURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @value = StatementController::STMTService.getEPrintURL(
          corpNum,
          itemCode,
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
  # 다수건의 전자명세서 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  # - https://docs.popbill.com/statement/ruby/api#GetMassPrintURL
  ##############################################################################
  def getMassPrintURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호 배열, 최대 100건
    mgtKeyList = ["20190917-01", "20190917-02", "20190917-03"]

    begin
      @value = StatementController::STMTService.getMassPrintURL(
          corpNum,
          itemCode,
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
  # 수신자 메일링크 URL을 반환합니다.
  # - 메일링크 URL은 유효시간이 존재하지 않습니다.
  # - https://docs.popbill.com/statement/ruby/api#GetMailURL
  ##############################################################################
  def getMailURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @value = StatementController::STMTService.getMailURL(
          corpNum,
          itemCode,
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
  # - https://docs.popbill.com/statement/ruby/api#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

    begin
      @value = StatementController::STMTService.getAccessURL(
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
  # 인감 및 첨부문서 등록 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/statement/ruby/api#GetSealURL
  ##############################################################################
  def getSealURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

    begin
      @value = StatementController::STMTService.getSealURL(
          corpNum,
          userID
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서에 첨부파일을 등록합니다.
  # - 첨부파일 등록은 전자명세서가 [임시저장] 상태인 경우에만 가능합니다.
  # - 첨부파일은 최대 5개까지 등록할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#AttachFile
  ##############################################################################
  def attachFile

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    # 첨부파일 경로
    filePath = "/Users/kimhyunjin/SDK/popbill.example.ruby/test.pdf"

    begin
      @Response = StatementController::STMTService.attachFile(
          corpNum,
          itemCode,
          mgtKey,
          filePath,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서에 첨부된 파일을 삭제합니다.
  # - 파일을 식별하는 파일아이디는 첨부파일 목록(GetFileList API) 의 응답항목
  #   중 파일아이디(AttachedFile) 값을 통해 확인할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#DeleteFile
  ##############################################################################
  def deleteFile

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    # 파일아이디, getFiles API 응답 항목중 AttachedFile 값 참조.
    fileID = "664ED8A5-7226-4BA5-84BD-514C56A014FE.PBF"

    begin
      @Response = StatementController::STMTService.deleteFile(
          corpNum,
          itemCode,
          mgtKey,
          fileID,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서에 첨부된 파일의 목록을 확인합니다.
  # - 응답항목 중 파일아이디(AttachedFile) 항목은 파일삭제(DeleteFile API)
  #   호출시 이용할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#GetFiles
  ##############################################################################
  def getFiles

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    begin
      @Response = StatementController::STMTService.getFiles(
          corpNum,
          itemCode,
          mgtKey,
      )
      render "statement/getFiles"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 발행 안내메일을 재전송합니다.
  # - https://docs.popbill.com/statement/ruby/api#SendEmail
  ##############################################################################
  def sendEmail

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    # 이메일주소
    emailAddr = "test@test.com"

    begin
      @Response = StatementController::STMTService.sendEmail(
          corpNum,
          itemCode,
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
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [문자] > [전송내역] 탭에서
  #   전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#SendSMS
  ##############################################################################
  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    # 발신번호
    sendNum = "07043042991"

    # 수신번호
    receiveNum = "010-111-222"

    # 메시지 내용, 메시지 길이가 90 byte 이상인 경우, 길이를 초과하는 메시지 내용은 자동으로 제거됩니다.
    contents = "문자메시지 전송을 확인합니다."

    begin
      @Response = StatementController::STMTService.sendSMS(
          corpNum,
          itemCode,
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
  # 전자명세서를 팩스로 전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역] 메뉴에서 전송결과를
  #   확인할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#SendFAX
  ##############################################################################
  def sendFAX

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-02"

    # 발신번호
    sendNum = "07043042991"

    # 수신팩스번호
    receiveNum = "070111222"

    begin
      @Response = StatementController::STMTService.sendFax(
          corpNum,
          itemCode,
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
  # 팝빌에 전자명세서를 등록하지 않고 팩스로 해당문서를 전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역]
  #   메뉴에서 전송결과를 확인할 수 있습니다.
  # - https://docs.popbill.com/statement/ruby/api#FAXSend
  ##############################################################################
  def FAXSend

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-04"

    # 발신번호
    sendNum = "07043042991"

    # 수신 팩스번호
    receiveNum = "070111222"

    # 전자명세서 정보
    statement = {

        # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
        "itemCode" => itemCode,

        # 맞춤양식코드, 공백처리시 기본양식으로 작성
        "formCode" => "",

        # [필수] 문서번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
        "mgtKey" => mgtKey,

        # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
        "writeDate" => "20190121",

        # [필수] 과세형태, {과세, 영세, 면세} 중 기재
        "taxType" => "과세",

        # [필수] {영수, 청구} 중 기재
        "purposeType" => "영수",

        # [필수] 공급가액 합계
        "supplyCostTotal" => "20000",

        # [필수] 세액 합계
        "taxTotal" => "2000",

        # 합계금액, 공급가액 합계 + 세액 합계
        "totalAmount" => "22000",

        # 기재 상 일련번호
        "serialNum" => "",

        # 사업자등록증 이미지 첨부여부
        "businessLicenseYN" => false,

        # 통장사본 이미지 첨부여부
        "bankBookYN" => false,

        # 발행시 알림문자 전송여부
        "smssendYN" => false,

        # 비고
        "remark1" => "비고1",
        "remark2" => "비고2",
        "remark3" => "비고3",


        ######################### 발신자 정보 #########################

        # 발신자 사업자번호
        "senderCorpNum" => "1234567890",

        # 발신자 상호
        "senderCorpName" => "발신자 상호",

        # 발신자 대표자 성명
        "senderCEOName" => "발신자 대표자명",

        # 발신자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
        "senderTaxRegID" => "",

        # 발신자 주소
        "senderAddr" => "발신자 주소",

        # 발신자 종목
        "senderBizClass" => "발신자 종목",

        # 발신자 업태
        "senderBizType" => "발신자 업태",

        # 발신자 담당자 성명
        "senderContactName" => "발신자 담당자명",

        # 발신자 담당자 메일주소
        "senderEmail" => "test@test.com",

        # 발신자 담당자 연락처
        "senderTEL" => "070-4304-2991",

        # 발신자 담당자 휴대폰번호
        "senderHP" => "010-1234-1234",


        ######################### 발신자받는자 정보 #########################

        # 수신자 사업자번호
        "receiverCorpNum" => "8888888888",

        # 수신자 상호
        "receiverCorpName" => "수신자 상호",

        # 수신자 대표자 성명
        "receiverCEOName" => "수신자 대표자 성명",

        # 수신자 주소
        "receiverAddr" => "수신자 주소",

        # 수신자 종목
        "receiverBizClass" => "종목",

        # 수신자 업태
        "receiverBizType" => "업태",

        # 수신자 담당자 성명
        "receiverContactName" => "수신자 담당자명",

        # 수신자 담당자 메일주소
        # 팝빌 개발환경에서 테스트하는 경우에도 안내 메일이 전송되므로,
        # 실제 거래처의 메일주소가 기재되지 않도록 주의
        "receiverEmail" => "test2@test.com",

        # 수신자 담당자 연락처
        "receiverTEL" => "070-4304-2999",

        # 수신자 담당자 휴대폰번호
        "receiverHP" => "010-4304-2991",


        ######################### 상세항목(품목) 정보 #########################

        "detailList" => [
            {
                "serialNum" => 1, # 일련번호 1부터 순차기재
                "purchaseDT" => "20190402", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
            {
                "serialNum" => 2, # 일련번호, 1부터 순차기재
                "purchaseDT" => "20190402", # 거래일자 yyyyMMdd
                "itemName" => "테스트1", # 품명
                "spec" => "규격", # 규격
                "unit" => "단위", # 단위
                "qty" => "1", # 수량
                "unitCost" => "10000", # 단가
                "supplyCost" => "10000", # 공급가액
                "tax" => "1000", # 세액
                "remark" => "비고", # 비고
            },
        ],

        ######################### 전자명세서 추가속성 #########################
        # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
        # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
        "propertyBag" => {
            "CBalance" => "15000",
            "Deposit" => "5000",
            "CBalance" => "20000",
        }
    } # end of statement Hash

    begin
      @value = StatementController::STMTService.faxSend(
          corpNum,
          statement,
          sendNum,
          receiveNum,
      )
      @name = "팩스접수번호(receiptNum)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서에 다른 전자명세서 1건을 첨부합니다.
  # - https://docs.popbill.com/statement/ruby/api#AttachStatement
  ##############################################################################
  def attachStatement

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-01"

    # 첨부할 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    stmtItemCode = 121

    # 첨부할 전자명세서 문서번호
    stmtMgtKey = "20190402-02"

    begin
      @Response = StatementController::STMTService.attachStatement(
          corpNum,
          itemCode,
          mgtKey,
          stmtItemCode,
          stmtMgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서에 첨부된 다른 전자명세서를 첨부해제합니다.
  # - https://docs.popbill.com/statement/ruby/api#DetachStatement
  ##############################################################################
  def detachStatement

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    # 전자명세서 문서번호
    mgtKey = "20190917-01"

    # 첨부해제할 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    stmtItemCode = 121

    # 첨부해제할 전자명세서 문서번호
    stmtMgtKey = "20190402-02"

    begin
      @Response = StatementController::STMTService.detachStatement(
          corpNum,
          itemCode,
          mgtKey,
          stmtItemCode,
          stmtMgtKey,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서 메일전송 항목에 대한 전송여부를 목록으로 반환합니다.
  # - https://docs.popbill.com/statement/ruby/api#ListEmailConfig
  ##############################################################################
  def listEmailConfig

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

    begin
      @Response = StatementController::STMTService.listEmailConfig(
          corpNum,
          userID,
      )
      render "statement/listEmailConfig"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서 메일전송 항목에 대한 전송여부를 수정합니다.
  # 메일전송유형
  # SMT_ISSUE : 수신자에게 전자명세서가 발행 되었음을 알려주는 메일입니다.
  # SMT_ACCEPT : 발신자에게 전자명세서가 승인 되었음을 알려주는 메일입니다.
  # SMT_DENY : 발신자에게 전자명세서가 거부 되었음을 알려주는 메일입니다.
  # SMT_CANCEL : 수신자에게 전자명세서가 취소 되었음을 알려주는 메일입니다.
  # SMT_CANCEL_ISSUE : 수신자에게 전자명세서가 발행취소 되었음을 알려주는 메일입니다.
  # - https://docs.popbill.com/statement/ruby/api#UpdateEmailConfig
  ##############################################################################
  def updateEmailConfig

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

    # 메일 전송 유형
    emailType = "SMT_ISSUE"

    # 메일 전송 여부 (true-전송, false-미전송)
    sendYN = true

    begin
      @Response = StatementController::STMTService.updateEmailConfig(
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
  # - https://docs.popbill.com/statement/ruby/api#GetBalance
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    begin
      @value = StatementController::STMTService.getBalance(corpNum)
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
  # - https://docs.popbill.com/statement/ruby/api#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

    begin
      @value = StatementController::STMTService.getChargeURL(
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
  # - https://docs.popbill.com/statement/ruby/api#GetPartnerBalance
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    begin
      @value = StatementController::STMTService.getPartnerBalance(corpNum)
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
  # - https://docs.popbill.com/statement/ruby/api#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = StatementController::STMTService.getPartnerURL(
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
  # 연동회원의 전자명세서 API 서비스 과금정보를 확인합니다.
  # - https://docs.popbill.com/statement/ruby/api#GetChargeInfo
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    itemCode = 121
    begin
      @Response = StatementController::STMTService.getChargeInfo(corpNum, itemCode)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자명세서 발행단가를 확인합니다.
  # - https://docs.popbill.com/statement/ruby/api#GetUnitCost
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표, 126-영수증
    itemCode = 121

    begin
      @value = StatementController::STMTService.getUnitCost(
          corpNum,
          itemCode,
      )
      @name = "unitCost(발행단가)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  # - https://docs.popbill.com/statement/ruby/api#CheckIsMember
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 파트너 링크아이디
    linkID = StatementController::LinkID

    begin
      @Response = StatementController::STMTService.checkIsMember(
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
  # - https://docs.popbill.com/statement/ruby/api#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = StatementController::STMTService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  # - https://docs.popbill.com/statement/ruby/api#JoinMember
  ##############################################################################
  def joinMember

    # 연동회원 가입정보
    joinInfo = {

        # 링크아이디
        "LinkID" => StatementController::LinkID,

        # 아이디, 6자이상 50자미만
        "ID" => "testkorea20190403",

        # 비밀번호, 6자이상 20자 미만
        "PWD" => "thisispassword",

        # 사업자번호, '-' 제외 10자리
        "CorpNum" => "0000001511",

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
      @Response = StatementController::STMTService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
  # - https://docs.popbill.com/statement/ruby/api#GetCorpInfo
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    begin
      @Response = StatementController::STMTService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다
  # - https://docs.popbill.com/statement/ruby/api#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

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
      @Response = StatementController::STMTService.updateCorpInfo(
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
  # - https://docs.popbill.com/statement/ruby/api#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

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
      @Response = StatementController::STMTService.registContact(
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
  # - https://docs.popbill.com/statement/ruby/api#ListContact
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    begin
      @Response = StatementController::STMTService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 담당자 정보를 수정합니다.
  # - https://docs.popbill.com/statement/ruby/api#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 팝빌회원 아이디
    userID = StatementController::TestUserID

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
      @Response = StatementController::STMTService.updateContact(
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
