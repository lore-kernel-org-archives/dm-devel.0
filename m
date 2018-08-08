From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 00/17] Misc Multipath patches
Date: Wed,  8 Aug 2018 17:21:18 -0500
Message-ID: <1533766895-28605-1-git-send-email-bmarzins@redhat.com>
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
set.  The only difference is in
0002-libmultipath-fix-tur-checker-double-locking.patch 
It now sets ct->devt when initially creating the tur_checker_context,
while that structure is still only referenced by a local variable.
After that, ct->devt is only ever read. This should remove any issues
with it needing locking.

Patches 0001-0005 are a number of fixes to the tur checker.These are
        the ones that should get the most attention.
Patches 0006-0017 are minor issues found by coverity.
        Not all of them are bugs that could actually occur in practice,
        but they are simple and hopefully non-controversial changes.

Benjamin Marzinski (17):
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

 libmultipath/checkers/tur.c              | 168 +++++++++++--------------------
 libmultipath/dict.c                      |   5 +-
 libmultipath/discovery.c                 |  14 ++-
 libmultipath/parser.c                    |  12 ++-
 libmultipath/print.c                     |   8 --
 libmultipath/prioritizers/path_latency.c |   3 +-
 libmultipath/structs.c                   |   2 +-
 libmultipath/uevent.c                    |   6 ++
 multipath/main.c                         |   2 +-
 multipathd/cli_handlers.c                |  11 +-
 multipathd/main.c                        |  26 +++--
 11 files changed, 115 insertions(+), 142 deletions(-)

-- 
2.7.4
