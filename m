Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B2E2F3621
	for <dm-devel@lists.linux.dev>; Thu, 18 Dec 2025 23:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766100861; cv=none; b=AUt2Xc8J40C5ckZvncALTCuOi0k6YhC4VT8/SQJ6fz5bcTfmg1i4uni24TQMXpieABgDu1R97pwZE8W/XX0L5bNJPweuBJ+yBEoeLa6nVOwqc+JR+HDuQphuAQNvYx7t3jN2o9r1vbGsfFhyWRzPMiTtRjA+rV4T3ahy43XqWHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766100861; c=relaxed/simple;
	bh=OIFDtLMZcMqrMNaSx+kKBR5adaidsHnTA0ngCrZyBaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=a5xLz0aJC9jXQoFDkf3cXqem7MG0JUmKnSGxk0ZhUq/eEMiLqYmqVjvsg36tudWBTpkNU83zXOJKIgM/qJofFYR1xJqVjqo3pEKB+WBn79ktQuvExf3o1QD/HGBsajzpDHnuSzejJ3Oi+sJmeGMecqmd/lW7QZauqgPH9wT36yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LG8Cu8V8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LG8Cu8V8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766100857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzZ9Tl19W1gcyOnH6vOdltOxRKj+I1u4wRXT/0Dmjo0=;
	b=LG8Cu8V8XASBgwvRyYHRMQmiPNIkY8tbBsd+7MSAMH8Ufjl7qQmlxNV0IREPAm2FKTO0Oo
	SKScKIT8OMg+eSe6v7ThMaVtIYdVKqnwMj5FkV1xLk5ImLBmPLeQPqA58/zU3xKxgxObKU
	KQGhgS8wahjuU+jwnoW8QvnJ6nuoWCs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-B5HjGdDuOlaxT50Tqs-lVA-1; Thu,
 18 Dec 2025 18:34:14 -0500
X-MC-Unique: B5HjGdDuOlaxT50Tqs-lVA-1
X-Mimecast-MFC-AGG-ID: B5HjGdDuOlaxT50Tqs-lVA_1766100853
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC03F195DE48;
	Thu, 18 Dec 2025 23:34:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6186819560B4;
	Thu, 18 Dec 2025 23:34:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BINYBEE2122969
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 18:34:11 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BINYAZ52122968;
	Thu, 18 Dec 2025 18:34:10 -0500
Date: Thu, 18 Dec 2025 18:34:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/21] multipathd: free paths in checker_finished()
Message-ID: <aUSPcsNAzvD5rj4M@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
 <20251217212113.234959-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217212113.234959-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g3yipHqqiuLLQWbZYf2vxC1ge64bDw_xQyBS9HRxriU_1766100853
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2025 at 10:20:55PM +0100, Martin Wilck wrote:
> Modifying the pathvec in a deep call stack is unexpected and
> error-prone. Free paths in the checkerloop instead, after
> having synced all maps.

I'm not fond of the fact that this leaves paths around, when callers
expect that the path will be removed. For instance, right now
cli_add_path() and uev_add_path() can call ev_remove_path to handle
INIT_REMOVED paths, and expect that success means the path is removed.
They can end up storing duplicate paths with this code.

What do you think about having calls to ev_remove_path() actually remove
the path if multipath device successfully orphans it. All the callers
of that function already expect that it likely will remove the path, and
that means that whenever multipathd is explicitly told to remove a path,
it will, if it can. If it can't, then the path was always going to get
removed later, and delaying that later incidental remove till the next
path check shouldn't make much difference.

-Ben
 
> Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/libmultipath.version | 1 +
>  libmultipath/structs_vec.c        | 7 +++----
>  libmultipath/structs_vec.h        | 1 +
>  multipathd/main.c                 | 1 +
>  4 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 89ae2a3..e5b7b83 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -58,6 +58,7 @@ global:
>  	change_foreign;
>  	check_alias_settings;
>  	check_daemon;
> +	check_removed_paths;
>  	checker_clear_message;
>  	checker_disable;
>  	checker_enable;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index f651b29..3a9ab58 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -573,16 +573,16 @@ static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
>  	return NULL;
>  }
>  
> -static void check_removed_paths(const struct multipath *mpp, vector pathvec)
> +void check_removed_paths(vector pathvec)
>  {
>  	struct path *pp;
>  	int i;
>  
>  	vector_foreach_slot(pathvec, pp, i) {
> -		if (pp->mpp == mpp &&
> +		if (pp->mpp &&
>  		    (pp->initialized == INIT_REMOVED ||
>  		     pp->initialized == INIT_PARTIAL) &&
> -		    !find_devt_in_pathgroups(mpp, pp->dev_t)) {
> +		    !find_devt_in_pathgroups(pp->mpp, pp->dev_t)) {
>  			condlog(2, "%s: %s: freeing path in %s state",
>  				__func__, pp->dev,
>  				pp->initialized == INIT_REMOVED ?
> @@ -615,7 +615,6 @@ void sync_paths(struct multipath *mpp, vector pathvec)
>  			orphan_path(pp, "path removed externally");
>  		}
>  	}
> -	check_removed_paths(mpp, pathvec);
>  	update_mpp_paths(mpp, pathvec);
>  	vector_foreach_slot (mpp->paths, pp, i)
>  		pp->mpp = mpp;
> diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
> index 1188ada..cb02d75 100644
> --- a/libmultipath/structs_vec.h
> +++ b/libmultipath/structs_vec.h
> @@ -18,6 +18,7 @@ int adopt_paths (vector pathvec, struct multipath *mpp,
>  void orphan_path (struct path * pp, const char *reason);
>  void set_path_removed(struct path *pp);
>  
> +void check_removed_paths(vector pathvec);
>  int verify_paths(struct multipath *mpp);
>  int update_mpp_paths(struct multipath * mpp, vector pathvec);
>  int update_multipath_strings (struct multipath *mpp, vector pathvec);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d3bf4d0..49a1f25 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3127,6 +3127,7 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
>  	}
>  	if (uev_timed_out && !need_to_delay_reconfig(vecs))
>  		unblock_reconfigure();
> +	check_removed_paths(vecs->pathvec);
>  	partial_retrigger_tick(vecs->pathvec);
>  }
>  
> -- 
> 2.52.0

