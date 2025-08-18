Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5C3218DA
	for <dm-devel@lists.linux.dev>; Mon, 18 Aug 2025 12:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521204; cv=none; b=mbyn7f5xKAnF3VvlqWXAUlmO/59DWq0j5RyYPmvv3JhmdpWg1Rk/JowOo21rYqpdBdk29+CgJ6B/KWYwFJhXJ3I0fCN6/7REcH/V8ek4CN+VfNvA+MJyCEp4MrmK4H/ABQmD0cdCVKzAIqiq6+xkTfc3OpEU5JdODBbTxQKDImk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521204; c=relaxed/simple;
	bh=WBE0oMuxITUJ1wAIUo8hptcNZSWMAQKOt9B68thTXxM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nLuzUc5K0pGFbDgONKnFU28pQd0ElSeI/ma4WWpcc+8klx3SpLC91iunIaI8O8VsB9qvuimxb0We7/nETSniu28buSzUQ2NerFeqy+5Yz6jgyRY8HJWnVooUD7W526RtZ7FVmkItUQx4l4BLkIr51XdAwLQ3xc8sj0HOtGCGr+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3mE2KUE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3mE2KUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755521202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ykp6TYO+Yx365LX4B5MEyBlO6P2k6QpmJSVG6GYd+L4=;
	b=I3mE2KUEHq4m9ghajv4bUxGk7Ld5k9g2skOJdLLuMjY9b4hcIFYipX/7b/AlAU/DAySRxF
	bN+HgfJAFVgubRtsCIHFphjirLAwOHAI00SqpDY85KVuAhJNdqv7yD60fa9NtDSXxRnkaQ
	SJ0SnPZTKCHJBaV0uSZ53BVygsPMKe0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-266-rcH_eymTO3KS6iSh8-N0-A-1; Mon,
 18 Aug 2025 08:46:39 -0400
X-MC-Unique: rcH_eymTO3KS6iSh8-N0-A-1
X-Mimecast-MFC-AGG-ID: rcH_eymTO3KS6iSh8-N0-A_1755521198
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A129118002C9;
	Mon, 18 Aug 2025 12:46:37 +0000 (UTC)
Received: from [10.22.80.227] (unknown [10.22.80.227])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06CE719560AD;
	Mon, 18 Aug 2025 12:46:35 +0000 (UTC)
Date: Mon, 18 Aug 2025 14:46:32 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@lst.de>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org
Subject: Re: [PATCH] dm error: mark as DM_TARGET_PASSES_INTEGRITY
In-Reply-To: <20250818045821.1483488-1-hch@lst.de>
Message-ID: <03731de6-fb74-3564-ccbe-25dbd3df9508@redhat.com>
References: <20250818045821.1483488-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Applied, thanks.

Mikulas


On Mon, 18 Aug 2025, Christoph Hellwig wrote:

> Mark dm error as DM_TARGET_PASSES_INTEGRITY so that it can be stacked on
> top of PI capable devices.  The claim is strictly speaking as lie as dm
> error fails all I/O and doesn't pass anything on, but doing the same for
> integrity I/O work just fine :)
> 
> This helps to make about two dozen xfstests test cases pass on PI capable
> devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 2af5a9514c05..8fede41adec0 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -263,7 +263,8 @@ static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>  static struct target_type error_target = {
>  	.name = "error",
>  	.version = {1, 7, 0},
> -	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
> +	.features = DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM |
> +		DM_TARGET_PASSES_INTEGRITY,
>  	.ctr  = io_err_ctr,
>  	.dtr  = io_err_dtr,
>  	.map  = io_err_map,
> -- 
> 2.47.2
> 
> 

