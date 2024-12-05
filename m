Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4401AF0BE
	for <dm-devel@lists.linux.dev>; Thu,  5 Dec 2024 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733425338; cv=none; b=HN3otUTPlZ5CC7JTiaH/RaBzVHGSi3GWLUdoPBQ32Xmtm7QttL3guO371C+EXvfE1pMSsN938nPTGRz+AH6tvDSrPbu3TeNFQ4PgWl0Ykk+pwvQR3rd0m1BAo6Wje8C8bcPAMpEodeZz+bnwwl6VpBGxDL0H3RMmJm/5Fsojil4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733425338; c=relaxed/simple;
	bh=8yGRYrj63UszA///hvh7X24Hm71xebL4lMYPxZcUJZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Ghm/5oFkJdRJ9CBRUtNnGKOjWC+a10E30RW53cWzsLJyl4IHUREwL+1bB1U+pIr3JagCFXeB6Ty6mLNwsiK7QiauJHtHCdefNgr0U+OIdQpPE1PZWwU5inJSGiEl2lhhS483tAvBtBHCnvjEIL1+V27BD9xYnz2eBw4ytbhyxL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RkNG45Un; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RkNG45Un"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733425334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uuFbOK5yU6pSYqPsOhjBiG6LilUEpI4g23WBw5RVYaA=;
	b=RkNG45Un+WytLEmh96RKBaOSDax79rTY/323MRU+WTKRUJk3McSzAe5BiBESwfecJNNyBh
	tlI30RYzSRmYMPL57OWMlLW40c6GHgt9MHzWtE0Kegp5kXN/fgy4f6YUzGfPXbnOem49xk
	WYI0HLHzmXvHDZsUO90h1GvJZbE1Zfs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-112-nb-VoXfKNCOWejLY7RG6jg-1; Thu,
 05 Dec 2024 14:02:13 -0500
X-MC-Unique: nb-VoXfKNCOWejLY7RG6jg-1
X-Mimecast-MFC-AGG-ID: nb-VoXfKNCOWejLY7RG6jg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27B361955D47;
	Thu,  5 Dec 2024 19:02:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 524BD1955F3E;
	Thu,  5 Dec 2024 19:02:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4B5J28T31240506
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 5 Dec 2024 14:02:08 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4B5J27Ou1240504;
	Thu, 5 Dec 2024 14:02:07 -0500
Date: Thu, 5 Dec 2024 14:02:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Gleb Chesnokov <gleb.chesnokov@scst.dev>,
        Bart Van Assche <bvanassche@acm.org>,
        Vladislav Bolkhovitin <vst@vlnb.net>, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] multipath-tools: add SCST to hwtable
Message-ID: <Z1H4r9Nbg_a2LfZ5@redhat.com>
References: <20241129120916.302317-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241129120916.302317-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ngShQT6WQccVkHCxAkR2eH5_f4FZvVNiNpmHVy8NlXM_1733425331
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 29, 2024 at 01:09:16PM +0100, Xose Vazquez Perez wrote:
> Based on: https://github.com/SCST-project/scst/blob/master/scst/README#L1905-L1908
> 
> Cc: Gleb Chesnokov <gleb.chesnokov@scst.dev>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Vladislav Bolkhovitin <vst@vlnb.net>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/hwtable.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index cf39a50d..8612fb21 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1036,6 +1036,15 @@ static struct hwentry default_hw[] = {
>  		.checker_name  = DIRECTIO,
>  		.detect_checker = DETECT_CHECKER_OFF,
>  	},
> +	{
> +		/* Generic SCSI Target Subsystem for Linux (SCST) */
> +		.vendor        = "^SCST_",
> +		.product       = ".*",
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.no_path_retry = 12,
> +		.prio_name     = PRIO_ALUA,
> +	},
>  	/*
>  	 * DataCore
>  	 */
> -- 
> 2.47.1

