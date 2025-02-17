Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091941A5B9D
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 22:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739832908; cv=none; b=S+ETljtvMpPntnpKHLLVT1D9qtX2efmcUzTEFkn++9YGSvm+vwR7kj62A337cBLiOpNmwolZ0xhPQyKSiYxG9Y7pFiNEEm9aBNYm4CBN2Wfdj7LVlAwRgSDVxx+4GCuPQudTU3wbvZwneJ/XboetCpC1/dmiIcKY0Ve7uE44IsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739832908; c=relaxed/simple;
	bh=XIPw4lL5wkRExB08qqJJDdfDUb+MKJ/rDKhMQZ0wo2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Q4rAoS4iSMrOj7X80HPshlZLXl5sR4prgzMpJKQrrUkjb1iN/S5eWWpbol4AKZMyweiJoX/MOhF71+7bNmKngVHdpOcypYG14q628HWO8AoYJSFIszKe2IS4lYPk61VeAIgQwBBuoBu1DI5Bv7EHvNuED31eAiQbj+Bcpl50hrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JLnMM2jL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JLnMM2jL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739832905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pV776y2szEt4F5tHDh5jcujZULRDknTsrfgxCApglI8=;
	b=JLnMM2jLAGD95m6Iec1RIBqzgEj104L//tS2ZlH7cF4eUID9Q7GfiMDsoOM5b56mTKpKP6
	mZNmWYhHXi1RUuhfkHuWO6+IkRY2OCH/6LzzrzYPTxykpIQVc+T5FxT3IyyWtio1aXY0F+
	K5Q4W6pr7CpF3Cpz1v59FQcfGVzVmWc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-dh7qsx3GMJW7h341nQCZ-g-1; Mon,
 17 Feb 2025 17:55:04 -0500
X-MC-Unique: dh7qsx3GMJW7h341nQCZ-g-1
X-Mimecast-MFC-AGG-ID: dh7qsx3GMJW7h341nQCZ-g_1739832903
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8729B19039C1;
	Mon, 17 Feb 2025 22:55:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 354821800362;
	Mon, 17 Feb 2025 22:55:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51HMt1Yi3050029
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 17:55:01 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51HMt1N33050028;
	Mon, 17 Feb 2025 17:55:01 -0500
Date: Mon, 17 Feb 2025 17:55:01 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Alice Frosi <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 04/10] libmpathutil: move systemd_listen_fds() support
 into multipathd
Message-ID: <Z7O-RUP9bv4h552T@redhat.com>
References: <20250214221011.136762-1-mwilck@suse.com>
 <20250214221011.136762-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250214221011.136762-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 20N_Ny4VX3YqLcCnHBLEhWvQNHs5x_KoarG2k08lvPg_1739832903
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2025 at 11:10:05PM +0100, Martin Wilck wrote:
> This feature is only used by multipathd.

We should probably move all of ux_socket_listen() to multipathd, since
it's only used there. But I see why you split out this code, and moving
ux_socket_listen() can happen whenever.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/uxsock.c | 15 ---------------
>  multipathd/main.c     | 28 +++++++++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
> index 889d7a1..59c4717 100644
> --- a/libmpathutil/uxsock.c
> +++ b/libmpathutil/uxsock.c
> @@ -46,23 +46,8 @@ int ux_socket_listen(const char *name)
>  {
>  	int fd;
>  	size_t len;
> -#ifdef USE_SYSTEMD
> -	int num;
> -#endif
>  	struct sockaddr_un addr;
>  
> -#ifdef USE_SYSTEMD
> -	num = sd_listen_fds(0);
> -	if (num > 1) {
> -		condlog(3, "sd_listen_fds returned %d fds", num);
> -		return -1;
> -	} else if (num == 1) {
> -		fd = SD_LISTEN_FDS_START + 0;
> -		condlog(3, "using fd %d from sd_listen_fds", fd);
> -		return fd;
> -	}
> -#endif
> -
>  	/* This is after the PID check, so unlinking should be fine */
>  	if (name[0] != '@' && unlink(name) == -1 && errno != ENOENT)
>  		condlog(1, "Failed to unlink %s", name);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 52630f7..5455bdf 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1863,15 +1863,41 @@ uevqloop (void * ap)
>  	pthread_cleanup_pop(1);
>  	return NULL;
>  }
> +
> +#ifdef USE_SYSTEMD
> +static int get_systemd_sockets(long *ux_sock)
> +{
> +	int num = sd_listen_fds(0);
> +
> +	if (num > 1) {
> +		condlog(3, "sd_listen_fds returned %d fds", num);
> +		return -1;
> +	} else if (num == 1) {
> +		ux_sock[0] = SD_LISTEN_FDS_START + 0;
> +		condlog(3, "using fd %ld from sd_listen_fds", ux_sock[0]);
> +	}
> +	return num;
> +}
> +#else
> +static int get_systemd_sockets(long *ux_sock __attribute__((unused)))
> +{
> +	return 0;
> +}
> +#endif
> +
> +
>  static void *
>  uxlsnrloop (void * ap)
>  {
>  	long ux_sock;
> +	int num;
>  
>  	pthread_cleanup_push(rcu_unregister, NULL);
>  	rcu_register_thread();
>  
> -	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
> +	num = get_systemd_sockets(&ux_sock);
> +	if (num < 1)
> +		ux_sock = ux_socket_listen(DEFAULT_SOCKET);
>  	if (ux_sock == -1) {
>  		condlog(1, "could not create uxsock: %d", errno);
>  		exit_daemon();
> -- 
> 2.48.1

