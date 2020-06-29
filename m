From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 00/10] block: blktrace framework cleanup
Date: Mon, 29 Jun 2020 16:43:03 -0700
Message-ID: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

Hi,

There are many places where trace API accepts the struct request_queue*
parameter which can be derived from other function parameters.

This patch-series removes the struct request queue parameter from the
blktrace framework and adjusts the tracepoints definition and usage
along with the tracing API itself.

Also with the queue parameter removed now we can merge some of the trace
events with creating generic event class for bio based tarce events.

Finally few of more cleanups to remove the trace_block_rq_insert()
wrapper blk_mq_sched_request_inserted(), get rid of the extra parameter
for trace_block_getrq, remove the blk_trace_request_get_cgid(),
fix tracepoint comment header,  and blk_fill_rwbs() related triggred
cleanup.

I've added patches after first cleanup as I scan the code for more
cleanup. I think patch distribution can be better but it will be great
to have some feedback as the amount of clenaup has grown bigger.

Any comments are welcome.

Regards,
Chaitanya

Chaitanya Kulkarni (11):
  block: blktrace framework cleanup
  block: rename block_bio_merge class to block_bio
  block: use block_bio event class for bio_queue
  block: use block_bio event class for bio_bounce
  block: get rid of the trace rq insert wrapper
  block: remove extra param for trace_block_getrq()
  block: get rid of blk_trace_request_get_cgid()
  block: fix the comments in the trace event block.h
  block: remove unsed param in blk_fill_rwbs()
  block: use block_bio class for getrq and sleeprq
  block: remove block_get_rq event class

 block/bfq-iosched.c           |   4 +-
 block/blk-core.c              |   6 +-
 block/blk-merge.c             |   4 +-
 block/blk-mq-sched.c          |   6 -
 block/blk-mq-sched.h          |   1 -
 block/blk-mq.c                |  10 +-
 block/bounce.c                |   2 +-
 block/kyber-iosched.c         |   4 +-
 block/mq-deadline.c           |   4 +-
 drivers/md/dm.c               |   4 +-
 include/linux/blktrace_api.h  |   2 +-
 include/trace/events/bcache.h |  10 +-
 include/trace/events/block.h  | 226 +++++++++++-----------------------
 kernel/trace/blktrace.c       | 129 +++++++++----------
 14 files changed, 161 insertions(+), 251 deletions(-)

-- 
2.26.0
