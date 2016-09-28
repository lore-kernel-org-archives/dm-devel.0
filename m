From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 05/10] md/dm-crypt: Rename a jump label in crypt_set_key()
Date: Wed, 28 Sep 2016 17:42:28 +0200
Message-ID: <f89d98a2-fe7e-a9d3-5bdc-2a1943e09049@users.sourceforge.net>
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
Date: Wed, 28 Sep 2016 15:21:18 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7778e9b..7e0fd82 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1496,20 +1496,19 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 	/* The key size may not be changed. */
 	if (cc->key_size != (key_string_len >> 1))
-		goto out;
+		goto set_memory;
 
 	/* Hyphen (which gives a key_size of zero) means there is no key. */
 	if (!cc->key_size && strcmp(key, "-"))
-		goto out;
+		goto set_memory;
 
 	if (cc->key_size && crypt_decode_key(cc->key, key, cc->key_size) < 0)
-		goto out;
+		goto set_memory;
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
 	r = crypt_setkey_allcpus(cc);
-
-out:
+set_memory:
 	/* Hex key string not needed after here, so wipe it. */
 	memset(key, '0', key_string_len);
 
-- 
2.10.0

