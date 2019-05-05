# frozen_string_literal: true

module TokenHelper
  ISS = "http://localhost:3000/"
  AUD = "http://localhost:3000"

  PRIVATE_KEY = OpenSSL::PKey::RSA.generate(2048)
  PUBLIC_KEY = PRIVATE_KEY.public_key

  def self.token(sub, permissions, exp)
    payload = {
      "iss": ISS,
      "sub": sub,
      "aud": [AUD],
      "iat": (Time.now.in_time_zone - 1.hour).to_i,
      "exp": exp,
      "scope": "openid profile email",
      "permissions": permissions
    }

    JWT.encode payload, PRIVATE_KEY, 'RS256'
  end

  def self.for_user(user, permissions = [], exp = (Time.now.in_time_zone + 20.minutes).to_i)
    token(user.external_user_id, permissions, exp)
  end

  def self.token_verifier
    lambda do |token|
      JWT.decode(token,
                 TokenHelper::PUBLIC_KEY,
                 true, # Verify the signature of this token
                 algorithm: 'RS256',
                 iss: TokenHelper::ISS,
                 verify_iss: true,
                 aud: TokenHelper::AUD,
                 verify_aud: true)
    end
  end
end