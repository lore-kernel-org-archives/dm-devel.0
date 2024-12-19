Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106A1D278B
	for <dm-devel@lists.linux.dev>; Thu, 19 Dec 2024 23:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734649560; cv=none; b=Uv+tcDpQ4lPMXAsDOlKYO/3LkTbKt/1Z7HBDexbd+r19T+eIfGKDZ52RyWcmnxXor9i3QKmNl2q/+cxhaC6AFE5xb/+KZB8Y6D8uH4fODSDc2aD34OWNUDUCNwiSfu8XoKX0bFIEY7y3v/0gsClxd6FAanvjH9ojzWFxJQ8JWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734649560; c=relaxed/simple;
	bh=4tV1ZsSW18fxhIggPlt8JkJwdsKI2i0qvQlPr+etJgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=f5BR/fu2BHdiHEw53FRqKkjesqVWM0GojvGdON+0iDrah3DGZB+tqDIn2j/7CkDXwmwMA+03fW6lg0vzUOuSCyr+Oqm5QdaMOhqZt131CMvxfpZLG9igxX+Rwn7Rh4ZAKIsa/rQhA/jvqi2XvCxJuXQuj7L7zkujCs89hAoRn64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Al/Mvc3m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Al/Mvc3m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734649556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NIcWS6jlLuArTd51/R5i/wnTcjJrCInaAJOCuy6oNp8=;
	b=Al/Mvc3mePCVY8oCUgz8lDFOGdu0HC4SSYL9+jxvoDlSn0iZZ3+mURZvLhpEUxTx9GpTx7
	6WntYccsMXUFi3XugdFrn8f1IFhboZ6j8KTSm3QLIUmBCQ/PozVlkwHm9MDeMcmXoFOQM/
	CvKfiJ24HwHJ8iPsDEZ2vrzs4Smj9L8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-237-6ChNNQa9M0K4tBBZc4TIug-1; Thu,
 19 Dec 2024 18:05:53 -0500
X-MC-Unique: 6ChNNQa9M0K4tBBZc4TIug-1
X-Mimecast-MFC-AGG-ID: 6ChNNQa9M0K4tBBZc4TIug
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC11F195608B;
	Thu, 19 Dec 2024 23:05:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F9E419560AD;
	Thu, 19 Dec 2024 23:05:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BJN5otq1754922
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 18:05:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BJN5oYU1754921;
	Thu, 19 Dec 2024 18:05:50 -0500
Date: Thu, 19 Dec 2024 18:05:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 04/14] multipathd: quickly re-sync if a map is
 inconsistent
Message-ID: <Z2Smztyjr-Na1VRA@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
 <20241211225909.298770-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241211225909.298770-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rgPKrqx49fqUJYhOLj1h8LB0rnzEKz8N9HLdn40CI_s_1734649552
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2024 at 11:58:59PM +0100, Martin Wilck wrote:
> After reading the kernel device-mapper table, update_pathvec_from_dm()
> sets the mpp->need_reload flag if an inconsistent state was found (often a
> path with wrong WWID). We expect reload_and_sync_map() to fix this situation.
> However, schedule a quick resync in this case, to be double-check that the
> inconsistency has been fixed.

Like I mentioned in by second comment to patch 03, this sync already
happens as part of reload_and_sync_map().

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

