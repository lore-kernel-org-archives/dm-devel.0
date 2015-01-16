From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/8] Misc multipath patches.
Date: Fri, 16 Jan 2015 14:23:24 -0600
Message-ID: <1421439812-11826-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

The first three of these patches are resends of earlier patches, just
rebased.  The next three are all related to adding support for deferred
removes to multipath.  With the deferred_remove option set to "yes"
mutipathed will now use the new device-mapper deferred remove funationality
to do deferred removes on multipath devices that are sill open when the
last of their paths has been removed.  This will cause the devices to get
removed when the last user closes them, unless a path has not reappeared,
and cancelled the deferred remove.  The last two are new bugfixes.

Benjamin Marzinski (8):
  correctly set partition delimiter on rename
  libmultipath: fix sysfs_get_size bug
  Revert "libmultipath: fixup strlcpy"
  libmultipath: refactor partmaps code
  multipathd: fix memory corruption issue
  multipathd: add deferred_remove support
  multipathd: don't buffer output with systemd
  libmutipath: allow blanks in device blacklist

 libmultipath/Makefile      |   6 +
 libmultipath/blacklist.c   |  16 ++-
 libmultipath/config.c      |   5 +
 libmultipath/config.h      |   4 +
 libmultipath/configure.c   |   1 +
 libmultipath/defaults.h    |   1 +
 libmultipath/devmapper.c   | 284 +++++++++++++++++++++++++++++----------------
 libmultipath/devmapper.h   |  11 +-
 libmultipath/dict.c        |  17 +++
 libmultipath/propsel.c     |  26 +++++
 libmultipath/propsel.h     |   1 +
 libmultipath/structs.h     |   8 ++
 libmultipath/structs_vec.c |   3 +-
 libmultipath/sysfs.c       |   2 +-
 libmultipath/util.c        |   3 +-
 multipath/multipath.conf.5 |  14 +++
 multipathd/main.c          |  34 ++++--
 17 files changed, 317 insertions(+), 119 deletions(-)

-- 
1.8.3.1
