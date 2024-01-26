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

package Foswiki::Plugins::WebLinkPlugin::Core;

=begin TML

---+ package WebLinkPlugin::Core

=cut

use strict;
use warnings;

use Foswiki::Func ();
use constant TRACE => 0; # toggle me

=begin TML

---++ new

constructor

=cut

sub new {
  my $class = shift;

  my $this = bless({@_}, $class);

  return $this;
}

=begin TML

---++ WEBLINK($session, $params, $theTopic, $theWeb) -> $result

implementation of this macro

=cut

sub handleWEBLINK {
  my ($this, $session, $params, $topic, $web) = @_;

  _writeDebug("called WEBLINK()");

  # get params
  my $theWeb = $params->{_DEFAULT} || $params->{web} || $web;
  my $theName = $params->{name};
  my $theMarker = $params->{marker} || 'current';
  my $theClass = $params->{class} || 'webLink';

  my $defaultFormat =
    '<a class="'.$theClass.' $marker" href="$url" title="%ENCODE{"$tooltip" type="html"}%">$title</a>';

  my $theFormat = $params->{format} || $defaultFormat;

  #_writeDebug("theFormat=$theFormat, theWeb=$theWeb");

  my $theSummary = $params->{summary} || 
    Foswiki::Func::getPreferencesValue('WEBSUMMARY', $theWeb) || 
    Foswiki::Func::getPreferencesValue('SITEMAPUSETO', $theWeb) || '';
  my $theTooltip = $params->{tooltip} || $theSummary;

  my $homeTopic = Foswiki::Func::getPreferencesValue('HOMETOPIC') 
    || $Foswiki::cfg{HomeTopicName} 
    || 'WebHome';

  my $theUrl = $params->{url} ||
    $session->getScriptUrl(0, 'view', $theWeb, $homeTopic);

  # unset the marker if this is not the current web 
  $theMarker = '' unless $theWeb eq $session->{webName};

  # normalize web name
  $theWeb =~ s/\//\./g;

  # get a good default name
  unless ($theName) {
    $theName = $theWeb;
    $theName = $2 if $theName =~ /^(.*)[\.](.*?)$/;
  }

  my $title = '';
  if ($theFormat =~ /\$title/) {
    $title = Foswiki::Func::getTopicTitle($theWeb, $homeTopic);
    $title = $theName if $title eq $homeTopic;
  }

  my $result = $theFormat;
  $result =~ s/\$default/$defaultFormat/g;
  $result =~ s/\$marker/$theMarker/g;
  $result =~ s/\$url/$theUrl/g;
  $result =~ s/\$tooltip/$theTooltip/g;
  $result =~ s/\$summary/$theSummary/g;
  $result =~ s/\$name/$theName/g;
  $result =~ s/\$title/$title/g;
  $result =~ s/\$web/$theWeb/g;
  $result =~ s/\$topic/$homeTopic/g;

  #_writeDebug("result=$result");
  return Foswiki::Func::decodeFormatTokens($result);
}

# statics
sub _writeDebug {
  print STDERR "WebLinkPlugin::Core - $_[0]\n" if TRACE;
}


1;
