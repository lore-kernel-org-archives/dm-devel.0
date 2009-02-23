From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 11/14] barriers
Date: Mon, 23 Feb 2009 14:22:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902231422190.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Move test for not-supported barriers to __make_request.

This test is sensible only for drivers that use requests (such as disk
drivers), not for drivers that use bios (such as device mapper).

It is better to fix it in generic code than to make workaround for it
in device mapper.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.29-rc6-devel/block/blk-core.c
===================================================================
--- linux-2.6.29-rc6-devel.orig/block/blk-core.c	2009-02-23 18:43:37.000000000 +0100
+++ linux-2.6.29-rc6-devel/block/blk-core.c	2009-02-23 18:44:27.000000000 +0100
@@ -1145,6 +1145,12 @@ static int __make_request(struct request
 	const int unplug = bio_unplug(bio);
 	int rw_flags;
 
+	if (bio_barrier(bio) && bio_has_data(bio) &&
+	    (q->next_ordered == QUEUE_ORDERED_NONE)) {
+		bio_endio(bio, -EOPNOTSUPP);
+		return 0;
+	}
+
 	nr_sectors = bio_sectors(bio);
 
 	/*
@@ -1450,11 +1456,6 @@ static inline void __generic_make_reques
 			err = -EOPNOTSUPP;
 			goto end_io;
 		}
-		if (bio_barrier(bio) && bio_has_data(bio) &&
-		    (q->next_ordered == QUEUE_ORDERED_NONE)) {
-			err = -EOPNOTSUPP;
-			goto end_io;
-		}
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
