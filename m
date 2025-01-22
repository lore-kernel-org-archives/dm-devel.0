Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AEA20FABC
	for <dm-devel@lists.linux.dev>; Wed, 22 Jan 2025 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737569755; cv=none; b=K4tqDruK42KE6wVXZ/YVURkQ3KJe93vgh8qsiEy6tkF4BAVogrZBzznd7J6xa7YrsZQebGcWib0HPW952Qw9aHhpjv8IxC+7QfAvlk0/XtotmHp3vfGzReC+ZCXv4C+/xyi6Ug6Sr1Ihv1L0uHm5nLCykjqwaOWgmVqWVrv/Fy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737569755; c=relaxed/simple;
	bh=WoeAB1TkdBvY1fk5lyAI/lLP7/r8fN3o5XNgr8c0vLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=qzPoPJZCcIcXbqTHTYoxwEDxSm7/1wpr7falfhYX9IRNQoo1yoBbc7V/eCEkI8/BWhoWNo1Q1VtaBRzRAeRfBMbXHshvWNNI/n1SuHzpFGJM5UE3yWrEcmcJZxrDjSrnL7OoIr1MKA6T+JVSROJuDEt9ywR0QDHHDZeteVMe07w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dxDnO2cd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dxDnO2cd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737569752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5dbQ/WCO/5qZShtlFnxRiywP6oGmhyCTDuuvokoxJoo=;
	b=dxDnO2cdV1dVnRuJyXqD2PQCE7DsswyqRC6yvBcwYEEgA7sq7juzpBGrWtBlu4FhDl/yAp
	jUEMDoPkzlsRkcWvA8Zt4UP9Zh6kGnzR3ZO543wJRAlktzmVcATP2Uc1ZPOS5zkfVUsEBq
	DNuilWYIQp2MlO20ttL+BQhrKZIxVXI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495--pcPRVaUMg-tvgOdc08LgA-1; Wed,
 22 Jan 2025 13:15:49 -0500
X-MC-Unique: -pcPRVaUMg-tvgOdc08LgA-1
X-Mimecast-MFC-AGG-ID: -pcPRVaUMg-tvgOdc08LgA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 247C1195608D;
	Wed, 22 Jan 2025 18:15:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEB9319560AA;
	Wed, 22 Jan 2025 18:15:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50MIFk3k3003958
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 22 Jan 2025 13:15:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50MIFkAE3003957;
	Wed, 22 Jan 2025 13:15:46 -0500
Date: Wed, 22 Jan 2025 13:15:46 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 04/15] multipathd: emit a warning if a map remains
 inconsistent after reload
Message-ID: <Z5E10rn9eLs6eaHr@redhat.com>
References: <20250117202738.126196-1-mwilck@suse.com>
 <20250117202738.126196-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250117202738.126196-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KpMZA9fegkh7-O3ESClQvY_R7ulRO5sfjf0vrTJDtHY_1737569748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2025 at 09:27:27PM +0100, Martin Wilck wrote:
> After reading the kernel device-mapper table, update_pathvec_from_dm()
> sets the mpp->need_reload flag if an inconsistent state was found (often a
> path with wrong WWID). We expect reload_and_sync_map() to fix this situation.
> If this is not the case (need_reload still set after map reloading), it's
> most probably a bug.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e4e6bf7..ff3031e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -3026,13 +3026,20 @@ checkerloop (void *ap)
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
> +					/* need_reload was cleared in dm_addmap and then set again */
> +					if (inconsistent && mpp->need_reload)
> +						condlog(1, "BUG: %s; map remained in inconsistent state after reload",
> +							mpp->alias);
>  				}
>  			}
>  			lock_cleanup_pop(vecs->lock);
> -- 
> 2.47.1

