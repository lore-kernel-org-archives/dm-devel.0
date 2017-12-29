From: liuchaowei110@gmail.com
Subject: [PATCH 2/2] dm: optimze stripe index search algorithm
Date: Fri, 29 Dec 2017 20:34:00 +0800
Message-ID: <5a4636ea.5465650a.6d7db.95fe@mx.google.com>
References: <20171229123400.20127-1-liuchaowei>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171229123400.20127-1-liuchaowei>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, liuchaowei <liuchaowei@smartisan.com>
List-Id: dm-devel.ids

From: liuchaowei <liuchaowei@smartisan.com>

The previous stripe index search algorithm use sequential search and
it's very slow if there are many and many physical storage devices.

The new alrogithm save the stripe index into stripe node structure,
and this driver will fetch stripe index from stripe node pointer
directly, faster than sequential search from an array

Change-Id: Ia1b3e01d54484fd40b82c52c0777ff36aac721b3
Signed-off-by: liuchaowei <liuchaowei@smartisan.com>
---
 drivers/md/dm-asymmetric-stripe.c | 40 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-asymmetric-stripe.c b/drivers/md/dm-asymmetric-stripe.c
index ead77ff25c6b..4902fd6c4674 100644
--- a/drivers/md/dm-asymmetric-stripe.c
+++ b/drivers/md/dm-asymmetric-stripe.c
@@ -34,6 +34,11 @@
 
 typedef struct asymmetric_stripe asm_stripe;
 typedef struct asymmetric_stripe_c asm_stripe_c;
+typedef struct asymmetric_stripe_node asm_stripe_node;
+
+struct asymmetric_stripe_node {
+	uint32_t stripe_id;
+};
 
 struct asymmetric_stripe {
 	struct dm_dev *dev;
@@ -42,6 +47,7 @@ struct asymmetric_stripe {
 	sector_t physical_start;
 	sector_t stripe_width;
 	sector_t opt_io_size;
+	sector_t internal_offs;
 	uint32_t ratio;
 
 	atomic_t error_count;
@@ -63,6 +69,7 @@ struct asymmetric_stripe_c {
 	/* Work struct used for triggering events*/
 	struct work_struct trigger_event;
 
+	asm_stripe_node *node;
 	asm_stripe stripe[0];
 };
 
@@ -99,10 +106,13 @@ static int get_stripe(struct dm_target *ti,
 		unsigned int stripe,
 		char **argv)
 {
+	static uint32_t chunk_id;
 	unsigned long long start;
 	char dummy;
 	int ret;
 	unsigned int id = stripe;
+	sector_t offs_prev, size;
+	uint32_t i;
 
 	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1)
 		return -EINVAL;
@@ -116,6 +126,17 @@ static int get_stripe(struct dm_target *ti,
 	sc->stripe[id].stripe_width = sc->avg_width * sc->stripe[id].ratio;
 	sc->stripe[id].opt_io_size = sc->chunk_size * sc->stripe[id].ratio;
 
+	if (id > 0) {
+		offs_prev = sc->stripe[id-1].internal_offs;
+		size = offs_prev + sc->stripe[id-1].opt_io_size;
+	} else
+		size = 0;
+
+	sc->stripe[id].internal_offs = size;
+
+	for (i = 0; i < sc->stripe[id].ratio; i++, chunk_id++)
+		sc->node[chunk_id].stripe_id = id;
+
 	return 0;
 }
 
@@ -127,6 +148,7 @@ static int set_stripe_ratio(struct dm_target *ti,
 	unsigned int i;
 	uint32_t r = 0, ratio;
 	char *tmp_ratio = ratio_str;
+	size_t len;
 
 	if (sizeof(sc->ratio_str) < strlen(ratio_str)) {
 		ti->error = "Too big stripe ratio string";
@@ -146,6 +168,13 @@ static int set_stripe_ratio(struct dm_target *ti,
 		r += ratio;
 	}
 
+	len = sizeof(asm_stripe_node) * r;
+	sc->node = kmalloc(len, GFP_KERNEL);
+	if (sc->node == NULL) {
+		ti->error = "Memory allocation for striped node failed";
+		return -ENOMEM;
+	}
+
 	sc->total_ratio = r;
 	sc->avg_width = ti->len / r;
 	sc->stripe_size = r * sc->chunk_size;
@@ -245,6 +274,7 @@ static int asymmetric_stripe_ctr(struct dm_target *ti,
 parse_error:
 	while (i--)
 		dm_put_device(ti, sc->stripe[i].dev);
+	kfree(sc->node);
 	kfree(sc);
 	return -EINVAL;
 }
@@ -254,6 +284,7 @@ static inline sector_t stripe_index_fetch(asm_stripe_c *sc,
 		uint32_t *stripe)
 {
 	sector_t width_offset;
+	uint32_t chunk_id;
 
 	if (sc->stripe_size_shift < 0)
 		width_offset = sector_div(*sector, sc->stripe_size);
@@ -262,11 +293,9 @@ static inline sector_t stripe_index_fetch(asm_stripe_c *sc,
 		*sector >>= sc->stripe_size_shift;
 	}
 
-	for (*stripe = 0; *stripe < sc->stripes; (*stripe)++) {
-		if (width_offset < sc->stripe[*stripe].opt_io_size)
-			break;
-		width_offset -= sc->stripe[*stripe].opt_io_size;
-	}
+	chunk_id = width_offset / sc->chunk_size;
+	*stripe = sc->node[chunk_id].stripe_id;
+	width_offset -= sc->stripe[*stripe].internal_offs;
 
 	return width_offset;
 }
@@ -280,6 +309,7 @@ static void asymmetric_stripe_dtr(struct dm_target *ti)
 		dm_put_device(ti, sc->stripe[i].dev);
 
 	flush_work(&sc->trigger_event);
+	kfree(sc->node);
 	kfree(sc);
 }
 
-- 
2.15.1
