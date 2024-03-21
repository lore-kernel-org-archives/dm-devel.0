Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6D18AE8
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711039732; cv=none; b=MBPh4tyJNn8L8FVU2roZC1beBiAs5jUVaVrlZC4XvXPVFKAmxVxePZ2kXwaxEFfF2HjKFQ6MNv8r222/Sm/4RlmImJ14V6udnTp+CHhgbn9Oj6Xkt4SCqLwLBEa0OduWCHtroEI301IgMFZXT6QzZ2ikSDYbLj8lPuFMzBVUjtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711039732; c=relaxed/simple;
	bh=pUa7QVsH4uafxOqqeERJAXXcWp3xynITD9Tzlpm6qjk=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=VmOx7VTru2h+DzK8qP2HIIOiP/8oHt/dRyU7nDcsTB9Df2r/NIjn3/jNmtRPMjlvaTEMahKp1afQlv10zgP9mbfcaZPkc+0aPCYhhbkmPPGyvQjN0BMvW6ZnUjcv3TVoUvYkActM4K0ay2K1oNeKA5EEvjUDpLdNVIKlQ+IArIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Azgd0yZL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Azgd0yZL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711039729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=0cZB4gwlUxCqdEj4Pby5N5x1t9cXp+0oeqGSsmUmQ2k=;
	b=Azgd0yZLBKaaifZkkGSZE7v8d5OJNJYtcqTAE91rMrykK7KDten0wAihM/U0ELz/tqP7gG
	Vf8IADDpp/h864lOvpuF3FdxbP7G2B/Khz3B3UNlAxxAGf1cQVGjrS2w84JW+dO6AqUwuc
	Odc4Hsxs7YhCdRVvN8jecerItzetU4E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-lkVroPc2PM2spjZLWQwZNA-1; Thu,
 21 Mar 2024 12:48:45 -0400
X-MC-Unique: lkVroPc2PM2spjZLWQwZNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FCDA38157BA
	for <dm-devel@lists.linux.dev>; Thu, 21 Mar 2024 16:48:45 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2214C8173;
	Thu, 21 Mar 2024 16:48:45 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0EC5D30BFECA; Thu, 21 Mar 2024 16:48:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 0AE5B3FB4B;
	Thu, 21 Mar 2024 17:48:45 +0100 (CET)
Date: Thu, 21 Mar 2024 17:48:45 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: align the outgoing bio in integrity_recheck
Message-ID: <580e4e3-b6b3-e291-282e-b57be178cec1@redhat.com>
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

It may be possible to set up dm-integrity with smaller sector size than
the logical sector size of the underlying device. In this situation,
dm-integrity guarantees that the outgoing bios have the same alignment as
incoming bios (so, if you create a filesystem with 4k block size,
dm-integrity would send 4k-aligned bios to the underlying device).

This guarantee was broken when integrity_recheck was implemented.
integrity_recheck sends bio that is aligned to ic->sectors_per_block. So
if we set up integrity with 512-byte sector size on a device with logical
block size 4k, we would be sending unaligned bio. This triggered a bug in
one of our internal tests.

This commit fixes it - it determines what's the actual alignment of the
incoming bio and then makes sure that the outgoing bio in
integrity_recheck has the same alignment.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2024-03-21 14:25:45.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2024-03-21 17:47:39.000000000 +0100
@@ -1699,7 +1699,6 @@ static noinline void integrity_recheck(s
 	struct bio_vec bv;
 	sector_t sector, logical_sector, area, offset;
 	struct page *page;
-	void *buffer;
 
 	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
 	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
@@ -1708,13 +1707,14 @@ static noinline void integrity_recheck(s
 	logical_sector = dio->range.logical_sector;
 
 	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
-	buffer = page_to_virt(page);
 
 	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
 		unsigned pos = 0;
 
 		do {
+			sector_t alignment;
 			char *mem;
+			char *buffer = page_to_virt(page);
 			int r;
 			struct dm_io_request io_req;
 			struct dm_io_region io_loc;
@@ -1727,6 +1727,14 @@ static noinline void integrity_recheck(s
 			io_loc.sector = sector;
 			io_loc.count = ic->sectors_per_block;
 
+			/* Align the bio to logical block size */
+			alignment = dio->range.logical_sector | bio_sectors(bio) | (PAGE_SIZE >> SECTOR_SHIFT);
+			alignment &= -alignment;
+			io_loc.sector = round_down(io_loc.sector, alignment);
+			io_loc.count += sector - io_loc.sector;
+			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
+			io_loc.count = round_up(io_loc.count, alignment);
+
 			r = dm_io(&io_req, 1, &io_loc, NULL);
 			if (unlikely(r)) {
 				dio->bi_status = errno_to_blk_status(r);

