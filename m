Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716F418E764
	for <dm-devel@lists.linux.dev>; Mon, 13 Jan 2025 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736790275; cv=none; b=VziB/6TNS37udsGsPkxf7iu8E828fCl6mSbdfrCnTEO4TztTqkPbicLWOCdu215RomcY6syypIXoK5lnGhlzk9bZ/fFfScWOviDA7lrFio2Kf4shKXFaTENqW1cLGESZKbKNuxQQDN3/8URLmrEusAbynD42y4jt9m3C4cP3re4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736790275; c=relaxed/simple;
	bh=2ILe0v6d6Tb6cc0m9oUqhJNAWugWkVY/uG9f55/PPUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ce03P8iZc8KVI0Nmo51IUBOaad2mmBsQicB9cw0njPccphb/rz5rAR1ddoHXb05jN1ORX4DqyAiuDCU96D4xwLsDUSLksLMrVQmwP/W674i2+DeywmKGo4W7xqhFGoDmPcvQ9EQg1bJzyw04QDA8vNzjibwNOOsj1njCqep2sVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZoMYxPOo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZoMYxPOo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736790271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Psz+8ye97sDE8ScGUrMwiitvX+XR3cmXVQvNSelufoA=;
	b=ZoMYxPOob8fMgVg6VDkClNNlkejgfZUwzcYtMc7kZjVK38gWx8MZNA71Fre2uHfDgd5zu/
	1XWths4/DuPctudr9QWSWEfR6yArdMuJGCq9dFa18JVj2OeAWGdDDfnzpTtyTYMsqwMXpC
	l/adll/zO1RriycSs67CBmcyi2gEfFQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-h6WzJ5UaM26mm8ujhIdCGg-1; Mon,
 13 Jan 2025 12:44:28 -0500
X-MC-Unique: h6WzJ5UaM26mm8ujhIdCGg-1
X-Mimecast-MFC-AGG-ID: h6WzJ5UaM26mm8ujhIdCGg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 636C919560B9;
	Mon, 13 Jan 2025 17:44:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A728430001BE;
	Mon, 13 Jan 2025 17:44:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50DHiO792643112
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 12:44:24 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50DHiNmm2643111;
	Mon, 13 Jan 2025 12:44:23 -0500
Date: Mon, 13 Jan 2025 12:44:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: chenrenhui <chenrenhui1@huawei.com>
Cc: dm-devel@lists.linux.dev, lixiaokeng@huawei.com, mwilck@suse.com
Subject: Re: [PATCH] libmultipath: add condition for enqueueing path to io
 error check
Message-ID: <Z4VQ9wAumKdP8Wlm@redhat.com>
References: <20250110063816.759-1-chenrenhui1@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250110063816.759-1-chenrenhui1@huawei.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9NQWAZTWti-1AtcWbFhD0IG9ayr77FeFvGm7RrAhaWk_1736790267
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 10, 2025 at 02:38:16PM +0800, chenrenhui wrote:
> In function io_err_stat_handle_pathfail(), path->io_err_dis_reinstate_time
> is set to 0 to enqueue path to io error check as soon as possible. But
> multipathd can not do it within marginal_path_err_recheck_gap_time seconds
> after power-on, because curr_time is less than
> marginal_path_err_recheck_gap_time.
> 
> To handle the early marginal path, we can enqueue path when
> io_err_dis_reinstate_time is 0.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: chenrenhui <chenrenhui1@huawei.com>
> ---
>  libmultipath/io_err_stat.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index 4996c0b0..879c310a 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -367,7 +367,8 @@ int need_io_err_check(struct path *pp)
>  		return 1;
>  	get_monotonic_time(&curr_time);
>  	if ((curr_time.tv_sec - pp->io_err_dis_reinstate_time) >
> -	    pp->mpp->marginal_path_err_recheck_gap_time) {
> +	    pp->mpp->marginal_path_err_recheck_gap_time ||
> +            pp->io_err_dis_reinstate_time == 0) {
>  		io_err_stat_log(4, "%s: reschedule checking after %d seconds",
>  				pp->dev,
>  				pp->mpp->marginal_path_err_recheck_gap_time);
> -- 
> 2.45.1.windows.1
> 

