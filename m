Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C211A3056
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 23:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733873677; cv=none; b=AaZcYD7o6cXL+hF3sFw9x45y/XTUi7G2q6jJ4f4pF4DdZgqZVRHqOA9aDX1gngMs4eCtXLmEcZPrCl6ipTW6GIB3HZMa/tfIcbb3se/jjZZkx8e4vSwWgylmcY196V1whJide+8gDVs5fE+HO3ppxZWqmC6Y0PMvjfHrQ66S1UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733873677; c=relaxed/simple;
	bh=Gheh9Kr44DpLVTV9/fS/zdTDPnhb3xoswCoAhn2fT/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=e2RYEZC1NEPLi5DryIK18g01oqnN93T79agcustRSQ3bDrZRmxQ5hAqbKmSNZgYGmRtt1kQlKCheKbhqacqeQ9b4sKrku+A9kHTldtSSnNJwhC/zuZ8cDUyd15fL3CvJxrRzxv2EIANFvy8b0D/pYgBDg0tqgcdWjQCJnKS7rYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JnmUSiJI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JnmUSiJI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733873674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VlaxKpDYJw9OSImY2m2LaN0Xd86awCb2pbHfMfJEDR8=;
	b=JnmUSiJIqtJor8yo3KEadpCebxCZsaVReVaP7Tgn9TyMbjZduAN9O9skMq9ltsVVWI4Bxe
	6tQ7rUwSmft5rCYfY2HSleOPbTmy3ApDYIcKug+iAyxI8ubAVF9m+YVRpF4BCG5vSkai+A
	UMwgKQSeB8TjFJ49EQz8GvtNeNlvhko=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-501-C08_PeGpNXCi_ckwRo4r-w-1; Tue,
 10 Dec 2024 18:34:32 -0500
X-MC-Unique: C08_PeGpNXCi_ckwRo4r-w-1
X-Mimecast-MFC-AGG-ID: C08_PeGpNXCi_ckwRo4r-w
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 010DF19560B3;
	Tue, 10 Dec 2024 23:34:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA4BE1956048;
	Tue, 10 Dec 2024 23:34:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BANYTmt1425706
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 18:34:29 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BANYTOf1425705;
	Tue, 10 Dec 2024 18:34:29 -0500
Date: Tue, 10 Dec 2024 18:34:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/13] multipathd: remove mpvec_garbage_collector()
Message-ID: <Z1jQBRIvfP2aQvGa@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
 <20241206233617.382200-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241206233617.382200-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oikrOrEqSj3zZnf9xJ-DdFJWv6wkLUv_5E4ZHIUhvhY_1733873671
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 07, 2024 at 12:36:12AM +0100, Martin Wilck wrote:
> This function duplicates functionality that we now have in the
> do_sync_mpp() code path. Remove it.

If we decide not to delete devices on do_sync_mpp() errors in the
checker, we probably want something like this to say around, perhaps
rolled into finish_checker().

But to go along with my feeling that we shouldn't be deleting the device
on errors in the checker, perhaps it should call dm_is_mpath() and only
delete the device on DM_IS_MPATH_NO.

Thoughts?

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 31 -------------------------------
>  1 file changed, 31 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7e844a5..43f6cc8 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1967,24 +1967,6 @@ enable_group(struct path * pp)
>  	}
>  }
>  
> -static void
> -mpvec_garbage_collector (struct vectors * vecs)
> -{
> -	struct multipath * mpp;
> -	int i;
> -
> -	if (!vecs->mpvec)
> -		return;
> -
> -	vector_foreach_slot (vecs->mpvec, mpp, i) {
> -		if (mpp && mpp->alias && !dm_map_present(mpp->alias)) {
> -			condlog(2, "%s: remove dead map", mpp->alias);
> -			remove_map_and_stop_waiter(mpp, vecs);
> -			i--;
> -		}
> -	}
> -}
> -
>  /* This is called after a path has started working again. It the multipath
>   * device for this path uses the followover failback type, and this is the
>   * best pathgroup, and this is the first path in the pathgroup to come back
> @@ -3002,7 +2984,6 @@ checkerloop (void *ap)
>  {
>  	struct vectors *vecs;
>  	struct path *pp;
> -	int count = 0;
>  	struct timespec last_time;
>  	struct config *conf;
>  	int foreign_tick = 0;
> @@ -3074,18 +3055,6 @@ checkerloop (void *ap)
>  			lock_cleanup_pop(vecs->lock);
>  		}
>  
> -		if (count)
> -			count--;
> -		else {
> -			pthread_cleanup_push(cleanup_lock, &vecs->lock);
> -			lock(&vecs->lock);
> -			pthread_testcancel();
> -			condlog(4, "map garbage collection");
> -			mpvec_garbage_collector(vecs);
> -			count = MAPGCINT;
> -			lock_cleanup_pop(vecs->lock);
> -		}
> -
>  		get_monotonic_time(&end_time);
>  		timespecsub(&end_time, &start_time, &diff_time);
>  		if (num_paths) {
> -- 
> 2.47.0

