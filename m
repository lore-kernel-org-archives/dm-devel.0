From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/42] SLES resync
Date: Tue,  8 Jan 2013 14:53:38 +0100
Message-ID: <1357653259-62650-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

here are some patches and bugfixes with have accumulated on
my SLES11 branch. Please apply.

(Patch 37 is blank due to merging, so it'll be missing from
 the patch set).

Hannes Reinecke (41):
  libmultipath: Invalid check for mpp->wwid in dm_addmap()
  Remove newline from condlog()
  Fixup pathgroup allocation in disassemble_map()
  libmultipath: resource leak in read_value_block()
  Accept several whitespaces in bindings file
  Add TAGS makefile target
  libmultipath: Fix typo in mp_prio_handler()
  Do not trigger a map reload on priority updates
  Introduce MP_FAST_IO_FAIL_UNSET
  Checker name is not displayed on failure
  Valgrind fixes for prioritizer
  Incorrect inquiry vendor length in hds prioritizer
  Print out multipath alias for flush_on_last_del messages
  Clarify setting origin in propsel.c
  libmultipath: error checking in remove_features()
  Increase parameter buffer
  Check return code from pathinfo()
  Inconsistent string quoting
  Switch off 'queue_if_no_path' before removing maps
  Double free in disassemble_map()
  libmultipath: prio keyword ignored for multipath config
  Path checker should return PATH_DOWN when no path is found
  Do not call sysfs_get_timeout for non-SCSI devices
  Make log_pthread more robust
  Print log messages when updating tables failed
  Update 'no_path_retry' correctly for failed paths
  Clean up uevent queue on shutdown
  libmultipath: Print out uevent sequence number
  Fix race condition in stop_waiter_thread()
  Use VECTOR_SIZE() defines
  Make 'allocated' an integer in vector.h
  Syntax error in /etc/init.d/boot.multipath
  multipath.init.suse: Update usage message
  multipath.conf.5: Clarify dev_loss_tmo settings
  Clarify dev_loss_tmo capping in multipath.conf.5
  multipathd: Ignore errors when creating pidfile
  multipathd deadlocks during restart
  multipathd: sighandlers might use uninitialized gvecs
  multipathd: crash in reconfigure CLI command
  multipathd: lock vectors during initial configuration

Petr Uzel (1):
  prio: fix merging of prioritizers with different args

 Makefile                                 |    7 ++
 libmultipath/alias.c                     |    2 +-
 libmultipath/config.h                    |    1 +
 libmultipath/configure.c                 |   13 ++--
 libmultipath/configure.h                 |    2 +-
 libmultipath/devmapper.c                 |   36 ++++++++--
 libmultipath/devmapper.h                 |    1 +
 libmultipath/dict.c                      |  108 +++++++++++++++---------------
 libmultipath/discovery.c                 |   38 ++++++-----
 libmultipath/dmparser.c                  |   20 +++---
 libmultipath/log_pthread.c               |  101 +++++++++++++++++++---------
 libmultipath/log_pthread.h               |   10 ++-
 libmultipath/parser.c                    |   32 +++++----
 libmultipath/prio.c                      |   51 ++++++++++++++-
 libmultipath/prio.h                      |    9 ++-
 libmultipath/prioritizers/alua.c         |    1 +
 libmultipath/prioritizers/datacore.c     |    1 +
 libmultipath/prioritizers/emc.c          |    1 +
 libmultipath/prioritizers/hds.c          |    6 +-
 libmultipath/prioritizers/hp_sw.c        |    1 +
 libmultipath/prioritizers/ontap.c        |    2 +
 libmultipath/prioritizers/rdac.c         |    2 +
 libmultipath/prioritizers/weightedpath.c |    6 ++-
 libmultipath/propsel.c                   |   53 ++++++++-------
 libmultipath/structs.c                   |    7 ++
 libmultipath/structs.h                   |    8 ++-
 libmultipath/structs_vec.c               |   29 +++++---
 libmultipath/sysfs.c                     |    2 +-
 libmultipath/uevent.c                    |   27 +++++++-
 libmultipath/uevent.h                    |    1 +
 libmultipath/util.c                      |   12 ++--
 libmultipath/vector.c                    |   10 ++--
 libmultipath/vector.h                    |   12 ++--
 libmultipath/waiter.c                    |    5 +-
 multipath.conf.annotated                 |    1 +
 multipath/main.c                         |    8 +-
 multipath/multipath.conf.5               |    9 ++-
 multipath/multipath.init.suse            |    6 +-
 multipathd/cli_handlers.c                |    2 +-
 multipathd/main.c                        |   98 ++++++++++++---------------
 40 files changed, 468 insertions(+), 273 deletions(-)

-- 
1.7.4.2
