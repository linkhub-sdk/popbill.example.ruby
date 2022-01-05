################################################################################
#
# 팝빌 홈택스 전자세금계산서 연동 API Ruby On Rails SDK Example
#
# 업데이트 일자 : 2020-07-23
# 연동기술지원 연락처 : 1600-9854 / 070-4304-2991~2
# 연동기술지원 이메일 : code@linkhub.co.kr
#
# <테스트 연동개발 준비사항>
# 1) 25, 28번 라인에 선언된 링크아이디(LinkID)와 비밀키(SecretKey)를
#    링크허브 가입시 메일로 발급받은 인증정보를 참조하여 변경합니다.
#
# 2) 홈택스 인증정보를 등록 합니다. (부서사용자등록 / 공인인증서 등록)
#    - 팝빌로그인 > [홈택스연동] > [환경설정] > [인증 관리] 메뉴에서 홈택스 인증 처리를 합니다.
#    - 홈택스연동 인증 관리 팝업 URL(GetCertificatePopUpURL API) 반환된 URL을 이용하여
#      홈택스 인증 처리를 합니다.
#
################################################################################

require 'popbill/htTaxinvoice'

class HttaxinvoiceController < ApplicationController

  # 링크아이디
  LinkID = "TESTER"

  # 비밀키
  SecretKey = "SwWxqU+0TErBXy/9TVjIPEnI0VTUMMSQZtJf3Ed8q3I="

  # 팝빌 연동회원 사업자번호
  TestCorpNum = "1234567890"

  # 팝빌 연동회원 아이디
  TestUserID = "testkorea"

  # 팝빌 홈택스 전자세금계산서 연동 API Service 초기화
  HTTIService = HTTaxinvoiceService.instance(
      HttaxinvoiceController::LinkID,
      HttaxinvoiceController::SecretKey
  )

  # 연동환경 설정, true-개발용, false-상업용
  HTTIService.setIsTest(true)

  # 인증토큰 IP제한기능 사용여부, true-권장
  HTTIService.setIpRestrictOnOff(true)

  # 팝빌 API 서비스 고정 IP 사용여부, true-사용, false-미사용, 기본값(false)
  HTTIService.setUseStaticIP(false)

  ##############################################################################
  # 전자세금계산서 매출/매입 내역 수집을 요청합니다. (조회기간 단위 : 최대 3개월)
  # - https://docs.popbill.com/httaxinvoice/ruby/api#RequestJob
  ##############################################################################
  def requestJob

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 전자세금계산서 유형, SELL-매출, BUY-매입, TRUSTEE-위수탁
    keyType = KeyType::SELL

    # 일자유형, W-작성일자, I-발행일자, S-전송일자
    dType = "S"

    # 시작일자, 표시형식(yyyyMMdd)
    sDate = "20190901"

    # 종료일자, 표시형식(yyyyMMdd)
    eDate = "20191231"

    begin
      @value = HttaxinvoiceController::HTTIService.requestJob(
          corpNum,
          keyType,
          dType,
          sDate,
          eDate,
      )
      @name = "jobID(접수번호)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집 요청 상태를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetJobState
  ##############################################################################
  def getJobState

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 수집 요청(RequestJob API) 호출시 반환반은 작업아이디(jobID)
    jobID = "019040411000000001"

    begin
      @Response = HttaxinvoiceController::HTTIService.getJobState(corpNum, jobID)
      render "httaxinvoice/getJobState"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 수집 요청건들에 대한 상태 목록을 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#ListActiveJob
  ##############################################################################
  def listActiveJob

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.listActiveJob(corpNum)
      render "httaxinvoice/listActiveJob"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자세금계산서 매입/매출 내역의 수집 결과를 조회합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#Search
  ##############################################################################
  def search

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

    # 작업아이디
    jobID = "019103116000000001"

    # 문서형태 배열, N-일반세금계산서, M-수정세금계산서
    type = ["N", "M"]

    # 과세형태 배열, T-과세, N-면세, Z-영세
    taxType = ["T", "N", "Z"]

    # 영수/청구 배열, R-영수, C-청구, N-없음]
    purposeType = ["R", "C", "N"]

    # 종사업장번호 사업자 유형, S-공급자, B-공급받는자, T-수탁자
    taxRegIDType = ''

    # 종사업장번호, 콤마(,)로 구분하여 구성 ex) 0001,0002
    taxRegIDYN = ''

    # 종사업장 유무, 공백-전체조회, 0-종사업장번호 없음, 1-종사업장번호 조회
    taxRegID = ''

    # 페이지 번호, 기본값 '1'
    page = 1

    # 페이지당 검색개수, 기본값 '500', 최대 '1000'
    perPage = 10

    # 정렬 방향, D-내림차순, A-오름차순
    order = "D"

    # 조회 검색어, 거래처 사업자번호 또는 거래처명 like 검색
    searchString = ""

    begin
      @Response = HttaxinvoiceController::HTTIService.search(
          corpNum,
          jobID,
          type,
          taxType,
          purposeType,
          taxRegIDType,
          taxRegIDYN,
          taxRegID,
          page,
          perPage,
          order,
          userID,
          searchString,
      )
      render "httaxinvoice/search"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자세금계산서 매입/매출 내역의 수집 결과 요약정보를 조회합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#Summary
  ##############################################################################
  def summary

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

    # 작업아이디
    jobID = "019103116000000001"

    # 문서형태 배열, N-일반세금계산서, M-수정세금계산서
    type = ["N", "M"]

    # 과세형태 배열, T-과세, N-면세, Z-영세
    taxType = ["T", "N", "Z"]

    # 영수/청구 배열, R-영수, C-청구, N-없음]
    purposeType = ["R", "C", "N"]

    # 종사업장번호 사업자 유형, S-공급자, B-공급받는자, T-수탁자
    taxRegIDType = ''

    # 종사업장번호, 콤마(,)로 구분하여 구성 ex) 0001,0002
    taxRegIDYN = ''

    # 종사업장 유무, 공백-전체조회, 0-종사업장번호 없음, 1-종사업장번호 조회
    taxRegID = ''

    # 조회 검색어, 거래처 사업자번호 또는 거래처명 like 검색
    searchString = ''

    begin
      @Response = HttaxinvoiceController::HTTIService.summary(
          corpNum,
          jobID,
          type,
          taxType,
          purposeType,
          taxRegIDType,
          taxRegIDYN,
          taxRegID,
          userID,
          searchString,
      )
      render "httaxinvoice/summary"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자세금계산서 1건의 상세정보를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetTaxinvoice
  ##############################################################################
  def getTaxinvoice

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 전자세금계산서 국세청 승인번호
    ntsConfirmNum = "201904024100020300000cc6"

    begin
      @Response = HttaxinvoiceController::HTTIService.getTaxinvoice(corpNum, ntsConfirmNum)
      render "httaxinvoice/getTaxinvoice"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자세금계산서 XML 정보를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetXML
  ##############################################################################
  def getXML

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 전자세금계산서 국세청 승인번호
    ntsConfirmNum = "201904024100020300000cc6"

    begin
      @Response = HttaxinvoiceController::HTTIService.getXML(corpNum, ntsConfirmNum)
      render "httaxinvoice/getXML"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자세금계산서 보기 팝업 URL을 반환힙니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetPopUpURL
  ##############################################################################
  def getPopUpURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 국세청 승인번호
    ntsConfirmNum = "201904024100020300000cc6"

    begin
      @value = HttaxinvoiceController::HTTIService.getPopUpURL(
          corpNum,
          ntsConfirmNum
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 전자세금계산서 인쇄 팝업 URL을 반환힙니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetPrintURL
  ##############################################################################
  def getPrintURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 국세청 승인번호
    ntsConfirmNum = "201904024100020300000cc6"

    begin
      @value = HttaxinvoiceController::HTTIService.getPrintURL(
          corpNum,
          ntsConfirmNum
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end



  ##############################################################################
  # 홈택스연동 인증관리를 위한 URL을 반환합니다.
  # - 반환된 URL은 보안정책에 따라 30초의 유효시간을 갖습니다.
  # - 부서사용자 또는 공인인증서 인증이 가능합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetCertificatePopUpURL
  ##############################################################################
  def getCertificatePopUpURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @value = HttaxinvoiceController::HTTIService.getCertificatePopUpURL(
          corpNum,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 등록된 홈택스 공인인증서의 만료일자를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetCertificateExpireDate
  ##############################################################################
  def getCertificateExpireDate

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @value = HttaxinvoiceController::HTTIService.getCertificateExpireDate(
          corpNum,
      )
      @name = "ExpireDate(홈택스 공인인증서 만료일시)"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 홈택스 공인인증서의 만료일자를 반환합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#CheckCertValidation
  ##############################################################################
  def checkCertValidation

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.checkCertValidation(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 홈택스 전자세금계산서 부서사용자 계정을 등록합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#RegistDeptUser
  ##############################################################################
  def registDeptUser

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 홈택스 부서사용자 계정아이디
    deptUserID = "deptuserid"

    # 홈택스 부서사용자 계정비밀번호
    deptUserPWD = "deptuserpwd"

    begin
      @Response = HttaxinvoiceController::HTTIService.registDeptUser(
          corpNum,
          deptUserID,
          deptUserPWD
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 전자세금계산서 부서사용자 아이디를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#CheckDeptUser
  ##############################################################################
  def checkDeptUser

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.checkDeptUser(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 전자세금계산서 부서사용자 계정정보를 이용하여 홈택스 로그인을 테스트합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#CheckLoginDeptUser
  ##############################################################################
  def checkLoginDeptUser

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.checkLoginDeptUser(
          corpNum,
      )
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 팝빌에 등록된 전자세금계산서 부서사용자 계정정보를 삭제합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#DeleteDeptUser
  ##############################################################################
  def deleteDeptUser

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.deleteDeptUser(
          corpNum,
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetBalance
  ##############################################################################
  def getBalance

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @value = HttaxinvoiceController::HTTIService.getBalance(corpNum)
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetChargeURL
  ##############################################################################
  def getChargeURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

    begin
      @value = HttaxinvoiceController::HTTIService.getChargeURL(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetPaymentURL
  ##############################################################################
  def getPaymentURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

    begin
      @value = HttaxinvoiceController::HTTIService.getPaymentURL(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetUseHistoryURL
  ##############################################################################
  def getUseHistoryURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

    begin
      @value = HttaxinvoiceController::HTTIService.getUseHistoryURL(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetPartnerBalance
  ##############################################################################
  def getPartnerBalance

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @value = HttaxinvoiceController::HTTIService.getPartnerBalance(corpNum)
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetPartnerURL
  ##############################################################################
  def getPartnerURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # CHRG-포인트충전
    togo = "CHRG"

    begin
      @value = HttaxinvoiceController::HTTIService.getPartnerURL(
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
  # 연동회원의 홈택스 전자세금계산서 연동 API 서비스 과금정보를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetChargeInfo
  ##############################################################################
  def getChargeInfo

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.getChargeInfo(corpNum)
      render "home/chargeInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 정액제 신청 팝업 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetFlatRatePopUpURL
  ##############################################################################
  def getFlatRatePopUpURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @value = HttaxinvoiceController::HTTIService.getFlatRatePopUpURL(
          corpNum,
      )
      @name = "URL"
      render "home/result"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 정액제 서비스 이용상태를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetFlatRateState
  ##############################################################################
  def getFlatRateState

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.getFlatRateState(corpNum)
      render "httaxinvoice/getFlatRateState"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 해당 사업자의 연동회원 가입여부를 확인합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#CheckIsMember
  ##############################################################################
  def checkIsMember

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 파트너 링크아이디
    linkID = HttaxinvoiceController::LinkID

    begin
      @Response = HttaxinvoiceController::HTTIService.checkIsMember(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#CheckID
  ##############################################################################
  def checkID

    #조회할 아이디
    testID = "testkorea"

    begin
      @Response = HttaxinvoiceController::HTTIService.checkID(testID)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/except"
    end
  end

  ##############################################################################
  # 파트너의 연동회원으로 회원가입을 요청합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#JoinMember
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
      @Response = HttaxinvoiceController::HTTIService.joinMember(joinInfo)
      render "home/response"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end


  ##############################################################################
  # 팝빌(www.popbill.com)에 로그인된 팝빌 URL을 반환합니다.
  # - 보안정책에 따라 반환된 URL은 30초의 유효시간을 갖습니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetAccessURL
  ##############################################################################
  def getAccessURL

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

    begin
      @value = HttaxinvoiceController::HTTIService.getAccessURL(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetCorpInfo
  ##############################################################################
  def getCorpInfo

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.getCorpInfo(corpNum)
      render "home/corpInfo"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 회사정보를 수정합니다
  # - https://docs.popbill.com/httaxinvoice/ruby/api#UpdateCorpInfo
  ##############################################################################
  def updateCorpInfo

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

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
      @Response = HttaxinvoiceController::HTTIService.updateCorpInfo(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#RegistContact
  ##############################################################################
  def registContact

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

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
      @Response = HttaxinvoiceController::HTTIService.registContact(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#GetContactInfo
  ##############################################################################
  def getContactInfo
    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 확인할 담당자 아이디
    contactID = 'testkorea'

    begin
      @Response = HttaxinvoiceController::HTTIService.getContactInfo(
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
  # - https://docs.popbill.com/httaxinvoice/ruby/api#ListContact
  ##############################################################################
  def listContact

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    begin
      @Response = HttaxinvoiceController::HTTIService.listContact(corpNum)
      render "home/listContact"
    rescue PopbillException => pe
      @Response = pe
      render "home/exception"
    end
  end

  ##############################################################################
  # 연동회원의 담당자 정보를 수정합니다.
  # - https://docs.popbill.com/httaxinvoice/ruby/api#UpdateContact
  ##############################################################################
  def updateContact

    # 팝빌회원 사업자번호
    corpNum = HttaxinvoiceController::TestCorpNum

    # 팝빌회원 아이디
    userID = HttaxinvoiceController::TestUserID

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
      @Response = HttaxinvoiceController::HTTIService.updateContact(
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
