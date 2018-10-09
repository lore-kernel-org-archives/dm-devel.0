From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v4 00/19] Misc Multipath patches
Date: Tue,  9 Oct 2018 18:02:57 -0500
Message-ID: <1539126196-28926-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

This batch is a resend of v4, rebased on the latest upstream code with
changes base on Martin's review

Changes in v4
	0001-libmultipath-fix-tur-checker-timeout.patch now fails back
	to synchronous mode if the thread was cancelled but continues to
	run.  Since this is an unlikely event, I decided that it made
	more sense to not complicate the existing thread synchronization
	code to allow multiple threads. However, if someone else want's
	to make those changes, I'm open to the idea.

	0002-libmultipath-fix-tur-checker-double-locking.patch now saves
	dev_t instead of a string in the checker context, as suggested
	by Martin

	The only differences in patches 0003-0005 are that they are
	rebased on top of the new patches 0001-0002, but I took off
	Martin's Reviewed-by (just it case I messed something up when
	rebasing them).

Changes in v3
        added patches 0018-0019

Changes in v2
        0002-libmultipath-fix-tur-checker-double-locking.patch now sets
        ct->devt when initially creating the tur_checker_context, while
        that structure is still only referenced by a local variable.
        After that, ct->devt is only ever read. This should remove any
        issues with it needing locking.

Benjamin Marzinski (19):
  libmultipath: fix tur checker timeout
  libmultipath: fix tur checker double locking
  libmultipath: fix tur memory misuse
  libmultipath: cleanup tur locking
  libmultipath: fix tur checker timeout issue
  libmultipath: fix set_int error path
  libmultipath: fix length issues in get_vpd_sgio
  libmultipath: _install_keyword cleanup
  libmultipath: remove unused code
  libmultipath: fix memory issue in path_latency prio
  libmultipath: fix null dereference int alloc_path_group
  libmutipath: don't use malformed uevents
  multipath: fix max array size in print_cmd_valid
  multipathd: function return value tweaks
  multipathd: minor fixes
  multipathd: remove useless check and fix format
  multipathd: fix memory leak on error in configure
  libmultipath: Don't blank intialized paths
  libmultipath: Fixup updating paths

 libmultipath/checkers/tur.c              | 168 +++++++++++--------------------
 libmultipath/dict.c                      |   5 +-
 libmultipath/discovery.c                 |  18 ++--
 libmultipath/parser.c                    |  12 ++-
 libmultipath/print.c                     |   8 --
 libmultipath/prioritizers/path_latency.c |   3 +-
 libmultipath/structs.c                   |   2 +-
 libmultipath/uevent.c                    |   6 ++
 multipath/main.c                         |   2 +-
 multipathd/cli_handlers.c                |  11 +-
 multipathd/main.c                        |  50 +++++----
 11 files changed, 130 insertions(+), 155 deletions(-)

-- 
2.7.4
