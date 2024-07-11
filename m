Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF5C10E4
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 00:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720657274; cv=none; b=tkAWXWbAgAc3dfc7/vJAQcB7VjI5iPAynCLNch453fREyB2FFKoUR/M6RUM/KgK0lHo/7gW3ApJ8sRbnq8q7rAKhC1IQSkwIIaEV4YKe0cm+dU4cRPI1tvX2JMj5MgHKW/Im5jnlM3/h/arIB0E52CB+ApNeOGuu2r7Sg9blc30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720657274; c=relaxed/simple;
	bh=s45PSwiMa+Xk8GUN460TH/C2uSUhYJJfkLWFcPiZif8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=B8jxoTIhjCnyJXEAYNKn7Sjy4QtFstN5DyfFLK1XYWe/fLKNM09VjvjWyCk1/Ky8Upp0yDFFpyRRh2faMOWDAQzwyGqW7+wrvOcltTjRosx/rcrvzXE48dhLD6KCoexs+Xh/93hRKAD0HAG3SBnHfc4qerhmL9rvz+D8Aj5t4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vcu8dTqL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vcu8dTqL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720657270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ds2cW+/FYPGRxagwQEmngPJYrka5w/pRHtBOBS5ku2k=;
	b=Vcu8dTqLGhKzD4l6F3aO8n23Wx3iwozDidc4ZkYupI6MojNTeS0Wg0KQ+GPM3fZ5pUI8X8
	ioWwEkPQGFnO9FQ/GhcPOpBwfdZLPprXUQTNACzC1whLdBYwIoEkLjOMtS4+uORF6mzVic
	1tI8MItp9XDOmapmlCOToA9DJm9TxK0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-623-ShBn_wQEPt2Z9Bk4XtKaKQ-1; Wed,
 10 Jul 2024 20:21:09 -0400
X-MC-Unique: ShBn_wQEPt2Z9Bk4XtKaKQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F2B8A1955F3B;
	Thu, 11 Jul 2024 00:21:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BB3B1955F3B;
	Thu, 11 Jul 2024 00:21:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B0L6IW1923581
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 20:21:06 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B0L6Nk1923580;
	Wed, 10 Jul 2024 20:21:06 -0400
Date: Wed, 10 Jul 2024 20:21:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 28/44] libmultipath: implement dm_is_mpath() with new API
Message-ID: <Zo8lcu9JCzpZee8T@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-29-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-29-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:19PM +0200, Martin Wilck wrote:
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 53 ++++++----------------------------------
>  1 file changed, 8 insertions(+), 45 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 859a861..6276041 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -965,52 +965,15 @@ static int dm_type_match(const char *name, char *type)
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
> +	int rc = libmp_mapinfo(DM_MAP_BY_NAME,
> +			       (mapid_t) { .str = name },
> +			       (mapinfo_t) { .uuid = uuid, .tgt_type = TGT_MPATH });
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
> -	}
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
> -	if (r < 0)
> -		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
> -	return r;

Since dm_get_events() and watch_dmevents() need to differentiate between
DM_IS_MPATH_NO and DM_IS_MPATH_ERR, this function needs to return
DM_IS_MPATH_ERR if libmp_mapinfo() returns DM_ERR.

Looking over this function, I did notice one thing.  It returns
DM_IS_MPATH_ERR if dm_task_get_info() fails, while libmp_mapinfo__()
returns DMP_NOT_FOUND if dm_task_get_info() fails. Looking at the
current lvm code, I can't see a way for dm_task_get_info() to fail
if we just called libmp_dm_task_run() and it succeeded. On the other
hand dm_task_get_info() failing does seem to be an error, not a
a sign that the device doesn't exist, so perhaps ibmp_mapinfo__()
should treat it like one. Although most of our code doesn't, and like I
said, I don't see how it could fail unless dm_task_run() already failed
(or wasn't called).

Any thoughts?

-Ben


> +	if (rc != DMP_OK || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN))
> +		return DM_IS_MPATH_NO;
> +	else
> +		return DM_IS_MPATH_YES;
>  }
>  
>  int dm_map_present_by_wwid(const char *wwid)
> -- 
> 2.45.2

