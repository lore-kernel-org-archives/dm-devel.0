Received: from leontynka.twibright.com (leontynka.twibright.com [109.81.181.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC8E350842;
	Tue, 26 Aug 2025 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.81.181.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218237; cv=none; b=rqkF8UgtJm1fY61+qiC7XMwY8HmvvsS3e6nqhieAWWbthpcST9TjRhXZkR3QSDu+fXmKP3is4tviyB6m1O/kQxuZsCcz+5IMMPHxjt2Td8FEsRfbCFEigS7bCrgovbbGXJOq29f7CWb2zoJBmOQP3ld6hOPhYATroUhrFkPGhts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218237; c=relaxed/simple;
	bh=TaMtshfmq7VD9kWh1Xk1B8MEuPO2dQgTtQZlkXjoLxk=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=OfLFWEBGv48DHEwFN+TasDEKDQbY+8SfIBL+/krsCiCg3IJNpugYKg6K/kSD78kJfh4IJJRc09gZmeePCSQTk0kcCshXWDg08lYxeQ5np7NrQlzFoxQ1/ig5fERHXY3L9FHTkeAPmKPkhEU7Cnoqjm/v/e2oT1FzvRgBedykvdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; arc=none smtp.client-ip=109.81.181.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from zen ([192.168.128.17] helo=debian.vm)
	by leontynka.twibright.com with smtp (Exim 4.96)
	(envelope-from <mpatocka@redhat.com>)
	id 1uqu9U-008Vrn-2t;
	Tue, 26 Aug 2025 15:55:57 +0200
Received: by debian.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 15:55:56 +0200
Message-ID: <20250826135556.406911161@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 15:54:59 +0200
From: Mikulas Patocka <mpatocka@redhat.com>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Biggers <ebiggers@kernel.org>,
 dengler@linux.ibm.com,
 linux-s390@vger.kernel.org,
 dm-devel@lists.linux.dev,
 ifranzki@linux.ibm.com,
 agk@redhat.com,
 snitzer@kernel.org,
 gmazyland@gmail.com,
 Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] dm-integrity: rename internal_hash
References: <20250826135453.012446010@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Rename "internal_hash" to "internal_shash" and introduce a boolean value
"internal_hash".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-25 15:46:51.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-25 15:46:51.000000000 +0200
@@ -219,10 +219,11 @@ struct dm_integrity_c {
 	__u8 log2_blocks_per_bitmap_bit;
 
 	unsigned char mode;
+	bool internal_hash;
 
 	int failed;
 
-	struct crypto_shash *internal_hash;
+	struct crypto_shash *internal_shash;
 	unsigned int internal_hash_digestsize;
 
 	struct dm_target *ti;
@@ -1639,11 +1640,11 @@ static void integrity_sector_checksum(st
 				      const char *data, unsigned offset, char *result)
 {
 	__le64 sector_le = cpu_to_le64(sector);
-	SHASH_DESC_ON_STACK(req, ic->internal_hash);
+	SHASH_DESC_ON_STACK(req, ic->internal_shash);
 	int r;
 	unsigned int digest_size;
 
-	req->tfm = ic->internal_hash;
+	req->tfm = ic->internal_shash;
 
 	r = crypto_shash_init(req);
 	if (unlikely(r < 0)) {
@@ -4708,12 +4709,14 @@ static int dm_integrity_ctr(struct dm_ta
 		buffer_sectors = 1;
 	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
 
-	r = get_mac(&ic->internal_hash, &ic->internal_hash_alg, &ti->error,
+	r = get_mac(&ic->internal_shash, &ic->internal_hash_alg, &ti->error,
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
 		goto bad;
-	if (ic->internal_hash)
-		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_hash);
+	if (ic->internal_shash) {
+		ic->internal_hash = true;
+		ic->internal_hash_digestsize = crypto_shash_digestsize(ic->internal_shash);
+	}
 
 	r = get_mac(&ic->journal_mac, &ic->journal_mac_alg, &ti->error,
 		    "Invalid journal mac", "Error setting journal mac key");
@@ -5235,8 +5238,8 @@ static void dm_integrity_dtr(struct dm_t
 	if (ic->sb)
 		free_pages_exact(ic->sb, SB_SECTORS << SECTOR_SHIFT);
 
-	if (ic->internal_hash)
-		crypto_free_shash(ic->internal_hash);
+	if (ic->internal_shash)
+		crypto_free_shash(ic->internal_shash);
 	free_alg(&ic->internal_hash_alg);
 
 	if (ic->journal_crypt)

