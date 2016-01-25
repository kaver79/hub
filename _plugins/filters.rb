# 18F Hub - Docs & connections between team members, projects, and skill sets
#
# Written in 2014 by Mike Bland (michael.bland@gsa.gov)
# on behalf of the 18F team, part of the US General Services Administration:
# https://18f.gsa.gov/
#
# To the extent possible under law, the author(s) have dedicated all copyright
# and related and neighboring rights to this software to the public domain
# worldwide. This software is distributed without any warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication along
# with this software. If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
#
# @author Mike Bland (michael.bland@gsa.gov)

require 'jekyll-assets'

module Hub

  # Contains Hub-specific Liquid filters.
  module Filters

    # relative URL OF team member's photo, or `nil` if their photo is missing
    def existing_photo(name, site)
      img_file_path = File.join(site['team_img_dir'], "#{name}.jpg")
      if File.exists? img_file_path
        return "/#{img_file_path}"
      else
        return nil
      end
    end

    # URL of team member's photo, or to the substitute image
    # when their photo is missing
    def photo_or_placeholder(name, site)
      return (existing_photo(name, site) ||
        "/" + File.join(site['team_img_dir'], site['missing_team_member_img']))
    end

    # Breaks a YYYYMMDD timestamp into a hyphenated version: YYYY-MM-DD
    # +timestamp+:: timestamp in the form YYYYMMDD
    def hyphenate_yyyymmdd(timestamp)
      Canonicalizer.hyphenate_yyyymmdd timestamp
    end

    # Returns a canonicalized, URL-friendly substitute for an arbitrary string.
    # +s+:: string to canonicalize
    def canonicalize(s)
      Canonicalizer.canonicalize s
    end

    # Chops off the suffix from s, if s ends with suffix.
    def trim_suffix(s, suffix)
      s.end_with? suffix and s[0..-(suffix.length + 1)] or s
    end

    # Retrieves the asset_path for a search component.
    # This is to make the path compatible with require.js.
    def require_js_asset_path(path)
      # Digging into the jekyll-assets internals here, since we can't invoke
      # the Filter directly. https://github.com/jekyll/jekyll-help/issues/97
      r = ::Jekyll::AssetsPlugin::Renderer.new @context, path
      path = r.render_asset_path
      path.end_with? '.js' and path[0..-('.js'.length + 1)] or path
    end

    # Because checking class types in Jekyll does not seem to work,
    # we wrap a check for of data type as a filter
    def is_hash?(data)
      return data.is_a? Hash
    end
  end
end

Liquid::Template.register_filter(Hub::Filters)
