From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/7] crypto: seqiv - remove seqiv_create()
Date: Thu,  9 Jul 2020 23:20:37 -0700
Message-ID: <20200710062042.113842-3-ebiggers@kernel.org>
References: <20200710062042.113842-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200710062042.113842-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

seqiv_create() is pointless because it just checks that the template is
being instantiated as an AEAD, then calls seqiv_aead_create().  But
seqiv_aead_create() does the exact same check, via aead_geniv_alloc().

Just remove seqiv_create() and use seqiv_aead_create() directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/seqiv.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index e48f875a7aac..23e22d8b63e6 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -164,23 +164,9 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-static int seqiv_create(struct crypto_template *tmpl, struct rtattr **tb)
-{
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
-		return -EINVAL;
-
-	return seqiv_aead_create(tmpl, tb);
-}
-
 static struct crypto_template seqiv_tmpl = {
 	.name = "seqiv",
-	.create = seqiv_create,
+	.create = seqiv_aead_create,
 	.module = THIS_MODULE,
 };
 
-- 
2.27.0
