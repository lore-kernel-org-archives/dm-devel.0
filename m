From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: add IV generation method null
Date: Fri, 16 Feb 2007 15:21:12 +0100
Message-ID: <20070216142112.GA924@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
Resent-To: dm-devel@redhat.com
Resent-Message-Id: <E1HKHkw-0006QK-Iq@agk.surrey.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

Hi,

Following patch (against SUSE's 2.6.18) adds the IV generation
method 'null' to be able to read old filesystem images created with
SuSE's loop_fish2 module.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Acked-By: Christophe Saout <christophe@saout.de>

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -103,6 +103,8 @@ static kmem_cache_t *_crypt_io_pool;
  *         encrypted with the bulk cipher using a salt as key. The salt
  *         should be derived from the bulk cipher's key via hashing.
  *
+ * null: For mounting legacy images only.
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -203,6 +205,13 @@ static int crypt_iv_essiv_gen(struct cry
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
@@ -213,6 +222,9 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_essiv_gen
 };
 
+static struct crypt_iv_operations crypt_iv_null_ops = {
+	.generator = crypt_iv_null_gen
+};
 
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
@@ -594,6 +606,8 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_gen_ops = &crypt_iv_plain_ops;
 	else if (strcmp(ivmode, "essiv") == 0)
 		cc->iv_gen_ops = &crypt_iv_essiv_ops;
+	else if (strcmp(ivmode, "null") == 0)
+		cc->iv_gen_ops = &crypt_iv_null_ops;
 	else {
 		ti->error = "Invalid IV mode";
 		goto bad2;

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE Labs
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)
