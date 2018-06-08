From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 00/28] multipath-tools: improve config file
	handling
Date: Fri,  8 Jun 2018 12:20:13 +0200
Message-ID: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This patch series fixes a number of small but important issues in
the way multipath-tools handle configuration files, in particular the
handling of multiple "device" and "blacklist" sections matching the
same device. Besides eliminating inconsistencies, the goal of the series is
to be able to use "multipath -t" or "multipathd show config" ouput as
configuration for multipath-tools, and obtain exactly the same results
as with the original configuration.

Late in the series, two new commands "multipath -T" and "multipath show config
local" are added, which avoid the lengthyness of the full configuration
dump and produce output more suitable as a local configuration template.

By far the largest part of the series is a new unit test (hwtable.c) for
configuration file handling. The commit message of the patch introducing
this unit test ("tests/hwtable: tests for config file handling and hwentry
merging") explains the problems / inconsistencies that the series is supposed
to fix. Tests that fail in the first place are marked with the BROKEN macro.
While reviewing the 2000 LOC of the new unit test is certainly a pain, I'd
like to ask reviewers to *pay special attention to the tests marked BROKEN*,
because that's where follow-up patches will change  the behavior of
multipath-tools in user-noticeable ways. I believe it's for the better, but
I'd like to make sure we all agree. For the rest of the unit test, reviewers
might appreciate the fact that tests succeed for the current code, and are
intended as regeression tests for the follow-up patches.

Patch 01-07 are just simple fixes and, as usual, "const" additions.
Patch 08-10 introduce the new unit test.
Patch 11-17 fix some basic problems which need to be fixed for dump/reload.
Patch 18-24 add the ability for dumping the configuration, using the output
as new configuration input ("reload"), and testing / comparing the results.
Patch 23-24 implement "multipathd show config local" and "multipath -T" on these
grounds.
Patch 23-27 fix more problems that surfaced in the dump/reload test.
Patch 28 clarifies the documentation of multipath.conf.

Martin Wilck (28):
  kpartx: no need to use FREE_CONST
  libmultipath: fix memory leak in process_config_dir()
  libmultipath: remove superfluous conditionals in load_config()
  libmultipath/structs.c: constify some functions
  libmultipath: some const usage in hwentry handling
  libmultipath: change prototypes of hwe_regmatch() and find_hwe()
  libmultipath/prio: constify simple getters
  tests/Makefile: autogenerate list of symbols to be wrapped
  tests/test-lib: cmocka helpers to simulate path and map discovery
  tests/hwtable: tests for config file handling and hwentry merging
  libmultipath: add debug messages to hwentry lookup/merging code
  libmultipath: use vector for for pp->hwe and mp->hwe
  libmultipath: allow more than one hwentry
  libmultipath: don't merge hwentries by regex
  libmultipath: merge hwentries inside a conf file
  libmultipath/hwtable: remove inherited props from ONTAP NVMe
  libmultipath: don't merge by regex in setup_default_blist()
  multipath, multipathd: consolidate config dumping
  tests/hwtable: implement configuration dump + reload test
  libmultipath: allow dumping only "local" hwtable in snprint_config
  tests/hwtable: add test for local configuration dump
  libmultipath: allow printing local maps in snprint_config
  multipathd: implement "show config local"
  multipath: implement "multipath -T"
  libmultipath: merge "multipath" config sections by wwid
  libmultipath: implement and use blacklist merging
  libmultipath: escape '"' chars while dumping config
  multipath.conf(5): various corrections and clarifications

 kpartx/devmapper.c         |   10 +-
 libmultipath/blacklist.c   |  125 ++-
 libmultipath/blacklist.h   |    2 +
 libmultipath/config.c      |  208 +++--
 libmultipath/config.h      |    5 +-
 libmultipath/dict.c        |   40 +-
 libmultipath/discovery.c   |   10 +-
 libmultipath/hwtable.c     |    3 -
 libmultipath/print.c       |  128 ++-
 libmultipath/print.h       |    9 +-
 libmultipath/prio.c        |    8 +-
 libmultipath/prio.h        |    8 +-
 libmultipath/propsel.c     |   53 +-
 libmultipath/structs.c     |   26 +-
 libmultipath/structs.h     |   24 +-
 libmultipath/structs_vec.c |   19 +
 libmultipath/structs_vec.h |    1 +
 libmultipath/vector.c      |   12 +
 libmultipath/vector.h      |    1 +
 multipath/main.c           |   92 +-
 multipath/multipath.8      |    8 +-
 multipath/multipath.conf.5 |  174 ++--
 multipathd/cli.c           |    2 +
 multipathd/cli.h           |    2 +
 multipathd/cli_handlers.c  |   80 +-
 multipathd/cli_handlers.h  |    1 +
 multipathd/main.c          |    1 +
 multipathd/multipathd.8    |    5 +
 tests/Makefile             |   36 +-
 tests/hwtable.c            | 1707 ++++++++++++++++++++++++++++++++++++
 tests/test-lib.c           |  359 ++++++++
 tests/test-lib.h           |   67 ++
 32 files changed, 2892 insertions(+), 334 deletions(-)
 create mode 100644 tests/hwtable.c
 create mode 100644 tests/test-lib.c
 create mode 100644 tests/test-lib.h

-- 
2.17.0
