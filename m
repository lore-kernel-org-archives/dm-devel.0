From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: test return value for DM_MAPIO_SUBMITTED
Date: Wed, 1 Jul 2015 17:30:36 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507011730020.16375@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

In properly written code we should not assume that DM_MAPIO_SUBMITTED is
zero. We should test the return value for DM_MAPIO_SUBMITTED rather than
testing it for zero.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-4.1/drivers/md/dm.c
===================================================================
--- linux-4.1.orig/drivers/md/dm.c	2015-06-29 19:38:06.000000000 +0200
+++ linux-4.1/drivers/md/dm.c	2015-06-29 19:38:33.000000000 +0200
@@ -1526,7 +1526,7 @@ static void __map_bio(struct dm_target_i
 		md = tio->io->md;
 		dec_pending(tio->io, r);
 		free_tio(md, tio);
-	} else if (r) {
+	} else if (r != DM_MAPIO_SUBMITTED) {
 		DMWARN("unimplemented target map return value: %d", r);
 		BUG();
 	}
