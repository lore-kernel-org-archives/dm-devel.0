Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638D32264CC
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755268304; cv=none; b=Jf0ZTQj65FlTjqyNLsEL6fTm8nUinrqqUq2g/hIqj2AA70jl/uwQvhQaOTqyKzCcF14bC2KpOOT341JK5orgkdhT2KNcHP9635olmwGBW8LGq7k3Lx/nWnDSuFI/7TgxLuzIpa8gFASBCQqXN3gydsmf2Ss4nZue4gtM7D107o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755268304; c=relaxed/simple;
	bh=NeO6btLNDBu0CJgnWoGagpsIUm3k6/RvB2Uw7CXSVN0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=G8hO3KuISf+mWU4gaqcjOqsE8k/j9QAPDDkUcLdzkwHtoouSf/g0KGAJdABFrFh5uldENHfpURcFk0cGn8vqTll5jdgix4Hm+99j/IuXW0+nFKFqxoUbg/us5H5napJP5DfVP5yOp5sbE7kFKejGJIjHhVvjt8k648sX/FDunIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UqgbxzO1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UqgbxzO1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755268301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4SeZV/MMsf6Q07pFyJQmO4gQUI50EDAQMj3gsW9jSE=;
	b=UqgbxzO14MGL0qHQt57NJ6QFor3IxWXV3pS3acLG3SIXUv0edjTny5LUd0qCAU9qA7+tRL
	B1azio5Dp0CogBcDlctLA1JPxpDBbMDWzsAzD7MWEhEvd8mlwz8ywCiv7zZvkPtJ368dDs
	qqGCAPAhX74tqWYzJZ9VsAO7LFJPVpk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-WsckURyONDukGLM6sfcBfA-1; Fri,
 15 Aug 2025 10:31:38 -0400
X-MC-Unique: WsckURyONDukGLM6sfcBfA-1
X-Mimecast-MFC-AGG-ID: WsckURyONDukGLM6sfcBfA_1755268297
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB0E21920738;
	Fri, 15 Aug 2025 14:31:29 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 195541955E89;
	Fri, 15 Aug 2025 14:31:27 +0000 (UTC)
Date: Fri, 15 Aug 2025 16:31:20 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    cengku@gmail.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] dm-pcache: fix uninitialized variable issue
In-Reply-To: <20250815133052.8138-1-dongsheng.yang@linux.dev>
Message-ID: <9b4290c2-57c8-a2c3-f617-46b2e6c2c6af@redhat.com>
References: <20250815133052.8138-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OUvx0RtmWfANbfJ68FvswvLLEBbObwf4tu-pGCvaDcs_1755268297
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 15 Aug 2025, Dongsheng Yang wrote:

> The 'ret' varialbe may be returned without initialized in some branch,
> this patch make sure it is initialized correctly with 0.

Hi

I've already fixed it (and I folded the fix into the existing commit).

Mikulas

> Fixes: 6fb8fbbaf147 ("dm-pcache: add persistent cache target in device-mapper")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202508151712.qMqD87iI-lkp@intel.com/
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-pcache/cache_dev.c b/drivers/md/dm-pcache/cache_dev.c
> index 722d7e952262..a7dafe8d35f7 100644
> --- a/drivers/md/dm-pcache/cache_dev.c
> +++ b/drivers/md/dm-pcache/cache_dev.c
> @@ -21,7 +21,7 @@ static int build_vmap(struct dax_device *dax_dev, long total_pages, void **vaddr
>  	struct page **pages;
>  	long i = 0, chunk;
>  	unsigned long pfn;
> -	int ret;
> +	int ret = 0;
>  
>  	pages = vmalloc_array(total_pages, sizeof(struct page *));
>  	if (!pages)
> -- 
> 2.43.0
> 

