class LegalController < ApplicationController
  def terms
    @custom_title = 'Terms of Use'
    @custom_description = 'The Terms of Use for CodeDoor, the marketplace for freelance programmers that have contributed to open source software.'
  end
end
