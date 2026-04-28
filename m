Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB674657CF
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 16:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777393248; cv=none; b=senQps9rvnfYdP0krteueHF093x7pB4Kmxl/+gxrxQRUDtSVZHFk4F5nqQV6CGIDeHOad82J/BH0gnW0GjV3zvpQRbibFETSvrwY7DMfCeWg+ifIMjfSAz8l8KLqvUb3MwThc0IXJuaKmDQO2+UKYJ/FHCIT17Zr404AV4qGAMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777393248; c=relaxed/simple;
	bh=NL42Fgfj3quzU0ajWvj06zGIbM5Mw3K1e6+8xjrW5KM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=i/hCUkwkj/D9MCSvVmhylJuAqmkaMQYtvT5Hkx45ev9L3UGit8tx8vst9ZV9m0jc0/g64R0cGndY/AtwHlvnWedOj+DjjQyOkUm5K3lrsdlolbFWvpErhLp0PEapFjQ4ZIXwGBQAWG7+ixi1/Pr0E2QThL0TRJP488+7MNtOqaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gu79p6tc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gu79p6tc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777393246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DdvJeyJsOKadMtx46rQLZ1Jkv7h9xz+WU0TCYw8lOjE=;
	b=gu79p6tcZmrqKAHKngVbpi6Y9mI7ueAWGN2w1U/dEo/N6w0c16JDMJADn/luhzOXYcpV0R
	ViXgCOoyfnIXUBXo8Op169P0srmns0JiM30dPrkYycl3gRNz0xL+W65YkD4ZQC2pq0gPd/
	LQOwknC2a6qsTtD1P1Jmygp4wIxFADo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-e5VDaWU9OPiQVeqIfezU7A-1; Tue,
 28 Apr 2026 12:20:39 -0400
X-MC-Unique: e5VDaWU9OPiQVeqIfezU7A-1
X-Mimecast-MFC-AGG-ID: e5VDaWU9OPiQVeqIfezU7A_1777393237
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5429B180034F;
	Tue, 28 Apr 2026 16:20:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79D7C19560AB;
	Tue, 28 Apr 2026 16:20:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63SGKYbn2773321
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Apr 2026 12:20:34 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63SGKWDW2773304;
	Tue, 28 Apr 2026 12:20:32 -0400
Date: Tue, 28 Apr 2026 12:20:32 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <afDeUNNWEIlxl5HC@redhat.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
 <ae65vfakVKg2aGcp@redhat.com>
 <af84cfb7-b673-404a-a7f9-6efd9d23a08f@oss.qualcomm.com>
 <f92f318b-5c99-4880-906c-136aa180d58c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f92f318b-5c99-4880-906c-136aa180d58c@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: w4Nj900kXOBQ2hwkt7MD_qDX2McJYUXCRURatCUw4Z0_1777393237
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Apr 28, 2026 at 06:43:08PM +0800, Linlin Zhang wrote:
> Correct the response to Benjamin's comments.
> 
> On 4/27/2026 8:20 PM, Linlin Zhang wrote:
> > 
> > 
> > On 4/27/2026 9:19 AM, Benjamin Marzinski wrote:
> >> On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
> >>> From: Eric Biggers <ebiggers@google.com>
> >>> +
> >>> +static int inlinecrypt_map(struct dm_target *ti, struct bio *bio)
> >>> +{
> >>> +	const struct inlinecrypt_ctx *ctx = ti->private;
> >>> +	sector_t sector_in_target;
> >>> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
> >>> +
> >>> +	bio_set_dev(bio, ctx->dev->bdev);
> >>> +
> >>> +	/*
> >>> +	 * If the bio is a device-level request which doesn't target a specific
> >>> +	 * sector, there's nothing more to do.
> >>> +	 */
> >>> +	if (bio_sectors(bio) == 0)
> >>> +		return DM_MAPIO_REMAPPED;
> >>> +
> >>> +	/*
> >>> +	 * The bio should never have an encryption context already, since
> >>> +	 * dm-inlinecrypt doesn't pass through any inline encryption
> >>> +	 * capabilities to the layer above it.
> >>> +	 */
> >>> +	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
> >>> +		return DM_MAPIO_KILL;
> >>> +
> >>> +	/* Map the bio's sector to the underlying device. (512-byte sectors) */
> >>> +	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
> >>> +	bio->bi_iter.bi_sector = ctx->start + sector_in_target;
> >>> +	/*
> >>> +	 * If the bio doesn't have any data (e.g. if it's a DISCARD request),
> >>> +	 * there's nothing more to do.
> >>> +	 */
> >>> +	if (!bio_has_data(bio))
> >>> +		return DM_MAPIO_REMAPPED;
> >>> +
> >>> +	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
> >>> +	dun[0] = ctx->iv_offset + sector_in_target; /* 512-byte sectors */
> >>> +	if (dun[0] & ((ctx->sector_size >> SECTOR_SHIFT) - 1))
> >>> +		return DM_MAPIO_KILL;
> >>
> >> If ctx->iv_offset is not a multiple of ctx->sector_size, this will
> >> always fail. ctx->iv_offset should probably get validated in
> >> inlinecrypt_ctr()
> > 
> > ACK
> > 
> > Yes, this assumes iv_offset is aligned to sector_size when large crypto
> > sectors are used. That’s a requirement of dm-inlinecrypt semantics, and
> > adding an explicit check in inlinecrypt_ctr() would make this fail earlier
> > and more clearly.
> 
> Sorry, the last response is wrong. No need to add check in inlinecrypt_ctr().
> 
> iv_offset is the starting offset for IVs that are generated as if the target were
> preceded by iv_offset 512-byte sectors.
> 
> I think this concern is based on an implicit assumption that
> sector_in_target is always data-unit (crypto sector) aligned. In this
> target, however, sector_in_target is derived from dm_target_offset() and
> is in 512-byte sectors, so it is not guaranteed to be a multiple of
> (sector_size >> SECTOR_SHIFT).

sector_in_target should be guaranteed to be sector_size aligned.
inlinecrypt_io_hints() sets the device logical block size to at least
ctx->sector_size, and validate_hardware_logical_block_alignment() makes
sure that the target starts on a logical block boundary. The block
layer enforces IO to be aligned with the logical block size, so
an IO that starts 7 sectors into a device with a 4096 ctx->sector_size
should be impossible. 

-Ben

