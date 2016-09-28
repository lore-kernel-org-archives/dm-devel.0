From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 01/10] md/dm-crypt: Use kcalloc() in crypt_alloc_tfms()
Date: Wed, 28 Sep 2016 17:36:45 +0200
Message-ID: <6aabc850-778f-7fc1-0cf7-f8e023ff4c9f@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 28 Sep 2016 13:26:22 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Fixes: 5d0be84ec0cacfc7a6d6ea548afdd07d481324cd ("dm crypt: fix free of bad values after tfm allocation failure")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a276883..68971a2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1454,8 +1454,7 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 	unsigned i;
 	int err;
 
-	cc->tfms = kzalloc(cc->tfms_count * sizeof(struct crypto_skcipher *),
-			   GFP_KERNEL);
+	cc->tfms = kcalloc(cc->tfms_count, sizeof(*cc->tfms), GFP_KERNEL);
 	if (!cc->tfms)
 		return -ENOMEM;
 
-- 
2.10.0

