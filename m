From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 10/10] md/dm-crypt: Delete unnecessary variable
 initialisations in crypt_iv_essiv_ctr()
Date: Wed, 28 Sep 2016 17:47:05 +0200
Message-ID: <3ce9ee21-2c4e-2b3b-1193-93dbec6fc8d1@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 16:44:32 +0200

Three local variables will be set to an appropriate pointer a bit later.
Thus omit the explicit initialisation which became unnecessary with
a previous update step.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 53a9155..d27716e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -361,9 +361,9 @@ static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	struct crypto_cipher *essiv_tfm = NULL;
-	struct crypto_ahash *hash_tfm = NULL;
-	u8 *salt = NULL;
+	struct crypto_cipher *essiv_tfm;
+	struct crypto_ahash *hash_tfm;
+	u8 *salt;
 	int err;
 
 	if (!opts) {
-- 
2.10.0
