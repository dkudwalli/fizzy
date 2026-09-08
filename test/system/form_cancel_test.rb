require "application_system_test_case"

class FormCancelTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:david))
    @card = cards(:layout)
  end

  # The comment form binds keydown.esc->form#cancel but has no "cancel" target,
  # so an unguarded this.cancelTarget read threw in the browser console.
  test "escaping a form without a cancel target raises no console error" do
    visit card_url(@card)
    find("lexxy-editor").click
    send_keys :escape

    assert_empty console_errors.grep(/Missing target element/)
  end

  private
    def console_errors
      page.driver.browser.logs.get(:browser).select { |entry| entry.level == "SEVERE" }.map(&:message)
    end
end
