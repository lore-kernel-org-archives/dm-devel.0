From: Hannes Reinecke <hare@suse.de>
Subject: SUSE multipath-tools patch resync
Date: Wed, 18 May 2011 17:03:28 +0200
Message-ID: <4DD3DFC0.9050300@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

finally I've finished rebasing my patch queue for
multipath-tools to the latest upstream git commit.
The resulting tree is at:

git.kernel.org:/pub/scm/linux/kernel/git/hare/multipath-tools.git
branch for-christophe

Here are the summary lines of the patches:
  * Reload map for device read-only setting changes
  * Increase priority value for emc priority callout
  * Allow dev_loss to be set to 'infinity'
  * Update manpages
  * multipath: add '-t' option to dump internal hwtable
  * Reassign existing device-mapper maps
  * alua: Handle LBA_DEPENDENT state
  * Update multipathd init script for SuSE
  * multipathd: Add PID to 'show daemon' cli command
  * Update pid file handling
  * Serialize startup on large machines
  * Add 'shutdown' cli command
  * multipathd: Update 'max_fds' handling
  * multipathd: crash in reconfigure CLI command
  * Add 'max_polling_interval' config variable
  * libmultipath: Only count UP and GHOST paths for prio update
  * Always synchronize with dm state
  * multipathd is not starting waitevent checker for single paths
  * More debugging output when synchronizing path states
  * libmultipath: Make path state message unique
  * Update dev_loss_tmo for no_path_retry
  * Check for valid argument in update_multipath_strings()
  * libmultipath: Remove duplicate calls to path_offline()
  * Check for offline path in get_prio()
  * Use state name in get_state()
  * Only check offline status for SCSI devices
  * libmultipath: zero out sense buffer in do_inq()
  * multipathd: fix memory issues in cli.c
  * multipathd: Remove handling of 'umount' events
  * Safe memory allocation in cli_handlers
  * multipathd: Fix uxlsnr race condition on shutdown
  * Rework sysfs device handling in multipathd
  * multipath: add SuSE init file
  * Checker name is not displayed on failure
  * Unload priority modules
  * Display avg priority as group priority
  * libmultipath: Improve debugging of log messages
  * libmultipath: rework sysfs handling
  * libmultipath: update waiter handling
  * libmultipath: do not fallback to search /proc/partitions
  * Start uevent service handler from main thread
  * Use lists for uevent processing
  * Remove sysfs_attr cache
  * Fixup strip trailing whitespaces for getuid return value
  * Check return value for select_alias()
  * Use enum free_path_mode for free_paths argument
  * vector paranoia
  * Update cli request processing
  * Implement 'bindings_file' option
  * kpartx: Intendation fix in devmapper.c
  * Use regmatch when checking for duplicates in hwtable
  * Update hwtable factorization
  * Specify prioritizer in the multipath section, too
  * Static Load balancing prioritizer
  * Synchronize dm states for IO errors
  * Add 'max_polling_interval' config variable
  * libmultipath: do not access dm structures after dm_task_destroy
  * Correctly remove logical partition maps
  * rdac checker: Whitespace cleanup
  * libmultipath: Fix possible string overflow
  * More debugging output for feature changes
  * Fixup debugging in dmparser.c
  * Correctly update feature strings
  * Select 'features' from multipath configuration
  * Increase uevent buffer size
  * libmultipath: remove strcmp_chomp()
  * Remove sysfs_lookup_devpath_by_subsys_id()
  * libmultipath: resolve hash collisions in pgcmp()
  * libmultipath: correct path count in setup_map()
  * Make status variable local
  * Make params variable local
  * multipath segfaults if configuration file contains errors
  * Use '--replace-whitespace' option for scsi_id
  * Asynchronous mode for tur checker
  * Move setup_thread_attr() to uevent.c
  * TUR checker should not return 'failed' for reservation conflict
  * directio: Reset 'running' parameter
  * Use timeout parameter for directio
  * libmultipath: check argument length in execute_program()
  * readsector0: block count calculation wrong
  * checkers: argument paranoia
  * Use refcounting for checkers
  * kpartx: Add option '-f' to force devmap creation
  * Add 'no_partitions' feature
  * Implement 'update' option for kpartx
  * kpartx: Indentation fix
  * Add compability flag LIBDM_API_COOKIE

(Did I mention I had quite a few outstanding?)
They are ordered in reverse order, in case you'd want to
cross-check against the git tree.

How to proceed best here?
Sending them all for review to the mailinglist seems a
bit excessive, but then that'll be automated anyway,
so I don't care.
Just tell me what you prefer.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
