Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4485F1CA
	for <dm-devel@lists.linux.dev>; Tue,  5 Dec 2023 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AEVBFQmR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701790883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=DPEH67pXd7yshVXb0bnH855ABWYXBfhDWMYuv7Gag7s=;
	b=AEVBFQmRt8b1SU1ofFWbsdJhV696Zeib7Z9Gr/rB+OSeRSynzb0QIlkU10YfJPGt6sQuRF
	sGJHUMVcgT4CKWQdQNz0HzXcZ0OCjUsDYC24oQ1syJOe802wxSKZkDN3TdYi0Oh3yRdExU
	vT1idvOkv8750oZ43bbTazeZw+TrvG0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-Ovnx1pLZOCadi9JW6KyVkg-1; Tue, 05 Dec 2023 10:40:17 -0500
X-MC-Unique: Ovnx1pLZOCadi9JW6KyVkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E399891035
	for <dm-devel@lists.linux.dev>; Tue,  5 Dec 2023 15:39:16 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5127B51E3;
	Tue,  5 Dec 2023 15:39:16 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 3F0BF30C1A8C; Tue,  5 Dec 2023 15:39:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 3B7443FB77;
	Tue,  5 Dec 2023 16:39:16 +0100 (CET)
Date: Tue, 5 Dec 2023 16:39:16 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, 
    David Teigland <teigland@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: don't modify the "bv" variable
Message-ID: <9a974add-cba-f1bd-9579-64974b51ff99@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

__bio_for_each_segment assumes that the first argument doesn't change - it
calls "bio_advance_iter_single((bio), &(iter), (bvl).bv_len)" to advance
the iterator. Unfortunatelly, the dm-integrity code changes it - it calls
"bv.bv_len -= pos". When this code path is taken, the iterator would be
out of sync and dm-integrity would report errors. This happens if the
machine is out of memory and "kmalloc" fails.

Fix this bug by making a copy of "bv" and changing the copy instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+
Fixes: 7eada909bfd7 ("dm: add integrity target")

---
 drivers/md/dm-integrity.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2023-12-05 14:29:13.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2023-12-05 16:31:30.000000000 +0100
@@ -1755,11 +1755,12 @@ static void integrity_metadata(struct wo
 		sectors_to_process = dio->range.n_sectors;
 
 		__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
+			struct bio_vec bv_copy = bv;
 			unsigned int pos;
 			char *mem, *checksums_ptr;
 
 again:
-			mem = bvec_kmap_local(&bv);
+			mem = bvec_kmap_local(&bv_copy);
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
@@ -1768,7 +1769,7 @@ again:
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
 				sector += ic->sectors_per_block;
-			} while (pos < bv.bv_len && sectors_to_process && checksums != checksums_onstack);
+			} while (pos < bv_copy.bv_len && sectors_to_process && checksums != checksums_onstack);
 			kunmap_local(mem);
 
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
@@ -1793,9 +1794,9 @@ again:
 			if (!sectors_to_process)
 				break;
 
-			if (unlikely(pos < bv.bv_len)) {
-				bv.bv_offset += pos;
-				bv.bv_len -= pos;
+			if (unlikely(pos < bv_copy.bv_len)) {
+				bv_copy.bv_offset += pos;
+				bv_copy.bv_len -= pos;
 				goto again;
 			}
 		}

