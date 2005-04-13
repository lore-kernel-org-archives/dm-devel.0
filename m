From: Bjorn Andersson <bjorn.andersson@silversmedjan.se>
Subject: dm-crypt userland key patch
Date: Wed, 13 Apr 2005 23:58:52 +0200
Message-ID: <20050413235852.45bd2500@emotpin>
References: <ac71172a05041310417117dd09@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="Multipart=_Wed__13_Apr_2005_23_58_52_+0200_BVXZgQBwSWwy4MAU"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac71172a05041310417117dd09@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: code@kryo.se
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--Multipart=_Wed__13_Apr_2005_23_58_52_+0200_BVXZgQBwSWwy4MAU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello

Patch to the dm-crypt module so that it hides the crypto-key from
userland. (dmsetup table)

Adds an extra option (DM_CRYPT_NULLKEYSTATUS) to
config/menuconfig/whateverconfig, under dm-crypt, so you can toggle the
patch.


Code by Bjorn Andersson and Erik Ekman.

// Bjorn

--Multipart=_Wed__13_Apr_2005_23_58_52_+0200_BVXZgQBwSWwy4MAU
Content-Type: text/x-patch;
 name="dm-crypt-nullkey.patch"
Content-Disposition: attachment;
 filename="dm-crypt-nullkey.patch"
Content-Transfer-Encoding: 7bit

diff -ur linux-2.6.11-gentoo-r4/drivers/md/Kconfig linux-2.6.11-gentoo-r4-mod/drivers/md/Kconfig
--- linux-2.6.11-gentoo-r4/drivers/md/Kconfig	2005-03-18 14:44:33.000000000 +0100
+++ linux-2.6.11-gentoo-r4-mod/drivers/md/Kconfig	2005-04-12 15:46:03.000000000 +0200
@@ -207,6 +207,18 @@
 
 	  If unsure, say N.
 
+config DM_CRYPT_NULLKEYSTATUS
+	bool "Hide key from userspace"
+	depends on DM_CRYPT
+	---help---
+	  When executing 'dmsetup table' it prints the crypto-key for all 
+	  mounted dm-crypt-devices. See dmsetup(8).
+
+	  This hides the real key and returns a key of zeros instead.
+
+	  If paranoid or unsure, say Y.
+	  If you need to see your keys in runtime, say N.
+
 config DM_SNAPSHOT
        tristate "Snapshot target (EXPERIMENTAL)"
        depends on BLK_DEV_DM && EXPERIMENTAL
diff -ur linux-2.6.11-gentoo-r4/drivers/md/dm-crypt.c linux-2.6.11-gentoo-r4-mod/drivers/md/dm-crypt.c
--- linux-2.6.11-gentoo-r4/drivers/md/dm-crypt.c	2005-04-12 12:51:28.000000000 +0200
+++ linux-2.6.11-gentoo-r4-mod/drivers/md/dm-crypt.c	2005-04-12 15:36:35.000000000 +0200
@@ -518,6 +518,7 @@
 /*
  * Encode key into its hex representation
  */
+#ifndef CONFIG_DM_CRYPT_NULLKEYSTATUS
 static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
 {
 	unsigned int i;
@@ -528,6 +529,7 @@
 		key++;
 	}
 }
+#endif
 
 /*
  * Construct an encryption mapping:
@@ -900,8 +902,11 @@
 		if (cc->key_size > 0) {
 			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
 				return -ENOMEM;
-
+#ifdef CONFIG_DM_CRYPT_NULLKEYSTATUS
+			memset(result + sz, '0', cc->key_size << 1);	
+#else
 			crypt_encode_key(result + sz, cc->key, cc->key_size);
+#endif
 			sz += cc->key_size << 1;
 		} else {
 			if (sz >= maxlen)

--Multipart=_Wed__13_Apr_2005_23_58_52_+0200_BVXZgQBwSWwy4MAU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--Multipart=_Wed__13_Apr_2005_23_58_52_+0200_BVXZgQBwSWwy4MAU--
