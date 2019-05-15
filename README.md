[![CircleCI](https://circleci.com/gh/IlluminusLimited/PinsterApi.svg?style=shield)](https://circleci.com/gh/IlluminusLimited/PinsterApi)
[![Maintainability](https://api.codeclimate.com/v1/badges/3451509b9dbfecfd7a22/maintainability)](https://codeclimate.com/github/IlluminusLimited/PinsterApi/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/3451509b9dbfecfd7a22/test_coverage)](https://codeclimate.com/github/IlluminusLimited/PinsterApi/test_coverage)

# PinsterApi

The api that brings the bacon home.


# Flows

## New Pin

1. In auth0 admin control panel make sure user has `create:pin` permission
1. Get auth0 token
1. `POST` to `/v1/pins` with a body like so:
    ```json
    {
      "data": {
        "name": "Wisconsin Unicorn",
        "year": 2009,
        "description": "This unicorn was made up, unless it exists. In that case, it is a very cool unicorn.",
      }
    }
    ```

1. Parse response for the `images_url`
1. POST to `images_url` with an empty `body` 
1. Parse response for the `image_service_token` and `image_service_url`
1. POST to `image_service_url` using the `image_service_token` as a `Bearer` token with a body like so:
    ```json
    {
      "data": {
        "image": "base64 encoded image",
        "name": "Optional name of image",
        "description": "Optional description",
        "featured": "Optional ISO8601 format"
      }
    }
    ```
1. Image service will  process your image and if it passes moderation it will `POST` back to the api 
    on your behalf, linking the image to your imageable (pin in this case).


# Deployment

Checklist

1. Generate new `OpenSSL::PKey::RSA.generate(2048)` keys for image service and pinster api.
    Use `rails generate_keys` and the `keys.env` file will contain urlsafe base64 encoded keys
    for use in environment variables.
1. Set environment variables in elasticbeanstalk configure thing.
1. Set environment variables in secrets manager for image service's keys


# .env setup

```dotenv
AUTH0_SITE=AUTH0_SITE_url
JWT_AUD=hosted_address
```


Things to remember for prod push:
1. run on ec2 instance
    ```ruby
          PgSearch::Multisearch.rebuild(Pin, true)
          PgSearch::Multisearch.rebuild(Assortment, true)
    ```

1. Set these envs:
    ```dotenv
    AUTH0_SITE=
    JWT_AUD=
    SWAGGER_HOST=
    SEED_USER_ID=
    RDS_DB_NAME=
    RDS_HOSTNAME=
    RDS_PASSWORD=
    RDS_PORT=
    RDS_USERNAME=
    SECRET_KEY_BASE=
    ```
1. Set up auth0