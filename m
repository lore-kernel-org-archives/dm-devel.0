Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF59679D0
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 00:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736382421; cv=none; b=FVVNiGjoix4lU2n95kt+cO348QgWGs2RkTW7RUrWgq4RoX9Rf7hIZb01PllMXtjfosZPV2fsuPe7U014B2rZNl9b5RYijQ26gP0ZkIMeKK8oOY0SKt/fJO3XFHo7a5+ffKFKFVL7SK3HcpwKUgAGHFIlgXWqPNIAuwv2EkkHP5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736382421; c=relaxed/simple;
	bh=RsyEVUERJ404bgiVEtLPt5OLTendKAoarL3lekNHDyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YZRLzoFIuc5yzRJY7P6yHlcO2JDz3toXk30exye1NzyZM3R58DzF+RwntYvnBg/m1Kj+z+MFN4HBeHWStjlMYxNN8Druhw4qWAmTQhH8SYpYpz82SNhG4eFiLFAzWy1akT459QFGhuZmhkmBL++59dsSq3IQPjvkEgw567f98Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PxrZnnVu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PxrZnnVu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736382418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYJo5m9LN2R1FadpQdsIlpoxqLoiHOChbisJUT3H7Zg=;
	b=PxrZnnVuy/6POg8OGm33v4VWiXhfK9gV1vAuTLAzAEOSnIC8pHYoEDEcpkK87J6n8MjyPr
	PowxLcSnilI3SK3V46oWEPkQR4cjTSNTVxFnXMzvSCcvQUMIFthcOVbHlT/3wasyl/DAQL
	ILdhCi4WxWfzETfNK941pNjMijJhpCQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-LFQOR2TsPy2Brd2YMpDkUA-1; Wed,
 08 Jan 2025 19:26:57 -0500
X-MC-Unique: LFQOR2TsPy2Brd2YMpDkUA-1
X-Mimecast-MFC-AGG-ID: LFQOR2TsPy2Brd2YMpDkUA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58F841944CEE;
	Thu,  9 Jan 2025 00:26:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19C17300018D;
	Thu,  9 Jan 2025 00:26:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 5090Qsai2470106
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Jan 2025 19:26:55 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 5090Qsln2470105;
	Wed, 8 Jan 2025 19:26:54 -0500
Date: Wed, 8 Jan 2025 19:26:54 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] libmultipath/foreign: fix memory leak in nvme foreign
 handler
Message-ID: <Z38XzlEsDLchkUIi@redhat.com>
References: <20250109000653.2469651-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250109000653.2469651-1-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PoAfJOAzCaNE8wSI1za6Pb-sl9S3SD8khlKT6Kc3WiI_1736382416
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 08, 2025 at 07:06:53PM -0500, Benjamin Marzinski wrote:
> _find_controllers() needs to free the udev device if it doesn't get
> added to a path. Otherwise it can leak memory whenever check_foreign()
> is called, causing multipathd's memory usage to continually grow.
> 

This also belongs in the stable branch.

-Ben

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/foreign/nvme.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
> index 0b7f4eab..cde660ce 100644
> --- a/libmultipath/foreign/nvme.c
> +++ b/libmultipath/foreign/nvme.c
> @@ -675,7 +675,8 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
>  	pthread_cleanup_push_cast(free_scandir_result, &sr);
>  	for (i = 0; i < r; i++) {
>  		char *fn = di[i]->d_name;
> -		struct udev_device *ctrl, *udev;
> +		struct udev_device *ctrl;
> +		struct udev_device *udev __attribute__((cleanup(cleanup_udev_device))) = NULL;
>  
>  		if (safe_snprintf(pathbuf + n, sizeof(pathbuf) - n, "/%s", fn))
>  			continue;
> @@ -719,11 +720,11 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
>  			continue;
>  
>  		path->gen.ops = &nvme_path_ops;
> -		path->udev = udev;
> +		path->udev = steal_ptr(udev);
>  		path->seen = true;
>  		path->map = map;
>  		path->ctl = udev_device_get_parent_with_subsystem_devtype
> -			(udev, "nvme", NULL);
> +			(path->udev, "nvme", NULL);
>  		if (path->ctl == NULL) {
>  			condlog(1, "%s: %s: failed to get controller for %s",
>  				__func__, THIS, fn);
> @@ -744,7 +745,7 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
>  		}
>  		vector_set_slot(&map->pgvec, &path->pg);
>  		condlog(3, "%s: %s: new path %s added to %s",
> -			__func__, THIS, udev_device_get_sysname(udev),
> +			__func__, THIS, udev_device_get_sysname(path->udev),
>  			udev_device_get_sysname(map->udev));
>  	}
>  	pthread_cleanup_pop(1);
> -- 
> 2.46.2
> 

