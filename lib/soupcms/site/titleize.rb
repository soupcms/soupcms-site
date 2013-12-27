class Titleize
  SMALL_WORDS = %w{a an and as at but by en for if in of on or the to v v. via vs vs.}

  def titleize(title)
    title = title.dup.gsub('_',' ').gsub('#','')
    title.downcase! unless title[/[[:lower:]]/] # assume all-caps need fixing

    phrases(title).map do |phrase|
      words = phrase.split
      words.map do |word|
        def word.capitalize
          # like String#capitalize, but it starts with the first letter
          self.sub(/[[:alpha:]].*/) { |subword| subword.capitalize }
        end

        case word
          when /[[:alpha:]]\.[[:alpha:]]/ # words with dots in, like "example.com"
            word
          when /[-‑]/ # hyphenated word (regular and non-breaking)
            word.split(/([-‑])/).map do |part|
              SMALL_WORDS.include?(part) ? part : part.capitalize
            end.join
          when /^[[:alpha:]].*[[:upper:]]/ # non-first letter capitalized already
            word
          when /^[[:digit:]]/ # first character is a number
            word
          when words.first, words.last
            word.capitalize
          when *(SMALL_WORDS + SMALL_WORDS.map { |small| small.capitalize })
            word.downcase
          else
            word.capitalize
        end
      end.join(" ")
    end.join(" ")
  end

  # Splits a title into an array based on punctuation.
  #
  #   "simple title"              # => ["simple title"]
  #   "more complicated: titling" # => ["more complicated:", "titling"]
  def phrases(title)
    phrases = title.scan(/.+?(?:[:.;?!] |$)/).map { |phrase| phrase.strip }

    # rejoin phrases that were split on the '.' from a small word
    if phrases.size > 1
      phrases[0..-2].each_with_index do |phrase, index|
        if SMALL_WORDS.include?(phrase.split.last.downcase)
          phrases[index] << " " + phrases.slice!(index + 1)
        end
      end
    end

    phrases
  end


end