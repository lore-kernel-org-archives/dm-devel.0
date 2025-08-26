Received: from leontynka.twibright.com (leontynka.twibright.com [109.81.181.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE7B3451A0;
	Tue, 26 Aug 2025 14:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.81.181.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217851; cv=none; b=DbvuZOAG955EpASVkwaOwp3sLdr2AjmUcBCbd3plZpQ5sltb/O8ui94JyR00czZoEvA96zKyMbEwmNHQ6b6VmVVUeNqaLs5Pu5fyxdiz8u12DZI/EQRoLXOm/A+dnTq6pBVbp110atoEG+Z6tx2f5AKN9IOAXCdxPFbYRc5hmOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217851; c=relaxed/simple;
	bh=tOm+70Bprfm0Usy8wEC4m6RzwJZ9iSCMo6uYZa2AQ1c=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=vFGQrPK0kQqxkNYXmPIqrG8Fu1VxAD0qM0Yp4dfdfQR3S2TZopQFFlD1Tt9GW7c4LsxATq5Vdiok3dKv5yPpIWhgoL3wBwrc/mipnZpvGhFcWyTkt0pfvJHRGlO1+qAbd4Nhs+HBKzdDNSrXjNDGyo6wdrpBjSQ9LCsitBc/z34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; arc=none smtp.client-ip=109.81.181.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
Received: from zen ([192.168.128.17] helo=debian.vm)
	by leontynka.twibright.com with smtp (Exim 4.96)
	(envelope-from <mpatocka@redhat.com>)
	id 1uqu9P-008VrT-2E;
	Tue, 26 Aug 2025 15:55:52 +0200
Received: by debian.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 15:55:51 +0200
Message-ID: <20250826135551.189472335@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 15:54:55 +0200
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
Subject: [PATCH 2/7] dm-integrity: replace bvec_kmap_local with kmap_local_page
References: <20250826135453.012446010@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Replace bvec_kmap_local with kmap_local_page - it will be needed for the
upcoming patches that make kmap_local_page optional, depending on whether
asynchronous hash interface is used or not.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2025-08-18 16:58:01.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2025-08-18 17:06:37.000000000 +0200
@@ -1838,11 +1838,11 @@ static void integrity_metadata(struct wo
 			char *mem, *checksums_ptr;
 
 again:
-			mem = bvec_kmap_local(&bv_copy);
+			mem = kmap_local_page(bv_copy.bv_page);
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
-				integrity_sector_checksum(ic, sector, mem + pos, checksums_ptr);
+				integrity_sector_checksum(ic, sector, mem + bv_copy.bv_offset + pos, checksums_ptr);
 				checksums_ptr += ic->tag_size;
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
@@ -2506,10 +2506,10 @@ skip_spinlock:
 		unsigned pos = 0;
 		while (dio->bio_details.bi_iter.bi_size) {
 			struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
-			const char *mem = bvec_kmap_local(&bv);
+			const char *mem = kmap_local_page(bv.bv_page);
 			if (ic->tag_size < ic->tuple_size)
 				memset(dio->integrity_payload + pos + ic->tag_size, 0, ic->tuple_size - ic->tuple_size);
-			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, dio->integrity_payload + pos);
+			integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem + bv.bv_offset, dio->integrity_payload + pos);
 			kunmap_local(mem);
 			pos += ic->tuple_size;
 			bio_advance_iter_single(bio, &dio->bio_details.bi_iter, ic->sectors_per_block << SECTOR_SHIFT);
@@ -2626,9 +2626,8 @@ static int dm_integrity_end_io(struct dm
 			while (dio->bio_details.bi_iter.bi_size) {
 				char digest[HASH_MAX_DIGESTSIZE];
 				struct bio_vec bv = bio_iter_iovec(bio, dio->bio_details.bi_iter);
-				char *mem = bvec_kmap_local(&bv);
-				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
-				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
+				char *mem = kmap_local_page(bv.bv_page);
+				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem + bv.bv_offset, digest);
 				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
 						min(ic->internal_hash_digestsize, ic->tag_size)))) {
 					kunmap_local(mem);

