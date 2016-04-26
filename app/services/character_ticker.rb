class CharacterTicker < ActiveInteraction::Base
  interface :subject,
            methods: %i(action_details current_action move_towards lon lat attack_range latlng)
  integer :tick_count

  def execute
    handle_current_action
    # handle_hunger
    # handle_thirst

    if character.changed?
      character.save
    end
  end

  private

  def handle_current_action
    target_lat = character.action_details.try(:[], 'target_lat')
    target_lon = character.action_details.try(:[], 'target_lon')
    case character.current_action
    when 'move'
      character.move_towards([target_lat, target_lon]) do
        character.current_action = nil
        character.action_details = nil
      end
    when 'search'
      character.move_towards([target_lat, target_lon]) do
        Search.run(character: character)
        character.current_action = nil
        character.action_details = nil
      end
    else
      # Default action: attack the closest zombie, if they're in range
      zombie = Zombie.closest_to(character.lon, character.lat)
      if zombie.present?
        if character.latlng.distance(zombie.latlng) / 1000 <= character.attack_range
          character.attack(zombie, tick_count)
        end
      end
    end
  end

  def character
    subject
  end
end
