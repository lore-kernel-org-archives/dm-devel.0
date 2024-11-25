Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C2E14F9CF
	for <dm-devel@lists.linux.dev>; Mon, 25 Nov 2024 20:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732566685; cv=none; b=KKtX6gWi0rVNKFKMbecLkMTWIZhUCYZIb7pVa6G9/RYtcDAD6mpxUbNcz//jAsjGWK7yylDjkOEvaGlR59/ao9yY9H2xZYz95bNCm5boar07rNuWvc/yTOuVVsxDKv8sbBf54IB7DCJgFSsopC/dBOJljm2Y4MCN5n8noEpMuB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732566685; c=relaxed/simple;
	bh=O/U6UAOtRE8NnKWzDbDUoEvQjy4IQ2Ws97GpcHOEfg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LrQIfQc2VBNGEMbQw2jNA/T2t4K/A9GpHgfgLjU6p5UaFIQkW0AO7uLwHIQIYS5st3hyd6NUQFh+aWvER4hgkhF9CeyXkwiuUKLuNrGcunrPxiKeWxHX+JW7mjOXcyiwwVF8Oysy4bcRvZl9WYphHxgeuhodtG598oVLCngYl1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DW3Fzlut; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DW3Fzlut"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732566682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TSTEBqQjAYW6IvZBopxll58LsKHpzlb9Xpl5UR/2tho=;
	b=DW3FzlutXaKCsu5SPQt+cnicRD3qjyDrr/IERgmP9oqDg2j76itA0YELeW4Mg6UarkpPpv
	1uLNpp5ZZ5nc81v3K4NMqp673fwsUqlWCpRRGfHXQEQ4xib722d43fw4oqCBDYsYjtAQA6
	EZv9fOfJsMlU0Zvp4MU5gn4JDykCPVo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-g0C_KW43NNyV3BaQKkhVPA-1; Mon,
 25 Nov 2024 15:31:17 -0500
X-MC-Unique: g0C_KW43NNyV3BaQKkhVPA-1
X-Mimecast-MFC-AGG-ID: g0C_KW43NNyV3BaQKkhVPA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EC281956046;
	Mon, 25 Nov 2024 20:31:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E4FB30000DF;
	Mon, 25 Nov 2024 20:31:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4APKVEgl761879
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 15:31:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4APKVE84761878;
	Mon, 25 Nov 2024 15:31:14 -0500
Date: Mon, 25 Nov 2024 15:31:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/3] libmultipath: fix handling of pp->pgindex
Message-ID: <Z0TeksRGcJ9k4cqx@redhat.com>
References: <20241125143224.51934-1-mwilck@suse.com>
 <20241125143224.51934-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241125143224.51934-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: a9gIyoKWtXmO1KpZu88_QyUKuHaQkM__zcYVqBeIu6k_1732566676
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 25, 2024 at 03:32:22PM +0100, Martin Wilck wrote:
> pp->pgindex is set in disassemble_map() when a map is parsed.
> There are various possiblities for this index to become invalid.
> pp->pgindex is only used in enable_group() and followover_should_fallback(),
> and both callers take no action if it is 0, which is the right
> thing to do if we don't know the path's pathgroup.
> 
> Make sure pp->pgindex is reset to 0 in various places:
> - when it's orphaned,
> - before (re)grouping paths,
> - when we detect a bad mpp assignment in update_pathvec_from_dm().
> 
> The hunk in group_paths is mostly redundant with the hunk in free_pgvec(), but
> because we're looping over pg->paths in the former and over pg->pgp in
> the latter, I think it's better too play safe.

I'm not sure this will always fix issue #105. Perhaps I'm overlooking
the connection in the code and this just needs a more explicit
explanation to aid clueless reviewers, but here's what I don't get.

As far as I can see, the only change here that would effect the reported
issue is the change to update_pathvec_from_dm(). While I totally agree
that if you have a path that appears to be two multipath devices, you
can't trust pp->pgindex, I believe there's also another problem.

Say you have a multipath device with two path groups (pgp1 and pgp2)
each with one path (pp1 in pgp1 and pp2 in pgp2). In this case,
pp1->pgindex == 1 and pp2->pgindex == 2. If update_pathvec_from_dm()
discovers that pp1 is part of another multipath device, and removes it,
that will mean that pgp1 is now empty, so update_pathvec_from_dm() will
also remove that (at the delete_pg label).  But pp2->pgindex will still
be set to 2 even though there's only one path group, so it will now
point off the end of the pgp list. Right?

At any rate, updating pgindex seems finicky and perhaps we should just
drop it. It's not that much work to scan the path groups for the path in
enable_group() and since we're already reading through the path groups
in followover_should_failback(), we can just refactor the code a little
bit to avoid needing pgindex at all.

-Ben
 
> Fixes: 99db1bd ("[multipathd] re-enable disabled PG when at least one path is up")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/pgpolicies.c  |  6 ++++++
>  libmultipath/structs.c     | 12 +++++++++++-
>  libmultipath/structs_vec.c |  8 ++++++++
>  3 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index edc3c61..23ef2bd 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -127,6 +127,8 @@ fail:
>  int group_paths(struct multipath *mp, int marginal_pathgroups)
>  {
>  	vector normal, marginal;
> +	struct path *pp;
> +	int i;
>  
>  	if (!mp->pg)
>  		mp->pg = vector_alloc();
> @@ -138,6 +140,10 @@ int group_paths(struct multipath *mp, int marginal_pathgroups)
>  	if (!mp->pgpolicyfn)
>  		goto fail;
>  
> +	/* Reset pgindex, we're going to invalidate it */
> +	vector_foreach_slot(mp->paths, pp, i)
> +		pp->pgindex = 0;
> +
>  	if (!marginal_pathgroups ||
>  	    split_marginal_paths(mp->paths, &normal, &marginal) != 0) {
>  		if (mp->pgpolicyfn(mp, mp->paths) != 0)
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 61c8f32..4851725 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -239,8 +239,18 @@ free_pgvec (vector pgvec, enum free_path_mode free_paths)
>  	if (!pgvec)
>  		return;
>  
> -	vector_foreach_slot(pgvec, pgp, i)
> +	vector_foreach_slot(pgvec, pgp, i) {
> +
> +		/* paths are going to be re-grouped, reset pgindex */
> +		if (free_paths != FREE_PATHS) {
> +			struct path *pp;
> +			int j;
> +
> +			vector_foreach_slot(pgp->paths, pp, j)
> +				pp->pgindex = 0;
> +		}
>  		free_pathgroup(pgp, free_paths);
> +	}
>  
>  	vector_free(pgvec);
>  }
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index d22056c..64c5ad5 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -139,6 +139,13 @@ static bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  				must_reload = true;
>  				dm_fail_path(mpp->alias, pp->dev_t);
>  				vector_del_slot(pgp->paths, j--);
> +				/*
> +				 * pp->pgindex has been set in disassemble_map(),
> +				 * which has probably been called just before for
> +				 * mpp. So he pgindex relates to mpp and may be
> +				 * wrong for pp->mpp. Invalidate it.
> +				 */
> +				pp->pgindex = 0;
>  				continue;
>  			}
>  			pp->mpp = mpp;
> @@ -354,6 +361,7 @@ void orphan_path(struct path *pp, const char *reason)
>  {
>  	condlog(3, "%s: orphan path, %s", pp->dev, reason);
>  	pp->mpp = NULL;
> +	pp->pgindex = 0;
>  	uninitialize_path(pp);
>  }
>  
> -- 
> 2.47.0

