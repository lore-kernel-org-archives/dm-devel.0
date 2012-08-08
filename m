From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-verity: fix overflow checking
Date: Wed, 8 Aug 2012 17:06:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1208081704280.24738@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
Cc: Wesley Miaw <wmiaw@netflix.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

BTW. This patch improves dm-verity overflow checking.

Mikulas

---

dm-verity: fix overflow checking

Overflow checking in dm-verity was not sufficient.
It would check overflow if sector_t was smaller than long long but not
if sector_t and long long have the same size. This patch implements
proper overflow checking.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-3.5-fast/drivers/md/dm-verity.c
===================================================================
--- linux-3.5-fast.orig/drivers/md/dm-verity.c	2012-08-08 21:24:00.000000000 +0200
+++ linux-3.5-fast/drivers/md/dm-verity.c	2012-08-08 21:28:06.000000000 +0200
@@ -718,8 +718,8 @@ static int verity_ctr(struct dm_target *
 	v->hash_dev_block_bits = ffs(num) - 1;
 
 	if (sscanf(argv[5], "%llu%c", &num_ll, &dummy) != 1 ||
-	    num_ll << (v->data_dev_block_bits - SECTOR_SHIFT) !=
-	    (sector_t)num_ll << (v->data_dev_block_bits - SECTOR_SHIFT)) {
+	    (sector_t)(num_ll << (v->data_dev_block_bits - SECTOR_SHIFT))
+	    >> (v->data_dev_block_bits - SECTOR_SHIFT) != nul_ll) {
 		ti->error = "Invalid data blocks";
 		r = -EINVAL;
 		goto bad;
@@ -733,8 +733,8 @@ static int verity_ctr(struct dm_target *
 	}
 
 	if (sscanf(argv[6], "%llu%c", &num_ll, &dummy) != 1 ||
-	    num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT) !=
-	    (sector_t)num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT)) {
+	    (sector_t)(num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT))
+	    >> (v->hash_dev_block_bits - SECTOR_SHIFT) != num_ll) {
 		ti->error = "Invalid hash start";
 		r = -EINVAL;
 		goto bad;
