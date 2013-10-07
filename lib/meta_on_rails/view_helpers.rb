module MetaOnRails
  module ViewHelpers
    def set_meta(meta = {})
      @meta = meta
    end

    def display_meta(default = {})
      meta = default.merge(@meta||{}).reject{|k,v|v.blank?}
      output=meta.map do |key, value|
        case key
        when :facebook, :custom
          value.map do |property, content|
            property = "og:#{property}" if key == :facebook
            %Q[<meta property="#{property}" content="#{normalize(content)}"/>]
          end.join("\n")
        else
          %Q[<meta name="#{key}" content="#{normalize(value)}"/>]
        end
      end.join("\n")
      Rails.version.to_i > 2 ? ActiveSupport::SafeBuffer.new(output) : output
    end

    private

    def normalize(s)
      s.gsub(/<\/?[^>]*>/, '').gsub('"',"'")
    end
  end
end
