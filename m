Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED17D2745C
	for <dm-devel@lists.linux.dev>; Mon, 17 Mar 2025 20:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742241664; cv=none; b=HF03IXtyhojAJ379gaVJb/tUdLpLtWxgStsBHp3iC2TQGVSG2MR79j0WxOxm9iIdftU1gU1V91oU8NmRZ9QgUwJCmaesVgjFPwfp+x70Et+McotVY5FVhxTYkbEVK1bfgAJ4PIKi+y3STAzzJ3mESNIyrXyeZat9c3FImKqmEmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742241664; c=relaxed/simple;
	bh=hT5nh3nk//h0HzDxGRry/QOxl5nZKUigDC7AXKcl0Jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=SP+XSSWAh0ZXk4GZQT89EmqZNXpKRvb/FUPSD07gz6roRN8WSbtZaNMOOK9PQtFKNx0G9EVi5fPgz/v6Cwe9oBDoE2+erJ0Y1mkw31z2ZMV44wyyXAzeBU6ivbP0JQdaxtDZNQH6BQMvsnHkRDjBMQFltxfPZ2lGEolpeYsBhpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hws0/DaH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hws0/DaH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742241661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2B44CMyXaUbm9Akq+Gw9SylBv64aVj04I/tIpX6CsLA=;
	b=hws0/DaH27WLJFgl4e0xnc6VwRM50+G3r6mStyZYKEKOhDhu+LiAoQ1273EIXJgeL1oVMK
	SEoxUgPn/ydZxKNOwPDbiTF2/GoF6x7dLKO6OtM0XWKG4G597ipjKSzvx4EjBYLJvge6Ex
	jzDGldr2CRtgAsLicGq0ci4aj+o2OBA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-76-jZ05CcOXNGSCWQR-nLX9eQ-1; Mon,
 17 Mar 2025 16:01:00 -0400
X-MC-Unique: jZ05CcOXNGSCWQR-nLX9eQ-1
X-Mimecast-MFC-AGG-ID: jZ05CcOXNGSCWQR-nLX9eQ_1742241659
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43FAB1808868;
	Mon, 17 Mar 2025 20:00:57 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB1B3180094A;
	Mon, 17 Mar 2025 20:00:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52HK0tvN2227891
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 16:00:55 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52HK0sS62227890;
	Mon, 17 Mar 2025 16:00:54 -0400
Date: Mon, 17 Mar 2025 16:00:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH RFC] multipath-tools: add Generic SCSI in hwtable
Message-ID: <Z9h_dgeRCakpLak9@redhat.com>
References: <20250317173352.14387-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250317173352.14387-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wYBCoV_QbBVcF1Tp16OCaMKHv_pIDszRoiEmOlmG090_1742241659
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 17, 2025 at 06:33:51PM +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index f8cf3fa9..34b1fd2f 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -79,6 +79,17 @@
>  #endif
>  

If we wanted to make these changes, we could just change
DEFAULT_PGPOLICY, DEFAULT_FAILBACK, and DEFAULT_NO_PATH_RETRY. But I
still think that for completely unknown devices, we should stick with
our current defaults. They're safe and I haven't heard any complaints
about them.

-Ben

>  static struct hwentry default_hw[] = {
> +	/*
> +	 * Generic SCSI devices
> +	 */
> +	{
> +		/* Generic SCSI */
> +		.vendor        = ".*",
> +		.product       = ".*",
> +		.pgpolicy      = GROUP_BY_PRIO,
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.no_path_retry = 30,
> +	},
>  	/*
>  	 * Generic NVMe devices
>  	 *
> -- 
> 2.48.1

