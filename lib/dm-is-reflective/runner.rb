
require 'dm-is-reflective'

module DmIsReflective::Runner
  module_function
  def options
    @options ||=
    [['-s, --scope SCOPE'                                          ,
      'SCOPE where the models should go (default: Object)'         ],
     ['-o, --output DIRECTORY'                                     ,
      'DIRECTORY where the output goes (default: dm-is-reflective)'],
     ['-h, --help'   , 'Print this message'                        ],
     ['-v, --version', 'Print the version'                         ]]
  end

  def run argv=ARGV
    puts(help) and exit if argv.empty?
    generate(*parse(argv))
  end

  def generate uri, scope, output
    require 'fileutils'
    FileUtils.mkdir_p(output)
    DataMapper.setup(:default, uri).auto_genclass!(:scope => scope).
      each do |model|
        path = "#{output}/#{model.name.gsub(/::/, '').
                                       gsub(/([A-Z])/, '_\1').
                                       downcase[1..-1]}.rb"
        File.open(path, 'w') do |file|
          file.puts model.to_source
        end
      end
  end

  def parse argv
    uri, scope, output = ['sqlite::memory:', Object, 'dm-is-reflective']
    until argv.empty?
      case arg = argv.shift
      when /^-s=?(.+)?/, /^--scope=?(.+)?/
        name  = $1 || argv.shift
        scope = if Object.const_defined?(name)
                  Object.const_get(name)
                else
                  mkconst_p(name)
                end

      when /^-o=?(.+)?/, /^--output=?(.+)?/
        output = $1 || argv.shift

      when /^-h/, '--help'
        puts(help)
        exit

      when /^-v/, '--version'
        puts(DmIsReflective::VERSION)
        exit

      else
        uri = arg
      end
    end
    [uri, scope, output]
  end

  def mkconst_p name
    name.split('::').inject(Object) do |ret, mod|
      if Object.const_defined?(mod)
        ret.const_get(mod)
      else
        ret.const_set(mod, Module.new)
      end
    end
  end

  def help
    maxn = options.transpose.first.map(&:size).max
    maxd = options.transpose.last .map(&:size).max
    "Usage: dm-is-reflective DATABASE_URI\n" +
    options.map{ |(name, desc)|
      if desc.empty?
        name
      else
        sprintf("  %-*s  %-*s", maxn, name, maxd, desc)
      end
    }.join("\n")
  end
end
