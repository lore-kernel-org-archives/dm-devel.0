From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] accessing invalid memory in "dm zoned: properly
 handle backing device failure"
Date: Mon, 26 Aug 2019 02:41:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908260232180.7419@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The patch 75d66ffb48efb30f2dd42f041ba8b39c5b2bd115 ("dm zoned: properly 
handle backing device failure") triggers a coverity warning:

*** CID 1452808:  Memory - illegal accesses  (USE_AFTER_FREE)
/drivers/md/dm-zoned-target.c: 137 in dmz_submit_bio()
131             clone->bi_private = bioctx;
132
133             bio_advance(bio, clone->bi_iter.bi_size);
134
135             refcount_inc(&bioctx->ref);
136             generic_make_request(clone);
>>>     CID 1452808:  Memory - illegal accesses  (USE_AFTER_FREE)
>>>     Dereferencing freed pointer "clone".
137             if (clone->bi_status == BLK_STS_IOERR)
138                     return -EIO;
139
140             if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
141                     zone->wp_block += nr_blocks;
142

The "clone" bio may be processed and freed before the check 
"clone->bi_status == BLK_STS_IOERR" - so this check can access invalid 
memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-zoned-target.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/drivers/md/dm-zoned-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zoned-target.c	2019-08-26 08:30:30.000000000 +0200
+++ linux-2.6/drivers/md/dm-zoned-target.c	2019-08-26 08:36:23.000000000 +0200
@@ -134,8 +134,6 @@ static int dmz_submit_bio(struct dmz_tar
 
 	refcount_inc(&bioctx->ref);
 	generic_make_request(clone);
-	if (clone->bi_status == BLK_STS_IOERR)
-		return -EIO;
 
 	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
 		zone->wp_block += nr_blocks;
