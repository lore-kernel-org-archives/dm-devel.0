From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/15] Multipath patch resync
Date: Sat,  7 Mar 2015 21:31:31 -0600
Message-ID: <1425785506-20419-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

The first eight of these patches are resends of earlier patches, just
rebased with minor changes. The next two are minor changes, adding
multipath's -B option to mutipathd, and blacklisting vd.* devices.
The two after that allow multipath to read additional configuration
files in a configuration directory /etc/multipath/conf.d by default,
and then do some cleanup of the parser code that I noticed while
adding the configuration directories. The next patch adds two new
configuration parameters that allow multipathd to delay the
reintegration of paths that are failing repeatedly. The next one
fixes a hard to hit memory corruption bug, and the last one
updates the EMC builtin configuration to autodetect ALUA setups.

Benjamin Marzinski (15):
  correctly set partition delimiter on rename
  libmultipath: fix sysfs_get_size bug
  Revert "libmultipath: fixup strlcpy"
  libmultipath: refactor partmaps code
  multipathd: fix memory corruption issue
  multipathd: add deferred_remove support
  multipathd: don't buffer output with systemd
  libmutipath: allow blanks in device blacklist
  multipathd: read-only bindings
  multipath: blacklist virtio-blk devices
  multipath: enable configuration directory
  libmultipath: cleanup parser code
  multipathd: Add delayed path reintegration
  Fix doublee free of alias after map add failure
  libmultipath: autodetect ALUA CLARiiON configurations

 libmultipath/Makefile      |   6 +
 libmultipath/blacklist.c   |  18 ++-
 libmultipath/checkers.c    |   1 +
 libmultipath/checkers.h    |   9 ++
 libmultipath/config.c      |  69 ++++++++++-
 libmultipath/config.h      |  12 ++
 libmultipath/configure.c   |   3 +
 libmultipath/defaults.h    |   3 +
 libmultipath/devmapper.c   | 284 +++++++++++++++++++++++++++++----------------
 libmultipath/devmapper.h   |  11 +-
 libmultipath/dict.c        | 126 +++++++++++++++++---
 libmultipath/dict.h        |   1 +
 libmultipath/hwtable.c     |   2 +
 libmultipath/parser.c      | 173 ++++++++-------------------
 libmultipath/parser.h      |   9 +-
 libmultipath/print.c       |   2 +
 libmultipath/propsel.c     |  58 +++++++++
 libmultipath/propsel.h     |   3 +
 libmultipath/structs.h     |  17 +++
 libmultipath/structs_vec.c |   3 +-
 libmultipath/sysfs.c       |   2 +-
 libmultipath/util.c        |   3 +-
 multipath.conf.annotated   |  80 +++++++++++++
 multipath.conf.defaults    |   7 +-
 multipath/multipath.conf.5 |  54 +++++++++
 multipathd/main.c          |  86 ++++++++++----
 multipathd/multipathd.8    |   5 +
 27 files changed, 761 insertions(+), 286 deletions(-)

-- 
1.8.3.1
