Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7910B1A76AE
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 22:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739833048; cv=none; b=jqSgpYbaCA5mo++9xNaBSNjhDvfnk75O99VU5SlSVh+x4pLCCBGG4FbgcKwTfZJ961XInx46RZ7WGYSuKP9lND0nxi+/nZey/GPc8Ra9GUhi6Vk2MR/cCfRo287qyFaGm6LizoamJ1OcvKs964ZeHq/PS3GXyOpNIWlp0K5bWvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739833048; c=relaxed/simple;
	bh=PpwiAWZwOyPAes3sdzwPOMkncnq/brVt53a77JR/oPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fMWvnfUoh8EKUMHO9X/LnjxRisYKogK9z7swxc+SDmY9aW2n8ogEO35ek+Zz52e7qw1yT/zQSoi8/TrScwl9kTE0zM6Y3g2O1BsEwEXTPIMe+VmP9LWPIVxjXFAhB8mUDGTt3imkFTc/AvMjRGgrVMl0Loq6QdFWiCyNfZ4yIzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y12lI8+r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y12lI8+r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739833045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R2BBJWB8BJTxkA6V7r7CvRAbp9g/kkJxZaem0i7pIWg=;
	b=Y12lI8+rc83RapPZb3hzEEymX/CvbQYsMe3puKYFBTta80AnhsUoKg5sQ9/EUKR0bkiegt
	gIU1mOaQ9pB1X7OhZ8EJ5tKf4o4lnIfeZ0BiwiwEzsOzE3pUh1fAj6Fly6srJ6cKpgYIRn
	Vdw4xCSE/IN+7yOUJuZvrSSN/S/iyuY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-6lcKXsicOpKBCurTnqZoJQ-1; Mon,
 17 Feb 2025 17:57:22 -0500
X-MC-Unique: 6lcKXsicOpKBCurTnqZoJQ-1
X-Mimecast-MFC-AGG-ID: 6lcKXsicOpKBCurTnqZoJQ_1739833041
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D67519373DC;
	Mon, 17 Feb 2025 22:57:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E59EC180035F;
	Mon, 17 Feb 2025 22:57:20 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51HMvJ7r3050088
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 17:57:19 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51HMvJI93050087;
	Mon, 17 Feb 2025 17:57:19 -0500
Date: Mon, 17 Feb 2025 17:57:19 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Alice Frosi <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 08/10] libmpathcmd: try both abstract and pathname
 sockets
Message-ID: <Z7O-zzUk0tP1Tv-N@redhat.com>
References: <20250214221011.136762-1-mwilck@suse.com>
 <20250214221011.136762-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250214221011.136762-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JOJRMSs46nhf5iC7AfDPyvZaq3e098S7jslYYfcrf2E_1739833041
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2025 at 11:10:09PM +0100, Martin Wilck wrote:
> When connecting to the multipathd socket, try the pathname socket
> first, then the abstract socket. Fail only if both connection attempts
> fail.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathcmd/mpath_cmd.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index c7cf954..ba5bb31 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -102,7 +102,10 @@ int mpath_connect__(int nonblocking)
>  	size_t len;
>  	struct sockaddr_un addr;
>  	int flags = 0;
> +	const char *names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
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
> +		if (err == ECONNREFUSED && ++name_idx == 1)

Most of the connect() return codes are things that could presumably be
fixed by trying a different address (not the errors related to a problem
with sockfd, but we just created the socket, so those seem pretty
impossible). Is there a reason why we don't just retry on any error?

-Ben

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

