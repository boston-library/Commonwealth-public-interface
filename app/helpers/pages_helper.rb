require 'rss'

module PagesHelper

  def render_dc_blog_feed
    source = 'http://blog.digitalcommonwealth.org/?feed=rss2'
    feed = Rails.cache.fetch('dc_rss_feed', :expires_in => 60.minutes) do
      RSS::Parser.parse(open(source).read, false).items[0..3]
    end
    if feed.length > 0
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
                  'Visit ' + link_to('Digital Commonwealth News & Announcements',
                                         blog_path,
                                         :target => '_blank') + ' for the latest updates.')
    end

  end

end
