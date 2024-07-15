Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA18C3BBC2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083702; cv=none; b=m7jTxdMTeEb53ImvYMTqbjudTsQtErLoEzNKX+L9mioIBp+ut0DX30upj3MLo6+8rYqwZ6fStADgjgL/hE33JVS6JSE+A7kjIH+gf/ymyohX0qsTdIcx8BpfJqPJKk63uVaLcOjONCBy8XhrMViKpjz9o6TjD/URp7fX2+upMMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083702; c=relaxed/simple;
	bh=QYtC9L/A5d141BDBDr17knGD3Cg4WQTaeDjD5ocBpm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pzFou/uuuph2QFt83tnbiHAaziP2tbjYKLOymVhtjeW/+VhqbbORF/bt2MMk8jnbjPmt9Kfl45EWTVqi6nQ69PPC3SEx81pmmLLFVq92hHCtItLTNwyf9IWfmeVwTaMCzIKaQA0oV3tu5UQXVBaC0Fn0uXktBgwrnBEuQuseCBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cxQAUBNS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cxQAUBNS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VWbwgCEVYo5DolHwpKnLKIHYmkYG71Q/XYvEsr67XVY=;
	b=cxQAUBNSbD9c/KUU/YAeWwS3Fv9NSE9LJknKT0FcfOQ50A7mod/ix8QG+LG3r9hbr76IiE
	AjnVavsRLF8jXepYS0HeI2DgxNBXLVOsaB4RWZ7mKllYOYN+WPdqPrxBTKL3ePoCFbRx8q
	e6Va3AqNbRyl6voTuZkTq7vGRIH1HWw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-giVgpvhVOemrqkew7r_OxQ-1; Mon,
 15 Jul 2024 18:48:17 -0400
X-MC-Unique: giVgpvhVOemrqkew7r_OxQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 681B2195609F;
	Mon, 15 Jul 2024 22:48:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E72B1955F40;
	Mon, 15 Jul 2024 22:48:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMmEH22096903
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:48:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMmELF2096902;
	Mon, 15 Jul 2024 18:48:14 -0400
Date: Mon, 15 Jul 2024 18:48:14 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 44/49] libmpathpersist: use libmp_mapinfo() in
 mpath_get_map()
Message-ID: <ZpWnLuBYztNJem0D@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-45-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-45-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:52PM +0200, Martin Wilck wrote:
> When obtaining the map name, make sure right away that the map is a multipath
> device. This saves an ioctl and slightly simplifies the function.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist_int.c | 50 +++++++++++++----------------
>  1 file changed, 23 insertions(+), 27 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
> index 5a5ac3b..a3eb80a 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -157,10 +157,9 @@ static int get_mpvec(vector curmp, vector pathvec, char *refwwid)
>  static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
>  			 struct multipath **pmpp)
>  {
> -	int ret = MPATH_PR_DMMP_ERROR;
> +	int rc;
>  	struct stat info;
> -	int major, minor;
> -	char *alias;
> +	char alias[WWID_SIZE], uuid[DM_UUID_LEN];
>  	struct multipath *mpp;
>  
>  	if (fstat(fd, &info) != 0){
> @@ -172,47 +171,44 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
>  		return MPATH_PR_FILE_ERROR;
>  	}
>  
> -	major = major(info.st_rdev);
> -	minor = minor(info.st_rdev);
> -	condlog(4, "Device  %d:%d", major, minor);
> -
>  	/* get alias from major:minor*/
> -	alias = dm_mapname(major, minor);
> -	if (!alias){
> -		condlog(0, "%d:%d failed to get device alias.", major, minor);
> +	rc = libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
> +			   (mapid_t) { .devt = info.st_rdev },
> +			   (mapinfo_t) {
> +				   .name = alias,
> +				   .uuid = uuid,
> +			   });
> +
> +	if (rc == DMP_NO_MATCH || !is_mpath_uuid(uuid)) {
> +		condlog(3, "%s: not a multipath device.", alias);
> +		return MPATH_PR_DMMP_ERROR;
> +	} else if (rc != DMP_OK) {
> +		condlog(1, "%d:%d failed to get device alias.",
> +			major(info.st_rdev), minor(info.st_rdev));
>  		return MPATH_PR_DMMP_ERROR;
>  	}
>  
> -	condlog(3, "alias = %s", alias);
> -
> -	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
> -		condlog(3, "%s: not a multipath device.", alias);
> -		goto out;
> -	}
> +	condlog(4, "alias = %s", alias);
>  
>  	/* get info of all paths from the dm device     */
> -	if (get_mpvec(curmp, pathvec, alias)){
> +	if (get_mpvec(curmp, pathvec, alias)) {
>  		condlog(0, "%s: failed to get device info.", alias);
> -		goto out;
> +		return MPATH_PR_DMMP_ERROR;
>  	}
>  
>  	mpp = find_mp_by_alias(curmp, alias);
>  
>  	if (!mpp) {
>  		condlog(0, "%s: devmap not registered.", alias);
> -		goto out;
> +		return MPATH_PR_DMMP_ERROR;
>  	}
>  
> -	ret = MPATH_PR_SUCCESS;
>  	if (pmpp)
>  		*pmpp = mpp;
> -	if (palias) {
> -		*palias = alias;
> -		alias = NULL;
> -	}
> -out:
> -	free(alias);
> -	return ret;
> +	if (palias && (*palias = strdup(alias)) == NULL)
> +		return MPATH_PR_DMMP_ERROR;
> +
> +	return MPATH_PR_SUCCESS;
>  }
>  
>  int do_mpath_persistent_reserve_in(vector curmp, vector pathvec,
> -- 
> 2.45.2

