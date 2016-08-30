From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] dm crypt: fix free of bad values after tfm
	allocation failure
Date: Tue, 30 Aug 2016 09:51:44 -0700
Message-ID: <1472575904-52443-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

If crypt_alloc_tfms() had to allocate multiple tfms and it failed before
the last allocation, then it would call crypt_free_tfms() and free
pointers from uninitialized memory.  Fix by allocating zeroed memory.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index eedba67..fb8fd42 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1453,7 +1453,7 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 	unsigned i;
 	int err;
 
-	cc->tfms = kmalloc(cc->tfms_count * sizeof(struct crypto_skcipher *),
+	cc->tfms = kzalloc(cc->tfms_count * sizeof(struct crypto_skcipher *),
 			   GFP_KERNEL);
 	if (!cc->tfms)
 		return -ENOMEM;
-- 
2.8.0.rc3.226.g39d4020
