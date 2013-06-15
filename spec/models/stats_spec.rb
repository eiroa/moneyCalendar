require 'spec_helper'
require 'date'

describe Stats do

  describe 'dates_and_data_from_to' do
    before(:each) do
      @transaction = TransactionDone.new
      @transaction.pay_date = Date.parse("2013-06-11")
      @transaction.amount = 100

      @transaction2 = TransactionDone.new
      @transaction2.pay_date = Date.parse("2013-07-11")
      @transaction2.amount = 100

      @transaction3 = TransactionDone.new
      @transaction3.pay_date = Date.parse("2013-06-15")
      @transaction3.amount = 100
    end

    describe 'when there are not payments in stats' do
      before(:each) do
        @dates, @data = Stats.dates_and_data_from_to([], "2013-06-10", "2013-06-15")
      end

      it 'should return dates with the list to the months that are between specified dates' do
        @dates.should eq ["June/2013"]
      end

      it 'should return data with the list to the sum of the expenses for each month that is between the specified dates' do
        @data.should eq [0]
      end
    end

    describe 'when there is a payment in stats' do
      before(:each) do
        @dates, @data = Stats.dates_and_data_from_to([@transaction], "2013-06-10", "2013-06-15")
      end

      it 'should return dates with the list to the months that are between specified dates' do
        @dates.should eq ["June/2013"]
      end

      it 'should return data with the list to the sum of the expenses for each month that is between the specified dates' do
        @data.should eq [100]
      end
    end

    describe 'when there are payments on differents months in stats' do
      describe 'and are in the selected range' do
        before(:each) do
          @dates, @data = Stats.dates_and_data_from_to([@transaction, @transaction2, @transaction3],
          "2013-06-10", "2013-08-15")
        end

        it 'should return dates with the list to the months that are between specified dates' do
          @dates.should eq ["June/2013", "July/2013", "August/2013"]
        end

        it 'should return data with the list to the sum of the expenses for each month that is between the specified dates' do
          @data.should eq [200, 100, 0]
        end
      end

      describe 'and are not in the selected range' do
        before(:each) do
          @dates, @data = Stats.dates_and_data_from_to([@transaction, @transaction2, @transaction3],
          "2013-06-10", "2013-06-15")
        end

        it 'should return dates with the list to the months that are between specified dates' do
          @dates.should eq ["June/2013"]
        end

        it 'should return data with the list to the sum of the expenses for each month that is between the specified dates' do
          @data.should eq [200]
        end
      end

    end
  end
end
