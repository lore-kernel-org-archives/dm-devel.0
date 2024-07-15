Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A5113E88B
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721081641; cv=none; b=j1Ur0mVJYVMoRr1a46sHG7piPOvPqMe56QOObK9Lwje7FySeF0D2Ju37cDmzY++pA1MSD02oivwWLrhTOOxAgbgwLucjCxDcAbCD2ZJa+DXlCB/8bdlL0ueRxS+9wk6xQ4iL293bd5Vv0d/RUoB3Z2GCu35LNKxOoN/wIOqnfPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721081641; c=relaxed/simple;
	bh=U1odkeyhO16KICPsLYsVcTydIyjOFFxot1P89q/B+U0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=AP1JJps2auoVmY+LaK9kOBp3JE1I59i1y+FIBKuUt1sOGxZqzcbBx3r6sfxsWqeV+EkyCqGc1rjvtNjqxy5JCUIxocUGwAFePxtDYZdM8wC/jLF6Q4Tgr89byQzImyG44mlTFUqqxbtymPcTmjKkIudUy6cjyCCCx4Ihlt4LgNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VkH+YJ3u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VkH+YJ3u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721081638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lxO9PLjymgEiy6+URhoFs2xgU/O2APdpKFJLJ1ck14M=;
	b=VkH+YJ3uL3BUoI3MampIG70U4ogcfBgdySlaDHWytmR6cPE8LBYcFYaZqLkWOafQWIeLoC
	G4VIvyIkpOL+r7JD7icXC+XlCrAr2BRRrbYvMGrb6qaPIH1APlmpDLFPD3xFsRazuu61tL
	7C8CmpJdx62cEZ3fLhhD6fJFf4BoTgA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-J_4bme64Oei9CQ6R5hqnfQ-1; Mon,
 15 Jul 2024 18:13:56 -0400
X-MC-Unique: J_4bme64Oei9CQ6R5hqnfQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 972881956080;
	Mon, 15 Jul 2024 22:13:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0522C1955D42;
	Mon, 15 Jul 2024 22:13:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMDrCA2095956
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:13:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMDrvp2095955;
	Mon, 15 Jul 2024 18:13:53 -0400
Date: Mon, 15 Jul 2024 18:13:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 16/49] libmultipath: add cleanup_dm_task(), and use it
 in devmapper.c
Message-ID: <ZpWfITb4SP7x_dRn@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-17-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-17-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:24PM +0200, Martin Wilck wrote:
> This allows us to get rid of a lot of goto statements, and generally
> obtain cleaner code.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 258 ++++++++++++++++-----------------------
>  1 file changed, 107 insertions(+), 151 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 8996c1d..4bff62d 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c



> @@ -1419,10 +1396,10 @@ do_foreach_partmaps (const char * mapname,
>  		     int (*partmap_func)(const char *, void *),
>  		     void *data)
>  {
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
>  	struct dm_names *names;
>  	unsigned next = 0;
> -	char *params = NULL;
>  	unsigned long long size;
>  	char dev_t[32];
>  	int r = 1;

Nitpick: You can remove 'r' now.

-Ben

> @@ -1431,21 +1408,18 @@ do_foreach_partmaps (const char * mapname,
>  	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
>  		return 1;
>  
> -	if (!libmp_dm_task_run(dmt)) {
> -		dm_log_error(3, DM_DEVICE_LIST, dmt);
> -		goto out;
> -	}
> +	if (!libmp_dm_task_run(dmt))
> +		return 1;
>  
>  	if (!(names = dm_task_get_names(dmt)))
> -		goto out;
> +		return 1;
>  
> -	if (!names->dev) {
> -		r = 0; /* this is perfectly valid */
> -		goto out;
> -	}
> +	if (!names->dev)
> +		/* this is perfectly valid */
> +		return 0;
>  
>  	if (dm_dev_t(mapname, &dev_t[0], 32))
> -		goto out;
> +		return 1;
>  
>  	do {
>  		if (
> @@ -1472,7 +1446,7 @@ do_foreach_partmaps (const char * mapname,
>  		    !isdigit(*(p + strlen(dev_t)))
>  		   ) {
>  			if ((r = partmap_func(names->name, data)) != 0)
> -				goto out;
> +				return 1;
>  		}
>  
>  		free(params);
> @@ -1481,11 +1455,7 @@ do_foreach_partmaps (const char * mapname,
>  		names = (void *) names + next;
>  	} while (next);
>  
> -	r = 0;
> -out:
> -	free(params);
> -	dm_task_destroy (dmt);
> -	return r;
> +	return 0;
>  }

