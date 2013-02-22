module PagesHelper

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
