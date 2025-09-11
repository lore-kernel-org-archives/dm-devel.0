Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BF43705AA
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 17:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757613453; cv=none; b=DRODj5SN+vkhg+cmZUzT47cKSK/pAVOEOQc4YccXlX0ebusNpwsdqls9/aoPkLGGx8CYVBe5ItkaGtO0UUN0I+qLkPjGNvJ3JjuKl4WSpEYzYy4ihkdk0r3jmf1CKJ1u8nhmDyyoBQ183B82ConcgWvsusUVI+L5y6EGYsbpw1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757613453; c=relaxed/simple;
	bh=ALKi7Epw60xFH+eiBppEbmRRayO8CPry2d/tIxZgO2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dhiLDlVc199Nll/JxdrYLJFsMU+Z/+4EeoYNE+pD0Tha1q9kpxFr639a8Y9zV1d8coJKAvmPuO9u3Tf8tjVagoXioW1uMRJMVGJ6wfavmMs3lvyKnTs1UbyNFCRmjl9GSl/br9jZkLb/gqDQ41AkaInDsWTozeEu/9dCSTf8C0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QAEmZ16S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QAEmZ16S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757613451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZL2s6gwJnpP69LQbRmflbJhSMI6o2Gc8xTWaaCoibak=;
	b=QAEmZ16Sbe8Aavsb8749eQGgq1AvwIk2rQJKllaFo/BtKtnmuYD2gJSzlxGQ3ogOYYkGdH
	BwAySQ1Dgfu6SgUAqIQjS8xl6L/RlNNN35hZdbKcD1blIQqzfXNgxNuAFBSeh8xhBqRCWE
	5+shHyR2U9JxvrBksyzHLKRyQx3n86M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-25TvytukOx-_KPDZTeawgA-1; Thu,
 11 Sep 2025 13:57:25 -0400
X-MC-Unique: 25TvytukOx-_KPDZTeawgA-1
X-Mimecast-MFC-AGG-ID: 25TvytukOx-_KPDZTeawgA_1757613444
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E23C2180057C;
	Thu, 11 Sep 2025 17:57:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9007319560B1;
	Thu, 11 Sep 2025 17:57:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58BHvMj7858204
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:57:22 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58BHvMNK858203;
	Thu, 11 Sep 2025 13:57:22 -0400
Date: Thu, 11 Sep 2025 13:57:22 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/3] multipath-tools: add QSAN to hwtable
Message-ID: <aMMNgi_w9YsneYKj@redhat.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
 <20250910194205.145919-4-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250910194205.145919-4-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JxnSbbc5P8b4nyE1WABfZ4Qy6-_yquLm1ljvd0Zq5IM_1757613444
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2025 at 09:41:59PM +0200, Xose Vazquez Perez wrote:
> Source #13/15: https://www.qsan.com/data/dl_files/qs_wp_iSCSI-MPIO-in-Linux%20(en).pdf
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 80e76fed..d9723f87 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1393,6 +1393,18 @@ static struct hwentry default_hw[] = {
>  		.flush_on_last_del = FLUSH_ALWAYS,
>  		.no_path_retry = NO_PATH_RETRY_QUEUE,
>  	},
> +	/*
> +	 * QSAN
> +	 */
> +	{
> +		// XF / XCubeFAS / XCubeSAN / XN / XCubeNXT Series
> +		.vendor        = "^Qsan",
> +		.product       = ".*",
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.no_path_retry = 30,
> +		.prio_args     = "exclusive_pref_bit",
> +	},
>  	/*
>  	 * EOL
>  	 */
> -- 
> 2.51.0

