From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 4/7] crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
Date: Thu,  9 Jul 2020 23:20:39 -0700
Message-ID: <20200710062042.113842-5-ebiggers@kernel.org>
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

CRYPTO_ALG_NEED_FALLBACK is handled inconsistently.  When it's requested
to be clear, some templates propagate that request to child algorithms,
while others don't.

It's apparently desired for NEED_FALLBACK to be propagated, to avoid
deadlocks where a module tries to load itself while it's being
initialized, and to avoid unnecessarily complex fallback chains where we
have e.g. cbc-aes-$driver falling back to cbc(aes-$driver) where
aes-$driver itself falls back to aes-generic, instead of cbc-aes-$driver
simply falling back to cbc(aes-generic).  There have been a number of
fixes to this effect:

commit 89027579bc6c ("crypto: xts - Propagate NEED_FALLBACK bit")
commit d2c2a85cfe82 ("crypto: ctr - Propagate NEED_FALLBACK bit")
commit e6c2e65c70a6 ("crypto: cbc - Propagate NEED_FALLBACK bit")

But it seems that other templates can have the same problems too.

To avoid this whack-a-mole, just add NEED_FALLBACK to INHERITED_FLAGS so
that it's always inherited.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ctr.c            | 2 --
 crypto/skcipher.c       | 2 --
 crypto/xts.c            | 2 --
 include/crypto/algapi.h | 3 ++-
 include/linux/crypto.h  | 4 ++--
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index ae8d88c715d6..c39fcffba27f 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -265,8 +265,6 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return err;
-	mask |= crypto_requires_off(crypto_get_attr_type(tb),
-				    CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 3b93a74ad124..467af525848a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -943,8 +943,6 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return ERR_PTR(err);
-	mask |= crypto_requires_off(crypto_get_attr_type(tb),
-				    CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/xts.c b/crypto/xts.c
index 35a30610569b..9a7adab6c3e1 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -340,8 +340,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return err;
-	mask |= crypto_requires_off(crypto_get_attr_type(tb),
-				    CRYPTO_ALG_NEED_FALLBACK);
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index da64c37482b4..22cf4d80959f 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -245,7 +245,8 @@ static inline u32 crypto_requires_off(struct crypto_attr_type *algt, u32 off)
  * template), these are the flags that should always be set on the "outer"
  * algorithm if any "inner" algorithm has them set.
  */
-#define CRYPTO_ALG_INHERITED_FLAGS	CRYPTO_ALG_ASYNC
+#define CRYPTO_ALG_INHERITED_FLAGS	\
+	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK)
 
 /*
  * Given the type and mask that specify the flags restrictions on a template
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7cd2d00f0a05..f73f0b51e1cd 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -60,8 +60,8 @@
 #define CRYPTO_ALG_ASYNC		0x00000080
 
 /*
- * Set this bit if and only if the algorithm requires another algorithm of
- * the same type to handle corner cases.
+ * Set if the algorithm (or an algorithm which it uses) requires another
+ * algorithm of the same type to handle corner cases.
  */
 #define CRYPTO_ALG_NEED_FALLBACK	0x00000100
 
-- 
2.27.0
