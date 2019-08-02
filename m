From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 00/16] multipath marginal pathgroups
Date: Fri,  2 Aug 2019 11:33:26 -0500
Message-ID: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, Muneendra Kumar <mkumar@redhat.com>
List-Id: dm-devel.ids

The first patch in this series is simply a resend of my previous patch
to fix vector_foreach_slot_backwards(). The rest of the patches are
related to adding support for an alternative way to deal with marginal
paths. Instead of delaying their reinstatement, which can cause problems
if multipath isn't set to queue IO when there are no usable paths, this
patchset adds a marginal_pathgroups option. If this is set, marginal
paths will be reinstated, but added to seperate marginal pathgroups.
They will remain there until the time when they would normally be
reinstated, at which point they will be returned to their regular
pathgroups. Marginal pathgroups will have a priority lower than all
regular pathgroups. This has the advantage of continuing to track
marginal paths, even if all the other paths go down temporarily, so that
multipath can switch back to the normal paths as soon as they come back
up.  This code also allows users to manually move paths between marginal
and regular pathgroups. This is especially important for Broadcom's
Fiber Channel Transport Daemon, since it doesn't use the multipathd
marginal path detectors, and thus will not automatically reinstate
marginal paths when all other paths have failed. 

https://www.mail-archive.com/dm-devel@redhat.com/msg12956.html

Benjamin Marzinski (16):
  libmultipath: make vector_foreach_slot_backwards work as expected
  libmultipath: add marginal paths and groups infrastructure
  tests: add path grouping policy unit tests.
  libmultipath: add wrapper function around pgpolicyfn
  libmultipath: fix double free in pgpolicyfn error paths
  libmultipath: remove store_pathgroup
  libmultipath: make one_group allocate a new vector
  libmultipath: consolidate group_by_* functions
  tests: update pgpolicy tests to work with group_paths()
  libmultipath: make pgpolicyfn take a paths vector
  libmultipath: make group_paths handle marginal paths
  tests: add tests for grouping marginal paths.
  libmultipath: add marginal_pathgroups config option
  libmutipath: deprecate delay_*_checks
  multipathd: use marginal_pathgroups
  multipath: update man pages

 libmultipath/config.h      |    1 +
 libmultipath/configure.c   |   22 +-
 libmultipath/dict.c        |    3 +
 libmultipath/pgpolicies.c  |  346 +++++-------
 libmultipath/pgpolicies.h  |   12 +-
 libmultipath/print.c       |   18 +
 libmultipath/print.h       |    6 +-
 libmultipath/propsel.c     |   62 ++-
 libmultipath/propsel.h     |    2 -
 libmultipath/structs.c     |   16 +-
 libmultipath/structs.h     |   15 +-
 libmultipath/switchgroup.c |   15 +-
 libmultipath/vector.h      |    2 +-
 multipath/multipath.conf.5 |   75 ++-
 multipathd/cli.c           |    5 +
 multipathd/cli.h           |    4 +
 multipathd/cli_handlers.c  |   91 ++++
 multipathd/cli_handlers.h  |    3 +
 multipathd/main.c          |   90 ++--
 multipathd/multipathd.8    |   19 +
 tests/Makefile             |    2 +-
 tests/pgpolicy.c           | 1036 ++++++++++++++++++++++++++++++++++++
 22 files changed, 1503 insertions(+), 342 deletions(-)
 create mode 100644 tests/pgpolicy.c

-- 
2.17.2
