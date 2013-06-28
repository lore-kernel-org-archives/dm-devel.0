From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-verity: Fix a boundary condition that
 caused failure for certain device sizes
Date: Fri, 28 Jun 2013 10:56:31 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1306281013480.16714@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1306281007500.16553@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1306281007500.16553@file01.intranet.prod.int.rdu2.redhat.com>
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



On Fri, 28 Jun 2013, Mikulas Patocka wrote:

Fix a boundary condition that caused failure for certain device sizes

The problem is reported at
http://code.google.com/p/cryptsetup/issues/detail?id=160

This is the userspace fix.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com

---
 lib/verity/verity_hash.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: cryptsetup-1.6.1/lib/verity/verity_hash.c
===================================================================
--- cryptsetup-1.6.1.orig/lib/verity/verity_hash.c	2013-06-28 01:20:35.000000000 +0200
+++ cryptsetup-1.6.1/lib/verity/verity_hash.c	2013-06-28 01:24:47.000000000 +0200
@@ -220,7 +220,7 @@ static int VERITY_create_or_verify_hash(
 	off_t hash_level_block[VERITY_MAX_LEVELS];
 	off_t hash_level_size[VERITY_MAX_LEVELS];
 	off_t data_file_blocks, s;
-	size_t hash_per_block, hash_per_block_bits;
+	size_t hash_per_block_bits;
 	off_t data_device_size = 0, hash_device_size = 0;
 	uint64_t dev_size;
 	int levels, i, r;
@@ -251,7 +251,6 @@ static int VERITY_create_or_verify_hash(
 	}
 
 	hash_per_block_bits = get_bits_down(hash_block_size / digest_size);
-	hash_per_block = 1 << hash_per_block_bits;
 	if (!hash_per_block_bits)
 		return -EINVAL;
 
@@ -271,8 +270,7 @@ static int VERITY_create_or_verify_hash(
 	for (i = levels - 1; i >= 0; i--) {
 		hash_level_block[i] = hash_position;
 		// verity position of block data_file_blocks at level i
-		s = data_file_blocks >> (i * hash_per_block_bits);
-		s = (s + hash_per_block - 1) / hash_per_block;
+		s = (data_file_blocks + ((off_t)1 << ((i + 1) * hash_per_block_bits)) - 1) >> ((i + 1) * hash_per_block_bits);
 		hash_level_size[i] = s;
 		if ((hash_position + s) < hash_position ||
 		    (hash_position + s) < 0) {
