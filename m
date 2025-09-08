Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16C831C593
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357693; cv=none; b=f38ACwbWelHCILMTait+7CQHV9Q9Tlc/G5FlWzIFa8N2nLvCrGTi9VJN4E0nbAVX4om9/pfMnX3JRRVWjV2y4TBx3qSV1g3a8hzr2AfuYZ+xb3S4Swv3NDkgUPqkJ2vUW05BDuuV5tOwPeCjWqAeqXAeQsFl/EUjw1ykxh8lmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357693; c=relaxed/simple;
	bh=2RV2q5yQTMv9hdACz+sEslit2aLZ+68dVRGaYeYEp4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CwsqUC2+U5FTqazAbH8VNxtxRCTB5FtS8gHJ6MtUu5wl4IGILnVE09YOSaIffOXIgA6vRbr4MsczdEFdK58vlWGr2uhQTtRrE4PnAEt1n89raj3qQoGsWT+QqLPHwlklS/AYIB2Snno17ndfGACTR1OI+mhHeDdDWT/hVmg8uMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EkAhisKA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EkAhisKA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757357690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vnKpKdngabPovd4VkSTm3p9lgdipD9eVxXJcVPaQINM=;
	b=EkAhisKAo/2BW23FYeP+jVTfQSYVxzFCZG4y0/95ULjAd8FKRtSka3z9c4ERtWcA0gYoPY
	e3sjwRwtjaSuhN5noYgsgC8lO2Zpg2HeWVqBefQrLV8RFh7rX1VrgYUoR4H1obh9fRlRLc
	D64yl+Uo6uzHMrEcrj03lnqOdxVHWbQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-zFzKPLG9PKeMsaoe8IHeMA-1; Mon,
 08 Sep 2025 14:54:49 -0400
X-MC-Unique: zFzKPLG9PKeMsaoe8IHeMA-1
X-Mimecast-MFC-AGG-ID: zFzKPLG9PKeMsaoe8IHeMA_1757357688
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F14E19560AE;
	Mon,  8 Sep 2025 18:54:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D659F19560BA;
	Mon,  8 Sep 2025 18:54:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 588Iskl0742948
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 14:54:46 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 588IskxR742947;
	Mon, 8 Sep 2025 14:54:46 -0400
Date: Mon, 8 Sep 2025 14:54:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] libmultipath/foreign/nvme: fix return value check in
 get_ctrl_blkdev()
Message-ID: <aL8mdcK6jyd1xHb6@redhat.com>
References: <20250905210714.167202-1-mwilck@suse.com>
 <20250905210714.167202-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250905210714.167202-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rSSE0gDVYZ3gOM_v--VENjlN4MpFd5q1G_h6s3PLmYk_1757357688
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2025 at 11:07:14PM +0200, Martin Wilck wrote:
> Only a negative return value from udev_enumerate_add_match_subsystem()
> indicates an error.
> 
> Fixes: 7b47762 ("libmultipath: nvme: fix path detection for kernel 4.16")
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/foreign/nvme.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
> index 0d19303..4cbdf60 100644
> --- a/libmultipath/foreign/nvme.c
> +++ b/libmultipath/foreign/nvme.c
> @@ -536,7 +536,7 @@ struct udev_device *get_ctrl_blkdev(const struct context *ctx,
>  	pthread_cleanup_push(_udev_enumerate_unref, enm);
>  	if (udev_enumerate_add_match_parent(enm, ctrl) < 0)
>  		goto out;
> -	if (udev_enumerate_add_match_subsystem(enm, "block"))
> +	if (udev_enumerate_add_match_subsystem(enm, "block") < 0)
>  		goto out;
>  
>  	if (udev_enumerate_scan_devices(enm) < 0) {
> -- 
> 2.51.0

