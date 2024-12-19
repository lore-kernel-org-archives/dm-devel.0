Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506CB5FDA7
	for <dm-devel@lists.linux.dev>; Thu, 19 Dec 2024 22:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734645871; cv=none; b=Zuyu7sFa5ZnNTdG5yU1TloEpFXlX9me5/vLKQnILepN5YNjPwW1FfRV27IefqUY2khT1XlfQ7nl7D42eqfBrW77y6TTydlT8dcWhJfJ8HuFzn6WRsGhHngwtblKQUFXJCCY4wlYgHPhNawq+1Le/NlmzVoyWcxYjNIinszRlWpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734645871; c=relaxed/simple;
	bh=FhLMU7vO1QtdVOHR+/1rBFFymbhjia0q0mfR0he7ihE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=WXSmOm71Ast2PLQrQr2ZmCzaD9PWlekv+T/ejhYr6reeEX7zFHuJaMOKsejXl8d83+jcAq3luAoHt5YbjJd62eKGdoJjEBGb/dbAxfyILXKtOuIQuVVc3aK4doGOe9q5ONE7vI6krAN+sb2L1QGlBxH6mMpfEItCj41O7cJTgLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5kkb0z7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5kkb0z7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734645868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OGiUHas9sF9ttxkBvxThekdRJF05UEYsPmlKCVlHEJ4=;
	b=J5kkb0z7uE1sKctOfCs+For74dgmJcBwxcHlyV5WZwlvVU7QnuINNJRqeI+Tw69/XIWX7m
	cYgL+rS0gRoloXNzlkHHVx9WsC5G6+7qPAzCkX2L3fFMBj/UTm0wdpiF3wPk9lbDUlb2Ib
	dU+SsgyXEfOxaj5mHjndrtt2bQoOF8Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-tkcV3mJTPVuPtGMoaeDIgg-1; Thu,
 19 Dec 2024 17:04:25 -0500
X-MC-Unique: tkcV3mJTPVuPtGMoaeDIgg-1
X-Mimecast-MFC-AGG-ID: tkcV3mJTPVuPtGMoaeDIgg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D60211956046;
	Thu, 19 Dec 2024 22:04:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95F93195608A;
	Thu, 19 Dec 2024 22:04:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BJM4MDV1753448
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 17:04:22 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BJM4M2A1753447;
	Thu, 19 Dec 2024 17:04:22 -0500
Date: Thu, 19 Dec 2024 17:04:22 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 08/14] multipathd: don't call reload_and_sync_map()
 from deferred_failback_tick()
Message-ID: <Z2SYZtAkLuqK-h6x@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
 <20241211225909.298770-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241211225909.298770-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6sYryP64eYXAkoUJ_9ImUge95q1XnT7eXCS3jvEZNOM_1734645864
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2024 at 11:59:03PM +0100, Martin Wilck wrote:
> Instead, move the call inside the existing loop over vecs->mpvec and call
> reload_and_sync_map() from checker_finished(). Note that we can't simply
> put the call deferred_failback_tick() in the "if" condition, because we
> need to adjust the ticks even if update_mpp_prio() returns true. For
> consistency, use separate bool variables for each condition that would
> necessitate a reload.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 39 ++++++++++++++-------------------------
>  1 file changed, 14 insertions(+), 25 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index b045f8b..b1f0f81 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2076,32 +2076,20 @@ ghost_delay_tick(struct vectors *vecs)
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
> -	}
> +	mpp->failback_tick--;
> +	if (!mpp->failback_tick &&
> +	    need_switch_pathgroup(mpp, &need_reload) &&
> +	    need_reload)
> +		return true;
> +	else

If (!mpp->failback_tick && need_switch_pathgroup(mpp, &need_reload) is
true by need_reload isn't, don't we still need to call
switch_pathgroup(mpp);

-Ben

> +		return false;
>  }
>  
>  static void
> @@ -2973,11 +2961,13 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
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
> @@ -2990,7 +2980,6 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
>  		if (inconsistent)
>  			mpp->sync_tick = 1;
>  	}
> -	deferred_failback_tick(vecs);
>  	retry_count_tick(vecs->mpvec);
>  	missing_uev_wait_tick(vecs);
>  	ghost_delay_tick(vecs);
> -- 
> 2.47.0

