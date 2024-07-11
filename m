Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48401803D
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 06:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720680218; cv=none; b=CuLsaSlFzBBYedPhz95k1l2inn1a+ViMmLKmOA+1YjR+fmNszOPTEr+fA6GiuuFDjLtYEX36l7idlJP+B1aw3Y6s1XOsEKHJvVTraTS7k9kBd0Ze1S77TwYDXBhTmoCMj8IbV6NjF9fABd4IF+mTrg/CLcPmlHml4l5yU2gREBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720680218; c=relaxed/simple;
	bh=vMMuzSJhFEvB8cVDCo64ehoFhA2RA14NXG8v0LYpLZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rr6+N3vjJ5e7Pu0mYs9djEi0IatCFQoKjeqG3Lz+Ym16FNJ7SUqVr4RgTp/CUELnisU7tjPo5SWMYp/y4zZ3xV5qt+LAUL83TtVd5FABZAhMsx/tjp4qzoXH1uPY/XbrIMrT48th9HTylpZ9S3jvFLT2qKiO4fIb/2mRypWQJGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IWXVzol/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWXVzol/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720680215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gx8zD4j5ca2ZQf1ANgcfMTSoSYcu1pSbdmhrQhHLIGo=;
	b=IWXVzol/GMblO7cj4DA1WYdBfQk8ASdT5cFCDYdR8wSrBr96g5H7VadwtzSZFUZZlI7YrV
	0hthNqtHT3Aj+jS+VfTgC4Yn9Ac0KC7UkGWhx+Hx0INDEDGYDCrugpbboJLyB2cImiEKi/
	UX/QFRcCpw2Dcn1Ld9iaxb+t3NKsDM0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-528-DOeCgPVsM6W-LLa2v133Ew-1; Thu,
 11 Jul 2024 02:43:31 -0400
X-MC-Unique: DOeCgPVsM6W-LLa2v133Ew-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06F531954B08;
	Thu, 11 Jul 2024 06:43:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1FE21955F40;
	Thu, 11 Jul 2024 06:43:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B6hS3M1933078
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 02:43:28 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B6hSvP1933077;
	Thu, 11 Jul 2024 02:43:28 -0400
Date: Thu, 11 Jul 2024 02:43:28 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 43/44] libmpathpersist: use libmp_mapinfo() in get_mpvec()
Message-ID: <Zo9_EAdj2LdNqeaf@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-44-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-44-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:34PM +0200, Martin Wilck wrote:

In the subject, you mean mpath_get_map(), not get_mpvec(). But the code looks
fine.

-Ben

> When obtaining the map name, make sure right away that the map is a multipath
> device. This saves an ioctl and slightly simplifies the function.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist_int.c | 51 ++++++++++++++---------------
>  1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
> index 5a5ac3b..a3e7bd8 100644
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
> @@ -172,47 +171,45 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
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
> +	rc = libmp_mapinfo(DM_MAP_BY_DEV,
> +			   (mapid_t) { ._u = { major(info.st_rdev), minor(info.st_rdev) } },
> +			   (mapinfo_t) {
> +				   .name = alias,
> +				   .uuid = uuid,
> +				   .tgt_type = TGT_MPATH,
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

