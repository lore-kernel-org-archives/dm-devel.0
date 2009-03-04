From: akpm@linux-foundation.org
Subject: [patch 1/1] md: use kzfree()
Date: Wed, 04 Mar 2009 12:04:18 -0800
Message-ID: <200903042004.n24K4JuE029084@imap1.linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, penberg@cs.helsinki.fi, akpm@linux-foundation.org, hannes@cmpxchg.org
List-Id: dm-devel.ids

From: Johannes Weiner <hannes@cmpxchg.org>

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Alasdair Kergon <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-crypt.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-crypt.c~md-use-kzfree drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~md-use-kzfree
+++ a/drivers/md/dm-crypt.c
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
_
