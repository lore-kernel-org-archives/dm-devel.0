Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793352109;
	b=Ue+n7g97K94W+HlRB4tGb7Y87316szfMfEHMcB/ShXGp/XpqofFOe9eUvxMVVDt6F/D9
	 7NJfVQXYVS7wjCJmZ3MPcp3NWw6EFihqOqPc6mXB5ehEPvvvix5go+Cq4vrGeXM93mZNG
	 jA2R1RyBR6KNoqfNjgMDPNa4/eTSFZjnRfNkTY2l6Cusq6aKb4B7OvMdmcHUJ/lB0OdVD
	 tLGw4kI0SnhXK/kZ/vdIUebc8RBTiSQQ682NZSykE6c2NUpLs2BfEaEqHsMdJvV/DI5do
	 VDstVAFWqd8x8UgzLmAXgk1VKFK4ra7/lIvsPg0NAv1Ol77RHVN35+3StcFPUqBYL9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793352109;
	h=DMARC-Filter:DKIM-Signature:X-Original-From:In-Reply-To:Date:Subject:
	 Cc:Message-Id:Mime-Version:X-Mailer:Content-Transfer-Encoding:
	 References:Content-Type:To:X-Lms-Return-Path:Received:From;
	bh=K3LEbG6xwteKsvtNo2f/L8YJueuoW81IhHXhpa5L5K0=;
	b=Z1HWB04Ygb3c4EQBfAzt6c7yrMTyLjKFlbZpI+Cm0SHQ726Via7iYmOzJ6RTDus2ZPwE
	 ss9oOnNfI9xgjI9AQHdL0clZ1Hant9duHoDqaUh+nQb1MbiSK/K0gpfHJdBGdAjqSq9JB
	 sMj+U3uNp7p1enhkglnfc25EseYRYYj7n0qdlNwEwAnawq9QXovAaZAJChQBQSof2gM9z
	 LeqlMIX1pBNEiV2e6cSFPfUdUIlhecdXiVtxaf+004qJVioWEPAZW+frheiAaGm6OQFv/
	 Tnmv/tlDcbJhtgtoXu8iC1P4o8sqTEcDp8IzVleg8ftKWfEpQh16nIqqEIAL50I8/yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=fnnas.com;
	spf=pass smtp.mailfrom=fnnas.com;
	dkim=pass header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=odn28AQt;
	arc=none smtp.remote-ip=209.127.231.42
Received: from va-2-42.ptr.blmpb.com (va-2-42.ptr.blmpb.com [209.127.231.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B27606A32D
	for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 09:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35B27606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.a=rsa-sha256 header.s=s1 header.b=odn28AQt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1793352104;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=K3LEbG6xwteKsvtNo2f/L8YJueuoW81IhHXhpa5L5K0=;
 b=odn28AQtOnx9Rhgk7DemNSys/GmKJ3qybLCiqzsRrb9ADiW0uIIo9DHyXFw6pVbf8x+IGv
 nEqjkEXPa0Z7+hmMylr67gWbIZO/9m5h2OPXJye2Rxk09b1fC2tpjeUTAB1bd37htceana
 KGTusbXcVZY1cfAFDkLwMocbs7TTDU7ixX5p1bsqt5eo7uTvrgc7Nwo9/1NMOxFvaEabhP
 Oa/xDzkXnFcR8qfNQQwrhULR+hSfjDqFTLztoyRA8XKrM6WAjG4fgFKEKduJivxnu2Verd
 thEmA/Pm1W7jIoNdsdVgLs7KGgraoyIs8G11fMDy/8zI9w16aPn8pCkhx7FDZw==
X-Original-From: chencheng@fnnas.com
In-Reply-To: <20261030092129.1671254-1-chencheng@fnnas.com>
Date: Fri, 30 Oct 2026 17:21:29 +0800
Subject: [PATCH 2/2] dm snapshot: fix discard writing into the next COW chunk
Cc: <stable@vger.kernel.org>, <yukuai@fygo.io>, <chencheng@fnnas.com>
Message-Id: <20261030092129.1671254-3-chencheng@fnnas.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0
Content-Transfer-Encoding: 7bit
References: <20261030092129.1671254-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>, 
	<agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>, 
	<bmarzins@redhat.com>
X-Lms-Return-Path: <lba+26ae461a5+bfced8+lists.linux.dev+chencheng@fnnas.com>
Received: from fedora ([183.34.162.132]) by smtp.feishu.cn with ESMTPS; Fri, 30 Oct 2026 17:21:40 +0800
From: "Chen Cheng" <chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

zero_exception() zeroes one chunk of the COW device and takes the start
sector from bio->bi_iter.bi_sector.  remap_exception() has already set
that to the COW chunk start plus the offset inside the chunk.  That
offset is needed for reads and writes, but for a discard it is wrong:
the zeroing window is shifted, so the head of the target chunk keeps
its old data and the tail lands in the next COW chunk, which holds a
different exception.

io_overlaps_chunk() should have caught this, but it only compares the
length.  "maps to entire chunks" in snapshot.rst also means the discard
has to start on a chunk boundary.

A discard that is not a full chunk has a second problem: after
remap_exception() it is sent to the COW device, where it hits a chunk
that still backs a live exception.  After a discard the contents are
undefined, but the exception stays in the table and keeps pointing at
that chunk, so a later read returns whatever the discard left instead
of the snapshot's data.

Reproducer:

	truncate -s 4M o.img c.img
	o=$(losetup -f --show o.img)
	c=$(losetup -f --show c.img)
	dmsetup create snap --table \
		"0 8192 snapshot $o $c P 512 1 discard_zeroes_cow"

	# write two chunks, this creates two exceptions
	head -c 256K /dev/zero | tr '\000' '\252' > pat
	dd if=pat of=/dev/mapper/snap bs=256K seek=1 count=1 conv=notrunc
	dd if=pat of=/dev/mapper/snap bs=256K seek=2 count=1 conv=notrunc

	# shift the snapshot by 8 sectors, so a discard that is aligned on
	# top is unaligned inside the snapshot
	dmsetup create top --table "0 8184 linear /dev/mapper/snap 8"
	blkdiscard -o 262144 -l 262144 /dev/mapper/top
	sync
	echo 3 > /proc/sys/vm/drop_caches

	# chunk 1
	dd if=/dev/mapper/snap bs=512 skip=512 count=8 | od -An -tx1 -N1
	# chunk 2
	dd if=/dev/mapper/snap bs=512 skip=1024 count=8 | od -An -tx1 -N1

Before: aa 00  <- chunk 2 was zeroed although it was not discarded
After:  aa aa  <- nothing written, a discard is only a hint

Fix it by requiring the discard to start on a chunk boundary in
io_overlaps_chunk(), and by finishing a discard that is not a full
chunk with bio_endio() instead of passing it down to the COW device.

Fixes: 2e6023850e17 ("dm snapshot: add optional discard support features")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/dm-snap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e49427bdbeef..6968e806eb84 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1946,12 +1946,12 @@ static void zero_exception(struct dm_snapshot *s, struct dm_exception *e,
 	dm_kcopyd_zero(s->kcopyd_client, 1, &dest, 0, zero_callback, bio);
 }
 
 static bool io_overlaps_chunk(struct dm_snapshot *s, struct bio *bio)
 {
-	return bio->bi_iter.bi_size ==
-		(s->store->chunk_size << SECTOR_SHIFT);
+	return bio->bi_iter.bi_size == (s->store->chunk_size << SECTOR_SHIFT) &&
+	       !(bio->bi_iter.bi_sector & s->store->chunk_mask);
 }
 
 static int snapshot_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dm_exception *e;
@@ -2007,15 +2007,17 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 	/* If the block is already remapped - use that, else remap it */
 	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
-		if (unlikely(bio_op(bio) == REQ_OP_DISCARD) &&
-		    io_overlaps_chunk(s, bio)) {
+		if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
 			dm_exception_table_unlock(&lock);
 			up_read(&s->lock);
-			zero_exception(s, e, bio, chunk);
+			if (io_overlaps_chunk(s, bio))
+				zero_exception(s, e, bio, chunk);
+			else
+				bio_endio(bio);
 			r = DM_MAPIO_SUBMITTED; /* discard is not issued */
 			goto out;
 		}
 		goto out_unlock;
 	}
-- 
2.56.0
