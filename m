Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3743730DD01
	for <dm-devel@lists.linux.dev>; Mon,  8 Sep 2025 18:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757356460; cv=none; b=Volznze5z8iTfleoQl0Ge/Eczks7pg68nj27k+sMUw9oMH7QQ+UPxkF66UFuu75XAYPzqd+Ja91JhooXdmHUo+89J2/3dgRD8Ho886lslajGCs4hcDff586Lm6Ud6ysEvPyfAOoSvmrxL6Rvlgy387ZZ3CVXqPzBWbn26Y6DkdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757356460; c=relaxed/simple;
	bh=CkAwtlXbyYMcuCtStqdSeMywY/YpcoOdjUB5P+OKMx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=dp8DTq6oK2eTYxAfM3/spu8QCK/kPtvLQYNkS+sSHzUj6vqr2RIzNDbZdUebHafz+socEulHChfrzX7kexwdPx1F39h+p4KXsNrfsQzyHcR4vR+YUxT76+XslsVpfNXiAk9w29O9/Mlvsrz63A2PBiauw8Ajyr1ByWYYbkio9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Apiu7Dil; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Apiu7Dil"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757356458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k2LVoY1zsAd7OMqgVawT71/GZLzGQYhyP+Z4FAZY40Q=;
	b=Apiu7DilFHGJgbDUTZRmyJMNwXu39jFdhrewLC7W/LkITvI4biIVsAFuCBachhmnsQD3kw
	L3dyGOv5jQtIf+JinS1zw0B7gMt+msLxchDq2ncjuzjmgE98uUvyUVh11XOuh1y+XHRDlt
	c7QL13RRLFeac1r/JeM0pOMtnKdX7aI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-xk9bpGgLMcyf_064kRnS8A-1; Mon,
 08 Sep 2025 14:34:14 -0400
X-MC-Unique: xk9bpGgLMcyf_064kRnS8A-1
X-Mimecast-MFC-AGG-ID: xk9bpGgLMcyf_064kRnS8A_1757356453
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E80A41800370;
	Mon,  8 Sep 2025 18:34:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A23561800451;
	Mon,  8 Sep 2025 18:34:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 588IYBD4742450
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Sep 2025 14:34:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 588IYAhj742447;
	Mon, 8 Sep 2025 14:34:10 -0400
Date: Mon, 8 Sep 2025 14:34:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] libmultipath: fix missing return value check in
 snprint_devices()
Message-ID: <aL8hol-agJsYXaYk@redhat.com>
References: <20250905210714.167202-1-mwilck@suse.com>
 <20250905210714.167202-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250905210714.167202-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: unH-EOA2sjiCPNoxh3sBXHHMgoe-nUcIRIoZlOzvWqI_1757356453
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 05, 2025 at 11:07:13PM +0200, Martin Wilck wrote:
> Coverity scan defect #488155.
> 

Your fix looks fine, but the code I see right above it isn't. We should
not be returning a positive number here if things went wrong. Looking
at the udev_enumerate_new() code, we should be safe always trusting it to
set errno correctly. So, the code should probably be

if (!enm)
	return -errno; 

If you don't want to handle that is this commit then:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Fixes: d041258 ("libmultipath: snprint_devices(): use udev_enumerate")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/print.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 019ae56..a7306f0 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1993,7 +1993,8 @@ int snprint_devices(struct config *conf, struct strbuf *buff,
>  	enm = udev_enumerate_new(udev);
>  	if (!enm)
>  		return 1;
> -	udev_enumerate_add_match_subsystem(enm, "block");
> +	if ((r = udev_enumerate_add_match_subsystem(enm, "block")) < 0)
> +		goto out;
>  
>  	if ((r = append_strbuf_str(buff, "available block devices:\n")) < 0)
>  		goto out;
> -- 
> 2.51.0

