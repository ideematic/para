module Para
  module SearchHelper
    def searchable_attributes(attributes)
      attributes.select do |attr|
        [:string, :text].include?(attr.type.to_sym) &&
          !attr.name.match(/password/)
      end.map(&:name).join('_or_')
    end

    def fulltext_search_param_for(attributes)
      "#{ searchable_attributes(attributes) }_cont"
    end

    def filtered?(attributes)
      params[:q] && params[:q][fulltext_search_param_for(attributes)].present?
    end
  end
end
