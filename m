Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71CC1CA80
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083485; cv=none; b=m9qycKhs62F4/schBxuZ3M6oln95QRh7hzqbQpy8IhKJW+DVAwcNjQ7ZhWzIXMH23Iz0zptGmydSpBfDkThQXZ2KHDLpOsrGn0CL6RqIOIBGg0UDOKtQuO91ccK9HGmLfux8rfq9bI+uW/4nFbq4XvaRiDsRep0XMUqRjvNlOa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083485; c=relaxed/simple;
	bh=UMmF8v62qCsvwJnMGPcuSj2DaZ0U2Zb+dKpQJKOQA98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Jq5PctgC7xaHZRw2B2HVEhgyB+kwt2jDFDnipq1MbDT54N7/jEvRpf7c10bNS3FrnZuIiHx5hfVgyKrJHRiX2LwO5OhFDUVttLFfdPb4/q16NoNapmZ/VyzLeuV0zgpyPcyHwz3VwviE7LefdePvaXgSdIlt/8KuQKDjDHuMJJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FTWaEOZR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FTWaEOZR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jk1uyPVAL+0TviX9KBx3belASW2bpbaM2REwvRDPB3U=;
	b=FTWaEOZRQt5iWcGXk3HoEwLe1tS0QdwJ29gXNkG/pcYeQdpYSWKyjoNdAxBpLQ3NElvE4p
	J/AriFOJ2IKsz0GECk3OqgWgNWDU3qG7Tvm9p2IRC5+OXttlYLZZw70Lumx6ZObuxYS2Ck
	WoTSSrXNyHRRQ94Cy7o8vPYu3fN5OjY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-UbBXENlFPSen35ZSssavdw-1; Mon,
 15 Jul 2024 18:44:41 -0400
X-MC-Unique: UbBXENlFPSen35ZSssavdw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7EFE1955D5E;
	Mon, 15 Jul 2024 22:44:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CAA81955D42;
	Mon, 15 Jul 2024 22:44:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMic3w2096800
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:44:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMiccg2096799;
	Mon, 15 Jul 2024 18:44:38 -0400
Date: Mon, 15 Jul 2024 18:44:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 37/49] libmultipath: use libmp_pathinfo() in
 update_multipath_table()
Message-ID: <ZpWmVu8SWIOcJkpe@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-38-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-38-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:45PM +0200, Martin Wilck wrote:
> This allows us to remove dm_get_status(), and dm_get_map(), of which
> update_multipath_table() was the last caller.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c   | 89 --------------------------------------
>  libmultipath/devmapper.h   |  2 -
>  libmultipath/structs_vec.c | 26 ++++++-----
>  3 files changed, 15 insertions(+), 102 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 587fc17..86ac01b 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -815,45 +815,6 @@ static int dm_get_dm_uuid(const char *mapname, char uuid[DM_UUID_LEN])
>  			     (mapinfo_t) { .uuid = uuid });
>  }
>  
> -int dm_get_map(const char *name, unsigned long long *size, char **outparams)
> -{
> -	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> -	uint64_t start, length;
> -	char *target_type = NULL;
> -	char *params = NULL;
> -
> -	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
> -		return DMP_ERR;
> -
> -	if (!dm_task_set_name(dmt, name))
> -		return DMP_ERR;
> -
> -	errno = 0;
> -	if (!libmp_dm_task_run(dmt)) {
> -		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> -		if (dm_task_get_errno(dmt) == ENXIO)
> -			return DMP_NOT_FOUND;
> -		else
> -			return DMP_ERR;
> -	}
> -
> -	/* Fetch 1st target */
> -	if (dm_get_next_target(dmt, NULL, &start, &length,
> -			       &target_type, &params) != NULL || !params)
> -		/* more than one target or not found target */
> -		return DMP_NOT_FOUND;
> -
> -	if (size)
> -		*size = length;
> -
> -	if (!outparams)
> -		return DMP_OK;
> -	else {
> -		*outparams = strdup(params);
> -		return *outparams ? DMP_OK : DMP_ERR;
> -	}
> -}
> -
>  bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
>  {
>  	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> @@ -896,56 +857,6 @@ static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
>  	return !strcmp(part_uuid + nc, map_uuid);
>  }
>  
> -int dm_get_status(const char *name, char **outstatus)
> -{
> -	int r = DMP_ERR;
> -	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> -	uint64_t start, length;
> -	char *target_type = NULL;
> -	char *status = NULL;
> -
> -	if (!(dmt = libmp_dm_task_create(DM_DEVICE_STATUS)))
> -		return r;
> -
> -	if (!dm_task_set_name(dmt, name))
> -		goto out;
> -
> -	errno = 0;
> -	if (!libmp_dm_task_run(dmt)) {
> -		dm_log_error(3, DM_DEVICE_STATUS, dmt);
> -		if (dm_task_get_errno(dmt) == ENXIO)
> -			r = DMP_NOT_FOUND;
> -		goto out;
> -	}
> -
> -	r = DMP_NOT_FOUND;
> -	/* Fetch 1st target */
> -	if (dm_get_next_target(dmt, NULL, &start, &length,
> -			       &target_type, &status) != NULL)
> -		goto out;
> -
> -	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
> -		goto out;
> -
> -	if (!status) {
> -		condlog(2, "got null status.");
> -		goto out;
> -	}
> -
> -	if (!outstatus)
> -		r = DMP_OK;
> -	else {
> -		*outstatus = strdup(status);
> -		r = *outstatus ? DMP_OK : DMP_ERR;
> -	}
> -out:
> -	if (r != DMP_OK)
> -		condlog(0, "%s: %s: error getting map status string: %d",
> -			__func__, name, r);
> -
> -	return r;
> -}
> -
>  int dm_is_mpath(const char *name)
>  {
>  	char uuid[DM_UUID_LEN];
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 7231a98..3daaa4c 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -131,8 +131,6 @@ int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
>  int dm_addmap_create (struct multipath *mpp, char *params);
>  int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
>  int dm_map_present_by_wwid(const char *uuid);
> -int dm_get_map(const char *name, unsigned long long *size, char **outparams);
> -int dm_get_status(const char *name, char **outstatus);
>  
>  enum {
>  	DM_IS_MPATH_NO,
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index ccc4efc..f2cfe31 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -484,30 +484,34 @@ int
>  update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
>  {
>  	int r = DMP_ERR;
> -	char *params = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
> +	unsigned long long size = mpp->size;
>  
>  	if (!mpp)
>  		return r;
>  
> -	r = dm_get_map(mpp->alias, &mpp->size, &params);
> +	r = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> +			  (mapid_t) { .str = mpp->alias },
> +			  (mapinfo_t) {
> +				  .target = &params,
> +				  .status = &status,
> +				  .size = &mpp->size,
> +			  });
> +
>  	if (r != DMP_OK) {
> -		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting table" : "map not present");
> +		condlog(2, "%s: %s", mpp->alias, dmp_errstr(r));
>  		return r;
> -	}
> +	} else if (size != mpp->size)
> +		condlog(0, "%s: size changed from %llu to %llu", mpp->alias, size, mpp->size);
>  
>  	if (disassemble_map(pathvec, params, mpp)) {
>  		condlog(2, "%s: cannot disassemble map", mpp->alias);
> -		free(params);
>  		return DMP_ERR;
>  	}
>  
> -	free(params);
> -	params = NULL;
> -	if (dm_get_status(mpp->alias, &params) != DMP_OK)
> -		condlog(2, "%s: %s", mpp->alias, (r == DMP_ERR)? "error getting status" : "map not present");
> -	else if (disassemble_status(params, mpp))
> +	if (disassemble_status(status, mpp))
>  		condlog(2, "%s: cannot disassemble status", mpp->alias);
> -	free(params);
>  
>  	/* FIXME: we should deal with the return value here */
>  	update_pathvec_from_dm(pathvec, mpp, flags);
> -- 
> 2.45.2

