require 'rest-client'
require 'json'

class Yodlee
  def initialize
    @rest_url = "https://rest.developer.yodlee.com/services/srest/restserver/v1.0"
  end

  def authenticate_app

    auth_url = "/authenticate/coblogin"

    credentials = { cobrandLogin: 'sbCobcameronpennyprofit', cobrandPassword: 'SUPER_SECRET' }

    @session_token = post(auth_url, credentials)['cobrandConversationCredentials']['sessionToken']

  end

  # Registers a user with yodlee
  def create_user
    #register3 is not available in evaluation mode
  end

  def login_user
    login_url = '/authenticate/login'
    credentials = { cobSessionToken: @session_token, login: 'sbMemcameronpennyprofit1', password: 'sbMemcameronpennyprofit1#123' }

    @user_token = post(login_url, credentials)['userContext']['conversationCredentials']['sessionToken']
  end

  def get_bank
    bank_url = '/jsonsdk/SiteTraversal/searchSite'

    credentials = {cobSessionToken: @session_token, userSessionToken: @user_token, siteSearchString: 'America First'}

    @bank_id = post(bank_url, credentials).first['siteId']
  end

  def grant_bank_login_forms
    login_url = '/jsonsdk/SiteAccountManagement/getSiteLoginForm'

    bank_access = {cobSessionToken: @session_token, siteId: @bank_id}

    @bank_forms = post(login_url, bank_access)['componentList']
  end

  def add_bank_to_user
    account_url = '/jsonsdk/SiteAccountManagement/addSiteAccount1'

    data = {
      cobSessionToken: @session_token,
      userSessionToken: @user_token,
      siteId: @bank_id,
      'credentialFields.enclosedType' => 'com.yodlee.common.FieldInfoSingle',
      'credentialFields[0].displayName' => @bank_forms[0]['displayName'],
      'credentialFields[0].fieldType.typeName' => @bank_forms[0]['fieldType']['typeName'],
      'credentialFields[0].name' => @bank_forms[0]['name'],
      'credentialFields[0].value' => 'sha5.Investment1',
      'credentialFields[0].valueIdentifier' => @bank_forms[0]['valueIdentifier'],
      'credentialFields[0].valueMask' => @bank_forms[0]['valueMask'],
      'credentialFields[0].isEditable' => @bank_forms[0]['isEditable'],
      'credentialFields[1].displayName' => @bank_forms[1]['displayName'],
      'credentialFields[1].fieldType.typeName' => @bank_forms[1]['fieldType']['typeName'],
      'credentialFields[1].name' => @bank_forms[1]['name'],
      'credentialFields[1].value' => 'Investment1',
      'credentialFields[1].valueIdentifier' => @bank_forms[1]['valueIdentifier'],
      'credentialFields[1].valueMask' => @bank_forms[1]['valueMask'],
      'credentialFields[1].isEditable' => @bank_forms[1]['isEditable'],
    }

    @bank_user = post(account_url, data)
  end

  def get_transactions
    transaction_url = '/jsonsdk/TransactionSearchService/executeUserSearchRequest'

    data = {
      cobSessionToken: @session_token,
      userSessionToken: @user_token,
      'transactionSearchRequest.containerType' => 'bank',
      'transactionSearchRequest.higherFetchLimit' => 500,
      'transactionSearchRequest.lowerFetchLimit' => 1,
      'transactionSearchRequest.resultRange.endNumber' => 100,
      'transactionSearchRequest.resultRange.startNumber' => 1,
      'transactionSearchRequest.searchClients.clientId' => 1,
      'transactionSearchRequest.searchClients.clientName' => 'DataSearchService',
      'transactionSearchRequest.ignoreUserInput' => true,
      'transactionSearchRequest.searchFilter.transactionSplitType' => 'ALL_TRANSACTION'
    }

    post(transaction_url, data)[["searchResult"]["transactions"]
  end

  private

  def post(url, content)
    JSON.parse(RestClient.post(@rest_url + url, content , :content_type => :json))
  end
end
