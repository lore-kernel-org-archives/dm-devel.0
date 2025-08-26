Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3B0352077
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219189; cv=none; b=TzXr+LvdWfj3Utuk+hebLZBmo3CpSJrkWodOyYRfJELyHSEbGBTMr6gVdWf+xdRtXAdcAlKPmZW8wIazxD2KSy4h6WMAvNM1JcVvZ4wtgh0wjEluMyJb0oJ0PqT/ms9LIOmDw7kNv9YXTbQQyr64qVPsNhfbuXKjCrLRouqNpco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219189; c=relaxed/simple;
	bh=tOm+70Bprfm0Usy8wEC4m6RzwJZ9iSCMo6uYZa2AQ1c=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=D4u1j5bLQyrId9QygFwmVUSRT+OzP8EV7Ho8pmgVxWZotdhwHYed3gzEQqOKoq5qCOGsXolu7jpayafDK08rdfeIMf9OHiXYMtdYxpWRcRhiewh0aVf5xSbPcBhUnYU60IbooBO0Etammc+9+grAwP3bZISnSoKiwbL7f9+TXbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DC+wsvAo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DC+wsvAo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756219185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=RLd4hMR9z2RheZ9720HXKttPMm+gPp2HqBozZPxa1UM=;
	b=DC+wsvAoeyv9rO4rT6+sUFYXM4+RRdzPqMS16X00dNOKU7L7WNPY/C7CeFIFwlLmM/xl79
	IoEhOYnbQg3Ei92/hrus7UNLTbPk7agyJeIJRDVAl9XPsOT/icMItjVr2tY+P/zMUgXoU5
	x1qGmMuJ2IWwGynAI4kyNHisAu/Oqvc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-Zq130GOcOLOxqf34yGv_2w-1; Tue,
 26 Aug 2025 10:39:42 -0400
X-MC-Unique: Zq130GOcOLOxqf34yGv_2w-1
X-Mimecast-MFC-AGG-ID: Zq130GOcOLOxqf34yGv_2w_1756219180
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F4CF18009C4;
	Tue, 26 Aug 2025 14:39:40 +0000 (UTC)
Received: from debian4.vm (unknown [10.22.80.227])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1EBD5180035C;
	Tue, 26 Aug 2025 14:39:35 +0000 (UTC)
Received: by debian4.vm (sSMTP sendmail emulation); Tue, 26 Aug 2025 16:39:34 +0200
Message-ID: <20250826143934.491658089@debian4.vm>
User-Agent: quilt/0.68
Date: Tue, 26 Aug 2025 16:36:48 +0200
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
References: <20250826143646.570314717@debian4.vm>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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

