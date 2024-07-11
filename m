Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0989F2904
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 06:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720678306; cv=none; b=IB9owh+QO50uLOX4F0CyTsDWX/3x4JT71+flIznKkXjOKQGoxYnqfFuYrVgeNKw+aHzmdJ05teP1JmNbEDHyEXJxT7OCY0D0/T+RbPD6AltIyZVo8ObrkBtg2yE0587ptWfoMs7gME6uf+EDUWJMH/XHruWpYjPw+io2t3o8dds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720678306; c=relaxed/simple;
	bh=8MJ+bV3s6CIIi8/UOsrtC5bGqA0i4UEaGFDM8yshLGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=D6kg87qdwuJTubV4w1gRiutThk3qgOB4thXpupvRqAgKz5AJHvSiTCnLP3FMLw8hgbWv3esvxAVmAD2Mf9q8Y0UlYdXAXDXDR4D1IPSz4NEba7TcOB0GpU3BavbLnTVSEKJAhxDd5rSuip0ZO3ild/eRPMb+Y0TRTBFDVi6hbqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NJbVynxJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJbVynxJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720678303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IeWK5bs8tWI8FLZnXeeAFLpHqupOE70bYKSVGDzZqiM=;
	b=NJbVynxJv+efZHOyjPiq2yH3LZIWXC9KLYxSEHIeqvujLovYE74bpkL2DnDC/fVbd1/u38
	dEAWsHbU7StNjxWAV/EZPkDzisL/0dXK9kVZd8Q8wI1twnTzHXcWw0wWZeTCxbJzOTRNQR
	WqMzVAEBNIN+kfj+NkPPs2rnLCW0pyE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-365-d7_YPA-JP0CKj_6KI_nb0w-1; Thu,
 11 Jul 2024 02:11:39 -0400
X-MC-Unique: d7_YPA-JP0CKj_6KI_nb0w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70637193586E;
	Thu, 11 Jul 2024 06:11:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA3CA1955F40;
	Thu, 11 Jul 2024 06:11:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B6Baw71932312
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 02:11:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B6BaYn1932311;
	Thu, 11 Jul 2024 02:11:36 -0400
Date: Thu, 11 Jul 2024 02:11:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 40/44] multipathd: implement add_map_without_path() with
 libmp_mapinfo()
Message-ID: <Zo93mF43FJsaar_o@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-41-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-41-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:31PM +0200, Martin Wilck wrote:
> Also, change the return value to int, as this is more expressive and
> the returned struct multipath isn't used by the caller.
> 
> Note: this removes the call to remove_map() at the end of the function,
> which doesn't make sense anyway, because update_multipath_table()
> would not return error unless the table disassembly failed, in which
> case nothing would have been added the the mpvec or pathvec yet.
> It should be sufficient to just cleanup the local data structures when
> add_map_without_path() fails.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 69 ++++++++++++++++++++++++-----------------------
>  1 file changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 442a154..9e82188 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -707,48 +707,53 @@ fail:
>  	return 0;
>  }
>  
> -static struct multipath *
> -add_map_without_path (struct vectors *vecs, const char *alias)
> +static int add_map_without_path (struct vectors *vecs, const char *alias)
>  {
> -	struct multipath * mpp = alloc_multipath();
> +	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths)))
> +		*mpp = alloc_multipath();
> +	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
>  	struct config *conf;
> +	char uuid[DM_UUID_LEN];
> +	int rc = DMP_ERR;
>  
> -	if (!mpp)
> -		return NULL;
> -	if (!alias) {
> -		free(mpp);
> -		return NULL;
> -	}
> +	if (!mpp || !(mpp->alias = strdup(alias)))
> +		return DMP_ERR;
>  
> -	mpp->alias = strdup(alias);

This again doesn't set mpp->size, when it previously did. Am I missing
something about why this is unnecessary? I get that it can be set by
a path, but if it is already set, it can be used the verity that the
path belongs.

> +	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME,
> +				(mapid_t) { .str = mpp->alias },
> +				(mapinfo_t) {
> +					.uuid = uuid,
> +					.tgt_type = TGT_MPATH,
> +					.dmi = &mpp->dmi,
> +					.target = &params,
> +					.status = &status,
> +				})) != DMP_OK)
> +		return rc;
> +
> +	if (!is_mpath_uuid(uuid))
> +		return DMP_NO_MATCH;
> +	else
> +		strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
>  
> -	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
> -		condlog(3, "%s: cannot access table", mpp->alias);
> -		goto out;
> -	}
> -	if (!strlen(mpp->wwid))
> -		dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE);
>  	if (!strlen(mpp->wwid))
>  		condlog(1, "%s: adding map with empty WWID", mpp->alias);
> +
>  	conf = get_multipath_config();
>  	mpp->mpe = find_mpe(conf->mptable, mpp->wwid);
>  	put_multipath_config(conf);
>  
> -	if (update_multipath_table(mpp, vecs->pathvec, 0) != DMP_OK)
> -		goto out;
> +	if ((rc = update_multipath_table__(mpp, vecs->pathvec, 0, params, status)) != DMP_OK)
> +		return DMP_ERR;
>  
>  	if (!vector_alloc_slot(vecs->mpvec))
> -		goto out;
> -
> -	vector_set_slot(vecs->mpvec, mpp);
> +		return DMP_ERR;
> +	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
>  
>  	if (update_map(mpp, vecs, 1) != 0) /* map removed */
> -		return NULL;
> +		return DMP_ERR;
>  
> -	return mpp;
> -out:
> -	remove_map(mpp, vecs->pathvec, vecs->mpvec);
> -	return NULL;
> +	return DMP_OK;
>  }
>  
>  static int
> @@ -862,14 +867,9 @@ int
>  ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>  {
>  	struct multipath * mpp;
> -	int reassign_maps;
> +	int reassign_maps, rc;
>  	struct config *conf;
>  
> -	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
> -		condlog(4, "%s: not a multipath map", alias);
> -		return 0;
> -	}
> -
>  	mpp = find_mp_by_alias(vecs->mpvec, alias);
>  
>  	if (mpp) {
> @@ -907,10 +907,13 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>  	/*
>  	 * now we can register the map
>  	 */
> -	if ((mpp = add_map_without_path(vecs, alias))) {
> +	if ((rc = add_map_without_path(vecs, alias)) == DMP_OK) {

sync_map_state() is called with an uninitialized mpp, however the call is
unnecssary, since add_map_without_path() will call update_map() which will
call sync_map_state(). 

-Ben

>  		sync_map_state(mpp);
>  		condlog(2, "%s: devmap %s registered", alias, dev);
>  		return 0;
> +	} else if (rc == DMP_NO_MATCH) {
> +		condlog(4, "%s: not a multipath map", alias);
> +		return 0;
>  	} else {
>  		condlog(2, "%s: ev_add_map failed", dev);
>  		return 1;
> -- 
> 2.45.2

