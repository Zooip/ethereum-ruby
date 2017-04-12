module Ethereum
  class Compiler

    private

      def filter_file_path_from hash
        Hash[hash.map{|k,v|[k.split(':').last,v]}]
      end

  end

  class RpcCompiler < Compiler

    def initialize(client = Ethereum::IpcClient.new)
      @client=client
    end

    def compile(files)
      [*files].each_with_object({}) { |file,hash| hash.merge!(compile_one(file)) }
    end

    def compile_one(file)
      @file = File.read(file)
      result=@client.eth_compile_solidity(@file)
      raise "CompilationError : #{result["error"]}" if result["error"]
      filter_file_path_from(result["result"])
    end

  end

  class SolcCompiler < Compiler

    def initialize(solc_command = '/usr/bin/solc')
      @solc_command=solc_command
    end

    def compile(files)
      params=[]
      params<<"--combined-json bin,abi,userdoc,devdoc"
      params<<"--optimize"

      elmts=[]
      elmts<<@solc_command.to_s
      elmts<<params.join(" ")
      elmts<<[*files].join(" ")

      command=elmts.join(" ")

      puts command

      output= JSON.parse(`#{command}`)

      filter_file_path_from(output["contracts"].map{|k,v| [k,convert_to_geth_output(v,output["version"],params.join(" "))]}.to_h)
    end

    private

    def convert_to_geth_output(h,version,params)
      {
          "code" =>h['bin'],
          "info" => {
              "source" => nil,
              "language"=> "Solidity",
              "languageVersion"=> version,
              "compilerVersion"=> version,
              "compilerOptions"=> params,
              "abiDefinition"=> JSON.parse(h["abi"]),
              "userDoc"=> JSON.parse(h["userdoc"]),
              "developerDoc"=> JSON.parse(h['devdoc'])

          }
      }
    end

  end
end

