Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58B92288F7
	for <dm-devel@lists.linux.dev>; Mon,  6 Oct 2025 17:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759770558; cv=none; b=G88qLzYsl0DiR5lpgCcXKbnUkiTSnAcL+yxmhEpzXLTtTp3SoX3Ywf2Zl4bP9+4DjFHvxZX5EcdTLKmasyQ4JrRKKLeiJkErXAvUWounhgcOLotjbO5iZOf3bTC6nYDrVlcynaImBdyk5eEFvbNRKvHJP3RvfZsvfD9XJBWFLRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759770558; c=relaxed/simple;
	bh=EHbh5Ojug1wn86jBpQLBydVPmGaaamsph63UQl//K/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mcPiJlYfuveJgeVDgOvka0aqctY5aBqb4fv9xnOvMY/hAtdTvjQ+OSEEXSjJvojZ8yWOkLdJhEdrlEcVVR4DW7tAZMg8cWG4sw9ihn0jCHfY+4t1wWqeTiKitu4p9H5hxgtIHHKUP7KLw3Fee1PBZmFiBefXq08WEWo/qheUDcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PP56Erky; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PP56Erky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759770555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uzd9/+sBmeri/eiC74yzta2lcdQtJM6lGT8mgT7YcDY=;
	b=PP56ErkyefjU4FJ7tIrOakNXbCagRP8Nd4QivzIZbqKLY5K1/fLBxUVuYvh31zjjOoOIdx
	K+fb3t+82vWFoWKQaXIqr7+ER/Oqchl/65txfv5Rzgjl4gSF+HjWFooB0q4Nr4HgmGZz71
	F0lIArEu0RObRvmUsFR+AScQFT8FJHk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-biw_u5hMOrmToGqFun0eOg-1; Mon,
 06 Oct 2025 13:09:10 -0400
X-MC-Unique: biw_u5hMOrmToGqFun0eOg-1
X-Mimecast-MFC-AGG-ID: biw_u5hMOrmToGqFun0eOg_1759770549
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35E281800365;
	Mon,  6 Oct 2025 17:09:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 965B01956056;
	Mon,  6 Oct 2025 17:09:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 596H97LD1994484
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 6 Oct 2025 13:09:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 596H96iV1994483;
	Mon, 6 Oct 2025 13:09:06 -0400
Date: Mon, 6 Oct 2025 13:09:06 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 1/3] multipath-tools: add Acronis Cyber Infrastructure
 to hwtable
Message-ID: <aOP3sjzUgFU4n8-k@redhat.com>
References: <20251004210122.109288-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251004210122.109288-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wZfWlD6Pgi58Wd5fKwDd8UDR-KUc_UkZfQQW6_Q-R4g_1759770549
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 04, 2025 at 11:01:22PM +0200, Xose Vazquez Perez wrote:
> Sources:
> https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructure_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux.html
> https://docs.virtuozzo.com/pdf/virtuozzo_hybrid_infrastructure_6_2_users_guide.pdf
> 
> v2: replace -FAILBACK_FOLLOWOVER with -FAILBACK_IMMEDIATE

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

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
> index 1a78c36d..f8bbf02d 100644
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
> +		.pgfailback    = -FAILBACK_IMMEDIATE,
> +		.flush_on_last_del = FLUSH_ALWAYS,
> +		.no_path_retry = NO_PATH_RETRY_QUEUE,
> +	},
>  	/*
>  	 * EOL
>  	 */
> -- 
> 2.51.0

