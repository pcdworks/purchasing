FROM ruby:3.3.8

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update -qq && \
    apt-get install -y nodejs postgresql-client libmagickwand-dev && \
    corepack enable && \
    corepack prepare yarn@1.22.19 --activate

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true


ADD . /app
WORKDIR /app
RUN bundle install
RUN yarn install --frozen-lockfile
RUN bundle exec rake assets:precompile


COPY ./docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh


ENV SECRET_KEY_BASE=
ENV DEVISE_SECRET_KEY=
ENV MAILER_USER_NAME=
ENV MAILER_PASSWORD=
ENV MAILER_PORT=
ENV MAILER_ADDRESS=
ENV DATABASE_NAME=
ENV DATABASE_USER=
ENV DATABASE_PASSWORD=
ENV OAUTH_OC_PROVIDER="OpenID Connect"
ENV OAUTH_OC_PORT=443
ENV OAUTH_OC_SCHEME="https"
ENV OAUTH_OC_HOST=
ENV OAUTH_OC_CLIENT_ID=
ENV OPAUTH_OC_SECRET_KEY=
ENV OAUTH_OC_REDIRECT_URI=
ENV TIME_ZONE=
ENV LOGO=

VOLUME [ "/app/storage" ]
VOLUME [ "/app/public/style"]

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

