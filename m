From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 0/4] block: a couple chunk_sectors
	fixes/improvements
Date: Tue, 15 Sep 2020 13:23:53 -0400
Message-ID: <20200915172357.83215-1-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Vijayendra Suman <vijayendra.suman@oracle.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi,

This v2 drops a patch from v1 and fixes the chunk_sectprs check added to
blk_stack_limits to convert chubk_sectors to bytes before comparing with
physical_block_size.

Jens, please feel free to pick up patches 1 and 2.

DM patches 3 and 4 are provided just to give context for how DM will be
updated to use chunk_sectors.

Mike Snitzer (4):
  block: use lcm_not_zero() when stacking chunk_sectors
  block: allow 'chunk_sectors' to be non-power-of-2
  dm table: stack 'chunk_sectors' limit to account for target-specific splitting
  dm: unconditionally call blk_queue_split() in dm_process_bio()

 block/blk-settings.c   | 22 ++++++++++++----------
 drivers/md/dm-table.c  |  5 +++++
 drivers/md/dm.c        | 45 +--------------------------------------------
 include/linux/blkdev.h | 12 +++++++++---
 4 files changed, 27 insertions(+), 57 deletions(-)

-- 
2.15.0
