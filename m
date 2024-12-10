Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AECE1F1936
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 23:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733872425; cv=none; b=VlGxh4wLOPzvLLO77djmMkNQ8Nr5ohnOYE4Z8c179+byfxMhoQ/3Qo2/3Y3EktN9SsQNiwMy5a/uWF6DTmsDvM6Pcx+QQg3GluvRAGv4+kCUDOp3A4i6lnUvHtrong8Yrbfl04Ehm5ByagefZeyXn764Gpa8BYtmKNvWJ8RzyhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733872425; c=relaxed/simple;
	bh=6nNhSXelVayMknbq+Qtpo5KU0HVeGtD3bigJfYrE25I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=g/qNHg4zJn+XalbRK38PU8JKeTPctI6O2opZqT81ITm3XXQCMwtOE+5+wLWu90exmAJkBLqbkgefmmv8jJTg6+Pc+SeXH9Ih0ftjNBky8rV8vQ5nP6BRULdZKN+5EgdUQPeIVvgTS/gLWAnsq9TcvvWZQNaR30+jwQRmoYIdeiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MBJH1fxS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MBJH1fxS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733872422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KzRduysSdjU2XSJ4cj0giwzXKffrIfFkvpUlBpR1Cr4=;
	b=MBJH1fxSR/4Wk148wNVwJE1cDnHVw1m9X0QXXTNxWoMna9u8UXBrkyHX48mn/y0iIlHYvq
	tyu2tckeBqAXVqEn9VzrcqAG+C1R+x7DNcrZgM+hTEH9r8JdNf4EdpQKZwbYWpMFVkO1Fo
	Opt8M62jkNViAXRP3VHRsVYvmoD/m4Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-0Szr1aYPPE2bVRJ2ZNfTYQ-1; Tue,
 10 Dec 2024 18:13:36 -0500
X-MC-Unique: 0Szr1aYPPE2bVRJ2ZNfTYQ-1
X-Mimecast-MFC-AGG-ID: 0Szr1aYPPE2bVRJ2ZNfTYQ
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9EF2719560A1;
	Tue, 10 Dec 2024 23:13:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39AA41956048;
	Tue, 10 Dec 2024 23:13:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BANDXLA1425207
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 18:13:33 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BANDXHt1425206;
	Tue, 10 Dec 2024 18:13:33 -0500
Date: Tue, 10 Dec 2024 18:13:33 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 11/13] multipathd: don't call update_map() from
 missing_uev_wait_tick()
Message-ID: <Z1jLHaJVtbnQRwqk@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-12-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241206233617.382200-12-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LHS65R4b65jw4jkVpYooGJUSWdqZimSIcf8KRSv-jZI_1733872415
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 07, 2024 at 12:36:15AM +0100, Martin Wilck wrote:
> Instead, check for missing uevents in the existing mpvec loop.
> Note that if the uevent tick expires, we need to call update_map() rather than
> reload_and_sync_map(), because the paths have not been added to the multipath
> (see wait_for_udev handling ev_add_path()).
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 40 +++++++++++++++++++---------------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4cf5493..4478cc9 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2011,29 +2011,19 @@ followover_should_failback(struct multipath *mpp)
>  	return 0;
>  }
>  
> -static void
> -missing_uev_wait_tick(struct vectors *vecs)
> +/* Returns true if update_map() needs to be called */
> +static bool
> +missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
>  {
> -	struct multipath * mpp;
> -	int i;
> -	int timed_out = 0;
> +	if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
> +		int wait = mpp->wait_for_udev;
>  
> -	vector_foreach_slot (vecs->mpvec, mpp, i) {
> -		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
> -			timed_out = 1;
> -			condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
> -			if (mpp->wait_for_udev > 1 &&
> -			    update_map(mpp, vecs, 0)) {
> -				/* update_map removed map */
> -				i--;
> -				continue;
> -			}
> -			mpp->wait_for_udev = 0;
> -		}
> +		mpp->wait_for_udev = 0;
> +		*timed_out = true;
> +		condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
> +		return wait > 1;
>  	}
> -
> -	if (timed_out && !need_to_delay_reconfig(vecs))
> -		unblock_reconfigure();
> +	return false;
>  }
>  
>  static void
> @@ -2947,9 +2937,16 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
>  static void checker_finished(struct vectors *vecs)
>  {
>  	struct multipath *mpp;
> +	bool uev_timed_out = false;
>  	int i;
>  
>  	vector_foreach_slot(vecs->mpvec, mpp, i) {
> +		if (missing_uev_wait_tick(mpp, &uev_timed_out) &&
> +		    update_map(mpp, vecs, 0)) {
> +			/* multipath device deleted */
> +			i--;
> +			continue;
> +		}

Looking at this made me think we should probably be adding a check
in reload_and_sync_map() for mpp->wait_for_udev. If it's no-zero,
we should set it to 2 (and we might want to make it symoblic too)
and skip the reload. Otherwise we'll be reloading when we shouldn't be.

>  		if ((update_mpp_prio(mpp) ||
>  		     (mpp->need_reload && mpp->synced_count > 0) ||
>  		     deferred_failback_tick(mpp)) &&
> @@ -2959,7 +2956,8 @@ static void checker_finished(struct vectors *vecs)
>  		else
>  			retry_count_tick(mpp);
>  	}
> -	missing_uev_wait_tick(vecs);
> +	if (uev_timed_out && !need_to_delay_reconfig(vecs))
> +		unblock_reconfigure();
>  	ghost_delay_tick(vecs);
>  	partial_retrigger_tick(vecs->pathvec);
>  }
> -- 
> 2.47.0

