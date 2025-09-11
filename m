Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E482362092
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757613434; cv=none; b=oQVohe7eJHV+FBD8OjN8/zHxRjqE9TJgy3BHQJnG75tkFpSbXgWxRfUqgiiDrWR9tJ39lMPMhiVYXfVF+P/FAjV9jwsIuZM2LpmgAiQvXD4GI/HjKb/N+v79On5uq7zcii+1zgQBWOlQDTcnfebqm4O5VyGtEXojabTYE5KdBvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757613434; c=relaxed/simple;
	bh=7acuFpLin1iBmPxZOlFZJWN6QRSM5TXouaUW0zfc1q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=IbUTYOcvt6kRwGDn9ok0Ap5JClyPzp9hvU2+jhMEn38fASrlbrJA5UxoIb5yN+HRNJZnS2Q3tAzKrjD+MJnf7HcaHCAqcnhrc+EgM70km+lCYcUxHDHZ2jGgb06xpqDF/PCUWz7Ut9VDzm4r/XlVk1kXqNb+c2ze+k8CzNxvOGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GCD68/lw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GCD68/lw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757613431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I9T00fn7/aCLAhX9FE9LgWyKem/dDpAMtjHqr/KrI7g=;
	b=GCD68/lw8NLUryafNq8d5Xfu1GHNaLKxHV0C2Uo9GraeNB++D+6aQCSk6M9Gr7wmU8+D03
	OVGFVvSqgHpdU+kx4x6WKHCYJosjJYBp1rKl4U2CIOO1Ypjf1bYBF2crfGbiDEAfPWtk3K
	miWR+uF3aVMOBNM4miqc3FKPaMG5+0g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-2Chb5jI2OoqhgQLhlg0VOg-1; Thu,
 11 Sep 2025 13:57:06 -0400
X-MC-Unique: 2Chb5jI2OoqhgQLhlg0VOg-1
X-Mimecast-MFC-AGG-ID: 2Chb5jI2OoqhgQLhlg0VOg_1757613424
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B9B11953954;
	Thu, 11 Sep 2025 17:57:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F251D300021A;
	Thu, 11 Sep 2025 17:57:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 58BHv2gm858196
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 13:57:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 58BHv2Zq858195;
	Thu, 11 Sep 2025 13:57:02 -0400
Date: Thu, 11 Sep 2025 13:57:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 2/3] multipath-tools: add EqualLogic PS to hwtable
Message-ID: <aMMNbgZyHs1YfzMM@redhat.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
 <20250910194205.145919-3-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250910194205.145919-3-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wjuWLzeNXy6rIIezI3W8FqIwxJF4KFeaWeXVvqnVP7I_1757613424
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2025 at 09:41:58PM +0200, Xose Vazquez Perez wrote:
> Source: https://dl.dell.com/manuals/all-products/esuprt_software/esuprt_it_ops_datcentr_mgmt/s-solution-resources_white-papers30_en-us.pdf
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/hwtable.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 12e10577..392131a3 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -408,6 +408,13 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_ALUA,
>  		.pgfailback    = -FAILBACK_IMMEDIATE,
>  	},
> +	{
> +		// EqualLogic PS Series
> +		.vendor        = "EQLOGIC",
> +		.product       = "100E-00",
> +		.pgpolicy      = MULTIBUS,
> +		.no_path_retry = 30,
> +	},
>  	/*
>  	 * Fujitsu
>  	 */
> -- 
> 2.51.0

