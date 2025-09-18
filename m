Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186AA2F3C1A
	for <dm-devel@lists.linux.dev>; Thu, 18 Sep 2025 11:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758194139; cv=none; b=ehkf/RLe+fKPAQMo8njTsKFngQLqM+Esdv/XEuPoROw0VbJah9cYWMp7M0VNsz211pabkX5HRzSxobE6iW/ERwX+lGvX+JWWW0SPGE71Q5iyadqaHgWuCJz+gS50Y7bERCN0Zivr+EqSms+JLQv2tW0/DVqo7D3x1WKNLalaf2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758194139; c=relaxed/simple;
	bh=7KKvXrlbZFt+9FdjRsuUJ4Nm5l1egFw8YPXxf6CfoWI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YTV6+qMhmYvh/MwYiUdLpIVif9lQjprjev1fP0o+kdzh1RMhlbPrQHLQ1TjA0Ijs0/NNODfgS/TA6rSxev5fTmP3vNkdXusilUlANGLgxhdXgeCRGd9cZBOALqHkyVaeq87aGM4cqv6KekQtsxsNV086VA/cA09DlgkEDc7c2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZbOeiwu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZbOeiwu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758194137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2cSt5j8tcsGSBbSxcGw0vImv8sfDBWg/1vktrdVzzM=;
	b=hZbOeiwuKpGtk9kYw0zlFMaHD0heu0py6s/flJAQKtlupAhq5i6VWvyhl8Es+ALGeNbiq/
	H5KuuSC1wWgnjxkr6SW5VkK6AyxEDyiYYgUciQZeyrwk2wSjShAyha/FbgLzNPdkW43jfE
	nJ2pcmpS7NGpbIRV2NkE6NyegRpSvHA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-UYijh1sjNtCETZ2pnVnb6A-1; Thu,
 18 Sep 2025 07:15:34 -0400
X-MC-Unique: UYijh1sjNtCETZ2pnVnb6A-1
X-Mimecast-MFC-AGG-ID: UYijh1sjNtCETZ2pnVnb6A_1758194133
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0E7F1800576;
	Thu, 18 Sep 2025 11:15:32 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD10D1800446;
	Thu, 18 Sep 2025 11:15:30 +0000 (UTC)
Date: Thu, 18 Sep 2025 13:15:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
cc: Bart Van Assche <bvanassche@acm.org>, 
    "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Mike Snitzer <snitzer@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
    Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the
 linear target
In-Reply-To: <qxeldko7kx763qu7aj7bei5gikwczyzlihaqpdxq3affkmcbz3@v32xuyu3ls5a>
Message-ID: <8e0be106-fcae-e566-8891-4272f6f0c738@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org> <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com> <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com> <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org> <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
 <qxeldko7kx763qu7aj7bei5gikwczyzlihaqpdxq3affkmcbz3@v32xuyu3ls5a>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _XtpUU0UEf4eHQ_pZtvRXk1tsurK5bXABhNixDj-iHw_1758194133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 18 Sep 2025, Shinichiro Kawasaki wrote:

> On Sep 15, 2025 / 17:42, Mikulas Patocka wrote:
> [...]
> > If the table has only linear targets and there is just one underlying
> > device, we can optimize REQ_PREFLUSH with data - we don't have to split
> > it to two bios - a flush and a write. We can pass it to the linear target
> > directly.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Tested-by: Bart Van Assche <bvanassche@acm.org>
> > 
> > ---
> >  drivers/md/dm-core.h |    1 +
> >  drivers/md/dm.c      |   31 +++++++++++++++++++++++--------
> >  2 files changed, 24 insertions(+), 8 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm.c	2025-09-15 17:30:25.000000000 +0200
> > +++ linux-2.6/drivers/md/dm.c	2025-09-15 17:35:47.000000000 +0200
> [...]
> > @@ -976,11 +972,12 @@ static void __dm_io_complete(struct dm_i
> >  	if (requeued)
> >  		return;
> >  
> > -	if (bio_is_flush_with_data(bio)) {
> > +	if (unlikely(io->requeue_flush_with_data)) {
> 
> Hello Mikluas,
> 
> Last night, I ran my fio test for zoned block devices using linux-next kernel
> with the tag "next-20250917" and dm-crypt on QEMU ZNS drive. Then I observed
> KASAN slab-use-after-free [1]. It happend at "__dm_io_complete+0x866/0x960",
> which points to the line above added by this patch. It looks like 'io' is freed
> before the reference to io->requeue_flush_with_data. I checked the function
> __dm_io_complete(), and found that free_io(io) is called just before the line
> of KASAN. It looks weird for me to access io->requeue_flush_with_data after
> freeing io. Do you think this is the cause of the KASAN?
> 
>   961                 dm_end_io_acct(io);
>   962         }
>   963         free_io(io);    <-------------------------------- free io here?
>   964         smp_wmb();
>   965         this_cpu_dec(*md->pending_io)
>   966
>   967         /* nudge anyone waiting on suspend queue */
>   968         if (unlikely(wq_has_sleeper(&md->wait)))
>   969                 wake_up(&md->wait);
>   970
>   971         /* Return early if the original bio was requeued */
>   972         if (requeued)
>   973                 return;
>   974
>   975         if (unlikely(io->requeue_flush_with_data)) {  <---- KASAN suaf
>   976                 /*
>   977                  * Preflush done for flush with data, reissue
>   978                  * without REQ_PREFLUSH.
> 
> I ran the fio test under the same condition several times, but I'm failing to
> recreate the KASAN so far. This KASAN looks very rare.
> 
> [1]

Hi

Thanks for testing it. I fixed it, I folded the fix into the existing 
patch. You can get it here:

https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

Mikulas

