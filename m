Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAEB47F2CA;
	Fri, 16 Oct 2026 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173747; cv=none; b=psqoJq4T4CuCJc6hbHrCtqA4HiyTHU09XzJ2auk5M4rDM3+imeMQTGyzDmKmSvBWzQ7JSwCDwGIymrOW2aTEr8oItAw8jG/i3D/eVKTjroyhoI4JOnj40eXBJr5ht99JBJkQ3JhMPE206yCxS3xeEa7210uBXqkBBUOqWaXSOfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173747; c=relaxed/simple;
	bh=WIYhszqT+3Hg9hoSWAjindyekdsa0dTNd5G9wkw8xBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c00nn1wTDTbBtVU+Pqt9fBypCh597i1cHFnIG/DtZVlyM4HRdnayitIdJh0+oTUIOASDAkqQn93PIgbsDe1zEEX52cGyhraH2gkNsbDnbav3JOJP/F7gQ5iL2aqGMd/5dA5dWMU3jcBCopOEwczZRa3pXS/KOfId5chYfZvaTfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THpj+LRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THpj+LRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9151F000C4;
	Fri, 16 Oct 2026 18:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792173744;
	bh=YN0svDI1andCGy2sy9syw2MK87rvko0lX/v3GxN2H64=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=THpj+LRmKE8iuLJnGCsKR/aZ66Ft4toLm9DY49mw9nqFlh0xFWxakSG9LCoTKhy+D
	 Oh28NK9mLokSnFGjYAkRYdK6oO//Mn3amNdEUlzjU1q2MMwsxyP7HA9zvaaHX8ZG+9
	 ARI8qoOT+qcxpfERjD4FCbzG8qU4V7sQkZA7m7s+wVZpsOyhmCUJVPFxcIHh3tUoaw
	 OFA0iqDjyYLt88R4DsG6chfht+H4URvsfbreaiJueAoo823seT9AewbLcAPKN0SKHA
	 vGcpHM8s+++WEGPaRwCdrGXuvP3LONjb+96FISEar7e8K4tWd3QRdHpqW5b9p73lA1
	 CDkLfY459tyAQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	hexlabsecurity@proton.me
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm array: validate array block headers on read" has been added to the 6.6-stable tree
Date: Fri, 16 Oct 2026 14:02:22 -0400
Message-ID: <20261016180222.4058164-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm array: validate array block headers on read

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-array-validate-array-block-headers-on-read.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit f12dd69353008d76c1914e34993f033fb23bca89
Author: Bryam Vargas <hexlabsecurity@proton.me>
Date:   Fri Jul 31 17:54:54 2026 -0500

    dm array: validate array block headers on read
    
    [ Upstream commit 2965787723084835b18dfe993cd450ebf5bd4540 ]
    
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
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 5e9c17307671c..1969d6cfbfa2b 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -38,6 +38,14 @@ struct array_block {
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
@@ -55,6 +63,7 @@ static int array_block_check(struct dm_block_validator *v,
 			     size_t size_of_block)
 {
 	struct array_block *bh_le = dm_block_data(b);
+	uint32_t nr_entries, max_entries, value_size;
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(bh_le->blocknr)) {
@@ -74,6 +83,26 @@ static int array_block_check(struct dm_block_validator *v,
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
