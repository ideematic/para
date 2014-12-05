module Para
  module ApplicationHelper
    include Para::SearchHelper
    include Para::ModelHelper
    include Para::OrderingHelper
    include Para::NavigationHelper
    include Para::FormHelper
    include Para::MarkupHelper
    include Para::TagHelper
    include Para::FlashHelper
  end
end
