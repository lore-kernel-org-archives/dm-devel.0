Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2F93629AA
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757613411; cv=none; b=gWQ4hgwMWwmhMkcS2fR/3T2J7JAKFavp2DqOBODdeNOrSkvyRyeT3gtK9lkLjX5tds5LzG5mXiMS4fwD8aN5ANkgMBGYNvgObuXNYj7svaZGBzrvoRe7IlgUPdY4yNZermBm3BZsfBktQqau6301XZ5aqWaH8sYF67byC4rzph4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757613411; c=relaxed/simple;
	bh=ckRHKTyLzWn5LdCpDFvy0/Xr22i1uQ3DkHQZ7BT7NCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=EqvZ0pvyT2tE1pujNOjggbbQMnhqPKnmZCoaaWWO34zIFL8lm5Hjp7mCDhexT4xV6tln4mO6NiGfoyWU9qC82CuJQhomJ+PUYNOg6khutF8kUiHZgB429pFhrn6njveNO15MW0pzP6N7dQE3F9JnJ50qEJcHTQr3vUxRhmwdyqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Owx/0JyE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Owx/0JyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757613406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kqf4SveSWm1WHdSVftBqBeuAwKxpchV2Dovx8QsqaVk=;
	b=Owx/0JyENEp6qZgn3MqABfMr8hUlXGUvffgu89fXg9BxdLDMGMCYypww60q6ONFNyatGrp
	tumF+JUQDAQPATKpwpd7HZSh7lAE1xmQnZgx5X6jeYIE1jjoEy8mjHEM6EwI/3n64kQOUY
	+9EzaKbFjr3bXFKboSAoVopLnowDiU8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-WvP2c8mRM8OqBypuidBzkg-1; Thu,
 11 Sep 2025 13:56:43 -0400
X-MC-Unique: WvP2c8mRM8OqBypuidBzkg-1
X-Mimecast-MFC-AGG-ID: WvP2c8mRM8OqBypuidBzkg_1757613402
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2319719373DE;
	Thu, 11 Sep 2025 17:56:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83EE3180035E;
	Thu, 11 Sep 2025 17:56:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58BHuerl858175
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:56:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58BHudVc858174;
	Thu, 11 Sep 2025 13:56:39 -0400
Date: Thu, 11 Sep 2025 13:56:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/3] multipath-tools: add Acronis Cyber Infrastructure to
 hwtable
Message-ID: <aMMNV-_0nX0gOdXM@redhat.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
 <20250910194205.145919-2-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250910194205.145919-2-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uOy0ITlYx4wETGa89Ae4DqwrW722l_C1JR7d5o4pj8g_1757613402
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2025 at 09:41:57PM +0200, Xose Vazquez Perez wrote:
> Source: https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructure_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux.html
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 1a78c36d..12e10577 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1371,6 +1371,21 @@ static struct hwentry default_hw[] = {
>  		.pgpolicy      = GROUP_BY_SERIAL,
>  		.no_path_retry = 30,
>  	},
> +	/*
> +	 * Acronis
> +	 */
> +	{
> +		// Cyber Infrastructure
> +		.vendor        = "VSTORAGE",
> +		.product       = "VSTOR-DISK",
> +		.prio_name     = PRIO_ALUA,
> +		.pgpolicy      = GROUP_BY_NODE_NAME,
> +		.detect_prio   = DETECT_PRIO_OFF,
> +		.features      = "2 pg_init_retries 50",
> +		.pgfailback    = -FAILBACK_FOLLOWOVER,

I'm not sure about the pgfailback setting. the FAILBACK_FOLLOWOVER mode
is not something that is really needed for a specific array type. It
works like FAILOVER_IMMEDIATE, but it's designed to work so that if
multiple nodes are using the same multipath device, and one of them
loses access to the highest priority pathgroup but the others don't,
multipath won't keep switching pathgroups back and forth. The nodes that
can see the higher priority pathgroup won't automatically switch back to
it, since they weren't the ones that switched away from it. So the
setting is more for a specific use case, and not a specific array type.

On the other hand, it is what the vendor tested, and with a single
machine accessing the multipath device, you usually only switch away
from the highest priority pathgroup because you lost access to all the
paths in it. So it usually won't get stuck on a lower priority pathgroup
while a higher priority one is usable, although that could happen. 

Thoughts?

-Ben

> +		.flush_on_last_del = FLUSH_ALWAYS,
> +		.no_path_retry = NO_PATH_RETRY_QUEUE,
> +	},
>  	/*
>  	 * EOL
>  	 */
> -- 
> 2.51.0

