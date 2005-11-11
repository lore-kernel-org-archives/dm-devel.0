From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.6
Date: Fri, 11 Nov 2005 23:05:27 +0100
Message-ID: <1131746727.7463.96.camel@zezette>
Reply-To: christophe.varoqui@free.fr
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Hello,

here goes multipath-tools-0.4.6.

Distributors using mostly-unmodified upstream package are encouraged to
upgrade. This version brings important bugfixes and nice new features,
including :

* add/del cli commands accept map names as param
  * new add "reinstate/fail" cli commands
  * new add "suspend/resume" cli commands
  * extended information display in "show map/paths" cli commands
  * fix thread reaping logic
  * user friendly map names (mpath[0..n]) without alias defines (!!!
    warning : chances are your current device naming will change !!!)
  * option to disable io queueing if no valid path after a delay
  * vendor/product as regexp in config file
  * set devmap uuid as multipath wwid
  * move hotplug logic to udev's rules.d/
  * configlets now adds up or replace the hardcoded ones
  * ALUA prioritizer update
  * option to use priorities as weights in the round-robin scheduler
  * add the directio checker

As usual, doc and download at :
http://christophe.varoqui.free.fr/

Archive mirror at ftp://sources.redhat.com/pub/dm/multipath-tools/

Regards,
cvaroqui


