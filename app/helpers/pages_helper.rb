require 'rss'

module PagesHelper

  def should_autofocus_on_search_box?
    action_name == 'home' ? true : false
  end

  def render_dc_blog_feed
    source = 'http://digitalcommonwealth.org/blog/?feed=rss2'
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
                  'Visit the ' + link_to('Digital Commonwealth News Blog',
                                         'http://digitalcommonwealth.org/blog/',
                                         :target => '_blank') + ' for the latest updates.')
    end

  end


  def pers_namePartSplitter(inputstring)
    splitNamePartsHash = Hash.new
    unless inputstring =~ /\d{4}/
      splitNamePartsHash[:namePart] = inputstring
    else
      if inputstring =~ /\(.*\d{4}.*\)/
        splitNamePartsHash[:namePart] = inputstring
      else
        splitNamePartsHash[:namePart] = inputstring.gsub(/,[\d\- \.\w?]*$/,"")
        splitArray = inputstring.split(/.*,/)
        splitNamePartsHash[:datePart] = splitArray[1].strip
      end
    end
    return splitNamePartsHash
  end

  def corp_namePartSplitter(inputstring)
    splitNamePartsArray = Array.new
    unless inputstring =~ /[\S]{5}\./
      splitNamePartsArray << inputstring
    else
      while inputstring =~ /[\S]{5}\./
        snip = /[\S]{5}\./.match(inputstring).post_match
        subpart = inputstring.gsub(snip,"")
        splitNamePartsArray << subpart.gsub(/\.\z/,"").strip
        inputstring = snip
      end
      splitNamePartsArray << inputstring.gsub(/\.\z/,"").strip
    end
    return splitNamePartsArray
  end

end
