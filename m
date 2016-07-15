From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: increase mempool size
Date: Fri, 15 Jul 2016 17:30:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607151728060.20843@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Milan Broz <mbroz@redhat.com>, mstnizer@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Increase mempool size from 16 to 64 entries.

When swapping to dm-crypt, all available memory is temporarily exhausted
and dm-crypt is only using the mempool reserve. Increasing mempool reserve
improves swapping performance.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -181,7 +181,7 @@ struct crypt_config {
 	u8 key[0];
 };
 
-#define MIN_IOS        16
+#define MIN_IOS        64
 
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
