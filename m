From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 4/8] md: use kzfree()
Date: Mon, 16 Feb 2009 15:29:30 +0100
Message-ID: <20090216144725.816139782@cmpxchg.org>
References: <20090216142926.440561506@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline; filename=md-use-kzfree.patch
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alasdair Kergon <dm-devel@redhat.com>
List-Id: dm-devel.ids

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alasdair Kergon <dm-devel@redhat.com>
---
 drivers/md/dm-crypt.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1137,8 +1137,7 @@ bad_ivmode:
 	crypto_free_ablkcipher(tfm);
 bad_cipher:
 	/* Must zero key material before freeing */
-	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
-	kfree(cc);
+	kzfree(cc);
 	return -EINVAL;
 }
 
@@ -1164,8 +1163,7 @@ static void crypt_dtr(struct dm_target *
 	dm_put_device(ti, cc->dev);
 
 	/* Must zero key material before freeing */
-	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
-	kfree(cc);
+	kzfree(cc);
 }
 
 static int crypt_map(struct dm_target *ti, struct bio *bio,


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
