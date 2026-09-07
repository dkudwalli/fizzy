module Card::Releasable
  extend ActiveSupport::Concern

  included do
    normalizes :release, with: -> { it.strip.presence }
  end

  class_methods do
    def releases
      where.not(release: nil).distinct.order(:release).pluck(:release)
    end
  end

  def released_in?(name)
    release == self.class.normalize_value_for(:release, name)
  end
end
