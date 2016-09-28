From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 07/10] md/dm-crypt: Rename a jump label in
 crypt_iv_tcw_whitening()
Date: Wed, 28 Sep 2016 17:44:14 +0200
Message-ID: <0d5a2aa2-b713-4c2a-cfe4-9c72fe8ec44a@users.sourceforge.net>
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
Date: Wed, 28 Sep 2016 15:32:15 +0200

Adjust jump labels according to the current Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3bc54c1..c457b5e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -698,13 +698,13 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	for (i = 0; i < 4; i++) {
 		r = crypto_shash_init(desc);
 		if (r)
-			goto out;
+			goto zero_memory;
 		r = crypto_shash_update(desc, &buf[i * 4], 4);
 		if (r)
-			goto out;
+			goto zero_memory;
 		r = crypto_shash_final(desc, &buf[i * 4]);
 		if (r)
-			goto out;
+			goto zero_memory;
 	}
 	crypto_xor(&buf[0], &buf[12], 4);
 	crypto_xor(&buf[4], &buf[8], 4);
@@ -712,7 +712,7 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	/* apply whitening (8 bytes) to whole sector */
 	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
 		crypto_xor(data + i * 8, buf, 8);
-out:
+zero_memory:
 	memzero_explicit(buf, sizeof(buf));
 	return r;
 }
-- 
2.10.0

