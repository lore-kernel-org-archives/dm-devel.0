From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 0/6] misc patches
Date: Mon, 27 Feb 2017 12:26:37 -0600
Message-ID: <1488220003-20541-1-git-send-email-bmarzins@redhat.com>
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

Differences from v3:
Rebased patches

Benjamin Marzinski (6):
  libmultipath: add detect_checker option
  libmultipath: cleanup orphan device states
  multipathd: don't update priority of failed paths
  multipathd: add messages on delayed path addition
  multipathd: allow resetting stats
  fix udev rules for failed multipath devices

 libmultipath/config.c                 |  3 ++
 libmultipath/config.h                 |  2 ++
 libmultipath/defaults.h               |  1 +
 libmultipath/devmapper.c              |  3 +-
 libmultipath/devmapper.h              |  6 ++++
 libmultipath/dict.c                   | 10 ++++++
 libmultipath/discovery.c              | 28 +++++++++++++--
 libmultipath/hwtable.c                |  1 +
 libmultipath/print.c                  |  4 +--
 libmultipath/prioritizers/alua_spc3.h |  1 +
 libmultipath/propsel.c                | 31 ++++++++++------
 libmultipath/propsel.h                |  1 +
 libmultipath/structs.c                |  2 ++
 libmultipath/structs.h                |  7 ++++
 multipath/11-dm-mpath.rules           | 67 ++++++++++++++++++++++++-----------
 multipath/multipath.conf.5            | 18 ++++++++++
 multipathd/cli.c                      |  2 ++
 multipathd/cli_handlers.c             | 44 +++++++++++++++++++++++
 multipathd/cli_handlers.h             |  2 ++
 multipathd/main.c                     |  8 ++++-
 20 files changed, 205 insertions(+), 36 deletions(-)

-- 
1.8.3.1
