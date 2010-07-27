From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1.5/2] dm-stripe: optimize sector division
Date: Tue, 27 Jul 2010 18:12:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007271811220.21698@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007271737310.14765@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1007271738500.14765@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Optimize sector division

Optimize sector division --- if the number of stripes is a power of two,
we don't have to do expensive division and can do shift and mask instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.35-rc6-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.35-rc6-fast.orig/drivers/md/dm-stripe.c	2010-07-28 00:01:04.000000000 +0200
+++ linux-2.6.35-rc6-fast/drivers/md/dm-stripe.c	2010-07-28 00:06:19.000000000 +0200
@@ -25,6 +25,7 @@ struct stripe {
 
 struct stripe_c {
 	uint32_t stripes;
+	int stripes_shift;
 
 	/* The size of this target / num. stripes */
 	sector_t stripe_width;
@@ -164,6 +165,10 @@ static int stripe_ctr(struct dm_target *
 	sc->ti = ti;
 
 	sc->stripes = stripes;
+	if (!(stripes & (stripes - 1)))
+		sc->stripes_shift = ffs(stripes) - 1;
+	else
+		sc->stripes_shift = -1;
 	sc->stripe_width = width;
 	ti->split_io = chunk_size;
 	ti->num_flush_requests = stripes;
@@ -212,7 +217,11 @@ static void stripe_map_sector(struct str
 {
 	sector_t offset = sector - sc->ti->begin;
 	sector_t chunk = offset >> sc->chunk_shift;
-	*stripe = sector_div(chunk, sc->stripes);
+	if (likely(sc->stripes_shift >= 0))
+		*stripe = chunk & ((1 << sc->stripes_shift) - 1),
+		chunk >>= sc->stripes_shift;
+	else
+		*stripe = sector_div(chunk, sc->stripes);
 	*result = (chunk << sc->chunk_shift) | (offset & sc->chunk_mask);
 }
 
