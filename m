From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 02/10] md/dm-crypt: Reduce the scope for a variable in
 crypt_alloc_tfms()
Date: Wed, 28 Sep 2016 17:38:27 +0200
Message-ID: <2cc0fee8-2228-1f0c-9428-3b872a39e64b@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 14:05:25 +0200

Move the definition for the variable "err" (including its declaration)
into an if branch (so that the corresponding setting will only be performed
if a call of the function "crypto_alloc_skcipher" failed as before
this refactoring).

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 68971a2..88a3b62 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1452,7 +1452,6 @@ static void crypt_free_tfms(struct crypt_config *cc)
 static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 {
 	unsigned i;
-	int err;
 
 	cc->tfms = kcalloc(cc->tfms_count, sizeof(*cc->tfms), GFP_KERNEL);
 	if (!cc->tfms)
@@ -1461,7 +1460,8 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 	for (i = 0; i < cc->tfms_count; i++) {
 		cc->tfms[i] = crypto_alloc_skcipher(ciphermode, 0, 0);
 		if (IS_ERR(cc->tfms[i])) {
-			err = PTR_ERR(cc->tfms[i]);
+			int err = PTR_ERR(cc->tfms[i]);
+
 			crypt_free_tfms(cc);
 			return err;
 		}
-- 
2.10.0

