Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB831EEA5F
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 23:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737417109; cv=none; b=fks7InpkdhStAxhj9MhSkOgQ49tlXzRlS99audO0I+On9qE4HXpJ0DsKCGfzT3Q1WC5J+9gj1tUOh6qhXKDZ9HCp2oERGUy4drOi++hxngXXXF/CLRJw2OJ+HX7FNO4ch3XslAh6GZbpCvjehv5tzl7pEVD6n36moLAj5Fayhv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737417109; c=relaxed/simple;
	bh=FLdCnZxFXRjLk9gSNrZM38dYA2vL5ixff8BHuLCgEuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=IfXbwIuCdFvFipB6ArzC84O/LLPOWpjfgGlj98yQZL6KpW0PTzKjqA99gpLH87S2iY44BkOri9bcFwpiTFMfHPhU8smzubflouZE0Vt+uehEAm0+Msev4qxZHwhQq4HB2viCKlZlCApJkLjqhG9eaC4hmLZ9gMdrLk5N4ZuTGL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TUn4W9u/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TUn4W9u/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737417105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0YVo8GwBYRhuX3Gw1cj41scCRuZdImZnp6LnBkVxRSY=;
	b=TUn4W9u/ECr4wdv1WVzunAvaeo59t6FNIE4F96L4MAq+OrFqfk9DsH7RdjC1TQAekVcr4c
	R95mea3AoGkjc07S2xidc0YnbZkc8UZ9Q7cN/y/c/LXS+4gap4zK0U3wbOFPiu+d7CCPa0
	b7FOn0ZB31FAgEfFYd9F5XmVp9mbaaw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-llS2-ltxMpyJK3HrZv13xQ-1; Mon,
 20 Jan 2025 18:51:42 -0500
X-MC-Unique: llS2-ltxMpyJK3HrZv13xQ-1
X-Mimecast-MFC-AGG-ID: llS2-ltxMpyJK3HrZv13xQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C09E19560B4;
	Mon, 20 Jan 2025 23:51:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED4223003E7F;
	Mon, 20 Jan 2025 23:51:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50KNpdu82933768
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 18:51:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50KNpdFY2933767;
	Mon, 20 Jan 2025 18:51:39 -0500
Date: Mon, 20 Jan 2025 18:51:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 15/15] multipathd: enable pathgroups in
 checker_finished()
Message-ID: <Z47hizoQciL5Yp-E@redhat.com>
References: <20250117202738.126196-1-mwilck@suse.com>
 <20250117202738.126196-16-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250117202738.126196-16-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hUTBh9u2-IEHTCAVlMFCHiyZb3ctxcy5jootS4Cy8hk_1737417101
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2025 at 09:27:38PM +0100, Martin Wilck wrote:
> multipathd calls enable_group() from update_path_state() if a path in a
> previously disabled pathgroup is reinstated. This call may be mistakenly
> skipped if the path group status wasn't up-to-date while update_path_state()
> was executed. This can happen after applying the previous patch "multipathd:
> sync maps at end of checkerloop", if the kernel has disabled the group during
> the last checker interval.
> 
> Therefore add another check in checker_finished() after calling sync_mpp(),
> and enable groups if necessary. This step can be skipped if the map was
> reloaded, because after a reload, all pathgroups are enabled by default.

The logic running in checker_finished() isn't the same as the logic
running in update_path_state(). It update_path_state(), we only enable a
pathgroup when a path switches to PATH_UP. In checker_finished(), we
enable it whenever a path is in PATH_UP. I worry that this might not
always be correct. Perhaps instead of just checking if the path is in
PATH_UP, we should also make sure that pp->is_checked isn't in
CHECK_PATH_SKIPPED, which would mean that the checker is pending or
messed up, and the path is using its old state. This still assumes that
the path switched to some other state before the pathgroup got delayed
in re-initializing again, but that seems pretty safe. I just don't want
to go re-enabling pathgroups where the controller is actually busy,
since I'm pretty sure that the kernel usually does the right thing
without multipathd's help.

Alternatively, we could make the check_finished() logic match the
update_path_state() logic exactly by just setting a flag in the path's
pathgroup during enable_group() (and possibly not call dm_enablegroup()
at all, but I suppose that there could be a benefit to re-enabling the
group as soon as possible. I'm still kinda fuzzy on whether the kernel's
own pathgroup re-enabling code makes all this redundant). Then, in
enable_pathrgoups(), instead of checking each path, we just need to
check if pgp->need_reenable is set for the pathgroup().

The other benefit to using a flag like pgp->need_reenable is that we
could clear it on all pathgroups if we called switch_pathgroups(), since
that will cause the kernel to enable all the pathgroups anyways, which
makes our pgp->status invalid. Although we probably should also update
pgp->status to be PGSTATE_ENABLED (or at least PGSTATE_UNDEF) if we
were messing with the pathgroups in switch_pathgroups(). And if we
update pgp->status, that would avoid unnecessary re-enables with my
first idea as well (since no pathgroups would be disabled anymore). 

But perhaps the best answer is to just to say that this is a corner case
where we skip a multipathd action that might be totally unnecessary. And
even if it is a problem, it will be fixed if multipathd ever decides
that the kernel is using the wrong pathgroup and should switch, or
whenever the table gets reloaded. Maybe the whole patch is unnecessary.

Thoughts? I'm clearly thinking too much.
-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 34 +++++++++++++++++++++++++++++++++-
>  1 file changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 310d7ef..98abadc 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2917,6 +2917,34 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
>  	return CHECKER_FINISHED;
>  }
>  
> +static void enable_pathgroups(struct multipath *mpp)
> +{
> +	struct pathgroup *pgp;
> +	int i;
> +
> +	vector_foreach_slot(mpp->pg, pgp, i) {
> +		struct path *pp;
> +		int j;
> +
> +		if (pgp->status != PGSTATE_DISABLED)
> +			continue;
> +
> +		vector_foreach_slot(pgp->paths, pp, j) {
> +			if (pp->state != PATH_UP)
> +				continue;
> +
> +			if (dm_enablegroup(mpp->alias, i + 1) == 0) {
> +				condlog(2, "%s: enabled pathgroup #%i",
> +					mpp->alias, i + 1);
> +				pgp->status = PGSTATE_ENABLED;
> +			} else
> +				condlog(2, "%s: failed to enable pathgroup #%i",
> +					mpp->alias, i + 1);
> +			break;
> +		}
> +	}
> +}
> +
>  static void checker_finished(struct vectors *vecs, unsigned int ticks)
>  {
>  	struct multipath *mpp;
> @@ -2943,12 +2971,16 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
>  				i--;
>  				continue;
>  			}
> -		} else if (prio_reload || failback_reload || ghost_reload || inconsistent)
> +		} else if (prio_reload || failback_reload || ghost_reload || inconsistent) {
>  			if (reload_and_sync_map(mpp, vecs) == 2) {
>  				/* multipath device deleted */
>  				i--;
>  				continue;
>  			}
> +		} else
> +			/* not necessary after map reloads */
> +			enable_pathgroups(mpp);
> +
>  		/* need_reload was cleared in dm_addmap and then set again */
>  		if (inconsistent && mpp->need_reload)
>  			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
> -- 
> 2.47.1

