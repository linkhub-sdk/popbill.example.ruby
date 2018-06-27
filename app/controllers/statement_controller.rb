################################################################################
# 팜빌 전자명세서 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2017-11-15
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 19, 22번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
# 2) 팝빌 개발용 사이트(test.popbill.com)에 연동회원으로 가입합니다.
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



  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
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
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea0131"

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
      @Response = StatementController::STMTService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 전자명세서 API 서비스 과금정보를 확인합니다.
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
  # 연동회원의 잔여포인트를 확인합니다.
  # - 과금방식이 파트너과금인 경우 파트너 잔여포인트(GetPartnerBalance API)
  #   를 통해 확인하시기 바랍니다.
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
  # 파트너의 잔여포인트를 확인합니다.
  # - 과금방식이 연동과금인 경우 연동회원 잔여포인트(GetBalance API)를 이용하시기 바랍니다.
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
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  ##############################################################################
  def getPopbillURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # LOGIN-팝빌로그인, CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = StatementController::STMTService.getPopbillURL(
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
    corpNum = StatementController::TestCorpNum

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

  ##############################################################################
  # 연동회원의 회사정보를 확인합니다.
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
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

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
  # 전자명세서 관리번호 중복여부를 확인합니다.
  # - 관리번호는 1~24자리로 숫자, 영문 '-', '_' 조합으로 구성할 수 있습니다.
  ##############################################################################
  def checkMgtKeyInUse

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-01"

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

      @name = "문서관리번호(mgtKey) 사용여부 확인"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 1건의 전자명세서를 임시저장 합니다.
  # - [임시저장] 상태의 전자명세서는 Issue API(발행)를 호출해야만 수신자에게 메일로 전송됩니다..
  ##############################################################################
  def register

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 전자명세서 정보
    statement = {

      # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
      "itemCode" => itemCode,

      # 맞춤양식코드, 공백처리시 기본양식으로 작성
      "formCode" => "",

      # [필수] 문서관리번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
      "mgtKey" => mgtKey,

      # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
      "writeDate" => "20170207",

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


      ######################### 공급자 정보 #########################

      # 공급자 사업자번호
      "senderCorpNum" => "1234567890",

      # 공급자 상호
      "senderCorpName" => "공급자 상호",

      # 공급자 대표자 성명
      "senderCEOName" => "공급자 대표자명",

      # 공급자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
      "senderTaxRegID" => "",

      # 공급자 주소
      "senderAddr" => "공급자 주소",

      # 공급자 종목
      "senderBizClass" => "공급자 종목",

      # 공급자 업태
      "senderBizType" => "공급자 업태",

      # 공급자 담당자 성명
      "senderContactName" => "공급자 담당자명",

      # 공급자 담당자 메일주소
      "senderEmail" => "test@test.com",

      # 공급자 담당자 연락처
      "senderTEL" => "070-4304-2991",

      # 공급자 담당자 휴대폰번호
      "senderHP" => "010-1234-1234",


      ######################### 공급자받는자 정보 #########################

      # 공급받는자 사업자번호
      "receiverCorpNum" => "8888888888",

      # 공급받는자 상호
      "receiverCorpName" => "공급자 상호",

      # 공급자받는자 대표자 성명
      "receiverCEOName" => "공급자 대표자 성명",

      # 공급자받는자 주소
      "receiverAddr" => "공급받는자 주소",

      # 공급자받는자 종목
      "receiverBizClass" => "종목",

      # 공급자받는자 업태
      "receiverBizType" => "업태",

      # 공급자받는자 담당자 성명
      "receiverContactName" => "공급받는자 담당자명",

      # 공급자받는자 담당자 메일주소
      "receiverEmail" => "test2@test.com",

      # 공급자받는자 담당자 연락처
      "receiverTEL" => "070-4304-2999",

      # 공급자받는자 담당자 휴대폰번호
      "receiverHP" => "010-4304-2991",


      ######################### 상세항목(품목) 정보 #########################

      "detailList" => [
        {
          "serialNum" => 1,   # 일련번호 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
        {
          "serialNum" => 2, # 일련번호, 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
      ],

      ######################### 전자명세서 추가속성 #########################
      # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
      # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
      "propertyBag" => {
        "CBalance" => "12345667"
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
  ##############################################################################
  def update

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 전자명세서 정보
    statement = {

      # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
      "itemCode" => itemCode,

      # 맞춤양식코드, 공백처리시 기본양식으로 작성
      "formCode" => "",

      # [필수] 문서관리번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
      "mgtKey" => mgtKey,

      # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
      "writeDate" => "20170207",

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


      ######################### 공급자 정보 #########################

      # 공급자 사업자번호
      "senderCorpNum" => "1234567890",

      # 공급자 상호
      "senderCorpName" => "공급자 상호_수정",

      # 공급자 대표자 성명
      "senderCEOName" => "공급자 대표자명_수정",

      # 공급자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
      "senderTaxRegID" => "",

      # 공급자 주소
      "senderAddr" => "공급자 주소",

      # 공급자 종목
      "senderBizClass" => "공급자 종목",

      # 공급자 업태
      "senderBizType" => "공급자 업태",

      # 공급자 담당자 성명
      "senderContactName" => "공급자 담당자명",

      # 공급자 담당자 메일주소
      "senderEmail" => "test@test.com",

      # 공급자 담당자 연락처
      "senderTEL" => "070-4304-2991",

      # 공급자 담당자 휴대폰번호
      "senderHP" => "010-1234-1234",


      ######################### 공급자받는자 정보 #########################

      # 공급받는자 사업자번호
      "receiverCorpNum" => "8888888888",

      # 공급받는자 상호
      "receiverCorpName" => "공급자 상호",

      # 공급자받는자 대표자 성명
      "receiverCEOName" => "공급자 대표자 성명",

      # 공급자받는자 주소
      "receiverAddr" => "공급받는자 주소",

      # 공급자받는자 종목
      "receiverBizClass" => "종목",

      # 공급자받는자 업태
      "receiverBizType" => "업태",

      # 공급자받는자 담당자 성명
      "receiverContactName" => "공급받는자 담당자명",

      # 공급자받는자 담당자 메일주소
      "receiverEmail" => "test2@test.com",

      # 공급자받는자 담당자 연락처
      "receiverTEL" => "070-4304-2999",

      # 공급자받는자 담당자 휴대폰번호
      "receiverHP" => "010-4304-2991",


      ######################### 상세항목(품목) 정보 #########################

      "detailList" => [
        {
          "serialNum" => 1,   # 일련번호 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
        {
          "serialNum" => 2, # 일련번호, 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
      ],

      ######################### 전자명세서 추가속성 #########################
      # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
      # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
      "propertyBag" => {
        "CBalance" => "12345667"
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
  # 1건의 전자명세서 상태/요약 정보를 확인합니다.
  # - 응답항목에 대한 자세한 정보는 "[전자명세서 API 연동매뉴얼] > 3.3.1.
  #   GetInfo (상태 확인)"을 참조하시기 바랍니다.
  ##############################################################################
  def getInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

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
  # - 응답항목에 대한 자세한 정보는 "[전자명세서 API 연동매뉴얼] > 3.3.2. GetInfos
  #   (상태 대량 확인)"을 참조하시기 바랍니다.
  ##############################################################################
  def getInfos

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호 배열, 최대 1000건
    mgtKeyList = ["20170201-01", "20170201-02"]

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
  ##############################################################################
  def getDetailInfo

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-01"

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
  # 검색조건을 사용하여 전자명세서 목록을 조회합니다.
  # - 응답항목에 대한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
  #   3.3.3. Search (목록 조회)" 를 참조하시기 바랍니다.
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # [필수] 일자유형, R-등록일시 W-작성일자 I-발행일시 중 택1
    dType = "W"

    # [필수] 시작일자, yyyyMMdd
    sDate = "20170101"

    # [필수] 종료일자, yyyyMMdd
    eDate = "20170228"

    # 전송상태값 배열, 미기재시 전체상태조회, 문서상태값 3자리숫자 작성
    # 2,3번째 와일드카드 가능 ex) 1**, 2**
    state = ["2**", "4**"]

    # 명세서 종류코드 배열, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
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
  # 1건의 전자명세서를 삭제합니다.
  # - 전자명세서를 삭제하면 사용된 문서관리번호(mgtKey)를 재사용할 수 있습니다.
  # - 삭제가능한 문서 상태 : [임시저장], [발행취소]
  ##############################################################################
  def delete

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-01"

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
  # 전자명세서 상태 변경이력을 확인합니다.
  # - 상태 변경이력 확인(GetLogs API) 응답항목에 대한 자세한 정보는 "[전자명세서 API 연동매뉴얼]
  #   > 3.3.4 GetLogs (상태 변경이력 확인)" 을 참조하시기 바랍니다.
  ##############################################################################
  def getLogs

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

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
  # 전자명세서에 첨부파일을 등록합니다.
  # - 첨부파일 등록은 전자명세서가 [임시저장] 상태인 경우에만 가능합니다.
  # - 첨부파일은 최대 5개까지 등록할 수 있습니다.
  ##############################################################################
  def attachFile

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 첨부파일 경로
    filePath = "/Users/John/Documents/WorkSpace/ruby project/ruby_popbill_example/test.pdf"

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
  # 전자명세서에 첨부된 파일의 목록을 확인합니다.
  # - 응답항목 중 파일아이디(AttachedFile) 항목은 파일삭제(DeleteFile API)
  #   호출시 이용할 수 있습니다.
  ##############################################################################
  def getFiles

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

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
  # 전자명세서에 첨부된 파일을 삭제합니다.
  # - 파일을 식별하는 파일아이디는 첨부파일 목록(GetFileList API) 의 응답항목
  #   중 파일아이디(AttachedFile) 값을 통해 확인할 수 있습니다.
  ##############################################################################
  def deleteFile

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

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
  # 1건의 전자명세서를 즉시발행 처리합니다.
  ##############################################################################
  def registIssue

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-03"

    # 전자명세서 정보
    statement = {

      # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
      "itemCode" => itemCode,

      # 맞춤양식코드, 공백처리시 기본양식으로 작성
      "formCode" => "",

      # [필수] 문서관리번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
      "mgtKey" => mgtKey,

      # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
      "writeDate" => "20170206",

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


      ######################### 공급자 정보 #########################

      # 공급자 사업자번호
      "senderCorpNum" => "1234567890",

      # 공급자 상호
      "senderCorpName" => "공급자 상호",

      # 공급자 대표자 성명
      "senderCEOName" => "공급자 대표자명",

      # 공급자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
      "senderTaxRegID" => "",

      # 공급자 주소
      "senderAddr" => "공급자 주소",

      # 공급자 종목
      "senderBizClass" => "공급자 종목",

      # 공급자 업태
      "senderBizType" => "공급자 업태",

      # 공급자 담당자 성명
      "senderContactName" => "공급자 담당자명",

      # 공급자 담당자 메일주소
      "senderEmail" => "test@test.com",

      # 공급자 담당자 연락처
      "senderTEL" => "070-4304-2991",

      # 공급자 담당자 휴대폰번호
      "senderHP" => "010-1234-1234",


      ######################### 공급자받는자 정보 #########################

      # 공급받는자 사업자번호
      "receiverCorpNum" => "8888888888",

      # 공급받는자 상호
      "receiverCorpName" => "공급자 상호",

      # 공급자받는자 대표자 성명
      "receiverCEOName" => "공급자 대표자 성명",

      # 공급자받는자 주소
      "receiverAddr" => "공급받는자 주소",

      # 공급자받는자 종목
      "receiverBizClass" => "종목",

      # 공급자받는자 업태
      "receiverBizType" => "업태",

      # 공급자받는자 담당자 성명
      "receiverContactName" => "공급받는자 담당자명",

      # 공급자받는자 담당자 메일주소
      "receiverEmail" => "test2@test.com",

      # 공급자받는자 담당자 연락처
      "receiverTEL" => "070-4304-2999",

      # 공급자받는자 담당자 휴대폰번호
      "receiverHP" => "010-4304-2991",


      ######################### 상세항목(품목) 정보 #########################

      "detailList" => [
        {
          "serialNum" => 1,   # 일련번호 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
        {
          "serialNum" => 2, # 일련번호, 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
      ],

      ######################### 전자명세서 추가속성 #########################
      # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
      # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
      "propertyBag" => {
        "CBalance" => "12345667"
      }
    } # end of statement Hash

    begin
      @Response = StatementController::STMTService.registIssue(
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
  # 1건의 [임시저장] 상태의 전자명세서를 발행처리합니다.
  # - 발행시 포인트가 차감됩니다.
  ##############################################################################
  def issue

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 메모
    memo = ''

    # 발행 안내메일 제목, 미기재시 기본양식으로 전송됨
    emailSubject = ''

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
  ##############################################################################
  def cancelIssue

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 메모
    memo = ''

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
  # 발행 안내메일을 재전송합니다.
  ##############################################################################
  def sendEmail

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

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
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [전송내역] 탭에서
  #   전송결과를 확인할 수 있습니다.
  ##############################################################################
  def sendSMS

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 발신번호
    sendNum = "07043042991"

    # 수신번호
    receiveNum = "010-111-222"

    # 메시지 내용, 90byte 초과된 내용은 삭제되어 전송됩니다.
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
  # 팝빌에 등록하지 않고 전자명세서를 팩스전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역]
  #   메뉴에서 전송결과를 확인할 수 있습니다.
  ##############################################################################
  def sendFAX

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

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
  # 팝빌에 등록하지 않고 전자명세서를 팩스전송합니다.
  # - 팩스 전송 요청시 포인트가 차감됩니다. (전송실패시 환불처리)
  # - 전송내역 확인은 "팝빌 로그인" > [문자 팩스] > [팩스] > [전송내역]
  #   메뉴에서 전송결과를 확인할 수 있습니다.
  ##############################################################################
  def FAXSend

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-04"

    # 발신번호
    sendNum = "07043042991"

    # 수신 팩스번호
    receiveNum = "070111222"

    # 전자명세서 정보
    statement = {

      # [필수] 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
      "itemCode" => itemCode,

      # 맞춤양식코드, 공백처리시 기본양식으로 작성
      "formCode" => "",

      # [필수] 문서관리번호, 숫자, 영문, '-', '_' 조합 (최대24자리)으로 사업자별로 중복되지 않도록 구성
      "mgtKey" => mgtKey,

      # [필수] 기재상 작성일자, 날짜형식(yyyyMMdd)
      "writeDate" => "20170206",

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


      ######################### 공급자 정보 #########################

      # 공급자 사업자번호
      "senderCorpNum" => "1234567890",

      # 공급자 상호
      "senderCorpName" => "공급자 상호",

      # 공급자 대표자 성명
      "senderCEOName" => "공급자 대표자명",

      # 공급자 종사업장 식별번호, 필요시 기재, 형식은 숫자 4자리
      "senderTaxRegID" => "",

      # 공급자 주소
      "senderAddr" => "공급자 주소",

      # 공급자 종목
      "senderBizClass" => "공급자 종목",

      # 공급자 업태
      "senderBizType" => "공급자 업태",

      # 공급자 담당자 성명
      "senderContactName" => "공급자 담당자명",

      # 공급자 담당자 메일주소
      "senderEmail" => "test@test.com",

      # 공급자 담당자 연락처
      "senderTEL" => "070-4304-2991",

      # 공급자 담당자 휴대폰번호
      "senderHP" => "010-1234-1234",


      ######################### 공급자받는자 정보 #########################

      # 공급받는자 사업자번호
      "receiverCorpNum" => "8888888888",

      # 공급받는자 상호
      "receiverCorpName" => "공급자 상호",

      # 공급자받는자 대표자 성명
      "receiverCEOName" => "공급자 대표자 성명",

      # 공급자받는자 주소
      "receiverAddr" => "공급받는자 주소",

      # 공급자받는자 종목
      "receiverBizClass" => "종목",

      # 공급자받는자 업태
      "receiverBizType" => "업태",

      # 공급자받는자 담당자 성명
      "receiverContactName" => "공급받는자 담당자명",

      # 공급자받는자 담당자 메일주소
      "receiverEmail" => "test2@test.com",

      # 공급자받는자 담당자 연락처
      "receiverTEL" => "070-4304-2999",

      # 공급자받는자 담당자 휴대폰번호
      "receiverHP" => "010-4304-2991",


      ######################### 상세항목(품목) 정보 #########################

      "detailList" => [
        {
          "serialNum" => 1,   # 일련번호 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
        {
          "serialNum" => 2, # 일련번호, 1부터 순차기재
          "purchaseDT" => "20170117",   # 거래일자 yyyyMMdd
          "itemName" => "테스트1",   # 품명
          "spec" => "규격",   # 규격
          "unit" => "단위",   # 단위
          "qty" => "1",   # 수량
          "unitCost" => "10000",  # 단가
          "supplyCost" => "10000",    # 공급가액
          "tax" => "1000",    # 세액
          "remark" => "비고", # 비고
        },
      ],

      ######################### 전자명세서 추가속성 #########################
      # - 추가속성에 관한 자세한 사항은 "[전자명세서 API 연동매뉴얼] >
      # 5.2. 기본양식 추가속성 테이블"을 참조하시기 바랍니다.
      "propertyBag" => {
        "CBalance" => "12345667"
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
  ##############################################################################
  def attachStatement

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 첨부할 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    stmtItemCode = 121

    # 첨부할 전자명세서 문서관리번호
    stmtMgtKey = "20170201-01"

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
  ##############################################################################
  def detachStatement

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170207-02"

    # 첨부해제할 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    stmtItemCode = 121

    # 첨부해제할 전자명세서 문서관리번호
    stmtMgtKey = "20170201-01"

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
  # 팝빌 전자명세서 관련 문서함 팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 매출문서함-SBOX, 임시(연동)문서함-TBOX
    togo = "TBOX"

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
  ##############################################################################
  def getPopUpURL
    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170206-01"

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
  # 1건의 전자명세서 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getPrintURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170206-01"

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
  # 다수건의 전자명세서 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getMassPrintURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호 배열, 최대 100건
    mgtKeyList = ["20170201-01", "20170201-02", "20170201-03"]

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
  # 1건의 전자명세서 인쇄팝업 URL을 반환합니다.
  # - 보안정책으로 인해 반환된 URL의 유효시간은 30초입니다.
  ##############################################################################
  def getEPrintURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170206-01"

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
  # 공급받는자 메일링크 URL을 반환합니다.
  # - 메일링크 URL은 유효시간이 존재하지 않습니다.
  ##############################################################################
  def getMailURL

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
    itemCode = 121

    # 전자명세서 문서관리번호
    mgtKey = "20170206-01"

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
  # 전자명세서 발행단가를 확인합니다.
  ##############################################################################
  def getUnitCost

    # 팝빌회원 사업자번호
    corpNum = StatementController::TestCorpNum

    # 전자명세서 종류코드, 121-거래명세서, 122-청구서, 123-견적서, 124-발주서, 125-입금표,126-영수증
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
  # 전자명세서 메일전송 항목에 대한 전송여부를 목록으로 반환한다.
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
  # 전자명세서 메일전송 항목에 대한 전송여부를 수정한다.
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

end
