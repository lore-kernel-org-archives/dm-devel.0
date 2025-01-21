Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535A01487E1
	for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 21:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737494933; cv=none; b=osrsoUsCOjB1n9zCqq0DRG63VthxSCJLRG8wjcf8Ok+BCVU7y7F5pUcnYIh3e6XOoEpDNc5yBjl8ilRTPAwBz8N/S19tW07gZgvao0dn5lhBYg4DTLYIjGmY3EM02l/kxHS40T9VqpgIhdqpNlWBGv+ZZV1+LerGK+BREU74RNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737494933; c=relaxed/simple;
	bh=70SuWmkNA6rLpQLtGSdQso8Yuc7MYq9qqjhptE9IlAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ebi22VpfN6nZ4R982ShWnPWiEgk1WP3qHeavD8ve5I5IgPQUkskvatbDdml496aij11XbSX+JDc64sGCxlCAqkYkv4bHscYgkIYY3MwK+pW0zujKyk/thABse8hTDln2naF/Ir1hI3+geYNOLYkCsDHuz/TLZ4i9k1nAKszCa2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BqFslsgI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BqFslsgI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737494930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NWbAapT6OiGtcC1kbM0G5LF41ehrMgXFIjLOGXgukIo=;
	b=BqFslsgIuWDNIlDiMOzWYH+NSXYudSH5MxcFmIsrTD8Pr4UWhPxZyFUCjWjyz5tIncgS9R
	eDc7H6MmmLgBXXsC5EtWPw8GKkMskEV+Jg27b0rYuGkpboDzSz3KrHeuGKY91DcnFzw4qV
	GxZzw3A7iu7afgJVjL7QQ8C6HfW55FU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-hyJ85PmhNt-4dIsgkLyxow-1; Tue,
 21 Jan 2025 16:28:46 -0500
X-MC-Unique: hyJ85PmhNt-4dIsgkLyxow-1
X-Mimecast-MFC-AGG-ID: hyJ85PmhNt-4dIsgkLyxow
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 906831956055;
	Tue, 21 Jan 2025 21:28:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4854E19560AB;
	Tue, 21 Jan 2025 21:28:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50LLShGK2971488
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 21 Jan 2025 16:28:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50LLSh0x2971487;
	Tue, 21 Jan 2025 16:28:43 -0500
Date: Tue, 21 Jan 2025 16:28:43 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v4 15/15] multipathd: enable pathgroups in
 checker_finished()
Message-ID: <Z5ARi5FuWkr1It4r@redhat.com>
References: <20250121114538.31963-1-mwilck@suse.com>
 <20250121114538.31963-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250121114538.31963-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lwKloHjCICgaulDFzUadE5Z2hDnziq7b9hLzriEuG88_1737494925
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 21, 2025 at 12:45:38PM +0100, Martin Wilck wrote:
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
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 310d7ef..2052ede 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2917,6 +2917,36 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
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
> +			if (!(pp->state == PATH_UP &&
> +			      (pp->is_checked == CHECK_PATH_CHECKED ||
> +			       pp->is_checked == CHECK_PATH_NEW_UP)))
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
> @@ -2943,12 +2973,16 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
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
> 2.48.0

