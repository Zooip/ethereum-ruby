require 'spec_helper'

describe Ethereum::SolcCompiler do

  subject {Ethereum::SolcCompiler.new}

  describe "compile one file" do

    let(:file){File.join(FIXTURES_PATH,"/ContractWithParams.sol")}
    let(:output){subject.compile(file)}
    let(:contract_name){"ContractWithParams"}

    it "returns compiled code" do
      expect(output).to have_key(contract_name)
      expect(output[contract_name]).to have_key("code")
    end

    it "returns abi definition" do
      expect(output[contract_name]).to have_key("info")

      expect(output[contract_name]["info"]).to include(
                                                   "abiDefinition" => [{"constant"=>true, "inputs"=>[{"name"=>"_a", "type"=>"uint256"}], "name"=>"getSetting", "outputs"=>[{"name"=>"", "type"=>"uint256"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"getSetting", "outputs"=>[{"name"=>"", "type"=>"address"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[], "name"=>"genEvent", "outputs"=>[], "payable"=>false, "type"=>"function"}, {"inputs"=>[{"name"=>"_setting", "type"=>"address"}], "payable"=>false, "type"=>"constructor"}, {"anonymous"=>false, "inputs"=>[{"indexed"=>true, "name"=>"_a", "type"=>"address"}, {"indexed"=>true, "name"=>"_b", "type"=>"uint256"}], "name"=>"MyEvent", "type"=>"event"}],
                                               )
    end

  end

  describe "compile multiple files" do

    let(:files){[File.join(FIXTURES_PATH,"/ContractWithParams.sol"),File.join(FIXTURES_PATH,"/SimpleNameRegistry.sol")]}
    let(:contract_names) {["ContractWithParams", "SimpleNameRegistry", "SimpleContract"]} #/SimpleNameRegistry.sol contains 2 contracts
    let(:output){subject.compile(files)}

    it "compile each contracts" do
      expect(output.keys).to include(*contract_names)
    end

    it "returns the code of each contracts" do
      contract_names.each do |contract_name|
        expect(output[contract_name]).to have_key("code")
      end
    end

    it "return abi code of each contract" do

      abi_def={
          "ContractWithParams"=>[{"constant"=>true, "inputs"=>[{"name"=>"_a", "type"=>"uint256"}], "name"=>"getSetting", "outputs"=>[{"name"=>"", "type"=>"uint256"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"getSetting", "outputs"=>[{"name"=>"", "type"=>"address"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[], "name"=>"genEvent", "outputs"=>[], "payable"=>false, "type"=>"function"}, {"inputs"=>[{"name"=>"_setting", "type"=>"address"}], "payable"=>false, "type"=>"constructor"}, {"anonymous"=>false, "inputs"=>[{"indexed"=>true, "name"=>"_a", "type"=>"address"}, {"indexed"=>true, "name"=>"_b", "type"=>"uint256"}], "name"=>"MyEvent", "type"=>"event"}],
          "SimpleNameRegistry"=>[{"constant"=>true, "inputs"=>[{"name"=>"", "type"=>"address"}], "name"=>"aEntries", "outputs"=>[{"name"=>"", "type"=>"bytes32"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[{"name"=>"_a", "type"=>"address"}, {"name"=>"_n", "type"=>"bytes32"}], "name"=>"register", "outputs"=>[], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[{"name"=>"_n", "type"=>"bytes32"}], "name"=>"getAddress", "outputs"=>[{"name"=>"a", "type"=>"address"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[], "name"=>"sampleBoolRetFalse", "outputs"=>[{"name"=>"b", "type"=>"bool"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"first", "outputs"=>[{"name"=>"", "type"=>"uint8"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[{"name"=>"", "type"=>"bytes32"}], "name"=>"nEntries", "outputs"=>[{"name"=>"", "type"=>"address"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"second", "outputs"=>[{"name"=>"", "type"=>"uint16"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[{"name"=>"_a", "type"=>"address"}], "name"=>"getName", "outputs"=>[{"name"=>"n", "type"=>"bytes32"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"fourth", "outputs"=>[{"name"=>"", "type"=>"bytes8"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[], "name"=>"sampleBoolRetTrue", "outputs"=>[{"name"=>"b", "type"=>"bool"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[{"name"=>"_b", "type"=>"bool"}], "name"=>"sampleBool", "outputs"=>[], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"third", "outputs"=>[{"name"=>"", "type"=>"uint32"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"threeParams", "outputs"=>[{"name"=>"a", "type"=>"address"}, {"name"=>"b", "type"=>"bytes32"}, {"name"=>"c", "type"=>"uint256"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[{"name"=>"_b", "type"=>"bool"}, {"name"=>"_a", "type"=>"bytes32"}, {"name"=>"_c", "type"=>"int8"}, {"name"=>"_d", "type"=>"bytes4"}], "name"=>"sampleMulti", "outputs"=>[], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"sixth", "outputs"=>[{"name"=>"", "type"=>"bytes32"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"fifth", "outputs"=>[{"name"=>"", "type"=>"bytes16"}], "payable"=>false, "type"=>"function"}, {"inputs"=>[], "payable"=>false, "type"=>"constructor"}],
          "SimpleContract"=>[{"inputs"=>[], "payable"=>false, "type"=>"constructor"}]
      }

      contract_names.each do |contract_name|
        expect(output[contract_name]).to have_key("info")
        expect(output[contract_name]["info"]).to include(
                                                     "abiDefinition" => abi_def[contract_name],
                                                 )
      end
    end
  end


  describe "compile one file with import" do

    let(:file){File.join(FIXTURES_PATH,"/OwnedContract.sol")}
    let(:output){subject.compile(file)}
    let(:contract_name){"OwnedContract"}

    it "returns compiled code" do
      expect(output).to have_key(contract_name)
      expect(output[contract_name]).to have_key("code")
    end

    it "returns abi definition" do
      expect(output[contract_name]).to have_key("info")

      expect(output[contract_name]["info"]).to include(
                                                   "abiDefinition" => [{"constant"=>false, "inputs"=>[], "name"=>"getMyVar", "outputs"=>[{"name"=>"var_value", "type"=>"uint256"}], "payable"=>false, "type"=>"function"}, {"constant"=>true, "inputs"=>[], "name"=>"owner", "outputs"=>[{"name"=>"", "type"=>"address"}], "payable"=>false, "type"=>"function"}, {"constant"=>false, "inputs"=>[{"name"=>"newOwner", "type"=>"address"}], "name"=>"changeOwner", "outputs"=>[], "payable"=>false, "type"=>"function"}, {"inputs"=>[], "payable"=>false, "type"=>"constructor"}, {"anonymous"=>false, "inputs"=>[{"indexed"=>false, "name"=>"newOwner", "type"=>"address"}, {"indexed"=>false, "name"=>"previousOwner", "type"=>"address"}], "name"=>"OwnerChanged", "type"=>"event"}]
                                               )
    end

  end
end