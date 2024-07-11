Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F294171AF
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 03:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720669114; cv=none; b=ENVG/WT7uc2+/B9+TvaQ8yCtibj3JfSmjniA8xdM2y8QwKXuf6/zwgkax0VbHL97NN+7qSuORYKPia8FoYzwDvNF0qFb5UpuXL3fIfkHwnESfQQAHIYJct2M1VTgQqqeZBleuwsuEByTPUjdWaSqcOoef7F2TtYIHa3pV+YXnEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720669114; c=relaxed/simple;
	bh=mksMnDxoUvhBdXkncGnvWsGo3O5rq7/JZuensI/J89A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PzVVn0aFQyvLS2G+Ys+9uHgJ4uNHalEWLENXTf++iISmVe37FuwognPw52pGftoEM+B/ZNmtdbWIjy4rM1EOyk/L9eM4icxeh66EiZ9kpg1y/OEA3l6sqDsTky/T+paUxqGHj9o0lfdrNgdSywcUN/cAKAVdHjqSlqYqywG6JDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IWvP+GNO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWvP+GNO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720669111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kmq+VJ9zo4LM+wOm5KWt9/1Fc5qmEIBLOhi7fMwkFrc=;
	b=IWvP+GNOiXSxrBpK4jOMHEjh0ABTS9rYCIyj2/AOtofLiakwZh55UJB78inK9cjOxvG2XI
	LMxwZGTrNuZAYm4OtIEi4jiadJw0pp8LgItiqLUNAMJDJbLEN5EIAaKseAVbAirVzY3ZaR
	YnVA+ZXac+HPB7axHNgoF+hiaLqhpxQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-eXMENri0NI-MEdRPTgwdtA-1; Wed,
 10 Jul 2024 23:38:29 -0400
X-MC-Unique: eXMENri0NI-MEdRPTgwdtA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDAC819560B3;
	Thu, 11 Jul 2024 03:38:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4372319560AE;
	Thu, 11 Jul 2024 03:38:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B3cRjK1928464
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 23:38:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B3cQ4f1928463;
	Wed, 10 Jul 2024 23:38:26 -0400
Date: Wed, 10 Jul 2024 23:38:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 31/44] libmultipath: add is_mpath_uuid() helper
Message-ID: <Zo9TsqnZ3Zs6XD1w@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-32-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-32-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:22PM +0200, Martin Wilck wrote:
> Export it, as it will be used by multipathd and libmpathpersist.
> 

This is fine. But I was thinking that if you wanted to actually add
some optional flags to the flags argument of libmp_mapinfo(), this would
be a good use. You could have a flag like DM_MAP_MPATH_WWID, which would
verify that the device had a multipath UUID_PREFIX (and possibly force a
check for a multipath target type) and then return the wwid without the
multipath uuid prefix.

Just a thought.

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c          | 13 +++++++++----
>  libmultipath/devmapper.h          |  2 ++
>  libmultipath/libmultipath.version |  1 +
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 806ffb8..5f6c0c8 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -829,6 +829,11 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
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
> @@ -845,7 +850,7 @@ int dm_get_wwid(const char *name, char *uuid, int uuid_len)
>  	if (rc != DMP_OK)
>  		return rc;
>  
> -	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
> +	if (is_mpath_uuid(tmp))
>  		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
>  	else {
>  		uuid[0] = '\0';
> @@ -970,7 +975,7 @@ int dm_is_mpath(const char *name)
>  			       (mapid_t) { .str = name },
>  			       (mapinfo_t) { .uuid = uuid, .tgt_type = TGT_MPATH });
>  
> -	if (rc != DMP_OK || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +	if (rc != DMP_OK || !is_mpath_uuid(uuid))
>  		return DM_IS_MPATH_NO;
>  	else
>  		return DM_IS_MPATH_YES;
> @@ -1065,7 +1070,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  				  .uuid = uuid,
>  				  .tgt_type = TGT_MPATH,
>  				  .target = &params }) != DMP_OK
> -	    || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +	    || !is_mpath_uuid(uuid))
>  		return DM_FLUSH_OK; /* nothing to do */
>  
>  	/* if the device currently has no partitions, do not
> @@ -1309,7 +1314,7 @@ struct multipath *dm_get_multipath(const char *name)
>  			  }) != DMP_OK)
>  		return NULL;
>  
> -	if (strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +	if (!is_mpath_uuid(uuid))
>  		return NULL;
>  
>  	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index db5c5fd..a2b2837 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -131,6 +131,8 @@ enum {
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

