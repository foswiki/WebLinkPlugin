# Plugin for Foswiki - The Free and Open Source Wiki, http://foswiki.org/
#
# WebLinkPlugin is Copyright (C) 2010-2024 Michael Daum http://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::WebLinkPlugin;

use strict;
use warnings;

=begin TML

---+ package WebLinkPlugin

=cut

use Foswiki::Func ();

our $VERSION = '2.01';
our $RELEASE = '%$RELEASE%';
our $SHORTDESCRIPTION = 'A parametrized %WEB macro';
our $LICENSECODE = '%$LICENSECODE%';
our $NO_PREFS_IN_TOPIC = 1;
our $core;

=begin TML

---++ initPlugin($topic, $web, $user) -> $boolean

=cut

sub initPlugin {

  Foswiki::Func::registerTagHandler('WEBLINK', sub {
    return getCore()->handleWEBLINK(@_);
  });

  return 1;
}

sub finishPlugin {
  undef $core;
}

sub getCore {

  unless (defined $core) {
    require Foswiki::Plugins::WebLinkPlugin::Core;
    $core = Foswiki::Plugins::WebLinkPlugin::Core->new();
  }

  return $core;
}

1;
