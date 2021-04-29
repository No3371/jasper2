set -e

bash scripts/build.sh

gem build moving.gemspec

bundle exec rake site:deploy --quiet