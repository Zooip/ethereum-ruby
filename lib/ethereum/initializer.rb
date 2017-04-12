module Ethereum

  class Initializer

    # @todo Allow usage of precompiled contracts

    attr_accessor :contracts, :file, :client

    def initialize(files, client = Ethereum::IpcClient.new, compiler: Ethereum::SolcCompiler.new)
      @client = client
      compiler_output = compiler.compile(files)
      contracts = compiler_output.keys
      @contracts = []
      contracts.each do |contract|
        abi = compiler_output[contract]["info"]["abiDefinition"]
        name = contract.split(":").last
        code = compiler_output[contract]["code"].gsub("0x","")
        @contracts << Ethereum::Contract.new(name, code, abi)
      end
    end

    def build_all
      @contracts.each do |contract|
        contract.build(@client)
      end
    end

  end
end
