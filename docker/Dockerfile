FROM ruby:3.0.0
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libmagickwand-dev yarn

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true


ADD . /app
WORKDIR /app
RUN bundle install
RUN yarn install
RUN bundle exec rake assets:precompile
RUN bundle exec rails webpacker:compile


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
ENV LDAP_HOST=
ENV LDAP_PORT=
ENV LDAP_BASE=
ENV LDAP_USER=
ENV LDAP_PASS=
ENV TIME_ZONE=


VOLUME [ "/app/storage" ]

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

