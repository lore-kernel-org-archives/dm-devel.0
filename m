Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD61CA80
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083385; cv=none; b=BK3/aG+Vi8KccuHrHgeOguyz/vic9zphDGlYVGTaEbsXaairt4T8ER/LlF40mY0WgkfKgdBDvbDcwtsYfpKWa/hL8wYCLMzBW/I//9RZIO4Bk8pAiFgPbwBhbDuxeVaTdDKt+KfKBuC5mwOUt8PcLMOW0p6bNEJu5QcZS6AhHtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083385; c=relaxed/simple;
	bh=AgmIbPuqLzlaawnpJl5kAoRbSjzJQOkE3aFKxtk8oeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=MBdUcaGr6RgrRxT8madUcYPyAb7YdlvhDv2NGVXjgz/OY6BfT/QW5UEos6uT+ok+gz1u2d2F+a1PVX1GXclMI0/FEP2Hj2UqRveRyhX7ZSS9qGF+UeWT3OvRghy47GJW9KrQBmcHJy/sQOHoTYywdPXFnIbrOkpo0o3ahsRbgJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qd0WOha5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qd0WOha5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7mpZo5+kQWcZYclYJ4QCIzMLY8HsgGfEl2avCvLzzOg=;
	b=Qd0WOha5Iw2Rc5OgPO7Z2FmE60GubvxWBj3jyD8Xar7/zZd506LqUT+PDvgMod/6YvNlF/
	qmS9oJpUPXHbZEOXB0jhYs8atHbbAFrDHw0onO2wbBMnegyjtGbybYVTa1RrAO9+IdqWlH
	r0C+hbmrNbWAaMByT/6A0S6lkAc4V1E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661--qMPbQ0GNiO7tvsenzWK6Q-1; Mon,
 15 Jul 2024 18:42:58 -0400
X-MC-Unique: -qMPbQ0GNiO7tvsenzWK6Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDB711955D44;
	Mon, 15 Jul 2024 22:42:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50D0E19560B2;
	Mon, 15 Jul 2024 22:42:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMgt3l2096740
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:42:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMgtFt2096739;
	Mon, 15 Jul 2024 18:42:55 -0400
Date: Mon, 15 Jul 2024 18:42:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 26/49] libmultipath: reimplement dm_map_name() with
 new API
Message-ID: <ZpWl7wbFwaLZuPal@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-27-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-27-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:34PM +0200, Martin Wilck wrote:
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 34 ++++++----------------------------
>  1 file changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 003d834..8af4167 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1481,37 +1481,15 @@ dm_is_suspended(const char *name)
>  	return info.suspended;
>  }
>  
> -char *
> -dm_mapname(int major, int minor)
> +char *dm_mapname(int major, int minor)
>  {
> -	char * response = NULL;
> -	const char *map;
> -	struct dm_task *dmt;
> -	int r;
> +	char name[WWID_SIZE];
>  
> -	if (!(dmt = libmp_dm_task_create(DM_DEVICE_INFO)))
> +	if (libmp_mapinfo(DM_MAP_BY_DEV,
> +			  (mapid_t) { ._u = { major, minor } },
> +			  (mapinfo_t) { .name = name }) != DMP_OK)
>  		return NULL;
> -
> -	if (!dm_task_set_major(dmt, major) ||
> -	    !dm_task_set_minor(dmt, minor))
> -		goto bad;
> -
> -	r = libmp_dm_task_run(dmt);
> -	if (!r) {
> -		dm_log_error(2, DM_DEVICE_INFO, dmt);
> -		goto bad;
> -	}
> -
> -	map = dm_task_get_name(dmt);
> -	if (map && strlen(map))
> -		response = strdup((const char *)map);
> -
> -	dm_task_destroy(dmt);
> -	return response;
> -bad:
> -	dm_task_destroy(dmt);
> -	condlog(0, "%i:%i: error fetching map name", major, minor);
> -	return NULL;
> +	return strdup(name);
>  }
>  
>  static int
> -- 
> 2.45.2

