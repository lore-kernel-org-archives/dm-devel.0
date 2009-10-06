From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm snapshot: don't use zero chunksize
Date: Tue, 6 Oct 2009 19:01:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0910061859230.20258@hs20-bc2-1.build.redhat.com>
References: <20090930144110.GA16605@redhat.com>
	<20091002222716.GA5351@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091002222716.GA5351@agk-dp.fab.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When playing with invalid chunksizes, I have found another bug: under 
certain conditions (too small devices or too big chunksize) the calculated 
hash table size is zero. This triggers invalid C operation (a shift by -1) 
and causes "out of memory" messages --- when there's really nothing out of 
memory.

This patch changes it to use minimum 64 hashsize.

Mikulas

---

Under some special conditions (too big chunk size or zero-sized device),
the resulting hash_size is calculated as zero.

rounddown_pow_of_two(0) is undefined operation (it expands to shift by -1).
And init_exception_table with zero argument would fail with -ENOMEM.

This patch makes minimum chunk size 64, just like for pending exception table.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.31-fast-new/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-snap.c	2009-10-07 00:32:09.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-snap.c	2009-10-07 00:33:04.000000000 +0200
@@ -570,6 +570,8 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
+	if (hash_size < 64)
+		hash_size = 64;
 	hash_size = rounddown_pow_of_two(hash_size);
 	if (init_exception_table(&s->complete, hash_size,
 				 DM_CHUNK_CONSECUTIVE_BITS))
