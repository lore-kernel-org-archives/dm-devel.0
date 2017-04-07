From: NeilBrown <neilb@suse.com>
Subject: [PATCH 0/2] Trace completion of all bios
Date: Fri, 07 Apr 2017 11:10:44 +1000
Message-ID: <149152735878.17489.16036848644242802943.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Jens,
 I think all objections to this patch have been answered so I'm
 resending.
 I've added a small cleanup patch first which makes some small
 enhancements to the documentation and #defines for the bio->flags
 field.

Thanks,
NeilBrown

---

NeilBrown (2):
      block: simple improvements for bio->flags
      block: trace completion of all bios.


 block/bio.c               |   13 +++++++++++++
 block/blk-core.c          |   10 +++++++++-
 drivers/md/dm.c           |    1 -
 drivers/md/raid5.c        |    2 --
 include/linux/blk_types.h |   24 +++++++++++++++---------
 5 files changed, 37 insertions(+), 13 deletions(-)

--
Signature
