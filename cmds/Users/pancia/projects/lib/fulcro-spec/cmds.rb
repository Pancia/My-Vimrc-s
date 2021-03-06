module CMD
  def test(opts)
    opts.banner = "Usage: test"
    opts.info = "Run clojure tests"
    lambda { |*args|
      EXE.system %{
        clj -A:tee:clj-tests \
          --config-file tests.local.edn \
          --focus-meta :test/focused \
          --watch \
          #{args.join " "}
      }
    }
  end
  def repl(opts)
    opts.banner = "Usage: repl"
    opts.info = "Run clojure repl"
    lambda { |*args|
      EXE.system %{
        clj -A:nREVL:test #{args.join " "}
      }
    }
  end
end

trap "SIGINT" do
  exit 130
end
