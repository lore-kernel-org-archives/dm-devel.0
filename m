Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD7F848E
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654881; cv=none; b=lij3LbwZVrMUoDlZ/GXKikOYBEWi/QtSPoag3ZtrYLIViOOS3sxtmfKHJffWesiC08HGnKel174knUUxYsR29o3LpIHx1ZWwJz5r30wIP+oqmQKbgdK5bVwci4N8WaEzDcma55xEmej55GO7ohCePvra1EHryj1vl6QF555h5rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654881; c=relaxed/simple;
	bh=2zlBNFqXsqup/q86BYS2j6IpSc6Y7kvPNkOpiUyNAP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=a0bW5d7m53IS7fTUEORxmV3qgHw1Vbcvo2lkppLK52kDnejHe8y9yvdvWRb0ACEq+3vGdNKhZd2vuqZy+Aj0u1aOM1RO8AF5VJ1Aknoa/frdzet6QHXGdpgbMJD6hvaUVRTFgVWI9z8bwgPHfmriWY/fXXC+vB4LnhOZCaRKfSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dEsP8agy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dEsP8agy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720654878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fj/b62tKGMTFHSHJQI/qdQueDrIaR00FYbgLjLPorPg=;
	b=dEsP8agy6vO8oVdvDFUVARB+UUXHyU4gnF/wxHbWwvm8bA1+pzXn0pBZQI7C50tApqNtc7
	wku+XwGOMeNWVHIY/TsjECvgaoWw/dX1e6SEbc5SKWJOx/5nKslO6Gkf4NlrqywCYPJpKS
	rMN4fxg3gX5Zo6vnzZxq1yBJh88Mq9s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-FSR477ECNt-bzXLJMx6Eqw-1; Wed,
 10 Jul 2024 19:41:12 -0400
X-MC-Unique: FSR477ECNt-bzXLJMx6Eqw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BD1A19560B2;
	Wed, 10 Jul 2024 23:41:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7B9E19560AA;
	Wed, 10 Jul 2024 23:41:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46ANf9hv1922589
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 19:41:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46ANf9HT1922588;
	Wed, 10 Jul 2024 19:41:09 -0400
Date: Wed, 10 Jul 2024 19:41:09 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 24/44] libmultipath: reimplement dm_map_name() with new
 API
Message-ID: <Zo8cFTIrGIEAX0nQ@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-25-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-25-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:15PM +0200, Martin Wilck wrote:
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 34 ++++++----------------------------
>  1 file changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 1eebcb5..caa8385 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1469,37 +1469,15 @@ dm_is_suspended(const char *name)
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

Again, I'd prefer:

			  (mapid_t) { .dev = makedev(major, minor) },

But you can feel free to ignore me if you'd rather keep it how it is.

-Ben

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

