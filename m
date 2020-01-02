From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: fix GFP flags
Date: Thu, 2 Jan 2020 08:23:32 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001020822080.32205@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

GFP_KERNEL is not supposed to be ored with GFP_NOFS (the result is
equivalent to GFP_KERNEL). Also, we use GFP_NOIO instead of GFP_NOFS,
because we don't want any I/O being submitted in the direct reclaim path.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v5.4+

---
 drivers/md/dm-crypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2020-01-02 14:16:21.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2020-01-02 14:16:21.000000000 +0100
@@ -717,7 +717,7 @@ static int crypt_iv_eboiv_gen(struct cry
 	struct crypto_wait wait;
 	int err;
 
-	req = skcipher_request_alloc(any_tfm(cc), GFP_KERNEL | GFP_NOFS);
+	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
 	if (!req)
 		return -ENOMEM;
 
