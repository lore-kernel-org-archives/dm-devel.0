Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D170013C9A2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721081674; cv=none; b=mPuqs5J/U8eUxcF/kyZ+iwrgTtK5MbSTS0auC2RvlZqC77K3+jfBH+EbK0Ug0mtqUT3CrkwfwyRLT6CvjskDD6AqQxDwHSNCbFNHgRO/mpqeBirz4u2ttjSQIfl7GxryupYsHVSRMxQAFlR3P4hbk+EONfxXbz5rTG3rAD8pcz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721081674; c=relaxed/simple;
	bh=vvFRPOdzEnJ/8lSA3bQw3EqxSzU395+sOT+7myKuXhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rG03VdWOMwzKYfAHUgnK0KFQSW5lhpM3yqgWHJ2EjNUVtpPDdNRiTAQ7gZIpBPUyhZViOzfxAiAOJrSie6U0n8uy5Ls+YNvXGA12sNxuavSIj+9IOGSNmUNhwPMzsWBf+DVLHKie/8y30p8NKC+MsSF++iyVqprq3F6Zc1mwrYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SG/t6MjG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SG/t6MjG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721081671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eSeSToSXbN5S6q+nh6nciEykR0mJVaKbKVJot0KB56E=;
	b=SG/t6MjGxiZFcftwsZTETHCgUSSbGEpu5/D4278LJivLHD60w3DW9xgf1pZaUvq9nR74LI
	TQ7DKuLM9//F2MFcpszpGWhXs7SbTE0YejqwXic8WfynQKuZxWmci8/mITfES5fx0WwrqD
	qJpw6qTalm/IdGxJAkTR/eWzRbs/N0c=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-LbG9UFL7Nce0ffGfSmc4bQ-1; Mon,
 15 Jul 2024 18:14:28 -0400
X-MC-Unique: LbG9UFL7Nce0ffGfSmc4bQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E766619560A2;
	Mon, 15 Jul 2024 22:14:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CD0A300018E;
	Mon, 15 Jul 2024 22:14:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMEOcG2095966
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:14:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMEO3s2095965;
	Mon, 15 Jul 2024 18:14:24 -0400
Date: Mon, 15 Jul 2024 18:14:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 17/49] libmultipath: rename dm_type()->dm_type_match()
 and use symbolic values
Message-ID: <ZpWfQOHEjwPP1O96@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-18-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-18-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:25PM +0200, Martin Wilck wrote:
> Also, make the function static.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 37 +++++++++++++++++++------------------
>  libmultipath/devmapper.h |  1 -
>  2 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 4bff62d..a63154f 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -806,43 +806,44 @@ out:
>  	return r;
>  }
>  
> -/*
> - * returns:
> - *    1 : match
> - *    0 : no match
> - *   -1 : empty map, or more than 1 target
> - */
> -int dm_type(const char *name, char *type)
> +enum {
> +	DM_TYPE_NOMATCH = 0,
> +	DM_TYPE_MATCH,
> +	/* more than 1 target */
> +	DM_TYPE_MULTI,
> +	/* empty map */
> +	DM_TYPE_EMPTY,
> +	DM_TYPE_ERR,
> +};
> +static int dm_type_match(const char *name, char *type)
>  {
> -	int r = 0;
>  	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	uint64_t start, length;
>  	char *target_type = NULL;
>  	char *params;
>  
>  	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
> -		return 0;
> +		return DM_TYPE_ERR;
>  
>  	if (!dm_task_set_name(dmt, name))
> -		goto out;
> +		return DM_TYPE_ERR;
>  
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> -		goto out;
> +		return DM_TYPE_ERR;
>  	}
>  
>  	/* Fetch 1st target */
>  	if (dm_get_next_target(dmt, NULL, &start, &length,
>  			       &target_type, &params) != NULL)
>  		/* multiple targets */
> -		r = -1;
> +		return DM_TYPE_MULTI;
>  	else if (!target_type)
> -		r = -1;
> +		return DM_TYPE_EMPTY;
>  	else if (!strcmp(target_type, type))
> -		r = 1;
> -
> -out:
> -	return r;
> +		return DM_TYPE_MATCH;
> +	else
> +		return DM_TYPE_NOMATCH;
>  }
>  
>  /*
> @@ -1426,7 +1427,7 @@ do_foreach_partmaps (const char * mapname,
>  		    /*
>  		     * if there is only a single "linear" target
>  		     */
> -		    (dm_type(names->name, TGT_PART) == 1) &&
> +		    (dm_type_match(names->name, TGT_PART) == DM_TYPE_MATCH) &&
>  
>  		    /*
>  		     * and the uuid of the target is a partition of the
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 19b79c5..ff28575 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -46,7 +46,6 @@ int dm_map_present (const char *name);
>  int dm_map_present_by_uuid(const char *uuid);
>  int dm_get_map(const char *name, unsigned long long *size, char **outparams);
>  int dm_get_status(const char *name, char **outstatus);
> -int dm_type(const char *name, char *type);
>  int dm_is_mpath(const char *name);
>  
>  enum {
> -- 
> 2.45.2

