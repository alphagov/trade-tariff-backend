# Presence validation does not need additional checks besides
# metadata
class PresenceValidationMatcher < TariffValidationMatcher
  attr_reader :condition

  def matches?(subject)
    super && matches_collection?
  end

  def failure_message
    msg = "expected #{subject.class.name} to validate #{validation_type} of #{attributes}"
    msg << " if #{condition} is true" if condition.present?
    msg
  end

  def if(condition)
    @condition = condition

    self
  end

  private

  def matches_collection?
    if condition.present?
      attributes.all? {|attribute|
        reflection_for(attribute)[:if] == condition
      }
    else
      true
    end
  end
end

def validate_presence
  PresenceValidationMatcher.new(:presence)
end