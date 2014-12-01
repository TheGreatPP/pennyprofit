require 'date'
require_relative 'yodlee'

class Banker

  def self.get_transactions
    yodlee = Yodlee.new

    yodlee.authenticate_app
    yodlee.login_user
    yodlee.get_bank
    yodlee.grant_bank_login_forms
    yodlee.add_bank_to_user
    transactions = yodlee.get_transactions

    # Print out transactions
    transactions.each { |trans|
      date = DateTime.parse(trans['postDate'])
      description = '%-30.30s' % trans['description']['description']
      formatted_date = '%-10.10s' % "#{date.month}/#{date.day}/#{date.year}"
      amount = '$' + trans['amount']['amount'].to_s
      puts description + " " + formatted_date + " " + amount
    }

    ''

  end
end