Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFD963CB
	for <dm-devel@lists.linux.dev>; Sat, 20 Dec 2025 04:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766205337; cv=none; b=tuZjvD+HHwmZvOqdVuEnDfZGCPadkDoWb2NW9u5WpJuzDCdEknEImAFny27hiSp5n/C4wiQDLInVD5T1sf5+jGQk3dOuf6SkjeAOwEhpL1eeb3nZU7qkX0yp3gVap6t6qJR0V9CR6ydxj1S5juA/3pYKZWq4S6hVOjXm1uzt+U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766205337; c=relaxed/simple;
	bh=rkd4t8k03Y4kvxWQ7KvsNWabGxAwqPQC4ODWm4H+eLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TJdGB/fWgkJHyXhjn6OlBJnvcorPmctb8eoNyi3Rwk61+q/qlu7pYJWIHwkVo6osCKNDEIUqVoOOXrjyXQRI/iXb4pwrN6JRlQ7M+7Dh+/AxuVgvV4ewE195v2yAKznOJHFjuZJeR3pP6gqSEFjcZtFHKkohAPh6OFygYQc/zTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ci9vYP58; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ci9vYP58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766205331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qAErDmwT7wqS/a125C6AoPv4TAC8wnd0J4szVq8oq7U=;
	b=ci9vYP58TopHBriExM8GR1tMcAdpnaCMUnlfPTclmWVH1xnhIMABrqHuWyTLzpIqYspu8x
	UH3K1DQH/P1QgS/esgrsF/whWyMfen84hZfn3urINzifCM6CWkWy5TfziejQaWtKLWu1RM
	JHLqcYii6j8SSjzaIE+hzsLaSWpeErc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-674-f26YsyqqMZmYxGrpkafvjg-1; Fri,
 19 Dec 2025 23:35:30 -0500
X-MC-Unique: f26YsyqqMZmYxGrpkafvjg-1
X-Mimecast-MFC-AGG-ID: f26YsyqqMZmYxGrpkafvjg_1766205329
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42AED18001D7;
	Sat, 20 Dec 2025 04:35:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9B5930001A2;
	Sat, 20 Dec 2025 04:35:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BK4ZRxS2174002
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Dec 2025 23:35:27 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BK4ZR1w2174001;
	Fri, 19 Dec 2025 23:35:27 -0500
Date: Fri, 19 Dec 2025 23:35:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 17/26] libmultipaths: annotate functions that may free
 paths
Message-ID: <aUYnj4K8W2gQE-Ww@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
 <20251219144108.237928-18-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251219144108.237928-18-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9EVdZ7o50c-SNv9hUp8k4ffrEvUB53h2q4KoDU5nhE0_1766205329
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 19, 2025 at 03:40:59PM +0100, Martin Wilck wrote:
> Paths are freed in check_removed_paths() quite deeply in the call
> stack. Annotate this function and some of its callers, lest we forget
> about it.

This looks fine. I just feel like I should point out that if you're
doing this to satisfy my objection, I don't think that it's necessary to
immediately remove these paths on every map reload. I was fine with
check_remove_paths() being removed from sync_paths(). All I was
envisioning was a check in ev_remove_path() to see if the path had been
removed from mpp->pg, and removing it there if it had. It actually seems
a little strange that we immeditately remove paths on reloads, but not
when the whole map is deleted. But I get that it's designed to avoid
freeing the paths in coalesce_paths(), and like I said, I'm fine with
it, so:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 33 +++++++++++++++++++++++++++++++--
>  multipathd/main.c          | 10 ++++++----
>  2 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 62ee450..9905ff2 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -563,6 +563,34 @@ static struct path *find_devt_in_pathgroups(const struct multipath *mpp,
>  	return NULL;
>  }
>  
> +/*
> + * check_removed_paths()
> + *
> + * This function removes paths from the pathvec and frees them if they have
> + * been marked for removal (INIT_REMOVED, INIT_PARTIAL).
> + * This is important because some callers (e.g. uev_add_path->ev_remove_path())
> + * rely on the paths being actually gone when the call stack returns.
> + * Be sure not to call it while these paths are still referenced elsewhere
> + * (e.g. from coalesce_paths(), where curmp may still reference them).
> + *
> + * Most important call stacks in multipath-tools 0.13.0:
> + *
> + * checker_finished()
> + *   sync_mpp()
> + *     do_sync_mpp()
> + *       update_multipath_strings()
> + *         sync_paths()
> + *           check_removed_paths()
> + *
> + * [multiple callers including update_map(), ev_remove_path(), ...]
> + *   setup_multipath()
> + *     refresh_multipath()
> + *       update_multipath_strings()
> + *         sync_paths()
> + *           check_removed_paths()
> + *
> + * refresh_multipath() is also called from a couple of CLI handlers.
> + */
>  static void check_removed_paths(const struct multipath *mpp, vector pathvec)
>  {
>  	struct path *pp;
> @@ -583,6 +611,7 @@ static void check_removed_paths(const struct multipath *mpp, vector pathvec)
>  	}
>  }
>  
> +/* This function may free paths. See check_removed_paths(). */
>  void sync_paths(struct multipath *mpp, vector pathvec)
>  {
>  	struct path *pp;
> @@ -611,8 +640,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
>  		pp->mpp = mpp;
>  }
>  
> -int
> -update_multipath_strings(struct multipath *mpp, vector pathvec)
> +/* This function may free paths. See check_removed_paths(). */
> +int update_multipath_strings(struct multipath *mpp, vector pathvec)
>  {
>  	struct pathgroup *pgp;
>  	int i, r = DMP_ERR;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7b522e8..697e269 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -503,6 +503,7 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
>  	remove_maps(vecs);
>  }
>  
> +/* This function may free paths. See check_removed_paths(). */
>  int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
>  {
>  	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
> @@ -513,6 +514,7 @@ int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
>  	return 0;
>  }
>  
> +/* This function may free paths. See check_removed_paths(). */
>  int setup_multipath(struct vectors *vecs, struct multipath *mpp)
>  {
>  	if (refresh_multipath(vecs, mpp) != 0)
> @@ -2519,8 +2521,8 @@ get_new_state(struct path *pp)
>  	return newstate;
>  }
>  
> -static int
> -do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
> +/* This function may free paths. See check_removed_paths(). */
> +static int do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
>  {
>  	int i, ret;
>  	struct path *pp;
> @@ -2538,8 +2540,8 @@ do_sync_mpp(struct vectors * vecs, struct multipath *mpp)
>  	return ret;
>  }
>  
> -static int
> -sync_mpp(struct vectors * vecs, struct multipath *mpp, unsigned int ticks)
> +/* This function may free paths. See check_removed_paths(). */
> +static int sync_mpp(struct vectors *vecs, struct multipath *mpp, unsigned int ticks)
>  {
>  	if (mpp->sync_tick)
>  		mpp->sync_tick -= (mpp->sync_tick > ticks) ? ticks :
> -- 
> 2.52.0

