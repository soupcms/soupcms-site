require 'spec_helper'

describe Titleize do

  it { expect(Titleize.new.titleize('title of the page')).to eq('Title of the Page') }
  it { expect(Titleize.new.titleize('##title of the page')).to eq('Title of the Page') }
  it { expect(Titleize.new.titleize('title_of_the_page')).to eq('Title of the Page') }

end