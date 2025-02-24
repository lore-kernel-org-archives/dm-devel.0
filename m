Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96481264A95
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740418362; cv=none; b=SUh10pYSkm76mYJW4+RtKxlCMIr21Fu/6QybCmzdyQL/wFj2xux7cy9xOq1MpQyDNac+wYMLLKnGtXDRnPHVVm8juQxRydyITPklnFYVihoWx7xC+uH4XoD21gd5BfT3uOB10VRPt3lMKRgz/n0aWdX2AXEbfRCIMJyp/ATXKYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740418362; c=relaxed/simple;
	bh=OT9CXmPNSFkDd7Ok+Ay5a2XKw2YiYDcvFQOJqjcgCr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QNkoqNQUDO1hLujcB0Tg3Y7pL+O/RS2Oq0lURTIYiEKVdBoX2gj+fzRJFNpWE+ruxgLd5YkM/0xt85RabQFDIkDsJCPbp30LrWTMOOkq1OrFAW4cFCaiQbrXMyQqwDuTgDdDHI+pASph3b2x/hFGcF/O4hjdnp/KNUJqqMIlz8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BvXJarSn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BvXJarSn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740418359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCNX2EvPYPn5ZKOOPKvLDVWJP2h+f3YdY0hdCyN144Q=;
	b=BvXJarSnAE1q0FyuZ6E4qtCOVDuOSUpEnf7S/mRZwHcPc5mHQ+P/qzVazZOq8Yo19murKR
	uLUuXMH+2Xxp7Kg1Iwuebi0HsozHaHBEIxzJsGEw1bdBFF5hEqzIm40d1+nMxVOOBopB0l
	mAwzpu5alQpWibbsQFVEVbrK6u8JjuA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-144-NLTqZEM9NaKwmG5dCe5kwA-1; Mon,
 24 Feb 2025 12:32:33 -0500
X-MC-Unique: NLTqZEM9NaKwmG5dCe5kwA-1
X-Mimecast-MFC-AGG-ID: NLTqZEM9NaKwmG5dCe5kwA_1740418352
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D7B31975AFC;
	Mon, 24 Feb 2025 17:32:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D49A61955F0F;
	Mon, 24 Feb 2025 17:32:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51OHWUMV300996
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 12:32:30 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51OHWUKM300995;
	Mon, 24 Feb 2025 12:32:30 -0500
Date: Mon, 24 Feb 2025 12:32:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Alice Frosi <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 08/10] libmpathcmd: try both abstract and pathname
 sockets
Message-ID: <Z7ytLpXCLgemdJRx@redhat.com>
References: <20250221204108.70631-1-mwilck@suse.com>
 <20250221204108.70631-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250221204108.70631-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ag4rB1C0Ff5u4HnaxbRw9QgdjnqzfMnDIy3tKDapiqc_1740418352
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2025 at 09:41:07PM +0100, Martin Wilck wrote:
> When connecting to the multipathd socket, try the pathname socket
> first, then the abstract socket. Fail only if both connection attempts
> fail.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathcmd/mpath_cmd.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index c7cf954..83cb6ad 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -102,7 +102,10 @@ int mpath_connect__(int nonblocking)
>  	size_t len;
>  	struct sockaddr_un addr;
>  	int flags = 0;
> +	const char *const names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
> +	int name_idx = 0;
>  
> +retry:
>  	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
>  	if (fd == -1)
>  		return -1;
> @@ -113,13 +116,17 @@ int mpath_connect__(int nonblocking)
>  			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
>  	}
>  
> -	len = mpath_fill_sockaddr__(&addr, ABSTRACT_SOCKET);
> +	len = mpath_fill_sockaddr__(&addr, names[name_idx]);
>  	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
>  		int err = errno;
>  
>  		close(fd);
> -		errno = err;
> -		return -1;
> +		if (++name_idx == 1)
> +			goto retry;
> +		else {
> +			errno = err;
> +			return -1;
> +		}
>  	}
>  
>  	if (nonblocking && flags != -1)
> -- 
> 2.48.1

