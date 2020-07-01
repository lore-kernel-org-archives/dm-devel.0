From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/6] crypto: algapi - remove crypto_check_attr_type()
Date: Tue, 30 Jun 2020 21:52:15 -0700
Message-ID: <20200701045217.121126-5-ebiggers@kernel.org>
References: <20200701045217.121126-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200701045217.121126-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

Remove crypto_check_attr_type(), since it's no longer used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/algapi.c         | 15 ---------------
 include/crypto/algapi.h |  1 -
 2 files changed, 16 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 24a56279ca80..58558fae12bd 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -818,21 +818,6 @@ struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb)
 }
 EXPORT_SYMBOL_GPL(crypto_get_attr_type);
 
-int crypto_check_attr_type(struct rtattr **tb, u32 type)
-{
-	struct crypto_attr_type *algt;
-
-	algt = crypto_get_attr_type(tb);
-	if (IS_ERR(algt))
-		return PTR_ERR(algt);
-
-	if ((algt->type ^ type) & algt->mask)
-		return -EINVAL;
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_check_attr_type);
-
 const char *crypto_attr_alg_name(struct rtattr *rta)
 {
 	struct crypto_attr_alg *alga;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index dce57c89cf98..78902563512b 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -116,7 +116,6 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 void *crypto_spawn_tfm2(struct crypto_spawn *spawn);
 
 struct crypto_attr_type *crypto_get_attr_type(struct rtattr **tb);
-int crypto_check_attr_type(struct rtattr **tb, u32 type);
 const char *crypto_attr_alg_name(struct rtattr *rta);
 int crypto_attr_u32(struct rtattr *rta, u32 *num);
 int crypto_inst_setname(struct crypto_instance *inst, const char *name,
-- 
2.27.0
