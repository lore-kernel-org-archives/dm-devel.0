Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E690323ED63
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 19:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733858436; cv=none; b=qNskrnchaNRBgZze5OyyhdqYddVPsWCh14rSxXiJ9kcs8cyboyEFwra2RTaJwRJ4A4nhd66a5xOiUnpddcTgi1T3QAJut2vx9WMhpN8JhT29+cq9CVz9kRCosIxWCJrG0LqSW5UP3JZ+jAiYmAFqfxQZcXYy+eaDlFU2FqoLbys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733858436; c=relaxed/simple;
	bh=NgLh4nPEOdhgsEIncxLXc7ol5Lzi1XktbZ2Fkg/Uv2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mUhnJhJgQ0XSIZfnqHEdcKAoFdJVz1Cy7kBivgGjwJOOZGPy5+iK/WMO7Ea3vqDRptdGGNciyFACXvFqIlcpWan7zqkCdpGH1oCnokfJBM7wQoq/2lI/brne3Q44X3LSgm0+7zFYZrfu0He9mQp8tnzXxmS2lBM66dQOzu5CcGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VKya/Qwy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VKya/Qwy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733858433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=su7MrxbE2Toa8uh+kj7+oNi1uxjHEnhWlYLm4+RHymA=;
	b=VKya/QwylBP94C08EQzImsj2BslF2vX0/SWnXNTXZq8Rc6cHNIkH9Sw81DsHtSIpgAWgl9
	1+BlVf05SSnrttQp3nhpdQ/+bv39TOQLK/J8njeB7ENo8RKcWx2SD7i+sWQw4uBA1EB5ol
	kGl2BpcEn6L12GgZ8pQ0MAFNvL61zqQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-045Zmnn7NKWFBcHcAfIXQg-1; Tue,
 10 Dec 2024 14:20:30 -0500
X-MC-Unique: 045Zmnn7NKWFBcHcAfIXQg-1
X-Mimecast-MFC-AGG-ID: 045Zmnn7NKWFBcHcAfIXQg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CBBB19560A2;
	Tue, 10 Dec 2024 19:20:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BF391956052;
	Tue, 10 Dec 2024 19:20:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BAJKQXL1419563
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 14:20:26 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BAJKQEh1419562;
	Tue, 10 Dec 2024 14:20:26 -0500
Date: Tue, 10 Dec 2024 14:20:26 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 04/13] multipathd: reload maps in do_sync_mpp() if
 necessary
Message-ID: <Z1iUekRg8sai8HLT@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241206233617.382200-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cF0jhNWYmgLsIxoeNNnHs4Pnlk889ca4bjZOekOLhMM_1733858428
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 07, 2024 at 12:36:08AM +0100, Martin Wilck wrote:
> update_pathvec_from_dm() may set mpp->need_reload if it finds inconsistent
> settings. In this case, the map should be reloaded, but so far we don't
> do this reliably. A previous patch added a call to reload_and_sync_map()
> in the CHECKER_FINISHED state, but in the mean time the checker may have
> waited for checker threads to finish, and may have dropped and re-acquired the
> vecs lock. As mpp->need_reload is a serious but rare condition, also try
> to fix it early in the checker loop. Because of the previous patch, we
> can call reload_and_sync_map() here.

Again, if the map has any paths in the INIT_PARTIAL or INIT_REMOVED
state, the reload will remove them from the pathvec and mess up our
looping through it. Reloading maps with need_reload will already happen
at the end of this path check loop, so it will still get done very
quickly.

Also, since we try to get all the paths for a device checked in the same
checker loop now, it seems to me that there could a benefit to waiting
till the end, to sync our state with the kernel. This could avoid some
path ping-ponging in a corner case. If a path failed and the kernel
noticed it while we are in a checker loop, but haven't gotten to
update_path_state() for that path yet, the path will still appear up to
multipathd. In this case, if we reloaded the multipath device while
updating an earlier path in the device, we would reinstate this failed
path in sync_map_state(), only for us or the kernel to fail it again
right afterwards.

-Ben
 
> Fixes: https://github.com/opensvc/multipath-tools/issues/105
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 131dab6..18083c7 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2450,12 +2450,25 @@ get_new_state(struct path *pp)
>  static int
>  do_sync_mpp(struct vectors *vecs, struct multipath *mpp)
>  {
> -	int ret;
> +	const int MAX_RETRIES = 1;
> +	int ret, retry = 0;
>  
> +try_again:
>  	ret = refresh_multipath(vecs, mpp);
>  	if (ret)
>  		return ret;
>  
> +	else if (mpp->need_reload) {
> +		if (retry++ < MAX_RETRIES) {
> +			condlog(2, "%s: %s needs reload", __func__, mpp->alias);
> +			if (reload_and_sync_map(mpp, vecs) == 2)
> +				/* map removed */
> +				return 1;
> +			goto try_again;
> +		} else
> +			condlog(1, "%s: %s still needs reload after %d retries",
> +				__func__, mpp->alias, retry);
> +	}
>  	set_no_path_retry(mpp);
>  	return 0;
>  }
> -- 
> 2.47.0

