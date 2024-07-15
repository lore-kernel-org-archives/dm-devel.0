Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75E140E3C
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083512; cv=none; b=Va9y8+ja5DDojK6i5leQsii8FDAJuvltgUNzNq4UihkSoZZtN3mAc03RNfLEDjRwTsx23cov7UA+vGasir+0mJKAttf9gK5fMweGKakjewsmqVRwJ6rD9xZzEXVYrkt+sC6SIjzU69hy5XdYNtQ/97YC+jzY12LRoz2CHxxxFVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083512; c=relaxed/simple;
	bh=fBvB0VSfk8e7wmPgl5RZhytAGkkBC5SJlIdMcf5F2So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ppM3u/ad9PDYPaqfQJwGTAlVXV6/7l5sO/zpmzNF/y7u2/bXBft7sWhUrhS6UYZQ6BPiD9sb9pQbjIoadzk7GOuyWWfRYhr9YXwjDFuf5bRU78zldHRcAwKYG6GGfgBrsf/40kYUKYWHhcaWU2NUwnq9jWNdrGXDiqMmHevagwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OEUwQZxw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OEUwQZxw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YK9qSWo5/AJozYpFaXT6+7qddQobjARKetg+7fB2cO0=;
	b=OEUwQZxwpSCz2J16DWyxAV4htEMk2guBqloL/pQfJv3OoOYuiynptJjBmZLr7Oa4AuhLlQ
	f5UfUIyqlA/JgF5MiBPhTwg62/03AopgovVxKI1D12j3DQjHk9ugzc36L6HLSGwzYjcOrB
	0ZGJ7b9p1QRKpUMBYUXlGcCZlQtSyMU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-336-4gz5tA2WOpaGw5S3sC-xEw-1; Mon,
 15 Jul 2024 18:45:05 -0400
X-MC-Unique: 4gz5tA2WOpaGw5S3sC-xEw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6AD11955D54;
	Mon, 15 Jul 2024 22:45:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 194211955F40;
	Mon, 15 Jul 2024 22:45:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMj2Ti2096811
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:45:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMj2kD2096810;
	Mon, 15 Jul 2024 18:45:02 -0400
Date: Mon, 15 Jul 2024 18:45:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 41/49] multipath: implement check_usable_paths() with
 libmp_pathinfo()
Message-ID: <ZpWmbrl7IUGY6uan@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-42-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-42-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:49PM +0200, Martin Wilck wrote:
> ... and use cleanup attributes. We need to call the disassemble...()
> functions from multipath directly now, but we fetch exactly the data
> we need from the kernel.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 58 ++++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index c82bc86..0d989dc 100644
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
> +	if (libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
> +			  (mapid_t) { .devt = devt },
> +			  (mapinfo_t) {
> +			      .name = mpp->alias,
> +			      .uuid = uuid,
> +			      .dmi = &mpp->dmi,
> +			      .size = &mpp->size,
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

