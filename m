Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714C81F2C3B
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733959020; cv=none; b=POnMgkJ+hltBXfr6vR6KUXOlsTpsrUsnjePEUqHRD88sKfrsAp1GQgyB4MyZG8UepTLppmNuwpH0QlZ1S1Qw7C3oOwa2CPzaC527ztemtqhgFaOr27dEGvjoKVqUQFpI6wmkXggpHnNvxd3EiZXBAcjOY9zP9/auWz2fuXMmAhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733959020; c=relaxed/simple;
	bh=jS2RIlCYTjn95mW9puixZzdFfo4DoZslvs5oqU2Jq+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ht7DvxHFWjCsrOFLrCY6AQut8vPYOYxANWMmOPkfRxUaMM6/s8rlesAR0yRD4eUwlpTA8DLnvjCcfvfOMez+Q1ziJa6fXijLoo4Gu9e0/XjabX/2r7Aa0c7E4Dvojwculhz5RJSjXnuIjBLSLHI8swecTQhRtd+yAv6C/Qk3lQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ovs9mHMy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ovs9mHMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733959017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=twaXyF6vBqJm/Vmcy7a5kzIxVb+/t/067m6XB95+7TY=;
	b=Ovs9mHMypf3Y/0hUhbwE98D2bk0PCtLRxfNjmcIu5flqxlNomXFjLN4a0yy/PyO09bQmJp
	mpSl1Gsw7wEADRBJ0Iz05ojnWKkJllEvlgG/UWJDfxZo/YC11LQm08u+fg6l6LzF/Xae68
	Q8KCtRXq+LYRgnRPdiAagPWwmrxQhLw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-kHLxtiKZMDGvh35zOgKhaw-1; Wed,
 11 Dec 2024 18:16:54 -0500
X-MC-Unique: kHLxtiKZMDGvh35zOgKhaw-1
X-Mimecast-MFC-AGG-ID: kHLxtiKZMDGvh35zOgKhaw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 88C1019560B6;
	Wed, 11 Dec 2024 23:16:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1830B1956054;
	Wed, 11 Dec 2024 23:16:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BBNGomT1463128
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Dec 2024 18:16:50 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BBNGoaL1463127;
	Wed, 11 Dec 2024 18:16:50 -0500
Date: Wed, 11 Dec 2024 18:16:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Jon Paul <Jon.Paul@hpe.com>, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH RFC] multipath-tools: add HPE MSA Gen7 (2070/2072) to
 hwtable
Message-ID: <Z1odYq4fnXv-8VZu@redhat.com>
References: <20241205224917.7104-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241205224917.7104-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3251NHRgGAgRmxfT_sEzlGNnuWlA9Z9PzSMWxOimc1Q_1733959012
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2024 at 11:49:16PM +0100, Xose Vazquez Perez wrote:
> https://support.hpe.com/connect/s/product?kmpmoid=1014856412
> 
> Just guessing, confirmation from manufacturer is needed.
> 
> Cc: Jon Paul <Jon.Paul@hpe.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/hwtable.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 32118339..543f0bc1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -188,9 +188,9 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  	},
>  	{
> -		/* MSA 1040, 1050, 1060, 2040, 2050 and 2060 families */
> +		/* MSA 1040, 1050, 1060, 2040, 2050, 2060 and 2070 families */
>  		.vendor        = "(HP|HPE)",
> -		.product       = "MSA [12]0[456]0 (SAN|SAS|FC|iSCSI)",
> +		.product       = "MSA [12]0[4567]0 (SAN|SAS|FC|iSCSI)",
>  		.pgpolicy      = GROUP_BY_PRIO,
>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>  		.no_path_retry = 18,
> -- 
> 2.47.1

