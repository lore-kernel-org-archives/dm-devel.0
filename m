Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3D41C232B
	for <dm-devel@lists.linux.dev>; Thu, 19 Dec 2024 21:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734645478; cv=none; b=p7GBKsXsMfIxBgZPLWIM7obvsAUwCR0wGGhUMYWLrWT1EHYINFJ6ixtau6LpvD3jsap9EQKymxC3f5rS175dB+3Hq2DlO2dk93xaqCzV5mYCUe6IRihChY3F7xRYaWbJ39xmW2EsoXQjhbKTO0H3nLWLZGZZRnG07W5qgAW/3Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734645478; c=relaxed/simple;
	bh=/OkTxO3/aM0xLTiMNr7QnRVaSTpMJIWHAQ2BEsEl0SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=pQgvZYydAZRYHc++cJMdM6GYFVRKrUVo0p9xLOApFyoYhUQof/K9qhLqoOjcQgwGZ/4y2WcBSiuoMPSsmZOZqZYoJ52LpDUdz15VA3ydiBPN1NcFpj2mMNPVCGY3I8IqzUIQJr647k9GLSriDHdyL3aGkbMyP/emNjQyuvtjKSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FBlD5D9Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FBlD5D9Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734645475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nAwkK3tpw6z2xxgJBnuCToU9Ffyg9W/aX/1+0FB9S48=;
	b=FBlD5D9Y25HPQGbDswN1qETU/jYZESBPcd0rvvtdcNmqzDrLs2ic/4SJ+odpOMDhcosPu6
	42thlMiNM0QAPfLX1MXj2jA/N3B3OtP+rh5SkdGW06KUYv4NshQ5/X44SUlhjxoSKn8g1i
	5WY+EoQ01iCIhlYpNKOFq0FxN3IUGKs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-539-PZ4nt9nJNjay0j2WxeFxaw-1; Thu,
 19 Dec 2024 16:57:53 -0500
X-MC-Unique: PZ4nt9nJNjay0j2WxeFxaw-1
X-Mimecast-MFC-AGG-ID: PZ4nt9nJNjay0j2WxeFxaw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F04E1956046;
	Thu, 19 Dec 2024 21:57:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D35791956053;
	Thu, 19 Dec 2024 21:57:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BJLvoO71753251
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 16:57:50 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BJLvojF1753250;
	Thu, 19 Dec 2024 16:57:50 -0500
Date: Thu, 19 Dec 2024 16:57:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 04/14] multipathd: quickly re-sync if a map is
 inconsistent
Message-ID: <Z2SW3m9qq9ZBTLa7@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
 <20241211225909.298770-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241211225909.298770-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nQgtZSJsvzwcPlsSe-p72dQMABcahwyGNlvgy2kzQmY_1734645472
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2024 at 11:58:59PM +0100, Martin Wilck wrote:
> After reading the kernel device-mapper table, update_pathvec_from_dm()
> sets the mpp->need_reload flag if an inconsistent state was found (often a
> path with wrong WWID). We expect reload_and_sync_map() to fix this situation.
> However, schedule a quick resync in this case, to be double-check that the
> inconsistency has been fixed.

I'm not too sure about this. My biggest worry with handling
mpp->need_reload in the checkerloop is what happens if for some reason
multipathd and the kernel keep disagreeing on something. You would just
keep reloading the device. That seems unlikely, so I've o.k. with
handling it here, but if that does happen, this would make it much
worse.  Instead of reloading every path check, you would reload every
loop.

If you do detect an inconsistent state, and trigger a reload, and the
state is still inconsistent after that, I would argue that yet another
reload is more likely to remain inconsistent than it is to fix the
problem. So I would rather not speed it up.

If I'm overlooking a case where a second reload would fix a problem,
please let me know.

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e4e6bf7..178618c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3026,13 +3026,22 @@ checkerloop (void *ap)
>  							     start_time.tv_sec);
>  			if (checker_state == CHECKER_FINISHED) {
>  				vector_foreach_slot(vecs->mpvec, mpp, i) {
> +					bool inconsistent;
> +
>  					sync_mpp(vecs, mpp, ticks);
> -					if ((update_mpp_prio(mpp) || mpp->need_reload) &&
> +					inconsistent = mpp->need_reload;
> +					if ((update_mpp_prio(mpp) || inconsistent) &&
>  					    reload_and_sync_map(mpp, vecs) == 2) {
>  						/* multipath device deleted */
>  						i--;
>  						continue;
>  					}
> +					/*
> +					 * If we reloaded due to inconsistent state,
> +					 * schedule another sync at the next tick.
> +					 */
> +					if (inconsistent)
> +						mpp->sync_tick = 1;
>  				}
>  			}
>  			lock_cleanup_pop(vecs->lock);
> -- 
> 2.47.0

