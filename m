From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/7] Don't optimize for failure case
Date: Wed, 18 Nov 2009 07:12:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180711510.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180711140.21358@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Don't optimize for failure case.

should_wake is just an optimization to avoid waking the thread up when
there's already something to do. Don't do this optimization in failure
handling code. It is totally pointless to optimize failures.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6.31-fast-new/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-raid1.c	2009-10-06 18:15:17.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-raid1.c	2009-10-06 18:15:20.000000000 +0200
@@ -529,7 +529,6 @@ static void write_callback(unsigned long
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
 	int uptodate = 0;
-	int should_wake = 0;
 	unsigned long flags;
 
 	ms = bio_get_m(bio)->ms;
@@ -561,12 +560,9 @@ static void write_callback(unsigned long
 		 * the main thread.
 		 */
 		spin_lock_irqsave(&ms->lock, flags);
-		if (!ms->failures.head)
-			should_wake = 1;
 		bio_list_add(&ms->failures, bio);
 		spin_unlock_irqrestore(&ms->lock, flags);
-		if (should_wake)
-			wakeup_mirrord(ms);
+		wakeup_mirrord(ms);
 		return;
 	}
 out:
