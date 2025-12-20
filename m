Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BA27EFE3
	for <dm-devel@lists.linux.dev>; Sat, 20 Dec 2025 04:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766204387; cv=none; b=hhh7M04GBpQKb3PWJxQhY49RnU54kFcxd+LACeDvcqzkKL5gx5goOMAvR1rIjqrR5NQDXBs3ctdZdckTPhuEBu9ESrfKWZgKmLOPA4j4Fh2/H/VJDith9Ay9PZbLK48Pfug/GCwDdIQ22/ySDIH+FVd3WOpF5ulTNSmEhH5hRcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766204387; c=relaxed/simple;
	bh=13v0Mv8DzYAqBOeAMoCTcLSWkfbgLnxsf5dpJmxzWto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rKWVYh+b39ErS/faNSDkiwO5IeNdYzAsuUkreBe9eN+v2Sr2P1/+I+NQf+XqbFVSbeiAAZGnGMjtmKh7vU4dvcUCgLjDZ32JMTbaDQDn6/YejWgYPyI0AEP2RR4zrwdg6QMPAJPPulhLsMwm9wO1st+mb8Yu5zaiVJhsCKPZGiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I2w1dGwd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I2w1dGwd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766204384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8L3mC2PjB7t4WT1jo00t4HDfX5xaJ2SxcjmdQJnN2c=;
	b=I2w1dGwdYcMyvz3YtGzvSSTUAZrn3mOCnxQTQH/dTF+UqKOjS+PaUfAYqPOroAmQ+IWq0I
	QXMWT3GPLtiU1dmDHghUCcEco279gqmsOtQU/iDFwdOsQ3OIuTxZoW7pwkk8TNnhh5p8ld
	XVak36z4z9j4Pvw4xSljX2Tbz4mOblk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-_8L55AHhPL6WxU6Pa8LwPg-1; Fri,
 19 Dec 2025 23:19:41 -0500
X-MC-Unique: _8L55AHhPL6WxU6Pa8LwPg-1
X-Mimecast-MFC-AGG-ID: _8L55AHhPL6WxU6Pa8LwPg_1766204380
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B52901955F34;
	Sat, 20 Dec 2025 04:19:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E844180049F;
	Sat, 20 Dec 2025 04:19:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BK4Jb0V2173544
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 23:19:38 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BK4Jbg02173543;
	Fri, 19 Dec 2025 23:19:37 -0500
Date: Fri, 19 Dec 2025 23:19:37 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 13/26] multipath: free paths through pathvec in
 check_usable_paths()
Message-ID: <aUYj2RFgD81maXre@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
 <20251219144108.237928-14-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251219144108.237928-14-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BZkn_IeX2wcqIFz6Qn_9s4DQAvvJHZVWGcxWbOGdi3g_1766204380
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2025 at 03:40:55PM +0100, Martin Wilck wrote:
> Paths belong to the pathvec and should be freed from it.
> Use cleanup_multipath() instead of cleanup_multipath_and_paths(),
> and free the paths via the pathvec instead.
> 

I don't know if this matters, but until you stop free_multipaths() from
clearing pp->mpp in patch 15/26, this will temporarily cause UAF errors,
since you free the paths from the pathvec first, and then attempt to
reset their pp->mpp value in free_multipaths() later.

You could avoid the temporary problem by moving the pathvec definition
before the mpp definition, since cleanup functions are run in reverse
order of their declaration.

But after applying patch 15/26, this is fine, so
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 4b8d7dd..d28628b 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -214,12 +214,12 @@ static int check_usable_paths(struct config *conf,
>  			      const char *devpath, enum devtypes dev_type)
>  {
>  	struct udev_device __attribute__((cleanup(cleanup_udev_device))) *ud = NULL;
> -	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths))) *mpp = NULL;
> +	struct multipath __attribute__((cleanup(cleanup_multipath))) *mpp = NULL;
>  	struct pathgroup *pg;
>  	struct path *pp;
>  	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
>  	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
> -	vector __attribute((cleanup(cleanup_vector))) pathvec = NULL;
> +	vector __attribute((cleanup(cleanup_pathvec_and_free_paths))) pathvec = NULL;
>  	char uuid[DM_UUID_LEN];
>  	dev_t devt;
>  	int r = 1, i, j;
> -- 
> 2.52.0

