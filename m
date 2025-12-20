Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156B8481DD
	for <dm-devel@lists.linux.dev>; Sat, 20 Dec 2025 04:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766204610; cv=none; b=Al+rWKQ9k39sR7BG8IGHPAVpEQMLpaCbDdnRd441y4w4wpLLkOiHjjs+qtyMnZLWE/xoiVaWwWAAn8y5lmSqntoFk+uW8GCuDZzr6dU2/xn/260jdC/sIJxvkKqyKWtSr1PxVY+greRfvs1Jgo00qxBnCzsUbrrG73A0LXRAAIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766204610; c=relaxed/simple;
	bh=rCrc1oeUQciwq3R8siuZNaVTjckkBqdc9Wty5MvGxWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Kyp31sfNSOPeVt2snwSz5yzkMuwfeSAfVvzoEwGRAqgia8nLCDRBL7PoyQh6+jRq0iuDJvspp6gc67AASOQHr7641jPMrCHCPygXVfNxhVJJo5FBdrxxsfm5HGCCBnM1nj4+XUmHhqXIF+8pq5QQsXSNvkyYgA9agzIrtjBk3x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BwoPD447; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BwoPD447"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766204608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w/LwMyAd/yamS84FkQ//3fV27Pp4s/kaK0CZQX/8Ze4=;
	b=BwoPD447zDPrHwHm5iKrXNJxT2P1ywoJ8iCySCUdzM/Xgv0a7k2cpJIVrVCGTJTJZcNWAL
	3i5+RXTmts35jflDszrTL6MnLnoihR0YXrwzI2CF2p0OovOgFa9ms2Ar6aJOCGeNRvSTFq
	6PNrPorxqIasDK6cj0d76qYdhSNHPCo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-636-nTpLUdDkN4i02TakQ-c3VA-1; Fri,
 19 Dec 2025 23:23:26 -0500
X-MC-Unique: nTpLUdDkN4i02TakQ-c3VA-1
X-Mimecast-MFC-AGG-ID: nTpLUdDkN4i02TakQ-c3VA_1766204605
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6BFD1956080;
	Sat, 20 Dec 2025 04:23:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9365E180045B;
	Sat, 20 Dec 2025 04:23:24 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BK4NNJH2173629
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 23:23:23 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BK4NNNx2173628;
	Fri, 19 Dec 2025 23:23:23 -0500
Date: Fri, 19 Dec 2025 23:23:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Benjamin Marzinski <bmarzins@suse.com>
Subject: Re: [PATCH v2 14/26] multipathd: add_map_without_path(): orphan
 paths instead of freeing them
Message-ID: <aUYkuzmyuntUhEvk@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
 <20251219144108.237928-15-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251219144108.237928-15-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G2UvtBUQHzi8s2tZ9ceCW2f-3VvaUiJtNfZ_hmbR2As_1766204605
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2025 at 03:40:56PM +0100, Martin Wilck wrote:
> If add_map_without_path() fails to set up the multipath data structures,
> don't free the paths associated with the map as
> cleanup_multipath_and_paths() would; just orphan the paths.
> update_pathvec_from_dm() will handle the paths and see if they
> need to be removed.
> 
> Suggested-by: Benjamin Marzinski <bmarzins@suse.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index c03546b..7b522e8 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -771,8 +771,8 @@ fail:
>  
>  static int add_map_without_path (struct vectors *vecs, const char *alias)
>  {
> -	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths)))
> -		*mpp = alloc_multipath();
> +	struct multipath __attribute__((cleanup(cleanup_multipath))) *mpp =
> +		alloc_multipath();
>  	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
>  	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
>  	struct config *conf;
> @@ -802,11 +802,13 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
>  	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
>  	put_multipath_config(conf);
>  
> -	if ((rc = update_multipath_table__(mpp, vecs->pathvec, 0, params, status)) != DMP_OK)
> +	if (update_multipath_table__(mpp, vecs->pathvec, 0, params, status) != DMP_OK ||
> +	    !vector_alloc_slot(vecs->mpvec)) {
> +		orphan_paths(vecs->pathvec, mpp, "failed to add map");
>  		return DMP_ERR;

I'm not sure we should just call orphan_paths() after we call
update_multipath_table__(). If we hit a cancellation point in the middle
of update_multipath_table__(), we want to fully orphan any paths that
got added to the device before we cancelled.  Perhaps the easiest way to
solve this is to make cleanup_multipath_and_paths() loop through all the
path in mpp->pg and orphan them before calling free_multipath(). We
shouldn't need to search through the entire pathvec here. Since this
multipath device was just created, the only paths that could have
pp->mpp set to this device will be in mpp->pg.

-Ben

> +	}
>  
> -	if (!vector_alloc_slot(vecs->mpvec))
> -		return DMP_ERR;
> +	/* Make sure mpp is not cleaned up on return */
>  	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
>  
>  	/*
> -- 
> 2.52.0

