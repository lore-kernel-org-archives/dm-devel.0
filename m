Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793382401;
	b=KjP4EUCarqlu+TGnoGSkXdvDy2EO+38aAyW/On+hAwf4cdaWy3O8/ENd5IMlIRA+ReID
	 RbMU90N0Q814JCI6FigI1JwsNqAwNlSCd0tT+V1/Vf2FUWvFyLzo7VPocq94O1rKbtES8
	 Yung7W3JrtDU666ivMM2VNZPqBDg5fVr82zJFKzBs75ss97o/FmlLzsqY0o9B5gGL62ju
	 f+6DZrGqhSE/lJoxbpgWGnFupT8+EynhPO9zjsSH06SJXb9wGGFC+OpWp1rggJltBtOkh
	 lcflJuozYjnyB/rBYsoh3xsk9fgnTJPAPQRnokWfb9Xu3Bx07Yq8yQpI8tcf6o8BTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793382401;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:In-Reply-To:
	 X-Scanned-By:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=oa/0SbZCkrkWQYpNMWgx1Jq/mZtpjQ3qALisXkFoJ58=;
	b=bT4316lXeX87i2Aw4cxZa+fXa8tEIx+s/uVYzG3dLADUGpktIBXfpKoGM/ha6VNo2abm
	 uafSHuaaR6LSsxaUZLezNElu8drfdE/qNtFbXQRxjqccgmwjBRvCuoYlTgFd+8eS4vUey
	 /DpX/tgzw2d9P8tKomQc9ioDr62hC6XsOybSE3sCBhdsWLD0aF1uXKwtCHApe/Px2rYSS
	 lA56edkCoTmWSqVFLSHT8g5buZA/5QQ+cFrhdrq/UDF4vBfm0JReVZ0twf/FqWaqSGbcO
	 LB3nDMA56Ay1fqUwGXZ+l565ekSfaR26RpVfbZ9xBjXIZTjqtA47zC4QhOGvhGJ3GFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hkIEU7CN;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557D0606A31A
	for <dm-devel@lists.linux.dev>; Fri, 30 Oct 2026 17:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 557D0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hkIEU7CN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793382400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oa/0SbZCkrkWQYpNMWgx1Jq/mZtpjQ3qALisXkFoJ58=;
	b=hkIEU7CNFihpKe/wCFDl/oM/xMArpTWSSp7lvmfQPR2jdJ7wGfk1JeQm+QTqiGfC1wFSCX
	yg4zOizU3wMxOdxUkhLIl21lj9tZ9s2l06ycOtXwiC2eQQnfXjpI5S6iLsLCLXq0jIvPcv
	NPJTpvb3JcnB8ZIC/IYsGGulRoXijNQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-_QVYoevBOwS5vN5n5mLqUg-1; Fri,
 30 Oct 2026 13:46:36 -0400
X-MC-Unique: _QVYoevBOwS5vN5n5mLqUg-1
X-Mimecast-MFC-AGG-ID: _QVYoevBOwS5vN5n5mLqUg_1793382395
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 719C01954B24;
	Fri, 30 Oct 2026 17:46:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 109A226C;
	Fri, 30 Oct 2026 17:46:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69UHkXjT1092818
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 Oct 2026 13:46:33 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69UHkVcX1092805;
	Fri, 30 Oct 2026 13:46:31 -0400
Date: Fri, 30 Oct 2026 13:46:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH] multipathd: Don't look at pointer to removed path
Message-ID: <auTX97jTl602SYIu@redhat.com>
References: <20261029235014.818202-1-bmarzins@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261029235014.818202-1-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bFiQnIo1-T0ImsAzI_owZhnOAzl0VAczdBlonZ-ZlrQ_1793382395
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 29, 2026 at 07:50:14PM -0400, Benjamin Marzinski wrote:
> In uev_update_path(), if the path wwid changes, we remove it and use
> needs_reinit to re-add the path. Once we remove the path, pp is pointing to
> freed memory, but we still read the value it pp to see if it's NULL before we
> check needs_reinit. This doesn't cause any bugs, since we don't dereference it,
> but it would still be cleaner if we stopped accessing it completely after we
> freed it. This is easy to do, since we only ever set needs_reinit if pp is
> non-NULL. So just check needs_reinit before we check if pp is NULL.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Since this is just a cosmetic change, I'll wait till Brian's
WWID verifying patch lands, and rebase on top of that.

-Ben

> ---
>  multipathd/main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6b..792bee36 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1769,6 +1769,9 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  	}
>  out:
>  	lock_cleanup_pop(vecs->lock);
> +	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
> +	if (needs_reinit)
> +		return uev_add_path(uev, vecs, 1);
>  	if (!pp) {
>  		/* If the path is blacklisted, print a debug/non-default verbosity message. */
>  		if (uev->udev) {
> @@ -1787,9 +1790,6 @@ out:
>  
>  		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
>  	}
> -	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
> -	if (needs_reinit)
> -		retval = uev_add_path(uev, vecs, 1);
>  	return retval;
>  }
>  
> -- 
> 2.56.0
> 

