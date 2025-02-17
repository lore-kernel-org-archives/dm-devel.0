Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8E21A5B9F
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 22:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739833137; cv=none; b=gQX57f8z+5rTNfEEGrtZ6vyH/rDR2/j4oTT6qV/OzfDQR/cNC51W4Cuk+3GZvSevaSu+H/6ApPrPnNkCrw9T6l2fE4PlbwRkYBLwAOBq8gIS2hK5qA1rPOq9vuq9aINEOvjoJM77BGi5gfV9wpyPzP6IHFASXw/8yJ+U2ZJnxTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739833137; c=relaxed/simple;
	bh=wdrSC51F+chIvLlf5UcfIlou0+B9Wn3inEFAJFQSF5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BqS2XMtJFpSslO70RK5r5kcFDX6tNPSc/xnrBICJIxFVYILuf7PXzZbodaNIPtEI0qDb1aBAx6rzR9Kt7hI/uyP+08nD4uj9fDqKIOzc28q80NQs4523HMnYvwxFCKhwzTE7VhaNq1+Hk36ffJAD/fZF2vnelgrwI4rZQUGyt4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8B3jlYp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8B3jlYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739833132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7r4eArzXb17ybeUEA09lln1I/w4yPcV1oMEyMlYx9s=;
	b=C8B3jlYpygfaLRETlyzHc/44XsYyy6iFEwTwcOhhQlhqoNlxrW4t7NulPe4+2iuiT0d0FZ
	MZ80FXCEp96tuzg00LODoCeDZMClKh6LApaKvu+OFQepaCrv5GnGmoiST/2x36G2x0brjE
	S6vhlXvfWYQF6b7VtRMSDWv7hJ7InXQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-144-oEg4keAaOZuaRsC7t0jdwg-1; Mon,
 17 Feb 2025 17:58:49 -0500
X-MC-Unique: oEg4keAaOZuaRsC7t0jdwg-1
X-Mimecast-MFC-AGG-ID: oEg4keAaOZuaRsC7t0jdwg_1739833128
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E04691955F28;
	Mon, 17 Feb 2025 22:58:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5468C1956094;
	Mon, 17 Feb 2025 22:58:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51HMwktA3050130
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 17:58:46 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51HMwjsO3050129;
	Mon, 17 Feb 2025 17:58:45 -0500
Date: Mon, 17 Feb 2025 17:58:45 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Alice Frosi <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 00/10]  multipath-tools: provide pathname and abstract
 sockets
Message-ID: <Z7O_Jecl1zz51xh0@redhat.com>
References: <20250214221011.136762-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250214221011.136762-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fKyJrtAFiW45GlYnpMQanAQOPDya7nPq_VwBFlpLVi0_1739833128
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2025 at 11:10:01PM +0100, Martin Wilck wrote:
> This set is an attempt to fix https://github.com/opensvc/multipath-tools/issues/111

For all patches except for 08, which I have a question about:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> Changes v2 -> v3:
> 
> Many, as a result of further discussions on GitHub. multipathd will now open
> both the abstract socket and the pathname socket /run/multipathd.socket by
> default, and client programs will try both sockets before giving up.  The
> "use_regular_socket=1" build parameter is not necessary any more.
> 
> Note that we'd switched from the regular socket "/var/run/multipath.sock" to
> an abstract socket in bb89077 ("multipathd: switch to abstract sockets for CLI
> commands") in multipath-tools 0.5.0. The rationale back then was that creating
> a pathname socket might fail if the directory structure isn't set up yet. As
> we now create both, and fail only if neither could be created, and as there is
> the early /run directory on modern systems, this argument shouldn't apply to
> this patch set. The name of the socket has been changed in order to indicate
> that the new approach is different from the old one.
> 
> Changes v1 -> v2:
> 
> - Introduced the mpath_fill_sockaddr() helper to cleanup struct sockaddr_un handling,
> in response to comments from Ben Marzinski on GitHub.
> - Fixed double remove of multipathd.socket during "make clean" (Ben).
> 
> Martin Wilck (10):
>   multipath-tools: move DEFAULT_SOCKET definition into Makefile.inc
>   multipath-tools: add helper mpath_fill_sockaddr__()
>   libmpathutil: add support for Unix pathname sockets
>   libmpathutil: move systemd_listen_fds() support into multipathd
>   multipathd: make uxsock_listen() take a pointer to fd
>   multipathd: allow receiving two socket fds from systemd
>   multipathd: listen on pathname and abstract socket by default
>   libmpathcmd: try both abstract and pathname sockets
>   libmpathcmd: honor MULTIPATH_SOCKET_NAME environment variable
>   multipathd: honor MULTIPATH_SOCKET_NAME environment variable
> 
>  .gitignore                                    |  1 +
>  Makefile.inc                                  | 10 +++-
>  create-config.mk                              |  1 +
>  libmpathcmd/mpath_cmd.c                       | 25 ++++++----
>  libmpathcmd/mpath_cmd.h                       |  1 -
>  libmpathcmd/mpath_fill_sockaddr.c             | 32 +++++++++++++
>  libmpathutil/uxsock.c                         | 41 +++++++---------
>  libmultipath/defaults.h                       |  1 -
>  multipathd/Makefile                           |  4 +-
>  multipathd/main.c                             | 48 +++++++++++++++++--
>  ...multipathd.socket => multipathd.socket.in} |  3 +-
>  multipathd/uxlsnr.c                           | 34 +++++++++----
>  multipathd/uxlsnr.h                           |  3 +-
>  13 files changed, 149 insertions(+), 55 deletions(-)
>  create mode 100644 libmpathcmd/mpath_fill_sockaddr.c
>  rename multipathd/{multipathd.socket => multipathd.socket.in} (84%)
> 
> -- 
> 2.48.1

