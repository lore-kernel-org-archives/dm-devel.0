Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513511CBA
	for <dm-devel@lists.linux.dev>; Mon,  3 Nov 2025 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762186539; cv=none; b=lRRcdUohEMhA1vRqrf/okDepE0/7wI8viYGPjFPJPs/9/sTLeD8LLVf70/GLCmdABR4gXZx4b9Lvm002mLMVulMZH5Ix1boYy9wVw5009fryDCOIwConMVy3t7ERLuJVALYsoaVrIBz24qrwsjGqBnNdxMbPZYcK57U7nL29X30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762186539; c=relaxed/simple;
	bh=ZR/sDYjpQKF1CKDhKCs09dp9eEQwFbA38q7Jicq8e4A=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Arz5+vjArtux/Tgm2TjeWApKYetT+Gd5LwmsekEabLrs2AJ6Wr2lcR9N5QNsflil+G5wS3rfDc7ht22MUKyBCf1mJQjsal8XAltRiazIy5K6jE/04HIFqcsJLaYuGbm6HuoAG6GqmFZ8b+KJMww6oT4bKg3vbHZPlJPn7VidkCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YNFk1F9d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YNFk1F9d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762186537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ajIoHf0YZl85cHlPMn5BAk8HERcqnQT0DKHhQNq20Ew=;
	b=YNFk1F9daMPS/fe62TO9bE+1RTtWWY1rJnUiz0zTLYsjyR0vD77WY9XN8myqkcpFxZg1yQ
	02N87YVnq0jpQKL9PnwXjVdl/VQlHq8yqq6b0FzUlfl1iB7x7M3OSVB0eCRIpkaCtEpxRz
	4J2bWBPqclSxN+y7KdXYVhT6R8DR2sA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-J4O6Lz9jNx6t4iBepiByAw-1; Mon,
 03 Nov 2025 11:15:35 -0500
X-MC-Unique: J4O6Lz9jNx6t4iBepiByAw-1
X-Mimecast-MFC-AGG-ID: J4O6Lz9jNx6t4iBepiByAw_1762186534
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55FBC18094C1;
	Mon,  3 Nov 2025 16:15:34 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6866619560A2;
	Mon,  3 Nov 2025 16:15:32 +0000 (UTC)
Date: Mon, 3 Nov 2025 17:15:29 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jon Hunter <jonathanh@nvidia.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Tushar Sugandhi <tusharsu@linux.microsoft.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: Don't warn if IMA_DISABLE_HTABLE is not enabled
In-Reply-To: <20251031153455.1057431-1-jonathanh@nvidia.com>
Message-ID: <60f0e17e-0d2a-e6b7-289d-84f7dac65a34@redhat.com>
References: <20251031153455.1057431-1-jonathanh@nvidia.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Accepted, thanks.

Mikulas


On Fri, 31 Oct 2025, Jon Hunter wrote:

> Commit f1cd6cb24b6b ("dm ima: add a warning in dm_init if duplicate ima
> events are not measured") added a warning message if CONFIG_IMA is
> enabled but CONFIG_IMA_DISABLE_HTABLE is not to inform users. When
> enabling CONFIG_IMA, CONFIG_IMA_DISABLE_HTABLE is disabled by default
> and so warning is seen. Therefore, it seems more appropriate to make
> this an INFO level message than warning. If this truly is a warning,
> then maybe CONFIG_IMA_DISABLE_HTABLE should default to y if CONFIG_IMA
> is enabled.
> 
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
> We have some tests that check for kernel warnings and whenever we
> stumbled across a new warning we see if there is a way to fix it.
> For this one it seems a bit odd to always warn for something that
> defaults to disabled. If necessary we can ignore it, but I wanted
> to see if this would be acceptable first.
> 
>  drivers/md/dm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index bff3ab4a3bd8..557f3f52edf4 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -272,7 +272,7 @@ static int __init dm_init(void)
>  	int r, i;
>  
>  #if (IS_ENABLED(CONFIG_IMA) && !IS_ENABLED(CONFIG_IMA_DISABLE_HTABLE))
> -	DMWARN("CONFIG_IMA_DISABLE_HTABLE is disabled."
> +	DMINFO("CONFIG_IMA_DISABLE_HTABLE is disabled."
>  	       " Duplicate IMA measurements will not be recorded in the IMA log.");
>  #endif
>  
> -- 
> 2.43.0
> 

