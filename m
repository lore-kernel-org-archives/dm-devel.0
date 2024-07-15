Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0063BBC2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083662; cv=none; b=UosMa1eewAG5Yd7DuxcZhnzTzl14mhy+vAUi20M6Z532GYS4ipadftkHaLTRJjKCFlpMKn81m7ssrX3sL1hgasXRcc4IqqcFGMAKD2rd8CZVDUguZHIxeZ/JgSj1WI9z/3FQ/PALkJKeNIimdu0N+0gMMJeJ0oRJJYXYXSiYAJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083662; c=relaxed/simple;
	bh=0AqQPKVACgs33L0IjCWeVdUmwDF3yp3FzuZz9JKK/pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=G1hVDdMfxuKPPJ7HLpVQZmFohU6XhyOEnNkmZd0hOsL2AB9Obpj+lzUo7Vs1PbxWpVCl6QzfUYePssUSQ++do9dQjcBxfaHFF8r5FydrrAQHl/y7V/KNVw1+xsiwpI4xN3lLD1Czw+qrVqfyDl+BlzkRdPnXDNZUavM7O1mSRYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hsDIwtDB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsDIwtDB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9nkq4yh7OX71DkHrPDiV3dhTfXBDMlFBzvtjwitChQs=;
	b=hsDIwtDB+MroSlr7CqmjL51HRiSKRectIGaLI1nM0WzScVxsbmBy8S72CR4kZge24HAETI
	v6rULH2H7K2n5VwjceVwUS3DZrsFYpriOdIY3LU1OM/SoYXswPCe+Ot97X5jMJmrwUOTLo
	JbyPHuQjGxgomhwVUvccFTTswMnR21A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512--UEhHgwEPnGWwocsJkr-gA-1; Mon,
 15 Jul 2024 18:47:36 -0400
X-MC-Unique: -UEhHgwEPnGWwocsJkr-gA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20D751956080;
	Mon, 15 Jul 2024 22:47:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AC1B1955F40;
	Mon, 15 Jul 2024 22:47:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMlXV52096878
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:47:33 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMlWqm2096877;
	Mon, 15 Jul 2024 18:47:32 -0400
Date: Mon, 15 Jul 2024 18:47:32 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 42/49] multipathd: implement add_map_without_path()
 with libmp_mapinfo()
Message-ID: <ZpWnBIiqvfRnWQKY@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-43-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-43-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:50PM +0200, Martin Wilck wrote:
> Also, change the return value to int, as this is more expressive and
> the returned struct multipath isn't used by the caller.
> 
> Also remove the call to sync_map_state() in ev_add_map(), which is
> redundant because add_map_without_path() would have called update_map()
> and thus sync_map_state() already.
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
>  multipathd/main.c | 79 ++++++++++++++++++++++++-----------------------
>  1 file changed, 41 insertions(+), 38 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1e7a6ac..536974c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -707,51 +707,57 @@ fail:
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
> +	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> +				(mapid_t) { .str = mpp->alias },
> +				(mapinfo_t) {
> +					.uuid = uuid,
> +					.dmi = &mpp->dmi,
> +					.size = &mpp->size,
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
> -	if (!strlen(mpp->wwid) &&
> -	    dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE) != DMP_OK) {
> -		condlog(3, "%s: cannot obtain WWID", mpp->alias);
> -		goto out;
> -	}
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
> +		return DMP_ERR;
> +	vector_set_slot(vecs->mpvec, steal_ptr(mpp));
>  
> -	vector_set_slot(vecs->mpvec, mpp);
> +	/*
> +	 * We can pass mpp here, steal_ptr() has just nullified it.

Nitpick: "We *can't* pass mpp here, ..."

-Ben

> +	 * vector_set_slot() just set the last slot, use that.
> +	 */
> +	if (update_map(VECTOR_LAST_SLOT(vecs->mpvec), vecs, 1) != 0) /* map removed */
> +		return DMP_ERR;
>  
> -	if (update_map(mpp, vecs, 1) != 0) /* map removed */
> -		return NULL;
> -
> -	return mpp;
> -out:
> -	remove_map(mpp, vecs->pathvec, vecs->mpvec);
> -	return NULL;
> +	return DMP_OK;
>  }
>  
>  static int
> @@ -865,14 +871,9 @@ int
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
> @@ -910,10 +911,12 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>  	/*
>  	 * now we can register the map
>  	 */
> -	if ((mpp = add_map_without_path(vecs, alias))) {
> -		sync_map_state(mpp);
> +	if ((rc = add_map_without_path(vecs, alias)) == DMP_OK) {
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

