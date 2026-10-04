Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8013EDAB5
	for <dm-devel@lists.linux.dev>; Sun,  4 Oct 2026 10:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791109033; cv=none; b=Omh4vYAJ4eqGrhVZQqix05AImJNfSDDtVo0O8QlA/GWib4ZerKWcFB8vD1JeeZ3Aa399a/s9HSOvvcKBz3ewrW/FEMyWsa6RXd43PFDYZvDa6g6rK9qKwXAVbeF2ZjYockR39ayyc8znzzh6AYOykqZEiHkWlNxbZ9eykq4j1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791109033; c=relaxed/simple;
	bh=OhCZLURNadE3CZuuDYvJNvkcZci0cIPtguZPDWGn4Qw=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PFAk4jt77vk+4PspD6V+qWE8DQiwjAGmefhTYSi/GC1+YELjoQAdjsgjmS7qMLhVMl5dOtNkjdFUaDafYlqp89Fv5rhWiXYjNmmmPXTHngjKyBFCoKAD1GsMgp9fFtiiDrbzgluyhlyeoiXG4VIWpZVbbvBDvjOncG6GXKsRK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ll3AdIsu; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ll3AdIsu"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71974de4so379625e9.1
        for <dm-devel@lists.linux.dev>; Sun, 04 Oct 2026 03:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791109029; x=1791713829; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=l3jm7AZDhohaccFrYhLBx5kcJ8ETJl6L+7tqknuEu1M=;
        b=Ll3AdIsuyWyuosCWEV9AbhfOLIqPqtWfXzNk+2ShAhP8RXUAZ2L56qAuQRq7KGHnEA
         QqvtZKgDukbiZgx8RmfJxkLOvUAObvt+jEHLFksp5dPDIpuzYyHCCmtP3JhgoLUPtRGw
         wcvFUUVNXIzmMOeTFQ2fK9RQzZQB30rofEJGGo/+sTXef/NpJwP7Wz/K1IWkPTN82pEC
         w4SYBJP8/PJmoHnvXAl0L7f6GicaiCMtlvjpntZlHjWS9N/t8dmKnBzQmytmLD4VY1P7
         kgkWyjrN0597bNABnK1CNR2c57eXDLiR0mILKgPpiyX1W88mW+gVJoQi1WDKaVA/IM72
         F/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791109029; x=1791713829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=l3jm7AZDhohaccFrYhLBx5kcJ8ETJl6L+7tqknuEu1M=;
        b=QkBAqO3JyBblKZITQ+fo6TqbPwoUtvujYuYd0mo5ZZjG5uXSjaRGG+yaPQXLlobnah
         CVn8FeuH2LD80Qhe/cbZFu4/T4nFGb/tRqU/q/spdzYqVtdW48hm9JL119Cj9mD7Iv/G
         nrWA6n4RPZp8tsnRnDwhAdlckupr1RooGPF2zV2Dky1rjsYiCHjegO3Q6EbZGW4vzPyR
         s/OXkIRafv8psIVvaqV93hMC4gjIlr0U5Rd+QuzZtzgfYUGMekybwOuA8VgA5cmBSt7l
         ioft/6DgEUjRO/5SjcPnrpmgud5wtW+FoJwoR09Dq5p/yvBfjxjQW02FuQ37XJKuaEM/
         ozYg==
X-Forwarded-Encrypted: i=1; AKwUvByAtaVaTN1YV63d/2igOTr1ScfJYT2WQNOYYywOdukbx8642qn6PV1R0m24TwMrnmm/HlmJmbiFRA==@lists.linux.dev
X-Gm-Message-State: AFuF++kIKYSxsMEUPpkedJqnY9FZ4vOHzkDhU0yodZWl+5ftShkB8Tfr
	4zDbXBvDvBKxgT5ZTPWaJp74DaitXOoLB1qm4L1Nee/RmFm6poIsPz5u
X-Gm-Gg: AYBFou2CM0eeuMCJCbR6xNQ8U+K/Mma2MdOL0QPCljENfG2fqpCrK8nMJgbfsTrVkMJ
	j7BpW6CpThy1e8Ur8OGvUGkIoE0PEBBjAtwYHi1fgUcPOqZw7EofuFth5TRrhzs/jBnFXiOuBa6
	vT//kehtFe1btuXn2DkNc5IltzRILKvQkkuVNOdpzwbjQ4c2qr7dzGRyw2otAWACqF19FpD9efM
	Bbn63XzVs8VBYdKrtK134fNS5FHREIkvY42GOjAbdSJKBkIzBCVY1zYsqMI6JILWnAoFpbD3eLJ
	o9zY3T4kBvi+xIhXExXd5cBtmWHfGe8qWYFnT0RD7A8w9ABWbp9QvG4XfdCTLpcMOi/g7YRey6e
	BUVxoEzKjjGHyNHnfp5ijcYDFDYiXS2GK3GPrpaZgFrXLpclvdw2veqieCSElwuUd1vm1CziZLs
	vVAyvzxCbGOrTh1TDHQ/OAuPULC3VOFVBnxAedJ/5GaoaQP3hPMC44DLAC5A5vK18jjUGc76GNc
	1rDsbLt8uWB9JT/vpY=
X-Received: by 2002:a05:600c:6217:b0:4a0:1e9f:64f6 with SMTP id 5b1f17b1804b1-4a027454f31mr114643005e9.0.1791109029324;
        Sun, 04 Oct 2026 03:17:09 -0700 (PDT)
Received: from L-P-ITAIH2-L-RF.rf.local ([193.169.70.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1698f7910sm73030505e9.3.2026.10.04.03.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 03:17:08 -0700 (PDT)
From: Itai Handler <itai.handler@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 1/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
Date: Sun,  4 Oct 2026 13:16:22 +0300
Message-Id: <20261004101622.2184287-2-itai.handler@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261004101622.2184287-1-itai.handler@gmail.com>
References: <20261004101622.2184287-1-itai.handler@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "sector_size:<bytes>" option is capped at 4096 bytes.  The reason is
stated in commit 8f0009a22517 ("dm crypt: optionally support larger
encryption sector size"): "the maximal IO must fit into the page limit,
so the limit is set to the minimal page size possible (4096 bytes)."

The rule is right; only the way it is resolved is not.  The page limit
it refers to is a property of the kernel that is running, but it was
written as the smallest page size of any architecture, so a kernel with
larger pages is held to a limit that belongs to a different one.  The
block layer has since stopped doing that for its own block size, in
commit 47dd67532303 ("block/bdev: lift block size restrictions to 64k"),
and dm-crypt is now the stricter of the two.

Apply the same rule to the kernel being built: raise the cap to
min(PAGE_SIZE, BLK_MAX_BLOCK_SIZE).

PAGE_SIZE is still the page limit the original commit meant.  A sector is
passed to the crypto API as a single scatterlist entry, bio_iter_iovec()
never returns more than PAGE_SIZE bytes, and crypt_alloc_buffer() may
fall back to order-0 pages for the write bounce buffer.

BLK_MAX_BLOCK_SIZE caps the logical block size that crypt_io_hints()
announces.  It is PAGE_SIZE without transparent hugepages, and 64K with
them, which no architecture having a PAGE_SIZE above 64K can enable - so
it does not lower the bound on any configuration today.  It is in the
expression so that this target cannot announce a block size
blk_validate_limits() would reject.

A larger unit also turns several crypto requests per page into one.
Whether that is worth anything depends on the driver: for a CPU cipher
the per-request cost is small, and it only pays off where a request
carries a large fixed cost, as when the cipher is offloaded over DMA.

Widen sector_size to unsigned int so that it can hold a sector larger
than 65535.  That also makes the option reject an argument of 69632,
which %hu truncates to 4096 and accepts as a 4096-byte sector.

Document that an encryption sector larger than the unit the device
writes atomically can be torn by a power failure, and what each cipher
mode does when that happens.

The maximum stays 4096 wherever PAGE_SIZE is 4096, the default stays 512
bytes, and every table using a size from 512 to 4096 behaves as it did.
The one behavioural change is the truncation above: an argument that
wrapped into range is now rejected rather than silently accepted.  A
mapping larger than 4096 bytes can only be activated where PAGE_SIZE
allows, so it is not suitable for portable on-disk formats.  Bump the
target version so that userspace can detect the new limit.

Assisted-by: LLM
Signed-off-by: Itai Handler <itai.handler@gmail.com>
---
 .../admin-guide/device-mapper/dm-crypt.rst    | 20 ++++++++++++-
 drivers/md/dm-crypt.c                         | 30 +++++++++++++++----
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index 4467f6d4b632..3a87cd4daf13 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -153,9 +153,27 @@ integrity_key_size:<bytes>
 
 sector_size:<bytes>
     Use <bytes> as the encryption unit instead of 512 bytes sectors.
-    This option can be in range 512 - 4096 bytes and must be power of two.
+    This option can be in range 512 - PAGE_SIZE bytes, further limited by
+    the block layer's maximum block size, and must be power of two.
     Virtual device will announce this size as a minimal IO and logical sector.
 
+    An encryption unit larger than 4096 bytes can only be used on a system
+    whose PAGE_SIZE is at least that large, so such a mapping is not
+    portable across architectures and is unsuitable for portable on-disk
+    formats such as LUKS.
+
+    An encryption sector larger than the unit the underlying device writes
+    atomically can be torn by a power failure, leaving part of the sector
+    written and part not. A device that advertises no atomic write unit
+    gives no such guarantee beyond a single logical block, so this is
+    already possible at 4096 bytes; a larger sector widens the window.
+    With XTS and ECB the torn sector decrypts to a mixture of old and new
+    data, as a torn write does on an unencrypted device. With chaining
+    modes the block at the tear also decrypts to garbage, with AEAD the
+    whole sector fails authentication, and with the wide-block diffusers
+    the whole sector decrypts to garbage. Use a large sector only where
+    losing a sector to a power failure is acceptable.
+
 iv_large_sectors
    IV generators will use sector number counted in <sector_size> units
    instead of default 512 bytes sectors.
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8e838530faab..045face6924b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -182,7 +182,7 @@ struct crypt_config {
 	} iv_gen_private;
 	u64 iv_offset;
 	unsigned int iv_size;
-	unsigned short sector_size;
+	unsigned int sector_size;
 	unsigned char sector_shift;
 
 	union {
@@ -241,6 +241,24 @@ struct crypt_config {
 #define MAX_TAG_SIZE	480
 #define POOL_ENTRY_SIZE	512
 
+/*
+ * Largest encryption sector size that can be requested with the
+ * "sector_size:<bytes>" option.
+ *
+ * A sector is handed to the crypto API as a single scatterlist entry, so it
+ * has to be covered by one bio_vec.  bio_iter_iovec() never returns more than
+ * PAGE_SIZE bytes, and crypt_alloc_buffer() may fall back to order-0 pages
+ * for the write bounce buffer, so PAGE_SIZE is the ceiling.
+ *
+ * crypt_io_hints() announces the sector size as the logical block size, which
+ * the block layer caps at BLK_MAX_BLOCK_SIZE.  That cap is never below
+ * PAGE_SIZE in any configuration today, so it does not lower the limit; take
+ * the minimum anyway so that this target cannot announce a block size
+ * blk_validate_limits() would reject.
+ */
+#define DM_CRYPT_MAX_SECTOR_SIZE	MIN_T(unsigned int, PAGE_SIZE, \
+					      BLK_MAX_BLOCK_SIZE)
+
 static DEFINE_SPINLOCK(dm_crypt_clients_lock);
 static unsigned int dm_crypt_clients_n;
 static volatile unsigned long dm_crypt_pages_per_client;
@@ -3137,9 +3155,9 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 			}
 			cc->key_mac_size = val;
 			set_bit(CRYPT_KEY_MAC_SIZE_SET, &cc->cipher_flags);
-		} else if (sscanf(opt_string, "sector_size:%hu%c", &cc->sector_size, &dummy) == 1) {
+		} else if (sscanf(opt_string, "sector_size:%u%c", &cc->sector_size, &dummy) == 1) {
 			if (cc->sector_size < (1 << SECTOR_SHIFT) ||
-			    cc->sector_size > 4096 ||
+			    cc->sector_size > DM_CRYPT_MAX_SECTOR_SIZE ||
 			    (cc->sector_size & (cc->sector_size - 1))) {
 				ti->error = "Invalid feature value for sector_size";
 				return -EINVAL;
@@ -3559,7 +3577,7 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 			if (cc->used_tag_size)
 				DMEMIT(" integrity:%u:%s", cc->used_tag_size, cc->cipher_auth);
 			if (cc->sector_size != (1 << SECTOR_SHIFT))
-				DMEMIT(" sector_size:%d", cc->sector_size);
+				DMEMIT(" sector_size:%u", cc->sector_size);
 			if (test_bit(CRYPT_IV_LARGE_SECTORS, &cc->cipher_flags))
 				DMEMIT(" iv_large_sectors");
 			if (test_bit(CRYPT_KEY_MAC_SIZE_SET, &cc->cipher_flags))
@@ -3585,7 +3603,7 @@ static void crypt_status(struct dm_target *ti, status_type_t type,
 			DMEMIT(",integrity_tag_size=%u,cipher_auth=%s",
 			       cc->used_tag_size, cc->cipher_auth);
 		if (cc->sector_size != (1 << SECTOR_SHIFT))
-			DMEMIT(",sector_size=%d", cc->sector_size);
+			DMEMIT(",sector_size=%u", cc->sector_size);
 		if (cc->cipher_string)
 			DMEMIT(",cipher_string=%s", cc->cipher_string);
 
@@ -3703,7 +3721,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 29, 0},
+	.version = {1, 30, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
2.34.1

