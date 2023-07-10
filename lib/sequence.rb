class Sequence
    def initialize(parent)
        @time = 0
        @events = []

        @parent = parent
    end

    def wait(time)
        @time += time
    end

    def events(&block)
        if block_given?
            sequence = Sequence.new(@parent)

            sequence.instance_eval(&block)

            @events << {
                time: @time,
                sequence: sequence
            }
        else
            @events
        end
    end

    def reset()
        @time = 0
    end

    def update(delta)
        @time += delta

        @events.delete_if do |event|
            if event[:time] <= @time
                if event[:sequence]
                    sequence = event[:sequence]

                    if sequence.events.empty?
                        true
                    else
                        sequence.update(delta)
                    end
                else
                    @parent.send(
                        event[:method],
                        *event[:arguments],
                        &event[:block]
                    )

                    true
                end
            end
        end
    end

    def define(method, value)
        define_singleton_method(method) do
            value
        end
    end

    def method_missing(method, *arguments, &block)
        @events << {
            time: @time,
            block: block,
            method: method,
            arguments: arguments
        }
    end
end