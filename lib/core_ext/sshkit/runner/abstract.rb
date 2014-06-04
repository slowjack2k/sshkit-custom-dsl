module SSHKit
  module Runner
    class Abstract
      attr_accessor :backends

      def active_backend
        self.class.active_backend
      end

      def active_backend=(new_backend)
        self.class.active_backend=new_backend
      end

      def self.active_backend
        Thread.current[:active_backend]
      end

      def self.active_backend=(new_backend)
        Thread.current[:active_backend]=new_backend
      end

      def send_cmd(cmd, *args, &block)

        begin

          if block
            args = Array(block.call(active_backend.host))
          end

          active_backend.send(cmd, *args)

        rescue Exception => e
          e2 = ExecuteError.new e
          raise e2, "Exception while executing on host #{active_backend.host}: #{e.message}"
        end

      end

    end
  end
end