From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/3] block: a few chunk_sectors fixes/improvements
Date: Fri, 11 Sep 2020 17:53:35 -0400
Message-ID: <20200911215338.44805-1-snitzer@redhat.com>
References: <20200911161344.GA28614@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200911161344.GA28614@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi,

Here are some changes that seem needed but that stop short of fixing the
initial report (of DM pgbench regression).  Would be nice if you could
review these block patches since they stand on their own.

I still have to look closer at how to get blk_queue_split() the info DM
has (in ti->max_io_len). Ideally a variant of blk_queue_split() could be
created that allows a 'chunk_sectors' override to be passed in, e.g.:
dm_process_bio() would call: blk_queue_split(&bio, ti->max_io_len);
And the provided ti->max_io_len would be used instead of a global (one
size fits all) q->limits.chunk_sectors.  The reason why this is
needed/ideal is due to DM's stacked nature.  Different offsets into a DM
device could yield entirely different max_io_len (or chunk_sectors)
settings.

BUT short of standing up a new variant of blk_queue_split() with per bio
override for 'chunk_sectors' (which is likely a non-starter for a few
reasons, recurssive nature of bio_split being the biggest): I'll need to
update all DM targets that call dm_set_target_max_io_len() to also do
this in each target's .io_hints hook:
  limits->chunk_sectors = lcm_not_zero(ti->max_io_len, limits->chunk_sectors);
Won't be perfect for some stacked devices (given it'll constrain
chunk_sectors to be less optimal as the IO limits are stacked) but it
should be an improvment -- and hopefully fix this pgbench regression.

Thanks,
Mike

Mike Snitzer (3):
  block: fix blk_rq_get_max_sectors() to flow more carefully
  block: use lcm_not_zero() when stacking chunk_sectors
  block: allow 'chunk_sectors' to be non-power-of-2

 block/blk-settings.c   | 22 ++++++++++++----------
 include/linux/blkdev.h | 31 ++++++++++++++++++++++---------
 2 files changed, 34 insertions(+), 19 deletions(-)

-- 
2.15.0
