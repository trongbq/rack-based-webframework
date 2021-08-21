class QuotesController < Rulers::Controller
    def a_quote
        render :a_quote, noun: 'winking'
    end

    def show
        quote = FileModel.find(params['id'])
        render_response :quote, obj: quote, ua: request.user_agent
    end

    def index
        quotes = FileModel.all
        render :index, quotes: quotes
    end

    def new_quote
        attrs = {
            'submitter' => 'web user',
            'quote' => 'A picture is worth a thousand pixels',
            'attribution' => 'Me'
        }

        m = FileModel.create(attrs)
        render :quote, obj: m
    end

    def exception
        raise "Something wrong!"
    end
end
