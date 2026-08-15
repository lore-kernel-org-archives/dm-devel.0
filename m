Received: from mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFED33E37A
	for <dm-devel@lists.linux.dev>; Sat, 15 Aug 2026 11:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786791998; cv=none; b=Qh+l5HUde+coj9XcsbmCrh2LUCEqQXdhG5cNLUBjbBgvJfolejYg2iErZmsuSLNUi3nb2HRU3QoufnAgsjdhNKt/L5Mtfr5IhcJycdV/GHTHBMs01whtwM9JJHKWy4uwZZobKvVxZ7WHrJojRCzo4A4+YaAqeYcWyHBMquMWyS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786791998; c=relaxed/simple;
	bh=1WdTn+7H9RJKUpvaMNGvGCbAlYyK8JOZD2Kd1+lXH2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SCi37YvhHhmXYKC1WB8wgc0G7tR1outzEN1UxDcHtuSFJURHG1pWVRSmw8tgjAu+vaaUIaaAtR2pJJsrcBW7pNWtQLgOkXK6Zp0IyY/9rSd5oxoOeEuQu8vlFcMsAAugoQCZ5stbR2jhGmok6c+y8vn1NrCK33N5YPM3mxoc8zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OFJ9qcrn; arc=none smtp.client-ip=95.215.58.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OFJ9qcrn"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=1WdTn+7H9RJKUpvaMNGvGCbAlYyK8JOZD2Kd1+lXH2w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786791992; v=1; x=1787396792;
 b=OFJ9qcrngFF0Pb+OJcBaKCrVBRPrx4E7BN+a4YqFx4N0cdI5lk0Ho1HY6OeaKCmn7Goswzgb
 wonbsCqViF0cvZF36s9N/46yTAfRSdXbSrgGWt0LAlvOWtaID35Nl8efxSEmQB8ZZzypXIW+5Yu
 uForyrFCkPxgCUP2PzAC+1WM=
X-Envelope-To: dm-devel@lists.linux.dev
Received: from fedora.fritz.box (62.216.208.217)
	by smtp.migadu.com with ESMTPS id ca7c6818f9b6bd40;
	Sat, 15 Aug 2026 11:06:32 +0000
X-Migadu-Flow: FLOW_OUT
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm-crypt: Use memzero_explicit() to wipe key material
Date: Sat, 15 Aug 2026 13:05:33 +0200
Message-ID: <20260815110532.5343-3-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3206; i=thorsten.blum@linux.dev; h=from:subject; bh=1WdTn+7H9RJKUpvaMNGvGCbAlYyK8JOZD2Kd1+lXH2w=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkN7n8mtfWrlTpI9HMW/O175NV04EhLvX/Kp7vfJL/4i rQ86jncUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABPpPcLwP2d5R84D/YyX7+dI PN/fcj+e3V7R67pUsM3EPP97ly/f+MTwz+Kxpf3DBZ855QXyPnVuFkmeeMG8p7T/9u5Z4RanV4u s5gYA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The code still wipes key material with memset(). Use memzero_explicit()
to prevent the compiler from optimizing these wipes away.

Also use size_t for the string length passed to memzero_explicit() and
drop the redundant sizeof(u8) multiplications.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/md/dm-crypt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..5194294871db 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -513,7 +513,7 @@ static void crypt_iv_lmk_wipe(struct crypt_config *cc)
 	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
 
 	if (lmk->seed)
-		memset(lmk->seed, 0, LMK_SEED_SIZE);
+		memzero_explicit(lmk->seed, LMK_SEED_SIZE);
 }
 
 static void crypt_iv_lmk_one(struct crypt_config *cc, u8 *iv,
@@ -630,8 +630,8 @@ static void crypt_iv_tcw_wipe(struct crypt_config *cc)
 {
 	struct iv_tcw_private *tcw = &cc->iv_gen_private.tcw;
 
-	memset(tcw->iv_seed, 0, cc->iv_size);
-	memset(tcw->whitening, 0, TCW_WHITENING_SIZE);
+	memzero_explicit(tcw->iv_seed, cc->iv_size);
+	memzero_explicit(tcw->whitening, TCW_WHITENING_SIZE);
 }
 
 static void crypt_iv_tcw_whitening(struct crypt_config *cc,
@@ -2596,7 +2596,7 @@ static int get_key_size(char **key_string)
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
 	int r = -EINVAL;
-	int key_string_len = strlen(key);
+	size_t key_string_len = strlen(key);
 
 	/* Hyphen (which gives a key_size of zero) means there is no key. */
 	if (!cc->key_size && strcmp(key, "-"))
@@ -2625,7 +2625,7 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 out:
 	/* Hex key string not needed after here, so wipe it. */
-	memset(key, '0', key_string_len);
+	memzero_explicit(key, key_string_len);
 
 	return r;
 }
@@ -2644,7 +2644,7 @@ static int crypt_wipe_key(struct crypt_config *cc)
 	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
 	r = crypt_setkey(cc);
-	memset(&cc->key, 0, cc->key_size * sizeof(u8));
+	memzero_explicit(cc->key, cc->key_size);
 
 	return r;
 }
@@ -3065,7 +3065,7 @@ static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
 
 	/* wipe the kernel key payload copy */
 	if (cc->key_string)
-		memset(cc->key, 0, cc->key_size * sizeof(u8));
+		memzero_explicit(cc->key, cc->key_size);
 
 	return ret;
 }
@@ -3644,7 +3644,7 @@ static int crypt_message(struct dm_target *ti, unsigned int argc, char **argv,
 			/* The key size may not be changed. */
 			key_size = get_key_size(&argv[2]);
 			if (key_size < 0 || cc->key_size != key_size) {
-				memset(argv[2], '0', strlen(argv[2]));
+				memzero_explicit(argv[2], strlen(argv[2]));
 				return -EINVAL;
 			}
 
@@ -3655,7 +3655,7 @@ static int crypt_message(struct dm_target *ti, unsigned int argc, char **argv,
 				ret = cc->iv_gen_ops->init(cc);
 			/* wipe the kernel key payload copy */
 			if (cc->key_string)
-				memset(cc->key, 0, cc->key_size * sizeof(u8));
+				memzero_explicit(cc->key, cc->key_size);
 			return ret;
 		}
 		if (argc == 2 && !strcasecmp(argv[1], "wipe"))
