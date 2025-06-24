Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766BE284682
	for <dm-devel@lists.linux.dev>; Tue, 24 Jun 2025 11:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766075; cv=none; b=Omr8fKFVYMXLFp9hSMdrufPskWS4Idlphy9wp+NxmCrpPKYlAujz7cgquF66DvNfcnhjaPgTWqyZiFJXTSjouoKOAGub7/Esocwqbkbgb8Nof7ngOl1noKSaHwkuO5LhcQPirI4RdBE7EVWfFPM19XN1XLJzqKm1U8qw+J0A7EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766075; c=relaxed/simple;
	bh=shkLqG12t/fvYLKka4juxh07XShvqn7xlQ7lX0I+3IE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=HksV1YI+snlU1xYujs2QI1lX7bQ/5vVewu1KgnDyrMgP+wHLgTIFRP1DLxP7aeDSsiLFkEhYSt/ULJGyBocioMIMClD54aGy5T92LdB1Ok2yiR9fDgSJ+rhr/9K9XwsYIjGVf/fmOpzko2Uy6DTeYgCPFFIOoRpQagyMm57RG2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XV6SUNe3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XV6SUNe3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750766072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Fvx7wBDUR06lwRLR6zvZJHHUH8VLoBG8DsMcf07s2G0=;
	b=XV6SUNe3Z+IuvRL7e2tE158f1pGxBE4rl/0eiSc4n/DS6D4SpCBtlFtaDqLCXbcWFwj2Ad
	NH9ZIdPRmamRCmocr7INjhLS1nPfI8LQ7Z3JC9/YcLYlEJwLTP/tblVmhvXtmf+8OWgph9
	Fn8gpMn0x7Fzi3jND8voYnnNaZPaQRU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-LRgK451ZMxW4YCxdjmZNxQ-1; Tue,
 24 Jun 2025 07:54:29 -0400
X-MC-Unique: LRgK451ZMxW4YCxdjmZNxQ-1
X-Mimecast-MFC-AGG-ID: LRgK451ZMxW4YCxdjmZNxQ_1750766068
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0578F180120C;
	Tue, 24 Jun 2025 11:54:28 +0000 (UTC)
Received: from [10.22.80.93] (unknown [10.22.80.93])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE79E180035C;
	Tue, 24 Jun 2025 11:54:26 +0000 (UTC)
Date: Tue, 24 Jun 2025 13:54:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH v2] dm-crypt: Prevent splitting of emulated zone append
 operations
In-Reply-To: <9e3e723f-dde8-4ea7-a606-275ee779d7ec@kernel.org>
Message-ID: <b459b3d0-15f2-16c0-15f0-f25f85ce4136@redhat.com>
References: <20250611011340.92226-1-dlemoal@kernel.org> <20250611011340.92226-2-dlemoal@kernel.org> <b5f54f1e-bd70-1003-a94f-fb6b8e131b4c@redhat.com> <959e29bd-a303-a3a0-13a9-ab4506fbac25@redhat.com> <9e3e723f-dde8-4ea7-a606-275ee779d7ec@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7RhYzmHcTfyvtYEh0zps5mH_mdWKPwYfLN3TshjbGYc_1750766068
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 24 Jun 2025, Damien Le Moal wrote:

> On 6/24/25 12:44 AM, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 23 Jun 2025, Mikulas Patocka wrote:
> > 
> >> Applied, thanks.
> >>
> >> Mikulas
> > 
> > Applied and reverted :)
> > 
> > I've just realized that this patch won't work because the value 
> > get_max_request_size is changeable by the user - it's in the file 
> > /sys/module/dm_crypt/parameters/max_write_size. So, if there is some large 
> > value when you create the device and later the user sets smaller value, 
> > dm-crypt will still split emulated zone append bios.
> 
> Indeed. Good catch.
> 
> > I suggest to set the limit limits->max_hw_sectors to BIO_MAX_VECS << 
> > PAGE_SHIFT (that's the maximum allowable value for dm-crypt) and then 
> > modify dm-crypt to not split bios that have the flag 
> > BIO_EMULATES_ZONE_APPEND.
> 
> I think we simply need to do a limit update when the user modifies the write
> limit through sysfs. That will prevent things from going out of sync if the
> user ever modifies the limit.

I think that's too complicated.

The sysfs limit was originally introduced to improve performance through 
concurrent encryption - if dm-crypt splits large bio to several smaller 
bios, it may improve performance because these smaller bios are encrypted 
by multiple cores in parallel.

As zoned devices won't see improved performance from limiting write size, 
we can just ignore the sysfs limit for zone append operations.

> Of note is that this patch turns out to be more than just about zone append
> emulation. We absolutely need it for any write request (for emulating zone
> append or regular writes) to avoid the accept partial return which would
> trigger issuing another BIO. In this case, we are at risk of deadlocking with
> queue freeze on blk_queue_enter() in the submission path. So this patch, and
> another one forcing splitting of all write BIOs to zoned DM devices is needed
> to avoid this deadlock.
> 
> I will send a v2 with the additional patch and a better commit message for this
> patch explaining this.

I've created this patch - please review it and test it.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

For a zoned dm-crypt device, the native support for zone append
operations (REQ_OP_ZONE_APPEND) is not enabled and instead dm-crypt
relies on the emulation done by the block layer using regular write
operations. This still requires to properly return the written sector as
the BIO sector of the original BIO. However, this can be done correctly
only and only if there is a single clone BIO used for processing the
original zone append operation issued by the user. If the size of a zone
append operation is larger than dm-crypt max_write_size, then the
orginal BIO will be split and processed as a chain of regular write
operations. Such chaining result in an incorrect written sector being
returned to the zone append issuer using the original BIO sector.
This in turn results in file system data corruptions using xfs or btrfs.

Fix this by modifying crypt_io_hints() to cap the max_hw_sectors limit
for the dm-crypt device to the BIO_MAX_VECS << PAGE_SHIFT limit. As this
limit also caps the device max_zone_append_sectors limit, this forces the
caller to issue zone append operations smaller or equal than this limit,
thus moving the splitting of large append operations to the caller
instead of the incorrect internal splitting.

This change does not have any effect on the size of BIOs received by
dm-crypt since the block layer does not automatically splits BIOs for
BIO-based devices. So there is no impact on the performance of regular
read and write operations.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Reported-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

Index: linux-dm/drivers/md/dm-crypt.c
===================================================================
--- linux-dm.orig/drivers/md/dm-crypt.c
+++ linux-dm/drivers/md/dm-crypt.c
@@ -3496,9 +3496,15 @@ static int crypt_map(struct dm_target *t
 	/*
 	 * Check if bio is too large, split as needed.
 	 */
-	max_sectors = get_max_request_size(cc, bio_data_dir(bio) == WRITE);
-	if (unlikely(bio_sectors(bio) > max_sectors))
-		dm_accept_partial_bio(bio, max_sectors);
+	if (unlikely(bio_flagged(bio, BIO_EMULATES_ZONE_APPEND))) {
+		max_sectors = BIO_MAX_VECS << PAGE_SHIFT >> SECTOR_SHIFT;
+		if (unlikely(bio_sectors(bio) > max_sectors))
+			return DM_MAPIO_KILL;
+	} else {
+		max_sectors = get_max_request_size(cc, bio_data_dir(bio) == WRITE);
+		if (unlikely(bio_sectors(bio) > max_sectors))
+			dm_accept_partial_bio(bio, max_sectors);
+	}
 
 	/*
 	 * Ensure that bio is a multiple of internal sector encryption size
@@ -3733,6 +3739,18 @@ static void crypt_io_hints(struct dm_tar
 		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
 	limits->dma_alignment = limits->logical_block_size - 1;
+
+	/*
+	 * For zoned devices, we cannot split write operations used to emulate
+	 * zone append operations. And since all write requests must be split on
+	 * BIO_MAX_VECS << PAGE_SHIFT size, apply this limit to the maximum
+	 * hardware I/O size so that we have a cap on the
+	 * max_zone_append_sectors limit when the zone limits are validated by
+	 * the block layer.
+	 */
+	if (ti->emulate_zone_append)
+		limits->max_hw_sectors = min(limits->max_hw_sectors,
+				BIO_MAX_VECS << PAGE_SHIFT >> SECTOR_SHIFT);
 }
 
 static struct target_type crypt_target = {

