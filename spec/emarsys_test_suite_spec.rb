require 'spec_helper'
require 'json'
require 'plissken'
require 'date'


module Escher
  describe Auth do

    Dir.glob('./spec/emarsys_test_suite/authenticate-error-*').each do |c|
      test_case = ::JSON.parse(File.read(c), symbolize_names: true).to_snake_keys
      test_case[:request][:uri] = test_case[:request].delete :url
      test_case[:config][:current_time] = Time.parse(test_case[:config].delete :date)
      escher = Auth.new(test_case[:config][:credential_scope], test_case[:config])
      key = {test_case[:key_db].first[0] => test_case[:key_db].first[1]}

      it "#{test_case[:title]}" do
        expect { escher.authenticate(test_case[:request], key, test_case[:mandatory_signed_headers]) }
          .to raise_error(EscherError, test_case[:expected][:error])
      end
    end


    Dir.glob('./spec/emarsys_test_suite/authenticate-valid-*').each do |c|
      test_case = ::JSON.parse(File.read(c), symbolize_names: true).to_snake_keys
      test_case[:request][:uri] = test_case[:request].delete :url
      test_case[:config][:current_time] = Time.parse(test_case[:config].delete :date)
      escher = Auth.new(test_case[:config][:credential_scope], test_case[:config])
      key = {test_case[:key_db].first[0] => test_case[:key_db].first[1]}

      it "#{test_case[:title]}" do
        expect { escher.authenticate(test_case[:request], key) }.not_to raise_error
      end
    end

  end

end
