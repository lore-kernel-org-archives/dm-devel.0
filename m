From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 00/15] Multipath patch dump
Date: Thu, 16 Jan 2020 20:18:05 -0600
Message-ID: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

This patch set is has multiple parts.

patch 01 is just a resubmit of my previous patch, with Martin's
corrections added.

Patches 02 - 06 are miscellaneous fixes and cleanups

Patches 07 - 09 are related to adding a new format wildcard, at the
        request of HPE, that allows multipath to get and display
        information from the vendor specific VPD pages

Patches 10 - 15 are the part that needs the most review, patch 14
        especially. It turns out that on machines with a large number
        of cores, io_destroy(), which is used by the directio checker,
        can take a long time to complete. Talking to some kernel people
        at Red Hat, I was told that this isn't a bug. It's working as
        expected, and multipath shouldn't be issuing so many
        io_destroy() calls (1 per path, when multipath or multipathd
        stops). Cutting out the io_destroy calls involved a major change
        to the directio checker. It's pretty hard to test a lot of the
        corner cases on actual hardware, so I've written a bunch of
        unit tests for this (patch 15).

Benjamin Marzinski (15):
  multipathd: warn when configuration has been changed.
  libmultipath: fix leak in foreign code
  Fix leak in mpathpersist
  libmultipath: remove unused path->prio_args
  libmultipath: constify get_unaligned_be*
  libmultipath: add missing hwe mpe variable merges
  libmultipath: fix sgio_get_vpd looping
  libmultipath: add vend_id to get_vpd_sgio
  libmultipath: add code to get vendor specific vpd data
  libmultipath: change how the checker async is set
  libmultipath: change failed path prio timeout
  multipathd: add new paths under vecs lock
  libmultipath: add new checker class functions
  libmultipath: make directio checker share io contexts
  tests: add directio unit tests

 libmpathpersist/mpath_persist.c  |   2 +-
 libmultipath/checkers.c          |  29 +-
 libmultipath/checkers.h          |   1 +
 libmultipath/checkers/directio.c | 337 ++++++++++++---
 libmultipath/config.c            |  12 +
 libmultipath/config.h            |   3 +
 libmultipath/dict.c              |  34 ++
 libmultipath/discovery.c         |  74 +++-
 libmultipath/discovery.h         |   2 +-
 libmultipath/foreign.c           |  11 +-
 libmultipath/hwtable.c           |   2 +
 libmultipath/print.c             |  27 ++
 libmultipath/prio.c              |   2 +-
 libmultipath/propsel.c           |  26 +-
 libmultipath/propsel.h           |   2 +
 libmultipath/structs.h           |  10 +-
 libmultipath/unaligned.h         |   4 +-
 mpathpersist/main.c              |   1 +
 multipath/main.c                 |   1 +
 multipath/multipath.conf.5       |   8 +
 multipathd/main.c                |  18 +-
 multipathd/uxlsnr.c              | 134 +++++-
 tests/Makefile                   |   3 +-
 tests/directio.c                 | 704 +++++++++++++++++++++++++++++++
 tests/vpd.c                      |  94 +++--
 25 files changed, 1394 insertions(+), 147 deletions(-)
 create mode 100644 tests/directio.c

-- 
2.17.2
