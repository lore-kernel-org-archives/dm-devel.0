Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDF329AB
	for <dm-devel@lists.linux.dev>; Thu, 11 Jul 2024 06:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720679261; cv=none; b=D2x7wi0IJLYJu5ILVpXBH8+3b9VOxWdStHefC33870YUl25VmYHMJv2OibxlwMXPWNgtmJIaQU5yKNIKxtjdmbIxXXhQlTatHlN6KFCoGdy54x4mDakue3Mxpz10IVODdG2CJIGxqPRqjaj817WpDtDwFw3e8YxonvHkYcvAUhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720679261; c=relaxed/simple;
	bh=6y4SZ+cFQwRGV/psdUpWgEKIp6dmWLPZlkX5BUQcsOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rCV0nBigjn/IZLuFdM7az2lmLxBpCb3CnF4Lzn81YeTnhDh6db0v5MyLikB2IaQH0iVJcUYFhjepl3XssNgJ8L4ympj/dQwAlFAvbF7+Q6fWQARQM7Lp2zECWo8W3bLFc2CmkFlYetK0Ojwa2f/o3CS4FsqbMWjWlEFOKBWM4po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dksf7AyR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dksf7AyR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720679258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lM32V4e8ZDy141r2WjW8esaZsO/RgDh0W1xMAy7H4KY=;
	b=Dksf7AyR/GvmC6Av1WtaIcbwfgJf/lf6jTIIaDUPhw/jki7klvpulaNpsR8vmiVz3qDLN6
	LCNXu0yB2UckiK3j+My7HoSzmrIom4PU5pHPMfAiQ1L5prQ3XvVgm+M3hLEiIF0Yp/ETtG
	az7Itr3nC6y/qfYytDwzirQcsSel0Qk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-NgQYBcCVOf6ZldBfGU18sQ-1; Thu,
 11 Jul 2024 02:27:32 -0400
X-MC-Unique: NgQYBcCVOf6ZldBfGU18sQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4AC54196CDEF;
	Thu, 11 Jul 2024 06:27:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6E2819560AE;
	Thu, 11 Jul 2024 06:27:30 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46B6RT4E1932692
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Jul 2024 02:27:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46B6RTGO1932691;
	Thu, 11 Jul 2024 02:27:29 -0400
Date: Thu, 11 Jul 2024 02:27:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 42/44] llibmultipath: fix return code check for
 dm_is_suspended()
Message-ID: <Zo97Ud-n5oxTFl-N@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-43-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-43-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:33PM +0200, Martin Wilck wrote:
> dm_is_suspended returns non-null if it failed to obtain the device
> information. It's wrong to assume in this case that the device is suspended.

I'm kinda torn on this one. Sure we don't know if the device is
suspended, and most likely if this failed, the device got removed.  But
on the other hand, it could have failed for another reason, and resuming
a device that isn't suspended (or doesn't exist) causes no harm.

I could go either way on this.

-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index e653ca6..e9a0103 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -604,7 +604,7 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  	/* If the resume failed, dm will leave the device suspended, and
>  	 * drop the new table, so doing a second resume will try using
>  	 * the original table */
> -	if (dm_is_suspended(mpp->alias))
> +	if (dm_is_suspended(mpp->alias) == 1)
>  		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias,
>  			     DMFL_NEED_SYNC | (flush ? 0 : DMFL_NO_FLUSH),
>  			     udev_flags);
> -- 
> 2.45.2

