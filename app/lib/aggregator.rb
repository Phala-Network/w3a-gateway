# frozen_string_literal: true

class Aggregator
  attr_reader :site

  def initialize(site)
    @site = site
  end

  def collect(page_view)
    raise NotImplementedError
  end

  def rotate!
    raise NotImplementedError
  end
end
