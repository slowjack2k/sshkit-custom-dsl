module SSHKit
  module Custom
    module DSL
      module Helper

        def active_backend
          SSHKit::Runner::Abstract.active_backend
        end

        def host
          active_backend.host
        end

        [:log, :debug, :fatal, :error, :warn, :info, :debug].each do |method|
          define_method method do |*args|
            active_backend.send method, *args
          end
        end

      end
    end
  end
end