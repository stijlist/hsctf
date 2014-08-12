Feature: Registration
  Scenario: Game hasn't started yet
    Given that I have not registered
    When I pm hsctf 'register'
    Then I should be registered

