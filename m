From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Tue, 16 Dec 2014 22:59:56 -0500
Message-ID: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

Hi,

Here is v3 of the request-based DM blk-support patchset.  I've also
published a git repo here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20-blk-mq

I found quite a few issues with v2 for both blk-mq and old
request-based DM.  I've still attributed the original patches from
Keith to him even though I fixed/rewrote significant portions.  Keith,
I'm happy to leave attribution like this unless you'd prefer I change
it.

In general, I'm not in love with the amount of churn in dm.c's
request-based DM code.  BUT I'm also not opposed to these changes if
others have a pressing need for blk-mq support landing for
dm-multipath.  So input on who cares about this work would be
appreciated.  I'd like to get an idea of the kinds of configurations
people are looking to deploy.

These changes have seen basic dm-multipath testing against both blk-mq
(virtio-blk) and traditional SCSI devices.  Error paths are largely
untested, as is dm-multipath's ability to function properly in the
face of heavy IO with concurrent path failures.  But I'm publishing
this work now in the hopes that others with real blk-mq devices can
test more fully.  Keith, it'd be awesome if you could provide the same
test coverage you did for blk-mq testing of your v2.

I'll work with Red Hat's Storage QE to hammer on the old request-based
side.  But with the holiday fast approaching I likely won't have full
test coverage until after the New Year.

Keith Busch (4):
  block: require blk_rq_prep_clone() be given an initialized clone request
  block: add blk-mq support to blk_insert_cloned_request()
  dm: submit stacked requests in irq enabled context
  dm: allocate requests from target when stacking on blk-mq devices

Mike Snitzer (4):
  block: initialize bio member of blk-mq request to NULL
  block: mark blk-mq devices as stackable
  dm: remove exports for request-based interfaces without external callers
  dm: split request structure out from dm_rq_target_io structure

 block/blk-core.c              |   7 +-
 block/blk-mq.c                |   1 +
 drivers/md/dm-mpath.c         |  53 +++++--
 drivers/md/dm-table.c         |  34 ++++-
 drivers/md/dm-target.c        |  15 +-
 drivers/md/dm.c               | 336 +++++++++++++++++++++++++++++-------------
 drivers/md/dm.h               |   8 +-
 include/linux/blkdev.h        |   1 +
 include/linux/device-mapper.h |  10 +-
 9 files changed, 335 insertions(+), 130 deletions(-)

-- 
1.9.3
