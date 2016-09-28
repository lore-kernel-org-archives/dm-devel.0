From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 09/10] md/dm-crypt: Two checks and one function call less in
 crypt_iv_essiv_ctr() after error detection
Date: Wed, 28 Sep 2016 17:46:03 +0200
Message-ID: <5d9795a8-a7ee-915c-ac83-f61100e9e639@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 16:38:37 +0200

The kfree() function was called in one case by the crypt_iv_essiv_ctr()
function during error handling even if the passed variable "salt"
contained a null pointer.

* Adjust a jump target according to the Linux coding style convention.

* Delete this function call and a condition check which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 47f6265..53a9155 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -382,7 +382,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	if (!salt) {
 		ti->error = "Error kmallocing salt storage in ESSIV";
 		err = -ENOMEM;
-		goto bad;
+		goto free_hash;
 	}
 
 	cc->iv_gen_private.essiv.salt = salt;
@@ -397,11 +397,8 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	cc->iv_private = essiv_tfm;
 
 	return 0;
-
-bad:
-	if (hash_tfm && !IS_ERR(hash_tfm))
-		crypto_free_ahash(hash_tfm);
-	kfree(salt);
+free_hash:
+	crypto_free_ahash(hash_tfm);
 	return err;
 }
 
-- 
2.10.0

