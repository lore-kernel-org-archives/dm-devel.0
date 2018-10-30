From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 00/22] libmultipath: checkers overhaul
Date: Tue, 30 Oct 2018 22:06:31 +0100
Message-ID: <20181030210653.29677-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

This is v3 of my "checkers overhaul" series.
Like v2, it's based on the previous "various multipath-tools 
patches" series. I'm resending only those patches that have
changed wrt v1 from Oct. 12th. Let me know if you need the
complete set. I kept Ben's Reviewed-by: tag in 21/22, as it
really changed only in a trivial way.

This series starts with a few minor fixes and then attempts
an overhaul of the checker code.

First, there's a block of patches to get rid of the "message"
char array in struct checker, replacing it with an integer.
This topic had been touched in recent discussion between Ben
and myself.

The next larger block fixes problems with checkers that try
to check unsupported devices. It's an interesting experience
to configure wrong checkers for the existing devices and see
what happens. With these patches, paths won't be falsely
teared down any more in such situations.

The last patch cleans up the checker data structure by splitting
it into a "checker class" and the path "checker instance".

There's more work to do in this area, but this is a start.

Regards,
Martin

----
Changes v2->v3:
 - 03/22: fixed one minor issue mentioned by Ben;
          reverted the const-ification of checker_message(),
	  as it will be reverted in 22/22 anyway.
 - 13/22: fix clariion checker semantics (Ben).
 - 21/22: rebased on top of updated 03/22.
 - 22/22: fix thread-safety issue from 03/22 (Ben).

Changes v1->v2:
 - 11/22: rebased on top of "various multipath-tools patches" series

Martin Wilck (22):
  libmultipath: fix use of uninitialized memory in write()
  libmultipath: fix memory leaks from scandir() use
  libmultipath/checkers: replace message by msgid
  libmultipath/checkers: cciss_tur: use message id
  libmultipath/checkers: directio: use message id
  libmultipath/checkers: emc_clariion: use message id
  libmultipath/checkers: hp_sw: use message id
  libmultipath/checkers: rdac: use message id
  libmultipath/checkers: readsector0: use message id
  libmultipath/checkers: tur: use message id
  multipathd: improve checker message logging
  libmultipath/checkers: support unsupported paths
  libmultipath: clariion checker: leave unsupported paths alone
  libmultipath: hp_sw checker: leave unsupported paths alone
  libmultipath: rdac checker: leave unsupported paths alone
  libmultipath: tur checker: leave unsupported paths alone
  libmultipath: pathinfo: don't blank wwid if checker fails
  multipathd: check_path: improve logging for "unusable path" case
  libmultipath: coalesce_paths: improve logging of orphaned paths
  libmultipath: sync_map_state: log failing paths
  libmultipath/checkers: cleanup class/instance model
  libmultipath: make checker_message thread safe

 libmultipath/checkers.c              | 209 ++++++++++++++++++---------
 libmultipath/checkers.h              |  67 ++++++---
 libmultipath/checkers/cciss_tur.c    |  13 +-
 libmultipath/checkers/directio.c     |  29 ++--
 libmultipath/checkers/emc_clariion.c | 114 ++++++++++++---
 libmultipath/checkers/hp_sw.c        |  39 +++--
 libmultipath/checkers/rdac.c         |  92 ++++++++----
 libmultipath/checkers/readsector0.c  |   7 +-
 libmultipath/checkers/tur.c          |  60 ++++----
 libmultipath/config.c                |  10 +-
 libmultipath/configure.c             |  10 +-
 libmultipath/discovery.c             |  16 +-
 libmultipath/foreign.c               |   5 +-
 libmultipath/foreign/nvme.c          |   6 +-
 libmultipath/print.c                 |   2 +-
 libmultipath/propsel.c               |  19 +--
 libmultipath/structs_vec.c           |   5 +-
 libmultipath/sysfs.c                 |   5 +-
 libmultipath/util.c                  |   9 ++
 libmultipath/util.h                  |   9 ++
 multipathd/main.c                    |  35 +++--
 21 files changed, 519 insertions(+), 242 deletions(-)

-- 
2.19.1
