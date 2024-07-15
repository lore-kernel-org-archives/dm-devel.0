Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21531CA80
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083440; cv=none; b=h5cXB+um3GQ3dgi1cDMf4hd8znYFtmPbb9T6i7dVzfnj0R2O51PAmHf8tZXFAp/T7NDahyvyopzv46vply2ExCB50ZrmmdTMazts2wihtyE5m541bfrPhe5uFM5m2iT+HIN+QZEBDVmUdvLJZJxCytsBtueFZvdENvSZq5c22/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083440; c=relaxed/simple;
	bh=mzNlbrxrPao4GFvBxi+SWKgQ4kMu4lCOhKOne72rKHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=JPulhbJ75k84WgotOYrTYXnTec2bWq9m7wxrBK2sAQMEkKYrHhXSJX0tJber2Obr2MUe0LhSqVa2bBy5KoK6fxYNm9f5vwd5vLhcEhhCuoHj/8Tlk8JSl/my0/PDFTeA/uN8hDHXFC1vcoL17QmfUtsC/yWKDezL8M8g3t0UPwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ClRkaMGu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ClRkaMGu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8Ou+Ac3XPsMCOgYZEPWaLyNg0+3QxGbNAzE/nG7Ohf4=;
	b=ClRkaMGu7jsZmMQ4u/lb8kF2sOlm0X4P+WoYEJ0XiG1VHmuJ/BBpNtZGuHH8aymGqZc+lv
	KOyUKOYNZgqSGvj9As+tYYovRqwNnQ5HQzpfDv6hR2ZHViDKbIG+aaFKLMOYo6VCwl8+gV
	XTWgp1Kl2YEvXmTI7Saa20N7IFU06SU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-368-17N0ROnaPLCI1i0yFp4CEA-1; Mon,
 15 Jul 2024 18:43:56 -0400
X-MC-Unique: 17N0ROnaPLCI1i0yFp4CEA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03B281955D5F;
	Mon, 15 Jul 2024 22:43:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E4A2195605A;
	Mon, 15 Jul 2024 22:43:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMhrhl2096772
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:43:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMhr7i2096771;
	Mon, 15 Jul 2024 18:43:53 -0400
Date: Mon, 15 Jul 2024 18:43:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 33/49] libmultipath: add is_mpath_uuid() helper
Message-ID: <ZpWmKaUg12RBOhLe@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-34-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-34-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:41PM +0200, Martin Wilck wrote:
> Export it, as it will be used by multipathd and libmpathpersist.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c          | 13 +++++++++----
>  libmultipath/devmapper.h          |  2 ++
>  libmultipath/libmultipath.version |  1 +
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 9483f02..6f17d32 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -840,6 +840,11 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
>  	}
>  }
>  
> +bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
> +{
> +	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> +}
> +
>  /**
>   * dm_get_wwid(): return WWID for a multipath map
>   * @returns:
> @@ -857,7 +862,7 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
>  	if (rc != DMP_OK)
>  		return rc;
>  
> -	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
> +	if (is_mpath_uuid(tmp))
>  		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
>  	else
>  		return DMP_NO_MATCH;
> @@ -982,7 +987,7 @@ int dm_is_mpath(const char *name)
>  
>  	switch (rc) {
>  	case DMP_OK:
> -		if (!strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +		if (is_mpath_uuid(uuid))
>  			return DM_IS_MPATH_YES;
>  		/* fallthrough */
>  	case DMP_NOT_FOUND:
> @@ -1082,7 +1087,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  			  (mapinfo_t) {
>  				  .uuid = uuid,
>  				  .target = &params }) != DMP_OK
> -	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +	    || !is_mpath_uuid(uuid))
>  		return DM_FLUSH_OK; /* nothing to do */
>  
>  	/* if the device currently has no partitions, do not
> @@ -1325,7 +1330,7 @@ struct multipath *dm_get_multipath(const char *name)
>  			  }) != DMP_OK)
>  		return NULL;
>  
> -	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +	if (!is_mpath_uuid(uuid))
>  		return NULL;
>  
>  	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 4c8f345..a10821f 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -136,6 +136,8 @@ enum {
>  	DM_IS_MPATH_YES,
>  	DM_IS_MPATH_ERR,
>  };
> +
> +bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
>  int dm_is_mpath(const char *name);
>  
>  enum {
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 7d3ff63..5b8f9e0 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -127,6 +127,7 @@ global:
>  	init_foreign;
>  	init_prio;
>  	io_err_stat_handle_pathfail;
> +	is_mpath_uuid;
>  	is_path_valid;
>  	libmp_dm_task_create;
>  	libmp_get_version;
> -- 
> 2.45.2

