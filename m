From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/5] dm thin: adapt code to use new async
	__blkdev_issue_discard
Date: Thu,  5 May 2016 11:54:20 -0400
Message-ID: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

I'd like to see these changes included in 4.7.

Jens, if you (and hch and others) are OK with the first 2 block
patches can you please add them to your 'for-4.7/core'?

Joe Thornber (1):
  dm thin: unroll issue_discard() to create longer discard bio chains

Mike Snitzer (4):
  block: reinstate early return of -EOPNOTSUPP from blkdev_issue_discard
  block: make bio_inc_remaining() interface accessible again
  dm thin: remove __bio_inc_remaining() and switch to using bio_inc_remaining()
  dm thin: use __blkdev_issue_discard for async discard support

 block/bio.c          |  11 ----
 block/blk-lib.c      |   7 ++-
 drivers/md/dm-thin.c | 159 +++++++++++++++++++++++----------------------------
 include/linux/bio.h  |  11 ++++
 4 files changed, 88 insertions(+), 100 deletions(-)

-- 
2.6.4 (Apple Git-63)
