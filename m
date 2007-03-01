From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: add IV generation method null
Date: Thu, 1 Mar 2007 16:16:32 +0100
Message-ID: <200703011616.33052.ludwig.nussel@suse.de>
References: <20070216142112.GA924@suse.de> <20070228144754.GA24504@suse.de>
	<20070301144112.GE3319@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070301144112.GE3319@agk.surrey.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair G Kergon wrote:
> On Wed, Feb 28, 2007 at 03:47:54PM +0100, Ludwig Nussel wrote:
> > Any comments/objections on the patch? Is there any additional action
> > from my side required to get this into the mainline kernel?
> 
> This comment ought to be more descriptive:
> 
>   null: For mounting legacy images only.

Ok, patch with better comment included.

> I'll include it in the next set of patches I send upstream.

Thanks! :-)

Add IV generation method 'null' to be able to read old filesystem
images created with SuSE's loop_fish2 module.

Signed-off-by: Ludwig Nussel <ludwig.nussel@suse.de>
Acked-By: Christophe Saout <christophe@saout.de>

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -103,6 +103,10 @@ static kmem_cache_t *_crypt_io_pool;
  *         encrypted with the bulk cipher using a salt as key. The salt
  *         should be derived from the bulk cipher's key via hashing.
  *
+ * null: the initial vector is always zero. This method is for
+ *       compatability with SuSE's obsolete loop_fish2 only. Do not
+ *       use it for creating new content.
+ *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
  */
@@ -203,6 +207,13 @@ static int crypt_iv_essiv_gen(struct cry
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
@@ -213,6 +224,9 @@ static struct crypt_iv_operations crypt_
 	.generator = crypt_iv_essiv_gen
 };
 
+static struct crypt_iv_operations crypt_iv_null_ops = {
+	.generator = crypt_iv_null_gen
+};
 
 static int
 crypt_convert_scatterlist(struct crypt_config *cc, struct scatterlist *out,
@@ -594,6 +608,8 @@ static int crypt_ctr(struct dm_target *t
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
