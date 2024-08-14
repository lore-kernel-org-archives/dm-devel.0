Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C23F1B0111
	for <dm-devel@lists.linux.dev>; Wed, 14 Aug 2024 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723671931; cv=none; b=EInYXgtiQCrnkmPg35/hz5ExKR5myyh3cwkelIXam7Klyu/w8Tg//RXrDPt/2USWqI7nfkix2ttHJlYIZrMxYfYz2IWiNiFSiQ17G5Lc+78BMGM1xmV2k+04ZAUKLmfVAm43aWzCRpsGYol4VkYVQDLgcrotvvs6KmBb8UF8b7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723671931; c=relaxed/simple;
	bh=EUBokEGt+hHGB0+MK8ZiOyYc6RLgHPVcQXNk8BBNSSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=nynEXXxkgfiE1G4Sw/i47SCjmnducZr0MYmm3xKJz2g+Y+eOiTz+dLO13D/l1F6JTBidGKy45s1mcNq8698MBKj2xyrQUg82MfJM+V4wIzkdJU2mVl0ckwCObjK9hH7P0vFoDf6aqrNoIGfGCldIevVtVWCiggi7GSQzTVmK7ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jCG/tFbW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jCG/tFbW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723671925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=abunyBNcJHigB8Yorid7Z1CgUuMuzaoD8QGJ4wZuvUk=;
	b=jCG/tFbWD9YWpM9xhXzKoEGp8nsh4hWZ1rbWx1KCo0b9edLao7NbmOavnDcbVVX1dw7vfA
	CxNLd1VPAQ7tsKIfRnQcy/fzKLFlBkMKkS21KsUAAVYsDxysBa2Y4eshCC2sspmhBY+nSE
	zCcNDUpwuvFq0bdTnfHxmiYpMR2eUvk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-Rlh157FMOX68u7okX48Q5Q-1; Wed,
 14 Aug 2024 17:45:21 -0400
X-MC-Unique: Rlh157FMOX68u7okX48Q5Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D74F19332AC;
	Wed, 14 Aug 2024 21:45:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC7E219560A3;
	Wed, 14 Aug 2024 21:45:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 47ELjGVC3533564
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 14 Aug 2024 17:45:16 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 47ELjFXx3533563;
	Wed, 14 Aug 2024 17:45:15 -0400
Date: Wed, 14 Aug 2024 17:45:15 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/2] libmpathcmd: reinstate ABI 1.0.0
Message-ID: <Zr0laySsCt7dfdjt@redhat.com>
References: <20240813094046.21644-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240813094046.21644-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 13, 2024 at 11:40:45AM +0200, Martin Wilck wrote:

For the set:
Tested-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> __mpath_connect() was part of our public ABI. Instead of removing
> it completely, define it as a weak alias of the new mpath_connect__().
> This way, programs linked against previous versions of libmpathcmd
> will continue to work.
> 
> This shouldn't interfere with general symbol naming rules, as a weak
> symbol won't override a library symbol of the same name.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathcmd/libmpathcmd.version | 12 ++++++++----
>  libmpathcmd/mpath_cmd.c         |  3 +++
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/libmpathcmd/libmpathcmd.version b/libmpathcmd/libmpathcmd.version
> index a786c25..81bdb2b 100644
> --- a/libmpathcmd/libmpathcmd.version
> +++ b/libmpathcmd/libmpathcmd.version
> @@ -10,16 +10,20 @@
>   *
>   * See libmultipath.version for general policy about version numbers.
>   */
> -LIBMPATHCMD_2.0.0 {
> +
> +LIBMPATHCMD_1.0.0 {
>  global:
>  	mpath_connect;
> -	mpath_connect__;
> +	__mpath_connect;
>  	mpath_disconnect;
>  	mpath_process_cmd;
>  	mpath_recv_reply;
>  	mpath_recv_reply_len;
>  	mpath_recv_reply_data;
>  	mpath_send_cmd;
> -local:
> -	*;
>  };
> +
> +LIBMPATHCMD_1.1.0 {
> +global:
> +	mpath_connect__;
> +} LIBMPATHCMD_1.0.0;
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index 1fa036c..a38e8b6 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -133,6 +133,9 @@ int mpath_connect__(int nonblocking)
>  	return fd;
>  }
>  
> +extern int __mpath_connect(int)
> +	__attribute__((weak, alias("mpath_connect__")));
> +
>  /*
>   * connect to a unix domain socket
>   */
> -- 
> 2.46.0

