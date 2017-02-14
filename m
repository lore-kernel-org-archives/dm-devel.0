From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 0/7] misc patches
Date: Mon, 13 Feb 2017 22:06:46 -0600
Message-ID: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Here's a couple of minor features bugfixes and cleanups. The biggest
change is that the detect_checker option now sets the checker for
devices with detected ALUA to TUR. Also, udev wasn't correctly
disabling rules for multipath devices that lost their last usable
path through a table reload. This was causing lvmetad some problems
on failing multipath devices.

Differences from v1:

libmultipath: add detect_checker option
----------------------------------------
Whether a path is alua or not is now checked once during pathinfo. I'm
assuming that devices that can be optionally configured in ALUA mode
will not switch modes while the device is present. If that's not the
case, then the user would need to run "multipathd reconfigure" or reload
the service to recheck if the device is in alua mode.  multipathd used
to also rerun the detection code whenever a path was orphaned. I can add
that ability to this version as well, but it doesn't seem like the
proper place to recheck.

fix udev rules for failed multipath devices
-------------------------------------------
I fixed some typos, and changed how the rules determine if an event was
triggered by device-mapper or not, since my previous version didn't
handle coldplug events correctly.

Benjamin Marzinski (7):
  kpartx: don't keep creating recursive partitions
  libmultipath: add detect_checker option
  libmultipath: cleanup orphan device states
  multipathd: don't update priority of failed paths
  multipathd: add messages on delayed path addition
  multipathd: allow resetting stats
  fix udev rules for failed multipath devices

 kpartx/dos.c                |  2 +-
 libmultipath/config.c       |  3 ++
 libmultipath/config.h       |  2 ++
 libmultipath/defaults.h     |  1 +
 libmultipath/devmapper.c    |  3 +-
 libmultipath/devmapper.h    |  6 ++++
 libmultipath/dict.c         | 10 +++++++
 libmultipath/discovery.c    | 29 ++++++++++++++++++--
 libmultipath/hwtable.c      |  1 +
 libmultipath/print.c        |  4 +--
 libmultipath/propsel.c      | 32 +++++++++++++++-------
 libmultipath/propsel.h      |  1 +
 libmultipath/structs.h      | 14 ++++++++++
 multipath/11-dm-mpath.rules | 67 +++++++++++++++++++++++++++++++--------------
 multipath/multipath.conf.5  | 18 ++++++++++++
 multipathd/cli.c            |  2 ++
 multipathd/cli_handlers.c   | 44 +++++++++++++++++++++++++++++
 multipathd/cli_handlers.h   |  2 ++
 multipathd/main.c           |  8 +++++-
 19 files changed, 212 insertions(+), 37 deletions(-)

-- 
1.8.3.1
