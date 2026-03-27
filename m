Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4235DBA21
	for <dm-devel@lists.linux.dev>; Fri, 27 Mar 2026 19:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774640525; cv=none; b=T4UGwVJ8c7KssATYfSEiOdeu8uYi1IHrfSlFUqvSqofpskKZVYfeUhL3dwLdULJP53d+QiX5AT3h8D1awvUY84mGgM/9TOjt7pa9FcBGz2/ktb6xWJX9ERjz1jFcSAl7+8VCAwrUv3MY+Tk2SC7r+AlsbZD5spz5Svsq5JnQXmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774640525; c=relaxed/simple;
	bh=RIXWwyn41S6G7CLttCThWixf32qHfQD/QRtqiJlo41I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Qqxz7XvtN9DEVvMKD6uVp/3o8wnNqowHQZFOxjouwZgztqxlX7wBsOUbZLe8Jys+abdaeFDoWWKTlj38dbOPsdeFH5vqDzo7BXc68DDNXWFrAoNy0Fto7RPkBHiP0GmNnciXMuIWQjvFqF4E9BSQn0soBz9Vfcy1ntF8b1sM5BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aI2B1o9A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aI2B1o9A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774640518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BShx1I7SJoZ9KEstRHMnrmvpaLynW9mpG7UWFPxv/u8=;
	b=aI2B1o9A+5yc1ZASbtvBSMpI6/yYjmMM9nZYaWbS2nygjGkFOja5j1XRC5EbB32waJYuJi
	KMaIibbHXijXLTwnGcTv1NXr6GbWYgS3Rom/FfCMNd/TIpBMDIXDROx9MCHy4sYQm4e4WW
	lmDOIzWatuLJxm4AIJOEFO6Ymv/rQnI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-z0GDBqXUOjqCjoCy-ctMLA-1; Fri,
 27 Mar 2026 15:41:54 -0400
X-MC-Unique: z0GDBqXUOjqCjoCy-ctMLA-1
X-Mimecast-MFC-AGG-ID: z0GDBqXUOjqCjoCy-ctMLA_1774640513
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F30021956096;
	Fri, 27 Mar 2026 19:41:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 547E41955D84;
	Fri, 27 Mar 2026 19:41:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62RJfoTn1274423
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 15:41:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62RJfoeF1274422;
	Fri, 27 Mar 2026 15:41:50 -0400
Date: Fri, 27 Mar 2026 15:41:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: dm-devel@lists.linux.dev, mpatocka@redhat.com, snitzer@kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/3] dm-integrity: fix mismatched queue limits
Message-ID: <acbdfhN8AT7p4qrN@redhat.com>
References: <20260325193608.2827042-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260325193608.2827042-1-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tYgaRFtW52sS0ap4B2Fi7JPzdWqnP8Y7kbdCA3Bf50Q_1774640513
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 25, 2026 at 12:36:06PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A user can integritysetup a device with a backing device using a 4k
> logical block size, but request the dm device use 1k or 2k. This
> mismatch creates an inconsistency such that the dm device would report
> limits for IO that it can't actually execute. Fix this by using the
> backing device's limits if they are larger.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/md/dm-integrity.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 06e805902151c..8dfd498ed1ffd 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -4047,9 +4047,15 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
>  	struct dm_integrity_c *ic = ti->private;
>  
>  	if (ic->sectors_per_block > 1) {
> -		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> -		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
> -		limits->io_min = ic->sectors_per_block << SECTOR_SHIFT;
> +		limits->logical_block_size =
> +				max(limits->logical_block_size,
> +				    ic->sectors_per_block << SECTOR_SHIFT);
> +		limits->physical_block_size =
> +				max(limits->physical_block_size,
> +				    ic->sectors_per_block << SECTOR_SHIFT);
> +		limits->io_min =
> +				max(limits->io_min,
> +				    ic->sectors_per_block << SECTOR_SHIFT);
>  		limits->dma_alignment = limits->logical_block_size - 1;
>  		limits->discard_granularity = ic->sectors_per_block << SECTOR_SHIFT;

Shouldn't this also respect the underlying device's discard_granularity?

-Ben

>  	}
> -- 
> 2.52.0
> 

