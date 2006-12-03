From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: [PATCH] crypto: bewbi IV,
	big endian wide block count for ABL-32-AES
Date: Sun,  3 Dec 2006 13:48:21 +0100
Message-ID: <11651501113230-git-send-email-rsnel@cube.dyndns.org>
References: <11651501031841-git-send-email-rsnel@cube.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11651501031841-git-send-email-rsnel@cube.dyndns.org>
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
Cc: herbert@gondor.apana.org.au
List-Id: dm-devel.ids

From: Rik Snel <rsnel@cube.dyndns.org>

ABL-32-AES needs a certain IV. This IV should be provided dm-crypt.
The block cipher mode could, in principle, generate the correct IV from
the plain IV, but I think that it is cleaner to supply the right IV
directly.

The sector -> wide block calculation is currently just a conversion
to bigendian and an increment, but if dm-crypt will support cypher
blocksizes larger than 512 bytes (which would be interesting for
wide blocks) the conversion will include a shift also.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 drivers/md/dm-crypt.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2c7aaac..a88dc95 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -117,6 +117,9 @@ static kmem_cache_t *_crypt_io_pool;
  * benbi: the 64-bit "big-endian 'narrow block'-count", starting at 1
  *        (needed for LRW-32-AES and possible other narrow block modes)
  *
+ * bewbi: the 64-bit "big-endian 'wide block'-count", starting at 1
+ *        (needed for ABL-32-AES and possible other wide block modes)
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -251,6 +254,14 @@ static int crypt_iv_benbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 	return 0;
 }
 
+static int crypt_iv_bewbi_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+{
+	memset(iv, 0, cc->iv_size - sizeof(u32));
+	*((u32*)iv + 3) = cpu_to_be32((sector & 0xffffffff) + 1);
+
+	return 0;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -267,6 +278,10 @@ static struct crypt_iv_operations crypt_iv_benbi_ops = {
 	.generator = crypt_iv_benbi_gen
 };
 
+static struct crypt_iv_operations crypt_iv_bewbi_ops = {
+	.generator = crypt_iv_bewbi_gen
+};
+
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
                           struct scatterlist *in, unsigned int length,
@@ -815,7 +830,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	cc->tfm = tfm;
 
 	/*
-	 * Choose ivmode. Valid modes: "plain", "essiv:<esshash>", "benbi".
+	 * Choose ivmode. Valid modes: "plain", "essiv:<esshash>", "benbi",
+	 *	"bewbi".
 	 * See comments at iv code
 	 */
 
@@ -827,6 +843,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
 	else if (strcmp(ivmode, "benbi") == 0)
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ivmode, "bewbi") == 0)
+		cc->iv_gen_ops = &crypt_iv_bewbi_ops;
 	else {
 		ti->error = "Invalid IV mode";
 		goto bad2;
-- 
1.4.4.1
