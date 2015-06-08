require 'rss'

module PagesHelper

  def render_dc_blog_feed
    source = CommonwealthVlrEngine.config[:content][:homepage][:news][:rss_link]
    if source.present?
      feed = Rails.cache.fetch('dc_rss_feed', :expires_in => 60.minutes) do
        RSS::Parser.parse(open(source).read, false).items[0..3]
      end
    end
    if source.present? && feed.length > 0
      content = []
      feed.each do |item|
        content << content_tag(:li,
                               link_to(item.title,
                                       item.link,
                                       :class => 'feed_item_link',
                                       :target => '_blank'),
                               :class => 'feed_item')
      end
      content_tag(:ul, content.join().html_safe, :class => 'feed_items')
    else
      content_tag(:p,
                  'Visit ' + link_to(CommonwealthVlrEngine.config[:content][:homepage][:news][:non_rss_text],
                                         CommonwealthVlrEngine.config[:content][:homepage][:news][:non_rss_link],
                                         :target => '_blank') + ' for the latest updates.')
    end
  rescue
    content_tag(:p, 'No news at the moment, please check back later...')
  end

end
