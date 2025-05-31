require 'time'
LOGS_FILE="app.log"

module Loggable
  def log_info (user,message)
    f = File.new(LOGS_FILE,"a")
    f.write"#{Time.now()} -- info -- User #{user} Transaction #{message}\n"
    f.close 
  end
  def log_warning (user,message)
    f = File.new(LOGS_FILE,"a")
    f.write"#{Time.now()} -- warning -- User #{user}  Transaction #{message}\n"
    f.close    
  end
  def log_error (user,message)
    f = File.new(LOGS_FILE,"a")
    f.write"#{Time.now()} -- error -- User #{user} Transaction #{message}\n"
    f.close 
  end
end

class User
  attr_accessor :balance
  attr_reader :name
  def initialize (name,balance)
    @name=name
    @balance=balance
  end
 
end
$users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]
class Transaction
  attr_reader :user,:value
  def initialize (user,value)
    @user = user
    @value = value
  end
  def balance_calculate!
    @user.balance =@user.balance+ @value 
  end 
end



class  Bank

  def process_transactions (*args,&block)
    raise "#{__method__} is abstract"
 
  end
end

class CBABank < Bank
  include Loggable
  def process_transactions (transactions,&block)   
    transactions.each do |trans|
      begin
          if($users.include? trans.user)
            if( trans.user.balance >  0)
              state= "success"
              trans.balance_calculate!
              if(trans.user.balance > 0)
                log_info trans.user.name,"succeeded"
              else
                log_warning trans.user.name,"has 0 balance"
              end

            else
              state="failure"
              message="with reason Not enough balance"
              log_error trans.user.name,"failed with message Not enough balance"
              raise "Balance not enough"

          end
        else
          state="failure"
          message="with reason Menna not exist in the bank!"
          log_error trans.user.name,"failed with message #{trans.user.name} not exist in"
          raise "not exist user"
        end
      rescue => e
        puts e.message
      end
      

     
      block.call state,trans.user.name,trans.value,message
    end
  end 
end

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new($users[0], -20),
  Transaction.new($users[0], -30),
  Transaction.new($users[0], -50),
  Transaction.new($users[0], -100),
  Transaction.new($users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]
CBABank.new().process_transactions(transactions) do |state,user,value,message|
   puts "Call endpoint for #{state} of #{user} transaction with value #{value} #{message}"
end

  