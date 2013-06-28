From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-verity: Fix a boundary condition that caused
 failure for certain device sizes
Date: Fri, 28 Jun 2013 10:12:12 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1306281007500.16553@file01.intranet.prod.int.rdu2.redhat.com>
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
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Cc: xuelingko@gmail.com, Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Fix a boundary condition that caused failure for certain device sizes

The problem is reported at
http://code.google.com/p/cryptsetup/issues/detail?id=160

For certain device sizes the number of hashes at a specific level was
calculated incorrectly.

It happens for example for a device with data and metadata block size 4096
that has 16385 blocks and algorithm sha256.

This patch fixes it.

The same bug exists in the veritysetup tool, so you must use fixed
veritysetup too if you want to use devices that are affected by this
boundary condition.

Cc: stable@kernel.org  # 3.4+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-3.9.8-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.9.8-fast.orig/drivers/md/dm-verity.c	2013-06-28 00:58:12.000000000 +0200
+++ linux-3.9.8-fast/drivers/md/dm-verity.c	2013-06-28 02:01:32.000000000 +0200
@@ -831,9 +831,8 @@ static int verity_ctr(struct dm_target *
 	for (i = v->levels - 1; i >= 0; i--) {
 		sector_t s;
 		v->hash_level_block[i] = hash_position;
-		s = verity_position_at_level(v, v->data_blocks, i);
-		s = (s >> v->hash_per_block_bits) +
-		    !!(s & ((1 << v->hash_per_block_bits) - 1));
+		s = (v->data_blocks + ((sector_t)1 << ((i + 1) * v->hash_per_block_bits)) - 1)
+					>> ((i + 1) * v->hash_per_block_bits);
 		if (hash_position + s < hash_position) {
 			ti->error = "Hash device offset overflow";
 			r = -E2BIG;
