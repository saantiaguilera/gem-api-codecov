RSpec.describe Codecov do

	describe "Script destination" do
	  it "has a default script destination" do
	    expect(Codecov.CODECOV_DESTINATION).not_to be nil
	  end

	  it "has a setter for the script destination" do
	  	Codecov.set_script_destination 'new_destination.sh'
	  	expect(Codecov.CODECOV_DESTINATION).to eq 'new_destination.sh'
	  end
	end

	describe "Downloading" do
	  it "downloads a script if not found" do
	  	expect(Codecov.itself).to receive(:open).with(anything()).and_return("stub")
	  	expect(IO.itself).to receive(:copy_stream).with("stub", anything()).and_return(true)

	  	expect(Codecov.download_script).to be true
	  end

	  it "doesnt download a script, if already exists" do
	  	Codecov.set_script_destination 'spec/resources/script_mock.sh'

	  	expect(Codecov.itself).not_to receive(:open).with(anything())

	  	Codecov.download_script
	  end
	end

	describe "Flags building" do
		it "Fails if param is nil" do
			expect(Codecov.as_flags(nil)).to eq('')
		end

		it "Builds as single flag if value is nil" do
			params = { 'c' => nil }
			expect(Codecov.as_flags(params)).to eq '-c'
		end

		it "Builds as kv flag if value is a string" do
			params = { 'X' => 'glib' }
			expect(Codecov.as_flags(params)).to eq '-X glib'
		end

		it "Builds as kv flag if value is empty string" do
			params = { 'X' => '' }
			expect(Codecov.as_flags(params)).to eq "-X ''"
		end 

		it "Builds as k . v flag if value is an array" do
			params = { 'X' => [ 'glib', 'silent' ] }
			expect(Codecov.as_flags(params)).to eq "-X glib -X silent"
		end

		it "Builds correctly with multiple params" do
			params = {
				'c' => nil,
				'X' => [ 'glib', 'silent', 'test' ],
				't' => 'access_token',
				'root_dir' => '',
				's' => nil,
				'f' => [ 'file1.txt', 'file2.txt' ]
			}
			expect(Codecov.as_flags(params)).to eq "-c -X glib -X silent -X test -t access_token -root_dir '' -s -f file1.txt -f file2.txt"
		end
	end

	describe "Run" do
		it "Downloads script if it doesnt exist" do
			Codecov.set_script_destination 'something.sh'
	  	expect(Codecov.itself).to receive(:download_script).and_return(nil)
	  	expect(Codecov.itself).to receive(:system).with(anything()).and_return(nil)
	  	expect(Codecov.run).to eq "bash #{Codecov.CODECOV_DESTINATION} "
		end

		it "Doesnt download script if it exists" do
			Codecov.set_script_destination 'spec/resources/script_mock.sh'
	  	expect(Codecov.itself).not_to receive(:download_script)
	  	expect(Codecov.itself).to receive(:system).with(anything()).and_return(nil)
	  	expect(Codecov.run).to eq "bash #{Codecov.CODECOV_DESTINATION} "
		end

		it "Runs with built flags if provided" do
			params = {
				'c' => nil,
				'X' => [ 'glib', 'silent', 'test' ],
				't' => 'access_token'
			}
			Codecov.set_script_destination 'spec/resources/script_mock.sh'
	  	expect(Codecov.itself).to receive(:system).with(anything()).and_return(nil)
	  	expect(Codecov.run(params)).to eq "bash #{Codecov.CODECOV_DESTINATION} #{Codecov.as_flags(params)}"
		end

		it "Runs with empty flags if no param passed" do
			Codecov.set_script_destination 'spec/resources/script_mock.sh'
	  	expect(Codecov.itself).to receive(:system).with(anything()).and_return(nil)
	  	expect(Codecov.run).to eq "bash #{Codecov.CODECOV_DESTINATION} "
		end
	end

end
