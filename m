Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594BE1CA80
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083416; cv=none; b=sqbzMDOR+lPN34wKuUqhxE5UAmTc4dvZXMaRgi6ly+E/EeGxJI3YrqLHVd65Q4gd5Pha0XDSaX1MZIpVU7ExKPn8+VCD3s9sPIe0hPjy+lS1f2RD1zP8/LIk4ajkc2yTQLJt82RXC8ne1rGVc3P3cm/x2Qey1gtrcCVR7bD6wB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083416; c=relaxed/simple;
	bh=Bw+gmcLS6QOUzAvpIpEkEFVrjo5aSZCVIBABBG9tm5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ajySsmf6gt5r1MS1huHljSp1Mt2bzJAq62PYn/jIHrQz+y5Mqp3kVEUet2pxvX91u/dPCqGmvlrZXSvths9wTt+EMUP3T+/9evkks6rueXap8WPove7LST5Z/bCpqu76EKdB1lH2eylzy5cry8DTw0Jcg2oO7DYYKApoSIoMqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+CoKUFH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+CoKUFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tukMSi/QdFh3f7osJZWbgsIkFKEjry9eDB21KrYtUe8=;
	b=O+CoKUFHjcyU60TWMZ6KAqvp4rTcwNazY4NJzXkoHVFl3+31+srqs6NTv/GrqHUn2xtS+a
	q+TIZrJn38Bac3ZC6L+5yelm3rZYpZV6UGh1v5rcL9HgLPwILTBE+RxLO4+CUkWZYVa2PH
	mOWOtPS4FT2SK6Tm7Up026q1Bls0sGU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-_ho8H39ZNve2n4wtsmhHIw-1; Mon,
 15 Jul 2024 18:43:30 -0400
X-MC-Unique: _ho8H39ZNve2n4wtsmhHIw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 170FB19560AD;
	Mon, 15 Jul 2024 22:43:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B37F300018D;
	Mon, 15 Jul 2024 22:43:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMhRlD2096747
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:43:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMhRjo2096746;
	Mon, 15 Jul 2024 18:43:27 -0400
Date: Mon, 15 Jul 2024 18:43:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 30/49] libmultipath: implement dm_is_mpath() with new
 API
Message-ID: <ZpWmD6ZXFZ8QnE43@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-31-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-31-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:38PM +0200, Martin Wilck wrote:
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 59 ++++++++++------------------------------
>  1 file changed, 15 insertions(+), 44 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 47ff827..11bccb1 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -975,52 +975,23 @@ static int dm_type_match(const char *name, char *type)
>  
>  int dm_is_mpath(const char *name)
>  {
> -	int r = DM_IS_MPATH_ERR;
> -	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> -	struct dm_info info;
> -	uint64_t start, length;
> -	char *target_type = NULL;
> -	char *params;
> -	const char *uuid;
> +	char uuid[DM_UUID_LEN];
> +	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> +			       (mapid_t) { .str = name },
> +			       (mapinfo_t) { .uuid = uuid });
>  
> -	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
> -		goto out;
> -
> -	if (!dm_task_set_name(dmt, name))
> -		goto out;
> -
> -	if (!libmp_dm_task_run(dmt)) {
> -		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> -		goto out;
> +	switch (rc) {
> +	case DMP_OK:
> +		if (!strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +			return DM_IS_MPATH_YES;
> +		/* fallthrough */
> +	case DMP_NOT_FOUND:
> +	case DMP_NO_MATCH:
> +		return DM_IS_MPATH_NO;
> +	case DMP_ERR:
> +	default:
> +		return DM_IS_MPATH_ERR;
>  	}
> -
> -	if (!dm_task_get_info(dmt, &info))
> -		goto out;
> -
> -	r = DM_IS_MPATH_NO;
> -
> -	if (!info.exists)
> -		goto out;
> -
> -	uuid = dm_task_get_uuid(dmt);
> -
> -	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
> -		goto out;
> -
> -	/* Fetch 1st target */
> -	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
> -			       &params) != NULL)
> -		/* multiple targets */
> -		goto out;
> -
> -	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
> -		goto out;
> -
> -	r = DM_IS_MPATH_YES;
> -out:
> -	if (r == DM_IS_MPATH_ERR)
> -		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
> -	return r;
>  }
>  
>  int dm_map_present_by_wwid(const char *wwid)
> -- 
> 2.45.2

