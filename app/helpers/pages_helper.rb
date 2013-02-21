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
    end
    return splitNamePartsArray

  end

end
