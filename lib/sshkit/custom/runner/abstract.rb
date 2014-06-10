module SSHKit
  module Custom
    module Runner
      ExecuteError = SSHKit::Runner::ExecuteError

      class Abstract
        attr_accessor :backends
        attr_reader :options
        attr_writer :wait_interval

        def self.create_runner(opts)
          opts_with_defaults = { in: :parallel }.merge(opts)

          case opts_with_defaults[:in]
          when :parallel
            Parallel
          when :sequence
            Sequential
          when :groups
            Group
          else
            fail "Don't know how to handle run style #{opts_with_defaults[:in].inspect}"
          end.new(opts_with_defaults)
        end

        def self.scope_storage
          ScopedStorage::ThreadLocalStorage
        end

        def self.scope
          @scope ||= ScopedStorage::Scope.new('sshkit_runner', scope_storage)
        end

        def self.active_backend
          scope[:active_backend] || fail(ArgumentError, 'Backend not set')
        end

        def self.active_backend=(new_backend)
          scope[:active_backend] = new_backend
        end

        def initialize(options = nil)
          @options = options || {}
        end

        def active_backend
          self.class.active_backend
        end

        def active_backend=(new_backend)
          self.class.active_backend = new_backend
        end

        def send_cmd(cmd, *args, &block)
          args = Array(block.call(active_backend.host)) if block
          active_backend.send(cmd, *args)
        rescue => e
          e2 = ExecuteError.new e
          raise e2, "Exception while executing on host #{active_backend.host}: #{e.message}"
        end

        def apply_block_to_bcks(&_block)
          fail SSHKit::Backend::MethodUnavailableError
        end

        def apply_to_bck(backend, &block)
          self.active_backend = backend
          block.call(backend.host)
         rescue => e
          e2 = ExecuteError.new e
          raise e2, "Exception while executing on host #{backend.host}: #{e.message}"
        ensure
          self.active_backend = nil
        end

        def do_wait
          sleep wait_interval
        end

        protected

        def wait_interval
          @wait_interval || options[:wait] || 2
        end
      end
    end
  end
end
