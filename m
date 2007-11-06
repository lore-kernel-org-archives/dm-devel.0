From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] LVM: Use rounddown_pow_of_two() macro for
	simplicity.
Date: Tue, 6 Nov 2007 11:56:57 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711061154220.24467@localhost.localdomain>
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
Cc: Andrew Morton <akpm@osdl.org>
List-Id: dm-devel.ids


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  since the source file already includes the log2.h header file, it
seems pointless to re-invent the necessary routine.


diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index cee16fa..fad8465 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -334,16 +334,6 @@ static int calc_max_buckets(void)
 }

 /*
- * Rounds a number down to a power of 2.
- */
-static uint32_t round_down(uint32_t n)
-{
-	while (n & (n - 1))
-		n &= (n - 1);
-	return n;
-}
-
-/*
  * Allocate room for a suitable hash table.
  */
 static int init_hash_tables(struct dm_snapshot *s)
@@ -361,8 +351,7 @@ static int init_hash_tables(struct dm_snapshot *s)
 	hash_size = min(origin_dev_size, cow_dev_size) >> s->chunk_shift;
 	hash_size = min(hash_size, max_buckets);

-	/* Round it down to a power of 2 */
-	hash_size = round_down(hash_size);
+	hash_size = rounddown_pow_of_two(hash_size);
 	if (init_exception_table(&s->complete, hash_size))
 		return -ENOMEM;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
