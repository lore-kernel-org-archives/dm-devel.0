From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v3 00/19] Misc Multipath patches
Date: Fri, 21 Sep 2018 18:05:08 -0500
Message-ID: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
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

This batch of patches is a resend of the non-merged pathes from my last
set, along with 2 new ones. It would be really great if we could get
a version bug after the outstanding commits go it.

Patches 0001-0005 are a number of fixes to the tur checker.These are
	the ones that should get the most attention.
Patches 0006-0017 are minor issues found by coverity.
	Not all of them are bugs that could actually occur in practice,
	but they are simple and hopefully non-controversial changes.
Patches 0018-0019 are new and related to changing path wwids

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
 11 files changed, 131 insertions(+), 154 deletions(-)

-- 
2.7.4
