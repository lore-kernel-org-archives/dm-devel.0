Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917162C861
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 05:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720676348; cv=none; b=kfeXs9IRMO/hwb7wz+NlhwmhTWOUKzlTEY0OYJpv43VyUTWrPvi/c3W4oRN57z6BAQvlAjAVx+aKJ15IdYp55lnqPb4wLgKUSW6py2c/iCACZrLMdNqYsO7FfRnhSeqX5Sw7tTFZkR5xeWDSUB6H+cTem7UQKiINMuGXJzMjWeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720676348; c=relaxed/simple;
	bh=jzTTUv84fNpPA9r+/UDN9/sjnN2vQhyb+tAejTqOkT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sG36SABNiT3ZEQIlBR8aGJ5zXSEFBbM1u2BTOL1cdf0JDiEtr5n8iPPBMyUMuGiH344dFIHausvJ8C9utsAlLf6rmOag8H3SBSQo4GeQxu3+Az5bssFRKc5mnmxkLcdyYiMyyZ6VGVUPMDF0wVxfqMxKn7QdaJVcnNDa+wv/Obc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DjPBP72X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DjPBP72X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720676345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jXds8LTTSCu9mEF0Vc0VoFB59MP4Dd3BxpaW3/0QxBA=;
	b=DjPBP72X/8qed8ACjMUeD6KG8VqVZQWSKPyTsELx5fdRIndWDCPjmlOEpZ0KR3k30p3F4B
	G1Bd8mcz5JYb5G0G63jvrpTTH/1hC/K0dkdaiOPKLY8F1q8wqClDcOpBTx+2YmFitso2lZ
	diYHH158plSQa8VG6OvN5TZR27ldcEc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-dCaYzOaCPw2NUCidJWUkBw-1; Thu,
 11 Jul 2024 01:39:01 -0400
X-MC-Unique: dCaYzOaCPw2NUCidJWUkBw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B36C01956064;
	Thu, 11 Jul 2024 05:39:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23A583000184;
	Thu, 11 Jul 2024 05:39:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B5cwjr1931451
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 01:38:58 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B5cwAD1931450;
	Thu, 11 Jul 2024 01:38:58 -0400
Date: Thu, 11 Jul 2024 01:38:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 39/44] multipath: implement check_usable_paths() with
 libmp_pathinfo()
Message-ID: <Zo9v8jyu65CTQ5Ve@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-40-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-40-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:30PM +0200, Martin Wilck wrote:
> ... and use cleanup attributes. We need to call the disassemble...()
> functions from multipath directly now, but we fetch exactly the data
> we need from the kernel.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 58 ++++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index c82bc86..b3b6c81 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -222,12 +222,14 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  static int check_usable_paths(struct config *conf,
>  			      const char *devpath, enum devtypes dev_type)
>  {
> -	struct udev_device *ud = NULL;
> -	struct multipath *mpp = NULL;
> +	struct udev_device __attribute__((cleanup(cleanup_udev_device))) *ud = NULL;
> +	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths))) *mpp = NULL;
>  	struct pathgroup *pg;
>  	struct path *pp;
> -	char *mapname;
> -	vector pathvec = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
> +	vector __attribute((cleanup(cleanup_vector))) pathvec = NULL;
> +	char uuid[DM_UUID_LEN];
>  	dev_t devt;
>  	int r = 1, i, j;
>  
> @@ -238,31 +240,39 @@ static int check_usable_paths(struct config *conf,
>  	devt = udev_device_get_devnum(ud);
>  	if (!dm_is_dm_major(major(devt))) {
>  		condlog(1, "%s is not a dm device", devpath);
> -		goto out;
> +		return r;
>  	}
>  
> -	mapname = dm_mapname(major(devt), minor(devt));
> -	if (mapname == NULL) {
> -		condlog(1, "dm device not found: %s", devpath);
> -		goto out;
> -	}
> -
> -	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
> -		condlog(1, "%s is not a multipath map", devpath);
> -		goto free;
> -	}
> +	mpp = alloc_multipath();
> +	if (!mpp)
> +		return r;
> +	if (!(mpp->alias = malloc(WWID_SIZE)))
> +		return r;
>  
>  	/* pathvec is needed for disassemble_map */
>  	pathvec = vector_alloc();
>  	if (pathvec == NULL)
> -		goto free;
> +		return r;
>  
> -	mpp = dm_get_multipath(mapname);
> -	if (mpp == NULL)
> -		goto free;

I can't see any thing that could go wrong, but we used to be setting
mpp->size in dm_get_multipath() and we no longer are, and setting
mpp->size is cheap and risk-free.

-Ben

> +	if (libmp_mapinfo(DM_MAP_BY_DEV,
> +			  (mapid_t) { ._u = { major(devt), minor(devt) } },
> +			  (mapinfo_t) {
> +			      .name = mpp->alias,
> +			      .uuid = uuid,
> +			      .dmi = &mpp->dmi,
> +			      .tgt_type = TGT_MPATH,
> +			      .target = &params,
> +			      .status = &status,
> +		      }) != DMP_OK)
> +		return r;
>  
> -	if (update_multipath_table(mpp, pathvec, 0) != DMP_OK)
> -		    goto free;
> +	if (!is_mpath_uuid(uuid))
> +		return r;
> +
> +	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
> +
> +	if (update_multipath_table__(mpp, pathvec, 0, params, status) != DMP_OK)
> +		return r;
>  
>  	vector_foreach_slot (mpp->pg, pg, i) {
>  		vector_foreach_slot (pg->paths, pp, j) {
> @@ -284,12 +294,6 @@ static int check_usable_paths(struct config *conf,
>  found:
>  	condlog(r == 0 ? 3 : 2, "%s:%s usable paths found",
>  		devpath, r == 0 ? "" : " no");
> -free:
> -	free(mapname);
> -	free_multipath(mpp, FREE_PATHS);
> -	vector_free(pathvec);
> -out:
> -	udev_device_unref(ud);
>  	return r;
>  }
>  
> -- 
> 2.45.2

