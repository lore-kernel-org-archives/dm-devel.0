From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/7] misc patches
Date: Fri, 10 Feb 2017 23:28:45 -0600
Message-ID: <1486790932-30917-1-git-send-email-bmarzins@redhat.com>
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
 libmultipath/discovery.c    |  1 +
 libmultipath/hwtable.c      |  1 +
 libmultipath/print.c        |  4 +--
 libmultipath/propsel.c      | 59 +++++++++++++++++++++++++++++++-------
 libmultipath/propsel.h      |  1 +
 libmultipath/structs.h      |  7 +++++
 multipath/11-dm-mpath.rules | 69 +++++++++++++++++++++++++++++++--------------
 multipath/multipath.conf.5  | 18 ++++++++++++
 multipathd/cli.c            |  2 ++
 multipathd/cli_handlers.c   | 44 +++++++++++++++++++++++++++++
 multipathd/cli_handlers.h   |  2 ++
 multipathd/main.c           |  8 +++++-
 19 files changed, 207 insertions(+), 36 deletions(-)

-- 
1.8.3.1
