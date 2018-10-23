From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 00/21] libmultipath: checkers overhaul
Date: Tue, 23 Oct 2018 23:58:46 +0200
Message-ID: <20181023215847.794-1-mwilck@suse.com>
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

As Ben has ack'd v2 of my "various multipath-tools patches"
series now, I'm resending my previously submitted series
"checkers overhaul" rebased on top of that. To spare the
list unnecessary repetition, I resend only this cover letter
and patch 11/21, because all others are exactly the same as
before.

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

Martin Wilck (21):
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

 libmultipath/checkers.c              | 196 +++++++++++++++++----------
 libmultipath/checkers.h              |  65 ++++++---
 libmultipath/checkers/cciss_tur.c    |  13 +-
 libmultipath/checkers/directio.c     |  29 ++--
 libmultipath/checkers/emc_clariion.c | 108 ++++++++++++---
 libmultipath/checkers/hp_sw.c        |  39 ++++--
 libmultipath/checkers/rdac.c         |  92 +++++++++----
 libmultipath/checkers/readsector0.c  |   7 +-
 libmultipath/checkers/tur.c          |  60 ++++----
 libmultipath/config.c                |  10 +-
 libmultipath/configure.c             |  10 +-
 libmultipath/discovery.c             |   7 +-
 libmultipath/foreign.c               |   5 +-
 libmultipath/foreign/nvme.c          |   6 +-
 libmultipath/print.c                 |   2 +-
 libmultipath/propsel.c               |  19 +--
 libmultipath/structs_vec.c           |   5 +-
 libmultipath/sysfs.c                 |   5 +-
 libmultipath/util.c                  |   9 ++
 libmultipath/util.h                  |   9 ++
 multipathd/main.c                    |  36 +++--
 21 files changed, 492 insertions(+), 240 deletions(-)

-- 
2.19.1
