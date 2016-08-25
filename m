From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-crypt: rename crypt_setkey_allcpus to
	crypt_setkey
Date: Thu, 25 Aug 2016 07:12:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1608250711520.24332@file01.intranet.prod.int.rdu2.redhat.com>
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

In the past, dm-crypt used per-cpu crypto context. This has been removed 
in the kernel 3.15 and the crypto context is shared between all cpus. This 
patch renames the function crypt_setkey_allcpus to crypt_setkey, because 
there is really no activity that is done for all cpus.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -1470,7 +1470,7 @@ static int crypt_alloc_tfms(struct crypt
 	return 0;
 }
 
-static int crypt_setkey_allcpus(struct crypt_config *cc)
+static int crypt_setkey(struct crypt_config *cc)
 {
 	unsigned subkey_size;
 	int err = 0, i, r;
@@ -1507,7 +1507,7 @@ static int crypt_set_key(struct crypt_co
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	r = crypt_setkey_allcpus(cc);
+	r = crypt_setkey(cc);
 
 out:
 	/* Hex key string not needed after here, so wipe it. */
@@ -1521,7 +1521,7 @@ static int crypt_wipe_key(struct crypt_c
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
 
-	return crypt_setkey_allcpus(cc);
+	return crypt_setkey(cc);
 }
 
 static void crypt_dtr(struct dm_target *ti)
