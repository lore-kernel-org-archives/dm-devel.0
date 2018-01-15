From: Mike Snitzer <snitzer@redhat.com>
Subject: [GIT PULL] block changes to improve device mapper for 4.16
Date: Sun, 14 Jan 2018 21:59:13 -0500
Message-ID: <20180115025913.GA20727@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

I prepared this pull request in the hope that it may help you review and
stage these changes for 4.16.

I went over Ming's changes again to refine the headers and code comments
for clarity to help ease review and inclussion.

I've done extensive testing of the changes in this pull request in
combination with all the dm-4.16 changes I'll be sending to Linus, using
this tree (which gets pulled into linux-next, I wanted some coverage):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
I'll obviously drop these changes from dm's linux-next once you pick
them up.

FYI, this dm-4.16 commit addresses the concerns Bart raised last week
against Ming's dm-mpath changes:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=7a9d12664a183c4a1e2fa86b0a9206006b95138e

The following changes since commit bf9ae8c5325c0070d0ec81a849bba8d156f65993:

  blk-mq: fix bad clear of RQF_MQ_INFLIGHT in blk_mq_ct_ctx_init() (2018-01-14 10:46:24 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-block-4.16/dm

for you to fetch changes up to 0e94dfab56071a7afd0a9de9b8f6a0535148fb36:

  blk-mq: issue request directly for blk_insert_cloned_request (2018-01-14 13:00:02 -0500)

Please pull, thanks!
Mike

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

- Ming's blk-mq improvements to blk_insert_cloned_request(), which is
  used exclusively by request-based DM's blk-mq mode, that enable
  substantial dm-mpath sequential IO performance improvements.

----------------------------------------------------------------
Mike Snitzer (4):
      block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
      block: properly protect the 'queue' kobj in blk_unregister_queue
      block: allow gendisk's request_queue registration to be deferred
      dm: fix incomplete request_queue initialization

Ming Lei (3):
      blk-mq: move actual issue into __blk_mq_issue_req helper
      blk-mq: return dispatch result from blk_mq_try_issue_directly
      blk-mq: issue request directly for blk_insert_cloned_request

 block/blk-core.c      |  3 +-
 block/blk-mq-sysfs.c  |  9 +-----
 block/blk-mq.c        | 86 +++++++++++++++++++++++++++++++++++++++------------
 block/blk-mq.h        |  3 ++
 block/blk-sysfs.c     | 18 +++++++++--
 block/genhd.c         | 23 +++++++++++---
 drivers/md/dm-rq.c    | 28 ++++++++++-------
 drivers/md/dm.c       | 11 ++++++-
 include/linux/genhd.h |  5 +++
 9 files changed, 136 insertions(+), 50 deletions(-)
