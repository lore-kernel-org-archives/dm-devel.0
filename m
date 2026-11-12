Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.230.196.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490931;
	b=EPaMkBpzufHto87JObdL2k0mXeQP7hu7LRdMzaiXPAn8JpgxIp6dXx7+aREUvWPbZl3z
	 q9Z6NQ9Wwwci3d2dxmOk0jC5Ox7B88frZdOkydIaltVd8AKtweSLWZAcxHREXe/OgwuNK
	 Gc+SH7MH87+uE5UHFXn03W9gtPKEb3quf7GFa5jOoCyXkkbf6agw8zOOQJ4JAzsWeoDh/
	 pm9cDd1rD0ZJw5xzYA2WHSJnWHHWtJ9vbjQBgzzqRGeoaPfoZJ5ilL0yiTto2MHzsUMGN
	 9Xx+jKvrBOp4NgCgouRGpijzECGCXb92OHydJqym+S0+vnvk1Xyl1BEWjzEYQWapbPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490931;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=KAOxkN7k61kk5jB4lBPmNan8FcEwgZkxLh55eZiLZ1E=;
	b=GkO6fWa0UgSKTMHbHRY+j4axO1/VhhhbqDvyUG4uIm/KAhHuemuXC7Lu662HXsAtGuEl
	 ohjYn5W0mu9ZSAGhedsiVyWzVmsvhwWYrsHMCY9aH+lQxHec3uEnvZSfINaJ8oITpV6nS
	 ZB4uPkX+ICDMgFbmW+e3KwNOTbi1IAkw99bhYTSYjcNTBh6coRsWRsFFElEYyzIjMMtKq
	 MXfD+1leSqZ9c+JkWksOihrumgQJoRPHO3F7TcKLlraH+KaNlUpSHfMBWkAPYgYjXl4ht
	 2bEFhF74aONkiVzQljvz5s0sP87x01G4NnGi5tL/wYZ+RFVdFpFCGpS3iw8GIynVLhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=xYl95GU3;
	arc=none smtp.remote-ip=37.230.196.243
Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB67606A31C
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 13:42:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AB67606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=xYl95GU3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1794490926;
	bh=JFkgqyB9Qz4kgc74Z73hpp3q8ytJXtkelNU5Si7Ll8g=;
	h=From:To:Cc:Subject:Date:From;
	b=xYl95GU3amK1NcwLSA/KZrnbuXOde3M4NbVwP39PBTjGYaVCV0QtZmdCAuTgR0y0p
	 PmY/qw7AIpdLVBjP8tajGwySo0ACOLfroXGbZJbuWaEU81chB1crZR8Mw10RLQQetR
	 m8NLmA7tTDngwJqfVTlsBdNlgFY94THBNIku/kpOkTudn4PddUiw6b30AlKGvE39LG
	 VMQaqNkTbc4z0/8W6iAOSLXzu4dw5lCY7UMwIQBoVhxvEks1m6hZaWjPXjhmtUF6ZJ
	 8f7lloiTCu4Uf6q0wX6kmJyWQ1hf608S6obgF+GB83/iEBmP5wNG9i2BCWnqdnHw4d
	 GiHQFHtD9rLlg==
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id AC78D255EC;
	Thu, 12 Nov 2026 16:42:06 +0300 (MSK)
Received: from mail.astralinux.ru (unknown [10.205.207.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Thu, 12 Nov 2026 16:42:00 +0300 (MSK)
Received: from DESKTOP-D46TNHI (rbta-msk-lt-981255.astralinux.ru [10.198.28.246])
	by mail.astralinux.ru (Postfix) with ESMTPA id 4jQM4m38XtzVQV;
	Thu, 12 Nov 2026 16:42:00 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10/5.15] dm array: validate array block headers on read
Date: Thu, 12 Nov 2026 16:40:10 +0300
Message-ID: <20261112134011.586-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 134 0.3.134 ce9cca31102af372fedb0df49d70b90f771aea0b, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;mail.astralinux.ru:7.1.1;astralinux.ru:7.1.1, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207439 [Nov 12 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/11/12 10:50:00 #28857468
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 2965787723084835b18dfe993cd450ebf5bd4540 upstream.

array_block_check() validates blocknr and csum and nothing else, while
node_check(), next to it, has bounded the structural fields since both
were written. dm_array_cursor_next() takes its loop bound from the
on-disk nr_entries and element_at() is unguarded pointer arithmetic, so
a count larger than the block holds keeps the cursor in one block while
the index grows past it and the read walks off the dm-bufio buffer --
dm_cache_load_mappings() drives it once per cache block at activation.

Check the header against itself: reject a zero value_size, require
max_entries to equal calc_max_entries() for that value_size and block
size, and require nr_entries to fit. Equality rather than an upper bound,
since a count below the real capacity trips BUG_ON() in fill_ablock() and
trim_ablock(). Metadata dm-array writes satisfies all three.

Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[mdmitrichenko: Keep the existing non-const validator argument when
 moving calc_max_entries() above array_block_prepare_for_write().]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-89574

 drivers/md/persistent-data/dm-array.c | 37 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index b7c82ad11bcc..c18349dd36d3 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -37,6 +37,14 @@ struct array_block {
  */
 #define CSUM_XOR 595846735
 
+/*
+ * Each array block can hold this many values.
+ */
+static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
+{
+	return (size_of_block - sizeof(struct array_block)) / value_size;
+}
+
 static void array_block_prepare_for_write(struct dm_block_validator *v,
 					  struct dm_block *b,
 					  size_t size_of_block)
@@ -54,6 +62,7 @@ static int array_block_check(struct dm_block_validator *v,
 			     size_t size_of_block)
 {
 	struct array_block *bh_le = dm_block_data(b);
+	uint32_t nr_entries, max_entries, value_size;
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(bh_le->blocknr)) {
@@ -73,6 +82,26 @@ static int array_block_check(struct dm_block_validator *v,
 		return -EILSEQ;
 	}
 
+	nr_entries = le32_to_cpu(bh_le->nr_entries);
+	max_entries = le32_to_cpu(bh_le->max_entries);
+	value_size = le32_to_cpu(bh_le->value_size);
+
+	if (!value_size) {
+		DMERR_LIMIT("%s failed: value_size is zero", __func__);
+		return -EILSEQ;
+	}
+
+	if (max_entries != calc_max_entries(value_size, size_of_block)) {
+		DMERR_LIMIT("%s failed: max_entries %u invalid for value_size %u",
+			    __func__, max_entries, value_size);
+		return -EILSEQ;
+	}
+
+	if (nr_entries > max_entries) {
+		DMERR_LIMIT("%s failed: too many entries", __func__);
+		return -EILSEQ;
+	}
+
 	return 0;
 }
 
@@ -138,14 +167,6 @@ static void dec_ablock_entries(struct dm_array_info *info, struct array_block *a
 		on_entries(info, ab, vt->dec);
 }
 
-/*
- * Each array block can hold this many values.
- */
-static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
-{
-	return (size_of_block - sizeof(struct array_block)) / value_size;
-}
-
 /*
  * Allocate a new array block.  The caller will need to unlock block.
  */
-- 
2.43.0

