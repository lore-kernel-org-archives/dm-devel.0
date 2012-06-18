From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-stripe: remove stripes_mask
Date: Mon, 18 Jun 2012 09:23:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206180921230.17218@file.rdu.redhat.com>
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

dm-stripe: remove stripes_mask

The structure stripe_c contains a stripes_mask field. This field is
useless because it can be trivially calculated by subtracting one from
stripes. It is used only at one place. This patch removes it.

The patch also changes ffs(stripes) - 1 to __ffs(stripes).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-3.4.2-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-3.4.2-fast.orig/drivers/md/dm-stripe.c	2012-06-18 12:53:23.000000000 +0200
+++ linux-3.4.2-fast/drivers/md/dm-stripe.c	2012-06-18 12:54:10.000000000 +0200
@@ -26,7 +26,6 @@ struct stripe {
 struct stripe_c {
 	uint32_t stripes;
 	int stripes_shift;
-	sector_t stripes_mask;
 
 	/* The size of this target / num. stripes */
 	sector_t stripe_width;
@@ -158,10 +157,8 @@ static int stripe_ctr(struct dm_target *
 
 	if (stripes & (stripes - 1))
 		sc->stripes_shift = -1;
-	else {
-		sc->stripes_shift = ffs(stripes) - 1;
-		sc->stripes_mask = ((sector_t) stripes) - 1;
-	}
+	else
+		sc->stripes_shift = __ffs(stripes);
 
 	r = dm_set_target_max_io_len(ti, chunk_size);
 	if (r)
@@ -226,7 +223,7 @@ static void stripe_map_sector(struct str
 	if (sc->stripes_shift < 0)
 		*stripe = sector_div(chunk, sc->stripes);
 	else {
-		*stripe = chunk & sc->stripes_mask;
+		*stripe = chunk & (sc->stripes - 1);
 		chunk >>= sc->stripes_shift;
 	}
 
