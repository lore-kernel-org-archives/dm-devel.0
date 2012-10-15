From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid: use DM_ENDIO_INCOMPLETE
Date: Mon, 15 Oct 2012 16:39:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210151638360.10685@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-raid: use DM_ENDIO_INCOMPLETE

Use a defined macro DM_ENDIO_INCOMPLETE instead of a numeric constant.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.6.2-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm-raid1.c	2012-10-15 21:39:30.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm-raid1.c	2012-10-15 21:40:55.000000000 +0200
@@ -1260,7 +1260,7 @@ static int mirror_end_io(struct dm_targe
 			mempool_free(read_record, ms->read_record_pool);
 			map_context->ptr = NULL;
 			queue_bio(ms, bio, rw);
-			return 1;
+			return DM_ENDIO_INCOMPLETE;
 		}
 		DMERR("All replicated volumes dead, failing I/O");
 	}
