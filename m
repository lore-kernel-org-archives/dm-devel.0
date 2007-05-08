From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 08/26] dm crypt: add null iv
Date: Tue, 8 May 2007 20:45:39 +0100
Message-ID: <20070508194539.GO24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

From: Ludwig Nussel <ludwig.nussel@suse.de>

Add a new IV generation method 'null' to read old filesystem images
created with SuSE's loop_fish2 module.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Acked-By: Christophe Saout <christophe@saout.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-crypt.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6.21/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-crypt.c	2007-05-01 17:40:49.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-crypt.c	2007-05-01 17:40:49.000000000 +0100
@@ -121,6 +121,9 @@ static void clone_init(struct crypt_io *
  * benbi: the 64-bit "big-endian 'narrow block'-count", starting at 1
  *        (needed for LRW-32-AES and possible other narrow block modes)
  *
+ * null: the initial vector is always zero.  Provides compatibility with
+ *       obsolete loop_fish2 devices.  Do not use for new devices.
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -257,6 +260,13 @@ static int crypt_iv_benbi_gen(struct cry
 	return 0;
 }
 
+static int crypt_iv_null_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
+{
+	memset(iv, 0, cc->iv_size);
+
+	return 0;
+}
+
 static struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
@@ -273,6 +283,10 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_benbi_gen
 };
 
+static struct crypt_iv_operations crypt_iv_null_ops = {
+	.generator = crypt_iv_null_gen
+};
+
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
                           struct scatterlist *in, unsigned int length,
@@ -803,6 +817,8 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
 	else if (strcmp(ivmode, "benbi") == 0)
 		cc->iv_gen_ops = &crypt_iv_benbi_ops;
+	else if (strcmp(ivmode, "null") == 0)
+		cc->iv_gen_ops = &crypt_iv_null_ops;
 	else {
 		ti->error = "Invalid IV mode";
 		goto bad2;
@@ -1030,7 +1046,7 @@ error:
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version= {1, 3, 0},
+	.version= {1, 5, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
