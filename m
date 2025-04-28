Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A7E2356BC
	for <dm-devel@lists.linux.dev>; Mon, 28 Apr 2025 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745837406; cv=none; b=hJQ8LFU51fCtlQEg8SRHyEq52UFcdvF2cPMlfzjfPj+9Yb6cvnv08R7uWYamHJzNV2qK58sSBTRxZ39f/YqZiM3vSFPbUIk1QprxgavNA66AjSIED/lBJTiXpEd6J3C6Xdmc7Ph0PBB9xcQYxyVeo5oW8PDl6TKKkd13ujzR818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745837406; c=relaxed/simple;
	bh=4DG7DJDZIP3rwGwgzQDgRgJ6Vj6kbPvlRlQ3XKozzaU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=k2s5TiBAODpVPDuBMKSuz8kNTix5q9KqNaH2H57xJ7H0YAF1nFfBzX+I1ejKCWBY4qUzNoM80Br7jqTJvyWXKqdZgOkh6gwSO3B2KZ8xGIc0BAaakMr4N79BiB1oMX0W6YGgC8l4PuicYfqRK3KP55M1y0PbzD9W82OMkuDMyBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jN7aFYEe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jN7aFYEe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745837403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vNFChF0dDP2Lc1kQ3WfgCxr/zYTrec8rsbzbDUeAX4U=;
	b=jN7aFYEe/B5+8r9CFLEx0wGXIIfXR155XjVqvUHEIc+ekPzjVVHIsTBA1NLzu54MpPtlMj
	oZqx/UD31mv1c9nElydaU0eFcpRCBzbSLzO0TFxgVnaymE1cWGdO4yjrjGVvjBxWvww3RV
	j5gXuzfC/2vNoNXTfi5OR0m3n+6vufg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-QvHH5SNZO3OM6aACR78_kA-1; Mon,
 28 Apr 2025 06:50:00 -0400
X-MC-Unique: QvHH5SNZO3OM6aACR78_kA-1
X-Mimecast-MFC-AGG-ID: QvHH5SNZO3OM6aACR78_kA_1745837399
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC6FF1956096;
	Mon, 28 Apr 2025 10:49:58 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC02819560A3;
	Mon, 28 Apr 2025 10:49:56 +0000 (UTC)
Date: Mon, 28 Apr 2025 12:49:53 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Kees Cook <kees@kernel.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
    linux-hardening@vger.kernel.org
Subject: Re: [PATCH] dm: dm-zoned: Adjust dmz_load_mapping() allocation
 type
In-Reply-To: <20250426061707.work.587-kees@kernel.org>
Message-ID: <dc1191b4-1010-260b-b7cb-dc748a05e571@redhat.com>
References: <20250426061707.work.587-kees@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hi

I accepted both patches.

Just nit-picking - I prefer type name as an argument to the sizeof 
operator rather than variable name - because when someone needs to find 
out where variables with a particular type are allocated, it can be easily 
done with grep if the sizeof operator contains the type name. So I changed 
your patches so that there are type names.

Mikulas



On Fri, 25 Apr 2025, Kees Cook wrote:

> In preparation for making the kmalloc family of allocators type aware,
> we need to make sure that the returned type from the allocation matches
> the type of the variable being assigned. (Before, the allocator would
> always return "void *", which can be implicitly cast to any pointer type.)
> 
> The assigned type is "struct dmz_mblock **" but the returned type will
> be "struct dmz_mblk **". These are the same allocation size (pointer
> size), but the types do not match. Adjust the allocation type to match
> the assignment.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: <dm-devel@lists.linux.dev>
> ---
>  drivers/md/dm-zoned-metadata.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index deff22ecccbb..8934ad20012c 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1687,7 +1687,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
>  
>  	/* Metadata block array for the chunk mapping table */
>  	zmd->map_mblk = kcalloc(zmd->nr_map_blocks,
> -				sizeof(struct dmz_mblk *), GFP_KERNEL);
> +				sizeof(*zmd->map_mblk), GFP_KERNEL);
>  	if (!zmd->map_mblk)
>  		return -ENOMEM;
>  
> -- 
> 2.34.1
> 

