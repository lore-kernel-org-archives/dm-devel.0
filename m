From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/12] Misc fixes
Date: Thu,  7 Dec 2017 12:48:54 -0600
Message-ID: <1512672546-12785-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The first patch here is just a rebased version of an earlier patch.  The last
patch is fixes for commit 95d594fd6f031e59bb73d04a631b6c592fe26214
"multipath-tools: intermittent IO error accounting to improve reliability".
The rest of the patches are various fixes and code cleanups that I've been
accumulating while working on removing the waiter threads. That work has run
into some hiccups with corner cases, so I thought I would send these cleanup
patches first, since they are generally useful, even without the waiter thread
changes.

Benjamin Marzinski (12):
  multipath: add "ghost_delay" parameter
  kpartx: don't delete partitions from partitions
  multipath: fix hwhandler check in select_action
  libmultipath: cleanup features handling code
  multipathd: move helper functions to libmultipath
  multipathd: fix device creation issues
  multipathd: remove select_* from setup_multipath
  libmultipath: __setup_multipath param cleanup
  multipathd: move recovery mode code to function
  multipathd: clean up set_no_path_retry
  multipath: check failed path dmstate in check_path
  multipathd: marginal path code fixes

 kpartx/del-part-nodes.rules |   1 +
 libmultipath/config.c       |   3 +
 libmultipath/config.h       |   3 +
 libmultipath/configure.c    |  38 +++----
 libmultipath/defaults.h     |   1 +
 libmultipath/devmapper.c    |   2 +-
 libmultipath/dict.c         |  12 +++
 libmultipath/dmparser.c     |  35 ++----
 libmultipath/hwtable.c      |   1 +
 libmultipath/io_err_stat.c  |  12 +--
 libmultipath/propsel.c      |  21 +++-
 libmultipath/propsel.h      |   1 +
 libmultipath/structs.c      |  17 ---
 libmultipath/structs.h      |  10 +-
 libmultipath/structs_vec.c  | 256 +++++++++++++++++++++++++-------------------
 libmultipath/structs_vec.h  |  12 ++-
 multipath/multipath.conf.5  |  21 +++-
 multipathd/cli_handlers.c   |  34 +++---
 multipathd/main.c           | 134 +++++++++--------------
 multipathd/main.h           |   1 -
 20 files changed, 322 insertions(+), 293 deletions(-)

-- 
2.7.4
