From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-raid1: remove unused condition
Date: Mon, 15 Oct 2012 16:38:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210151638030.10685@file.rdu.redhat.com>
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

dm-raid1: remove unused condition

mempool_alloc can't fail if __GFP_WAIT is specified, so the condition
that tests if read_record is non-NULL is always true.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-3.6.2-fast/drivers/md/dm-raid1.c
===================================================================
--- linux-3.6.2-fast.orig/drivers/md/dm-raid1.c	2012-10-15 21:31:57.000000000 +0200
+++ linux-3.6.2-fast/drivers/md/dm-raid1.c	2012-10-15 21:34:20.000000000 +0200
@@ -1198,11 +1198,9 @@ static int mirror_map(struct dm_target *
 		return -EIO;
 
 	read_record = mempool_alloc(ms->read_record_pool, GFP_NOIO);
-	if (likely(read_record)) {
-		dm_bio_record(&read_record->details, bio);
-		map_context->ptr = read_record;
-		read_record->m = m;
-	}
+	dm_bio_record(&read_record->details, bio);
+	map_context->ptr = read_record;
+	read_record->m = m;
 
 	map_bio(m, bio);
 
