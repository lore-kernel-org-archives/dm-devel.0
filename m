From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-stripe: remove minimum stripe size
Date: Mon, 18 Jun 2012 09:23:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206180923280.17218@file.rdu.redhat.com>
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

dm-stripe: remove minimum stripe size

There is no technical limitation in device mapper that would prevent the
dm-stripe target from using a stripe size smaller than page size.

This patch removes the limit and makes stripe volumes portable across
architectures with different page size.

The patch also makes it reject stripe sizes that do not fit to 32 bits.
(previously the upper bits were truncated)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stripe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.4.2-fast/drivers/md/dm-stripe.c
===================================================================
--- linux-3.4.2-fast.orig/drivers/md/dm-stripe.c	2012-06-18 14:52:22.000000000 +0200
+++ linux-3.4.2-fast/drivers/md/dm-stripe.c	2012-06-18 15:07:39.000000000 +0200
@@ -96,7 +96,7 @@ static int stripe_ctr(struct dm_target *
 	struct stripe_c *sc;
 	sector_t width;
 	uint32_t stripes;
-	uint32_t chunk_size;
+	unsigned long chunk_size;
 	char *end;
 	int r;
 	unsigned int i;
@@ -113,7 +113,7 @@ static int stripe_ctr(struct dm_target *
 	}
 
 	chunk_size = simple_strtoul(argv[1], &end, 10);
-	if (*end || (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
+	if (*end || !chunk_size || chunk_size != (uint32_t)chunk_size) {
 		ti->error = "Invalid chunk_size";
 		return -EINVAL;
 	}
