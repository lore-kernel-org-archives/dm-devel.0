Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD84A22
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 01:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707440708; cv=none; b=EmvTqkd172zDCPb60jRINt/71TyzdI60edYaGZ+c9A96oM67Xv1DZQoIlapv8Tl0YmSR39aRXjs56z4lZPPKCwhnsNha4mj3MnnaT/TKCF5x1OSUb3/WlEYhpBfVK9ho0NK/vgckqVd9Bgo7FiGST6MGSKIowaUaWgcExwsM5vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707440708; c=relaxed/simple;
	bh=8LLkT7LXjHEwrp8bFdPQuDqQE86o96sXGOWVD9PEKb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mwK3YmzNC1uwTNz9qvF6CKNMUdCw765TLy+AC57uJcaxAHerjEQf/9Bs9TMWzfPm/KwCT4he4iXNxPifgHQdF5JoVNR1g4JwzqPbucPo5H7+swaIhuiOnEZ6ghfgc6+SMFSrhB1UPAKLYgK7zDd9ZM+ISMzvOGf2gUTmfEjwNlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EY1ES85+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EY1ES85+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707440705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKAFcR/dFatYgWePlWM1VB9duCZnC++b9c5sY+HZr9Q=;
	b=EY1ES85+jSZL+sUItCSA4BfVhuW7tILYzbxt2+NcJr/xMdW+d+idFtm2TUUD9IHxxCKxK7
	qD+2enq36mOFc4IYKtOqbmoKsU0eJGCSs9oKO2NjzWqbGHK5yHVq96+gzp2QEqGcBXSn60
	OszfayMcdgb9IrMDUH4B4iEXAb9EL7w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-7UEk5L3bPqedAOpxC3HXiw-1; Thu, 08 Feb 2024 20:05:02 -0500
X-MC-Unique: 7UEk5L3bPqedAOpxC3HXiw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BABF3185A786;
	Fri,  9 Feb 2024 01:05:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA661103A;
	Fri,  9 Feb 2024 01:05:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 419151cP338657
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Feb 2024 20:05:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 419151ZV338656;
	Thu, 8 Feb 2024 20:05:01 -0500
Date: Thu, 8 Feb 2024 20:05:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>,
        Sergio Durigan Junior <sergiodj@sergiodj.net>,
        Chris Hofstaedtler <zeha@debian.org>
Subject: Re: [PATCH 6/6] multipathd: don't activate socket activation by
 default
Message-ID: <ZcV6PdkOQipdpMZL@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240205124638.17877-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2024 at 01:46:38PM +0100, Martin Wilck wrote:
> Socket activation will start multipathd on systems that don't have multipath
> hardware. This is often not desired.  On systems that do have multipath
> hardware, OTOH, it is highly recommended to enable multipathd.service directly
> rather than have it started via socket activation.  Therefore don't activate
> the socket by default.  multipathd still supports socket activation, so users
> who find it useful can disable multipathd.service and activate the socket.
> 
> Fixes: https://github.com/opensvc/multipath-tools/issues/76
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Cc: Sergio Durigan Junior <sergiodj@sergiodj.net>
> Cc: Chris Hofstaedtler <zeha@debian.org>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  multipathd/multipathd.socket | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket
> index c777e5e..6a62f5f 100644
> --- a/multipathd/multipathd.socket
> +++ b/multipathd/multipathd.socket
> @@ -10,4 +10,6 @@ Before=sockets.target
>  ListenStream=@/org/kernel/linux/storage/multipathd
>  
>  [Install]
> -WantedBy=sockets.target
> +# Socket activation for multipathd is disabled by default.
> +# Activate it here if you find it useful.
> +# WantedBy=sockets.target
> -- 
> 2.43.0

