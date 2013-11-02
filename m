From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 4/4] dm-crypt: Fix sparse (different base types)
	warnings
Date: Sat,  2 Nov 2013 22:24:04 +0100
Message-ID: <1383427444-19174-2-git-send-email-gmazyland@gmail.com>
References: <20131030181241.GA24325@agk-dp.fab.redhat.com>
	<1383427444-19174-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383427444-19174-1-git-send-email-gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

drivers/md/dm-crypt.c:575:16: warning: incorrect type in assignment (different base types)
drivers/md/dm-crypt.c:575:16:    expected unsigned int [unsigned] <noident>
drivers/md/dm-crypt.c:575:16:    got restricted __le32 [usertype] <noident>
...

Explicitly define endianess to silence these annoying warnings.

N.B. there is still warning about variable length array,
but this code is common use of hash structure on stack on
many parts of the kernel.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2d6ee75f..b71583e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -550,7 +550,7 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
 		char ctx[crypto_shash_descsize(lmk->hash_tfm)];
 	} sdesc;
 	struct md5_state md5state;
-	u32 buf[4];
+	__le32 buf[4];
 	int i, r;
 
 	sdesc.desc.tfm = lmk->hash_tfm;
@@ -696,7 +696,7 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 				  u8 *data)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	u64 sector = cpu_to_le64((u64)dmreq->iv_sector);
+	__le64 sector = cpu_to_le64((u64)dmreq->iv_sector);
 	u8 buf[TCW_WHITENING_SIZE];
 	struct {
 		struct shash_desc desc;
@@ -738,7 +738,7 @@ static int crypt_iv_tcw_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
-	u64 sector = cpu_to_le64((u64)dmreq->iv_sector);
+	__le64 sector = cpu_to_le64((u64)dmreq->iv_sector);
 	u8 *src;
 	int r = 0;
 
-- 
1.8.4.2
