From: mwilck@suse.com
Subject: [PATCH v2 00/21] multipath-tools: shutdown,
	libdevmapper races, globals
Date: Thu, 24 Sep 2020 15:36:55 +0200
Message-ID: <20200924133716.14120-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

this series contains a number of patches I've wanted to do for some
time. It's based on my "upstream-queue" tree
(https://github.com/openSUSE/multipath-tools/tree/upstream-queue),
plus my previously submitted "multipath-tools:add linker version scripts"
series. The reason is that this series contains a number of ABI
changes, and is thus suitable for demonstrating how to work with
the libmultipath linker version scripts.

Patch 1-8 are related to multipathd shutdown and systemd notifcation.
Patch 1 and 8 have been part of my earlier series "multipath-tools: 
Fix remaining shutdown delay issues" from Jan, 2019. But this is so
long ago that I didn't mark this as a v2. I have tried to address
Ben's issues with #1 (size_mismatch_seen leak, and premature sd_notify)
(https://www.redhat.com/archives/dm-devel/2019-January/msg00097.html).
#8 is just resent, after the recent discussion
(https://www.redhat.com/archives/dm-devel/2020-August/msg00342.html).
Ben's remark about sd_notify() drove me to reexamine that feature,
and actually improve a little by informing systemd of shutdown and
reconfigure operations.

Patch 9-11 are an attempt to fix races in libdevmapper, as discussed
a while ago in the "fix fd leak when iscsi device logs in" thread
(https://www.redhat.com/archives/dm-devel/2020-July/msg00321.html and
references).

Patch 12ff. add definitions of the symbol get_multipath_config(),
put_multipath_config(), udev, and logsink to libmultipath. This way
callers won't have to bother with defining these global symbols any
more in the future (but they still can).

Changes v1 -> v2:

 - rebased on "version script" series. Some patches which modify the
   ABI (10, 11, 13, 14, 17) have the respective hunks added.
 - 10/21: Added fix for the hwtable unit test. added comments.
   avoid logging a version that couldn't be determined.
 - 11/21: renamed libmp_task_run -> libmp_dm_task_run
 - 13/21: get_multipath_config(): return NULL if not initialized
   zero out configuration in _uninit_config() (Ben)
 - 17/21: Changed initialization as discussed with Ben. Added documentation
   in config.h.
 - 19/21: This one is new, as suggested by Ben
 - 20/21: This was 19 before, simplified now as the real changes are
   in libmpathpersist.
 - 21/21: New, also remove the globals in multipathd.

Regards
Martin

Martin Wilck (21):
  multipathd: allow shutdown during configure()
  multipathd: avoid sending "READY=1" to systemd on early shutdown
  multipathd: send "STOPPING=1" to systemd on shutdown
  multipathd: send "RELOADING=1" to systemd on DAEMON_CONFIGURE state
  multipathd: use volatile qualifier for running_state
  multipathd: generalize and fix wait_for_state_change_if()
  multipathd: set_config_state(): avoid code duplication
  multipathd: cancel threads early during shutdown
  multipath-tools: don't call dm_lib_release() any more
  libmultipath: devmapper: refactor libdm version determination
  libmultipath: protect racy libdevmapper calls with a mutex
  libmultipath: constify file argument in config parser
  libmultipath: provide defaults for {get,put}_multipath_config
  libmpathpersist: allow using libmultipath {get,put}_multipath_config
  multipath: use {get_put}_multipath_config from libmultipath
  mpathpersist: use {get,put}_multipath_config() from libmultipath
  libmultipath: add udev and logsink symbols
  multipath: remove logsink and udev
  libmpathpersist: call libmultipath_{init,exit}()
  mpathpersist: remove logsink and udev
  multipathd: remove logsink and udev

 kpartx/kpartx.c                         |   1 -
 libmpathpersist/libmpathpersist.version |   6 +
 libmpathpersist/mpath_persist.c         |  50 ++++-
 libmpathpersist/mpath_persist.h         |  31 ++++
 libmultipath/config.c                   | 124 +++++++++++--
 libmultipath/config.h                   |  70 ++++++-
 libmultipath/configure.c                |   6 +
 libmultipath/debug.c                    |   2 +
 libmultipath/devmapper.c                | 233 ++++++++++++++++--------
 libmultipath/devmapper.h                |  13 +-
 libmultipath/discovery.c                |   3 +
 libmultipath/libmultipath.version       |  29 ++-
 libmultipath/parser.c                   |   9 +-
 libmultipath/parser.h                   |   2 +-
 libmultipath/propsel.c                  |  10 +-
 libmultipath/util.c                     |  10 +
 libmultipath/util.h                     |   2 +
 mpathpersist/main.c                     |  22 +--
 multipath/main.c                        |  28 +--
 multipathd/cli_handlers.c               |   2 -
 multipathd/dmevents.c                   |   4 +-
 multipathd/main.c                       | 126 ++++++-------
 multipathd/waiter.c                     |   2 +-
 tests/Makefile                          |   2 +-
 tests/hwtable.c                         |   3 -
 tests/test-lib.c                        |  13 ++
 26 files changed, 571 insertions(+), 232 deletions(-)

-- 
2.28.0
