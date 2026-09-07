require "test_helper"

class User::FilteringTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  # Filter#cards is scoped to published cards, so a release only reachable from a
  # draft would sit in the dropdown matching nothing.
  test "releases skips releases only used by drafts" do
    cards(:layout).update!(release: "v1.2")
    cards(:layout).board.cards.create!(status: "drafted", creator: users(:david), release: "v9.9")

    assert_equal [ "v1.2" ], filtering.releases
  end

  private
    def filtering
      User::Filtering.new(users(:david), users(:david).filters.new)
    end
end
