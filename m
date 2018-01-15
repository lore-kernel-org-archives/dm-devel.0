From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [GIT PULL] block changes to improve device mapper for 4.16
Date: Mon, 15 Jan 2018 10:52:21 -0500
Message-ID: <20180115155220.GA16814@redhat.com>
References: <20180115025913.GA20727@redhat.com>
 <36b17d56-bd2b-220a-08c1-8bd44d33f854@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <36b17d56-bd2b-220a-08c1-8bd44d33f854@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jan 15 2018 at 10:33am -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 1/14/18 7:59 PM, Mike Snitzer wrote:
...
> > Ming Lei (3):
> >       blk-mq: move actual issue into __blk_mq_issue_req helper
> 
> I don't like this patch at all - it's a 10 line function (if that)
> that ends up with three outputs, two of them hidden in passed
> in pointers. On top of that, a function that is named
> __blk_mq_issue_req() and returns bool, you would logically expect
> a 'true' return to mean that it succeeded. This is the opposite.
> 
> Not strongly opposed to the rest.

OK, I'll have a closer look at how to clean it up (and also get with
Ming).

In the meantime, you can either cherry-pick my first 4 patches or feel
free to use this to pull them in:

The following changes since commit bf9ae8c5325c0070d0ec81a849bba8d156f65993:

  blk-mq: fix bad clear of RQF_MQ_INFLIGHT in blk_mq_ct_ctx_init() (2018-01-14 10:46:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-block-4.16/dm-changes-1

for you to fetch changes up to d0cc27da2b04351b3cb52afeb99ceca7b9f91f3b:

  dm: fix incomplete request_queue initialization (2018-01-14 12:59:59 -0500)

----------------------------------------------------------------
- Small correctness fix in del_gendisk() if GENHD_FL_HIDDEN is used.

- Cleanup blk_unregister_queue() to more precisely protect against
  concurrent sysfs changes, blk_mq_unregister_dev() now requires caller
  to hold q->sysfslock (blk_unregister_queue is only caller).

- Introduce add_disk() variant, add_disk_no_queue_reg(), that allows the
  gendisk to be registered but the associated disk->queue's
  blk_register_queue() is left for the driver to do once its
  request_queue is fully initialized.  Fixes long-standing DM
  request_queue initialization issues.

----------------------------------------------------------------
Mike Snitzer (4):
      block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
      block: properly protect the 'queue' kobj in blk_unregister_queue
      block: allow gendisk's request_queue registration to be deferred
      dm: fix incomplete request_queue initialization

 block/blk-mq-sysfs.c  |  9 +--------
 block/blk-sysfs.c     | 18 +++++++++++++++---
 block/genhd.c         | 23 +++++++++++++++++++----
 drivers/md/dm-rq.c    |  9 ---------
 drivers/md/dm.c       | 11 ++++++++++-
 include/linux/genhd.h |  5 +++++
 6 files changed, 50 insertions(+), 25 deletions(-)
