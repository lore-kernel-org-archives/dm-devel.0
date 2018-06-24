From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/8] libmpathpersist fixes
Date: Sun, 24 Jun 2018 15:19:47 +0200
Message-ID: <20180624131955.20206-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

this is v2 of my small set of libmpathpersist fixes. It's based
on upstream, thus it has a minor conflict with my previous patch
series "multipath-tools: improve config file handling". I can of
course provide a rebased patch set if you prefer.

Changes wrt v1:
 - introduce and use get_unaligned_be64 (Bart van Assche)
 - add test for (get|put)_unaligned_bexx functions

Note: we have both the "unaligned" and the "beXY_to_cpu" APIs
now, for essentially the same purpose. I wonder if we should
settle on a single API instead. I am unsure if beXY_to_cpu() has
alignment issues on some architectures (I don't think there are
issues on our current main target platforms). If yes, I believe that
we'd be on the safe side using the "unaligned" API.
Anyway, that could be done in a follow-up patch.

Thanks,
Martin

Martin Wilck (8):
  libmpathpersist: remove duplicate test in readfullstatus
  libmpathpersist: fix typo in mpath_format_readfullstatus
  libmpathpersist: fix stack overflow in mpath_format_readfullstatus()
  libmultipath: add (get|put)_unaligned_be64
  multipath-tools/tests: add tests for get_unaligned_beXX
  libmpathpersist: fix byte swapping for big endian systems
  (lib)mpathpersist: use O_RDONLY file descriptors
  libmultipath: fix gcc 8.1 "truncated output" warnings

 libmpathpersist/mpath_persist.c  |  8 +--
 libmpathpersist/mpath_pr_ioctl.c | 75 +++++++++----------------
 libmultipath/sysfs.c             |  4 +-
 libmultipath/unaligned.h         | 16 ++++++
 libmultipath/util.c              |  4 +-
 mpathpersist/main.c              |  2 +-
 tests/Makefile                   |  2 +-
 tests/unaligned.c                | 96 ++++++++++++++++++++++++++++++++
 8 files changed, 146 insertions(+), 61 deletions(-)
 create mode 100644 tests/unaligned.c

-- 
2.17.1
