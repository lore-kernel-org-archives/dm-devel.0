Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B05E20FABC
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737569779; cv=none; b=P0xtxDp87/hyBMH7P2/ZdsDkNrmRynDg7MIi6wZGWo5wUU+/UEAdlYxtjd4p0G1VIOrAL7OenuRHs5Y+rkQnz6PVTkwbmhEwUps5Qx+WlWHPDIlvhjmObt2tu48gH7Am06/XgLZeLOjt/1eA1FBScyZ8B6z9V3Ike+sA8h+eIHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737569779; c=relaxed/simple;
	bh=IdYpdqhGI5WmrnWEc7YSGzMzGA6g6DsvoIN4uy38UFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=hovZAmzWG5N150Q8ys0KFDP4dD0Tb9H1bBJ3QHsz1Q0wNlXLcY+2H/CU8vQLt74K89PMPKRuXC2EWIOWdaJzDNEg/BRCEObk/Afkuab1mFgRba2/rCOrVyQqj8xNKdsEE2Ke46XlHfCuw+Rm1JgotjdtAQOCcZefE8aVJT7uIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hk6MDsRU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hk6MDsRU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737569776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fZyU933ZKPAmWha/kP7d+gtTQuedLiTkXXP5v5rup8I=;
	b=Hk6MDsRULd0bSOd7+DFKSOcCvPk06HXtYk71A9yttlmyzp/8d9/5XySQIAi7p9RRHS1XW4
	avAXEQszT2JT//pkaV9yHhya9jozF1/scrH7Z71UoAbPELjmOBk5kpRl0r/8zXSpdGf4OV
	u07pOaiAlpDGqD9YLc+uScjarrtoDr4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-_pSHQAlMNMWZ2Fu_x6GDyA-1; Wed,
 22 Jan 2025 13:16:15 -0500
X-MC-Unique: _pSHQAlMNMWZ2Fu_x6GDyA-1
X-Mimecast-MFC-AGG-ID: _pSHQAlMNMWZ2Fu_x6GDyA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB7551956050;
	Wed, 22 Jan 2025 18:16:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B835195608E;
	Wed, 22 Jan 2025 18:16:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50MIGCuq3003967
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 13:16:12 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50MIGCqQ3003966;
	Wed, 22 Jan 2025 13:16:12 -0500
Date: Wed, 22 Jan 2025 13:16:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 08/15] multipathd: don't call reload_and_sync_map()
 from deferred_failback_tick()
Message-ID: <Z5E17NgSUJUv42FM@redhat.com>
References: <20250117202738.126196-1-mwilck@suse.com>
 <20250117202738.126196-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250117202738.126196-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 56SdCppwfawzmj_Hw7ap6xpOL9gw5zA1TOXAY9MeBAA_1737569774
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2025 at 09:27:31PM +0100, Martin Wilck wrote:
> Instead, move the call inside the existing loop over vecs->mpvec and call
> reload_and_sync_map() from checker_finished(). Note that we can't simply
> put the call deferred_failback_tick() in the "if" condition, because we
> need to adjust the ticks even if update_mpp_prio() returns true. For
> consistency, use separate bool variables for each condition that would
> necessitate a reload.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 39 +++++++++++++++------------------------
>  1 file changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 6df8769..8c2712d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2076,32 +2076,22 @@ ghost_delay_tick(struct vectors *vecs)
>  	}
>  }
>  
> -static void
> -deferred_failback_tick (struct vectors *vecs)
> +static bool deferred_failback_tick(struct multipath *mpp)
>  {
> -	struct multipath * mpp;
> -	int i;
>  	bool need_reload;
>  
> -	vector_foreach_slot (vecs->mpvec, mpp, i) {
> -		/*
> -		 * deferred failback getting sooner
> -		 */
> -		if (mpp->pgfailback > 0 && mpp->failback_tick > 0) {
> -			mpp->failback_tick--;
> +	if (mpp->pgfailback <= 0 || mpp->failback_tick <= 0)
> +		return false;
>  
> -			if (!mpp->failback_tick &&
> -			    need_switch_pathgroup(mpp, &need_reload)) {
> -				if (need_reload) {
> -					if (reload_and_sync_map(mpp, vecs) == 2) {
> -						/* multipath device removed */
> -						i--;
> -					}
> -				} else
> -					switch_pathgroup(mpp);
> -			}
> -		}
> +	mpp->failback_tick--;
> +	if (!mpp->failback_tick &&
> +	    need_switch_pathgroup(mpp, &need_reload)) {
> +		if (need_reload)
> +			return true;
> +		else
> +			switch_pathgroup(mpp);
>  	}
> +	return false;
>  }
>  
>  static void
> @@ -2973,11 +2963,13 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
>  	int i;
>  
>  	vector_foreach_slot(vecs->mpvec, mpp, i) {
> -		bool inconsistent;
> +		bool inconsistent, prio_reload, failback_reload;
>  
>  		sync_mpp(vecs, mpp, ticks);
>  		inconsistent = mpp->need_reload;
> -		if (update_mpp_prio(mpp) || inconsistent)
> +		prio_reload = update_mpp_prio(mpp);
> +		failback_reload = deferred_failback_tick(mpp);
> +		if (prio_reload || failback_reload || inconsistent)
>  			if (reload_and_sync_map(mpp, vecs) == 2) {
>  				/* multipath device deleted */
>  				i--;
> @@ -2988,7 +2980,6 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
>  			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
>  				mpp->alias);
>  	}
> -	deferred_failback_tick(vecs);
>  	retry_count_tick(vecs->mpvec);
>  	missing_uev_wait_tick(vecs);
>  	ghost_delay_tick(vecs);
> -- 
> 2.47.1

