From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] dm: constify crypt_iv_operations structures
Date: Sun, 29 Nov 2015 14:09:19 +0100
Message-ID: <1448802559-2671-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

The crypt_iv_operations are never modified, so declare them
as const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/md/dm-crypt.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3147c8d..c7058fc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -141,7 +141,7 @@ struct crypt_config {
 	char *cipher;
 	char *cipher_string;
 
-	struct crypt_iv_operations *iv_gen_ops;
+	const struct crypt_iv_operations *iv_gen_ops;
 	union {
 		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
@@ -756,15 +756,15 @@ static int crypt_iv_tcw_post(struct crypt_config *cc, u8 *iv,
 	return r;
 }
 
-static struct crypt_iv_operations crypt_iv_plain_ops = {
+static const struct crypt_iv_operations crypt_iv_plain_ops = {
 	.generator = crypt_iv_plain_gen
 };
 
-static struct crypt_iv_operations crypt_iv_plain64_ops = {
+static const struct crypt_iv_operations crypt_iv_plain64_ops = {
 	.generator = crypt_iv_plain64_gen
 };
 
-static struct crypt_iv_operations crypt_iv_essiv_ops = {
+static const struct crypt_iv_operations crypt_iv_essiv_ops = {
 	.ctr       = crypt_iv_essiv_ctr,
 	.dtr       = crypt_iv_essiv_dtr,
 	.init      = crypt_iv_essiv_init,
@@ -772,17 +772,17 @@ static struct crypt_iv_operations crypt_iv_essiv_ops = {
 	.generator = crypt_iv_essiv_gen
 };
 
-static struct crypt_iv_operations crypt_iv_benbi_ops = {
+static const struct crypt_iv_operations crypt_iv_benbi_ops = {
 	.ctr	   = crypt_iv_benbi_ctr,
 	.dtr	   = crypt_iv_benbi_dtr,
 	.generator = crypt_iv_benbi_gen
 };
 
-static struct crypt_iv_operations crypt_iv_null_ops = {
+static const struct crypt_iv_operations crypt_iv_null_ops = {
 	.generator = crypt_iv_null_gen
 };
 
-static struct crypt_iv_operations crypt_iv_lmk_ops = {
+static const struct crypt_iv_operations crypt_iv_lmk_ops = {
 	.ctr	   = crypt_iv_lmk_ctr,
 	.dtr	   = crypt_iv_lmk_dtr,
 	.init	   = crypt_iv_lmk_init,
@@ -791,7 +791,7 @@ static struct crypt_iv_operations crypt_iv_lmk_ops = {
 	.post	   = crypt_iv_lmk_post
 };
 
-static struct crypt_iv_operations crypt_iv_tcw_ops = {
+static const struct crypt_iv_operations crypt_iv_tcw_ops = {
 	.ctr	   = crypt_iv_tcw_ctr,
 	.dtr	   = crypt_iv_tcw_dtr,
 	.init	   = crypt_iv_tcw_init,

