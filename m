Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF9D19F48D
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 00:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766103313; cv=none; b=QneA4OerT80xAMBjpTpbdByG7RilDz1qjpc25mF1LTWTlmzKUt98P9Zpz97E0b7rczcpQ0YmVVHXT50cMP85jijPpz8iKcQeFsxW94Z1A/PrCx/Zlb4Mx/BodQMtPQH6U6K5dyOPbnkI/vXDPpmthGwYZIZqCn4WT9x/qFgAAT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766103313; c=relaxed/simple;
	bh=jlt/RmtCaj2hRUYSypRNSe8Z3Mw8IV/Mk+ooPlrlEuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=enmIU21WkZ5obGJD64vKCdziKeGSLbDkiVd8kWdQNbocoTfOrYJ1txTlaClWcTiDAzr14fJmsqovQRoDfC+jlVqWryArbAsDcmYSXFk1NheXGGJevz+Bqvm0mC7AOO8V9lcMjKp9fRawPLn6VLxAO6D2kpFORvS2XkcW3tUJYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BnoJQmPS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BnoJQmPS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766103310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EAzN2p94J0eD/7zojvTNAR57dlynGf/IZUUJGpbccUc=;
	b=BnoJQmPSZq1WSSemyMXYKLncmwp8wbe6dt8O6PCl/5QfEQFOXxle5nKFEUobfabDos76hX
	+j+PGPMW7TTMsFbZz0hqJEmnxZC8E7nncnXocjZFfpedASfzQxVzeQCaUK3Fec7YVeoM/e
	XEFXX/zDTrO0XH0XHmdbokBdVtlzQ6w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-263-_-HhilTvOFqrZV6CDioA3A-1; Thu,
 18 Dec 2025 19:15:06 -0500
X-MC-Unique: _-HhilTvOFqrZV6CDioA3A-1
X-Mimecast-MFC-AGG-ID: _-HhilTvOFqrZV6CDioA3A_1766103305
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5E6F1955F34;
	Fri, 19 Dec 2025 00:15:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6468C1953986;
	Fri, 19 Dec 2025 00:15:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BJ0F4ig2124201
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:15:04 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BJ0F4Xg2124200;
	Thu, 18 Dec 2025 19:15:04 -0500
Date: Thu, 18 Dec 2025 19:15:04 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 12/21] libmultipath: free_multipath: fix FREE_PATHS case
Message-ID: <aUSZCCPwZk_qATDx@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
 <20251217212113.234959-13-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217212113.234959-13-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YR2vRCmQW9msVKU-HM3BPDlopk3bO3bvdpLgzbtLthc_1766103305
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2025 at 10:21:04PM +0100, Martin Wilck wrote:
> free_multipath was passing FREE_PATHS to both free_pgvec() and
> free_pathvec(), which was wrong because a path could be referenced
> in both structures. This can't happen any more now, as free_pgvec()
> has lost the ability to free paths.
> 
> In general, free_multipath can't make any assumptions about whether
> a given path is referenced in mpp->paths, mpp->pg, or both. Therefore
> look first for paths that are referenced in mpp->pg but not in mpp->paths,
> clean them, and finally loop over mpp->paths.

Like I said in 07/21, I don't think we should free paths here. The paths
linked from the multipath device are also in the pathvec. We should
always be freeing them from there, so we don't have a pathvec with freed
paths.

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs.c | 44 +++++++++++++++++++++++++++++-------------
>  1 file changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 1ee29f6..29b62e4 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -298,8 +298,12 @@ void free_multipath_attributes(struct multipath *mpp)
>  }
>  
>  void
> -free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
> +free_multipath (struct multipath *mpp, enum free_path_mode free_paths)
>  {
> +	struct pathgroup *pgp;
> +	struct path *pp;
> +	int i, j;
> +
>  	if (!mpp)
>  		return;
>  
> @@ -310,22 +314,36 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
>  		mpp->alias = NULL;
>  	}
>  
> -	if (free_paths == KEEP_PATHS && mpp->pg) {
> -		struct pathgroup *pgp;
> -		struct path *pp;
> -		int i, j;
> -
> -		/*
> -		 * Make sure paths carry no reference to this mpp any more
> -		 */
> -		vector_foreach_slot(mpp->pg, pgp, i) {
> -			vector_foreach_slot(pgp->paths, pp, j)
> -				if (pp->mpp == mpp)
> +	/*
> +	 * If free_paths == FREE_PATHS, free all paths.
> +	 * Otherwise, make sure no references to this mpp remain.
> +	 *
> +	 * First loop over mpp->pg and clean the paths that might
> +	 * be missing in mpp->paths. Then clean the rest
> +	 * by looping over mpp->paths.
> +	 */
> +	vector_foreach_slot(mpp->pg, pgp, i) {
> +		vector_foreach_slot(pgp->paths, pp, j) {
> +			if (find_slot(mpp->paths, pp) == -1) {
> +				if (free_paths == FREE_PATHS)
> +					free_path(pp);
> +				else
>  					pp->mpp = NULL;
> +			}
>  		}
>  	}
>  
> -	free_pathvec(mpp->paths, free_paths);
> +	vector_foreach_slot(mpp->paths, pp, i) {
> +		if (free_paths == FREE_PATHS)
> +			free_path(pp);
> +		else
> +			pp->mpp = NULL;
> +	}
> +
> +	/*
> +	 * We've freed paths above already, use KEEP_PATHS here
> +	 */
> +	free_pathvec(mpp->paths, KEEP_PATHS);
>  	free_pgvec(mpp->pg);
>  	if (mpp->hwe) {
>  		vector_free(mpp->hwe);
> -- 
> 2.52.0

