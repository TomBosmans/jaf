# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

json_synonyms = Mime::Type.lookup('application/json')
                          .send(:synonyms)
                          .push('application/vnd.api+json')

Mime::Type.register 'application/json', :json, json_synonyms
