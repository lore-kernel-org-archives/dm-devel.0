Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F6D47B425;
	Tue, 16 Jun 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625533; cv=none; b=M+MY7VLb/fJRittb80xFEaj7gBM+GoQHa1ytraz7LvkGyuIc0v1gQt1DSnd1QN6eRF1awImDbU97uDXT4bQ7OSFAyUxABl8VmTzBoPB4a/6NJnf6i08dVqxxr1uBLersHLxhTIGcN0v/1gOzRHmUeHelRVpBrV/nGQDTa0xWG/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625533; c=relaxed/simple;
	bh=ncv2ZU5eMn+z/lp+z/27uOZkU0DTtf+G8ApYBrT4NFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D68KR8IWqd4stRzRIn+2Wx/cLZGIOpqU8t+uj5hT3lGfG+3j7Or6uLa0LT0Ghj/4fPo1bnAZXv5VZRDSAdHP9vfJ6z68ua0r4gHCQatJCxkkigxhgtEcvrFcD09c9Ul8X5g+byBUWvmT8+mseF3JOR0GA1eeLHLCRh/dAsaseYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuLe9SOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuLe9SOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C273E1F000E9;
	Tue, 16 Jun 2026 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781625532;
	bh=WSS9qsIGDXq6Wq0D3AchmOSN3ojpQzajWBsqYSeYQRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VuLe9SOkG3cmvBQHvosTCA7QqerRwq9ZV1+PgjNj4N94uaGsPtIusgrg/sE5Nog9c
	 GmvkBOUBH5ocYPDVJuANw/p93G/RjE3aS1whbM8nKdALfpB9pduRP6ASUNadMnItqq
	 UqPmM1LVAZzpnKl3eeVGWtQZI5gcONXUElKJiXw7NgwOobl14YLUH7hN/5uNFaA85G
	 SgMstEpgCiyS3T/xhWwTzMd97IHcAJEssNSY+zEt09ofz5NzEr+8XjoHjC1JSw6YWH
	 3T/4VQL/CeamknQB6/otARwo/u9fkaeB9eHNRcbmYcmMK1vxHTEvK1Ry1WaAeJxhiq
	 C/sVD6yh5qkyA==
Date: Tue, 16 Jun 2026 09:58:50 -0600
From: Keith Busch <kbusch@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	mpatocka@redhat.com, "Dr. David Alan Gilbert" <linux@treblig.org>,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O errors
Message-ID: <ajFyuoMqnvQm738z@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616150554.1686662-1-kbusch@meta.com>

BLK_STS_INVAL indicates the I/O request itself was invalid (for example a
misaligned direct I/O), not that the device has failed. dm-raid1 treated
any read or write completion error as a device failure: it failed the
mirror leg, retried on the alternatives - which fail identically - and
eventually returned EIO while spuriously degrading the array.

Since commit 5ff3f74e145a ("block: simplify direct io validity check") the
direct I/O path no longer rejects misaligned buffers up front, so an
invalid bio now reaches the lower block layers, which fail it with
BLK_STS_INVAL. dm-io collapses the block status into a per-region error
bit before invoking the completion callback, so record BLK_STS_INVAL on
the originating bio and have the dm-raid1 read, write and end_io paths
propagate it instead of failing the device.

This mirrors the raid1/raid10 fix in commit f7b24c7b41f23
("md/raid1,raid10: don't fail devices for invalid IO errors") for the
device-mapper mirror target.

Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Reported-by: Vjaceslavs Klimovs <vklimovs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
Resending patch 2/2 from a different machine. For some reason, only 1/2
is getting through with git-send-email, so manually replying to the
thread with the missing second patch.

 drivers/md/dm-io.c    | 14 +++++++++++++-
 drivers/md/dm-raid1.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 28adfeb58f240..f382e9f9be059 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -37,6 +37,7 @@ struct io {
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
+	struct bio *orig_bio;
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
 } __aligned(DM_IO_MAX_REGIONS);
@@ -132,8 +133,18 @@ static void complete_io(struct io *io)
 
 static void dec_count(struct io *io, unsigned int region, blk_status_t error)
 {
-	if (error)
+	if (error) {
 		set_bit(region, &io->error_bits);
+		/*
+		 * BLK_STS_INVAL means the bio was not valid for the underlying
+		 * device (e.g. a misaligned direct I/O), which is a caller error
+		 * rather than a device failure. Record it on the original bio so
+		 * bio-based targets can propagate it instead of treating it as a
+		 * media error and failing the device.
+		 */
+		if (error == BLK_STS_INVAL && io->orig_bio)
+			io->orig_bio->bi_status = error;
+	}
 
 	if (atomic_dec_and_test(&io->count))
 		complete_io(io);
@@ -398,6 +409,7 @@ static void async_io(struct dm_io_client *client, unsigned int num_regions,
 	io->client = client;
 	io->callback = fn;
 	io->context = context;
+	io->orig_bio = dp->orig_bio;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index de5c00704e69c..022ad791c2957 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -524,6 +524,17 @@ static void read_callback(unsigned long error, void *context)
 		return;
 	}
 
+	/*
+	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
+	 * e.g. a misaligned direct I/O. That is a caller error, not a device
+	 * failure, so propagate it rather than failing the mirror and retrying
+	 * on the other legs, which would fail the same way.
+	 */
+	if (bio->bi_status == BLK_STS_INVAL) {
+		bio_endio(bio);
+		return;
+	}
+
 	fail_mirror(m, DM_RAID1_READ_ERROR);
 
 	if (likely(default_ok(m)) || mirror_available(m->ms, bio)) {
@@ -622,6 +633,16 @@ static void write_callback(unsigned long error, void *context)
 		return;
 	}
 
+	/*
+	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
+	 * e.g. a misaligned direct I/O. Propagate the error without degrading
+	 * the array.
+	 */
+	if (bio->bi_status == BLK_STS_INVAL) {
+		bio_endio(bio);
+		return;
+	}
+
 	/*
 	 * If the bio is discard, return an error, but do not
 	 * degrade the array.
@@ -1262,7 +1283,12 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 		return DM_ENDIO_DONE;
 	}
 
-	if (*error == BLK_STS_NOTSUPP)
+	/*
+	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
+	 * e.g. a misaligned direct I/O. Propagate it rather than failing the
+	 * mirror and retrying, which would fail the same way on every leg.
+	 */
+	if (*error == BLK_STS_NOTSUPP || *error == BLK_STS_INVAL)
 		goto out;
 
 	if (bio->bi_opf & REQ_RAHEAD)
-- 
2.52.0


