From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 06/10] md/dm-crypt: Delete an unnecessary variable
 initialisation in crypt_set_key()
Date: Wed, 28 Sep 2016 17:43:22 +0200
Message-ID: <1a9b8a2d-8ae6-52f6-99b7-7e6172b6b6d1@users.sourceforge.net>
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
Date: Wed, 28 Sep 2016 15:24:13 +0200

The local variable "r" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7e0fd82..3bc54c1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1491,7 +1491,7 @@ static int crypt_setkey_allcpus(struct crypt_config *cc)
 
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
-	int r = -EINVAL;
+	int r;
 	int key_string_len = strlen(key);
 
 	/* The key size may not be changed. */
-- 
2.10.0
