From: NeilBrown <neilb@suse.com>
Subject: [PATCH 4/5] blk: use non-rescuing bioset for
	q->bio_split.
Date: Fri, 10 Mar 2017 17:00:47 +1100
Message-ID: <148912564749.4002.12977222491155249514.stgit@noble>
References: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <148912539296.4002.219258660543808741.stgit@noble>
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
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

A rescuing bioset is only useful if there might be bios from
that same bioset on the bio_list_on_stack queue at a time
when bio_alloc_bioset() is called.  This never applies to
q->bio_split.

Allocations from q->bio_split are only ever made from
blk_queue_split() which is only ever called early in each of
various make_request_fn()s.  The original bio (call this A)
is then passed to generic_make_request() and is placed on
the bio_list_on_stack queue, and the bio that was allocated
from q->bio_split (B) is processed.

The processing of this may cause other bios to be passed to
generic_make_request() or may even cause the bio B itself to
be passed, possible after some prefix has been split off
(using some other bioset).

generic_make_request() now guarantees that all of these bios
(B and dependants) will be fully processed before the tail
of the original bio A gets handled.  None of these early bios
can possible trigger an allocation from the original
q->bio_split as they are either too small to require
splitting or (more likely) are destined for a different queue.

The next time that the original q->bio_split might be used
by this thread is when A is processed again, as it might
still be too big to handle directly.  By this time there
cannot be any other bios allocated from q->bio_split in the
generic_make_request() queue.  So no rescuing will ever be
needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/blk-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 430c82f646eb..fae7966e1f98 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -712,7 +712,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_q;
 
-	q->bio_split = bioset_create_rescued(BIO_POOL_SIZE, 0);
+	q->bio_split = bioset_create(BIO_POOL_SIZE, 0);
 	if (!q->bio_split)
 		goto fail_id;
 
