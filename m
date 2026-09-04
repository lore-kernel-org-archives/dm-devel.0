Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284053B2FFB
	for <dm-devel@lists.linux.dev>; Fri,  4 Sep 2026 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788520497; cv=none; b=pyKSCvs7R4WrO6MIo5n1CGuNCVpPO7BT1wCDyMzFg2O4RleR4GoW7ZMzcfJ5AVB1ircUunnaRew2+16FpBSn74wfjfv2ax9y/BR6BjLwDb1jBl99Jis5ivrM5UVsedcxapsYnPp6brHLOb6DOA4MQxT1kdEas+n4jFVLh3ie3OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788520497; c=relaxed/simple;
	bh=do2e29h3iCrpskwlYhRBdSGZ7dqx+VcFP7BHTISjrlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QGdPhN9UF29RnlOiAB1dYH98BD3NiVZ4/+1y6zCOlv6mbZnHap6O8MSriEqEimGcffr92viO7szhJowkz9HLNezgQkql4HLQt7qwhVAMOjgqiQ17xL2DQOB5rQALVFXK51zXNrmT9c4PbyR0LPlPdTT+vvzzLOJ3aM/BEB+c4jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOYIaDsd; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOYIaDsd"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6b1b9c3af5cso698100eaf.2
        for <dm-devel@lists.linux.dev>; Fri, 04 Sep 2026 04:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788520495; x=1789125295; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/WIywcI+KwOnj7pmM9lMtx2mzzeZ/y4sOtXjbhkXZsY=;
        b=VOYIaDsdAgge053Q42OgZf6DooBXnBUpu1fSMM5QJT/XJ4gI0DB7tXn0EpTwn8Sy9B
         FJgInij0DkRjzTvEsezfiVE5g/NjV+fbfrXPnAJ5pnZZwhdKaq8uxc7dNeLiaa+A4aMr
         43JN0KqCvlzZwXe9g7YHrVX+HxfMniInim633stDCjtpnmv8CkSaSyIkW0oDlPyqKtEr
         i3YL12+ej6eCtdno0SP/JVSttHqbHzwTaGUbfcMl8I02gWB5GWoqHTohYqNYvCW5WJTK
         +lyWgQ2pKH4gJLLKRDo4o6T2OdFmOxW7NNREb6cuZ6mEPStioZUxNrT6XxUNW1318TcP
         1+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788520495; x=1789125295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/WIywcI+KwOnj7pmM9lMtx2mzzeZ/y4sOtXjbhkXZsY=;
        b=sDHLzv09HNEPkBIyLm1o0LpKMsIhI1rYJPKu390XPzj0g+1CflMesx9xx2DqjYfXwH
         o8HhtxzDcJRMIW/oS2rTPfyDTX3UZelkS9TRjDYxzUt77c7KkqRRjB5qHlsi6PzWW4Ut
         OmQFhuApfnaWpoikXfcxPTyqOOSuTTOAT9zcdavK/8Fesn6cIsBJte+spuVmjA+IKsbm
         u8rPaPGQatpbKDaaDq9AG3EB83ELsF7iRJJ6F9Wxd7y/nS0WkGW+FioU/bDF8DeMlavn
         IXkT8zwq7XU8cIJSeHhGOOVwya7CDStGXkxe0m5P4f2f/XHQB/8oWtJSSpVqxHQ/e5gc
         Xm0Q==
X-Forwarded-Encrypted: i=1; AKwUvBx2o+LcKm4Evv0V6RtmBKY1qHMPlkiJ4t8hWD5RMG/6Q9uyV4fg1uG3tvIl+6hMTOvDd0lW1C+Dyw==@lists.linux.dev
X-Gm-Message-State: AFuF++mvG2iVjLJlbiq6Z0DRAGE30EN2Ju9N8N1Sie8HT0ZPQj9z+qYW
	WYqisto6HHAfQ3gBehV3EVrn+2JAyKatKUjWyziLxMsfqRYcBdErFVOj
X-Gm-Gg: AYBFou0h03HkQO7XxSycQbhMYB+vLVzlwLasB9KwaZsdQG7W1zou1AeUFbcjdkivOKj
	AUSlMyYXVAmdOhSPm+mjBxfHS9tA9qHG1kBivUTRF6bta38SE6xaDNsy2Q4ODYfJ0+/rhBlaRq+
	OiCnPQXXfzBsS8QeIwmRYLIo/6HWZN35w0S/VMWzdlmVO+4DLagcJukTIi2mes8epUoeek26QmI
	kI2CTvVCqoB0WB7vuESJcBLNPyS1WSfoUsJhA0QsoyA2Q1Z7bqkYBU2FAhIkvohR3yVvRK6pen8
	dYXsYbQRh8h7X1yK2OJMGU/MHVnmEKLXes1Ld3B4lu/IU8J/sstDeK3AzLdtF1lztbYfS4j+b6b
	29JrfKUnlBPIO7MXxvzHQn5x6wFycEEi5gsQsJK02ycCcvcl1baTGzxA+Hi6QNxk9bF9f/g9J2T
	Ou2zIolb/OqPspx+/jrkCshUwaqET0E5WcdJmd125R0FUvKswYtsC0lv3a94/+evlLVgmyAaat+
	9mmSwUmhIq5K24Z0HNL0dup7Q==
X-Received: by 2002:a05:6820:4d04:b0:6a0:f44b:1265 with SMTP id 006d021491bc7-6b6fa8e0837mr3671210eaf.4.1788520494911;
        Fri, 04 Sep 2026 04:14:54 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a62be87sm5397869eec.6.2026.09.04.04.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:14:54 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH] md: fix typos in comments
Date: Fri,  4 Sep 2026 16:44:46 +0530
Message-ID: <20260904111449.26892-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/md/dm-cache-metadata.c               | 2 +-
 drivers/md/dm-crypt.c                        | 2 +-
 drivers/md/dm-exception-store.h              | 2 +-
 drivers/md/dm-raid.c                         | 2 +-
 drivers/md/dm-raid1.c                        | 2 +-
 drivers/md/dm-unstripe.c                     | 2 +-
 drivers/md/persistent-data/dm-btree-remove.c | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index acd9b179fcb3..179b76173255 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -49,7 +49,7 @@ enum superblock_flag_bits {
 enum mapping_bits {
 	/*
 	 * A valid mapping.  Because we're using an array we clear this
-	 * flag for an non existant mapping.
+	 * flag for an non existent mapping.
 	 */
 	M_VALID = 1,
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9e170de50ad3..013579a3227f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2365,7 +2365,7 @@ static unsigned int crypt_authenckey_size(struct crypt_config *cc)
 /*
  * If AEAD is composed like authenc(hmac(sha256),xts(aes)),
  * the key must be for some reason in special format.
- * This funcion converts cc->key to this special format.
+ * This function converts cc->key to this special format.
  */
 static void crypt_copy_authenckey(char *p, const void *key,
 				  unsigned int enckeylen, unsigned int authkeylen)
diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 061b4d310813..6924d673cf45 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -135,7 +135,7 @@ struct dm_dev *dm_snap_origin(struct dm_snapshot *snap);
 struct dm_dev *dm_snap_cow(struct dm_snapshot *snap);
 
 /*
- * Funtions to manipulate consecutive chunks
+ * Functions to manipulate consecutive chunks
  */
 #define DM_CHUNK_CONSECUTIVE_BITS 8
 #define DM_CHUNK_NUMBER_BITS 56
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8f5a5e1342a9..ac019a0f5a92 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1784,7 +1784,7 @@ static int rs_check_takeover(struct raid_set *rs)
 
 		/* raid10* -> raid0 */
 		if (mddev->new_level == 0) {
-			/* Can takeover raid10_near with raid disks divisable by data copies! */
+			/* Can takeover raid10_near with raid disks divisible by data copies! */
 			if (near_copies > 1 &&
 			    !(mddev->raid_disks % near_copies)) {
 				mddev->raid_disks /= near_copies;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index da2a5e2002ec..36516338ca6f 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1393,7 +1393,7 @@ static void mirror_resume(struct dm_target *ti)
  * we have encountered.
  *    A => Alive - No failures
  *    D => Dead - A write failure occurred leaving mirror out-of-sync
- *    S => Sync - A sychronization failure occurred, mirror out-of-sync
+ *    S => Sync - A synchronization failure occurred, mirror out-of-sync
  *    R => Read - A read failure occurred, mirror data unaffected
  *
  * Returns: <char>
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index bfcbe6bfa71a..770a9958def0 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -33,7 +33,7 @@ static void cleanup_unstripe(struct unstripe_c *uc, struct dm_target *ti)
 }
 
 /*
- * Contruct an unstriped mapping.
+ * Construct an unstriped mapping.
  * <number of stripes> <chunk size> <stripe #> <dev_path> <offset>
  */
 static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index aeec5b9a1dd5..2357ff9b53f3 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -31,7 +31,7 @@
  * least MIN_ENTRIES + 1.  We do this in the following ways:
  *
  * [A] No siblings => this can only happen if the node is the root, in which
- *     case we copy the childs contents over the root.
+ *     case we copy the children contents over the root.
  *
  * [B] No left sibling
  *     ==> rebalance(node, right sibling)
-- 
2.48.1

