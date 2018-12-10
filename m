From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 00/24] multipath-tools: improve logging at -v3
Date: Mon, 10 Dec 2018 11:06:32 +0100
Message-ID: <20181210100633.12966-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

most of the patches in this series reduce log levels of frequently
printed messages at verbosity level 3. My goal was to limit the
output of multipathd to one line per path per checker invocation,
which is sufficient to track multipathd's view of path health in
the logs.

The standard setting of -v2 is not enough for post-mortem analysis of many
failures. With this series, running multipathd with verbosity 3 becomes a
realistic option even in production environments. So far the amount of output
from multipathd with -v3 pretty much made this impossible, at least over
longer time periods, and also made reading these logs very cumbersome due to
the amount of redundant partly superfluos verbosity. I've taken care not
to loose important information in the logs.

Apart from that, the series fixes errors in the unit tests introduced by my
last "checker overhaul" patch series (proving that I forgot to run the
tests before submitting :-( ), and fixes a problem that I found while testing
handling of a bad configuration (paths with size mismatch).

Regards,
Martin

Changed in v4:

 - 22/24: removed false statement in comment.

Changes in v3:

Resent full series on Christophe's request. All patches except 22/24, 23/24 are
the same as before. Added Ben's "Reviewed-by:" where appropriate.

 - 22/24: added one fix for a non-symbolic reference to a domap() return value,
which I'd overlooked before.
 - 23/24: removed on Ben's review. The new 23/24 is just a code cleanup
without functional change.

Changes in v2:

The first 19 patches are identical to v1 as ACK'd by Ben, except 16/24
"libmultipath: coalesce_paths: fix size mismatch handling".
No. 8/24 "libmultipath: decrease log level of word splitting"
(not yet ACKd by Ben) also stays the same; the issue Ben raised
in his review is addressed in a separate patch, 20/24.
21/24 addresses implements Ben's suggestion to use named constants
as return values in coalesce_paths(). 22, 23, 24 do the same for
other important, related functions, as I found it strange to make
this change just for coalesce_paths() alone.  

Martin Wilck (24):
  tests/hwtable: set multipath_dir in local configuration
  tests/hwtable: adjust to new checker API
  multipath-tools: decrease verbosity of state messages
  libmultipath: decrease verbosity of pathinfo messages
  libmultipath: decrease verbosity of TUR checker messages
  libmultipath: avoid frequent messages from filter_property()
  libmultipath: decrease log level of "disassembled" messages
  libmultipath: decrease log level of word splitting
  libmultipath: increase log level of map removal
  multipathd: decrease log level of checker timing
  libmultipath: decrease log level of "prioritizer refcount" message
  libmpathpersist/update_map_pr: decrease log level for nop
  libmultipath: simplify devt2devname()
  libmultipath: decrease log level for failed VPD c9
  libmultipath: adopt_paths: check for size match
  libmultipath: coalesce_paths: fix size mismatch handling
  tests: add unit tests for bitmask functions
  multipathd: uev_remove_path: remove redundant orphan_paths call
  libmultipath: improve logging from orphan_paths
  libmultipath: avoid syslog loglevel > LOG_DEBUG
  coalesce_paths(): use symbolic return value
  domap(): use symbolic return value
  multipathd: simplify retry logic in ev_add_path()
  multipath: use symbolic return value and exit code

 libmpathpersist/mpath_persist.c |   3 +-
 libmultipath/blacklist.c        |  54 +++++++-------
 libmultipath/blacklist.h        |   2 +-
 libmultipath/checkers/tur.c     |   6 +-
 libmultipath/configure.c        |  48 +++++++------
 libmultipath/configure.h        |  22 ++++++
 libmultipath/discovery.c        |  20 +++---
 libmultipath/dmparser.c         |   6 +-
 libmultipath/log_pthread.c      |   3 +
 libmultipath/prio.c             |   2 +-
 libmultipath/structs_vec.c      |  18 +++--
 libmultipath/structs_vec.h      |   3 +-
 libmultipath/util.c             |   7 +-
 libmultipath/util.h             |  16 +++++
 multipath/main.c                | 121 ++++++++++++++++++--------------
 multipathd/cli_handlers.c       |   5 +-
 multipathd/main.c               |  45 ++++++------
 tests/Makefile                  |   7 +-
 tests/blacklist.c               |   7 +-
 tests/hwtable.c                 |  89 ++++++++++++-----------
 tests/util.c                    |  98 ++++++++++++++++++++++++++
 21 files changed, 382 insertions(+), 200 deletions(-)

-- 
2.19.2
