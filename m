Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA26B198E80
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720629065; cv=none; b=BlPOA5LE5yI1wGaAnT8BUykr0LREmMmx0yB08IXuL9eg3+hw5DCMmKvezea0BvgTElkCXy5L/lK8nLwtu84mwYAPAbQBhm4mbFuGY0+v1qjRQe44sw5Zpx7djd3JR3zQE2wseXPB2sR+LFtTwKswlDxrvhpycWenJxEVUHHnK20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720629065; c=relaxed/simple;
	bh=647qyCCarnKPBFnuidMLupkwwlECw8a71BbX5bI+erI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=VJcT6deqof/SlrQZ+2eHFuLLVrCZT7Rngg6F/W+rUXSDEuGa2dxWawovwYc3UXHzJ3wHERpgH7R0WVtEgPRuVkG0e7UmbZ2o3j9EvIGMuckq69rWPhydu6phX+5ZvM4RNFzSrEnsyxANk+MBsiMZEx39BvyMUOPd/x6FGP/uF0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NZ++I+Rx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZ++I+Rx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720629062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D+iq3w4KLOgafkfujMH8WGp9rSv3jnYHbEgriYXVueA=;
	b=NZ++I+RxWxY/ZKajM7pdHN3y7Gl16YaW8tLL70dHBLTtDhytzZLHEhA3F32LIhEFh4ZOa8
	eAgQH3ZlqgKoDp1T5+bGcpSIVQp3y+efhWr6DXMeY05mLE8khK2sZ9Ep/rO1Uwxsvi600g
	YGWAkM+FsLtplB3VIIh5U2o6pnogMJY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-564-YyvnL3axNV2yNd5HlGdJTQ-1; Wed,
 10 Jul 2024 12:30:59 -0400
X-MC-Unique: YyvnL3axNV2yNd5HlGdJTQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 746E51955F56;
	Wed, 10 Jul 2024 16:30:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 246A719560AE;
	Wed, 10 Jul 2024 16:30:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46AGUuQE1910216
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 12:30:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46AGUu3T1910215;
	Wed, 10 Jul 2024 12:30:56 -0400
Date: Wed, 10 Jul 2024 12:30:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 06/44] kpartx.rules: use @BINDIR@ to locate kpartx
Message-ID: <Zo63QKdTJPxeBwdo@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:38:57PM +0200, Martin Wilck wrote:
> The path for kpartx should match the installed binary.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  .gitignore                               | 1 +
>  kpartx/Makefile                          | 4 ++--
>  kpartx/{kpartx.rules => kpartx.rules.in} | 2 +-
>  3 files changed, 4 insertions(+), 3 deletions(-)
>  rename kpartx/{kpartx.rules => kpartx.rules.in} (96%)
> 
> diff --git a/.gitignore b/.gitignore
> index 049ffe8..355ddbb 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -12,6 +12,7 @@ config.mk
>  cscope.files
>  cscope.out
>  kpartx/kpartx
> +kpartx/kpartx.rules
>  multipath/multipath
>  multipath/multipath.8
>  multipath/multipath.conf.5
> diff --git a/kpartx/Makefile b/kpartx/Makefile
> index 7720a74..0d4c798 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile

Shouldn't we have

all: $(EXEC) kpartx.rules

so that kpartx.rules gets create when running "make", like happens in the
other makefiles?

-Ben

> @@ -19,7 +19,7 @@ $(EXEC): $(OBJS)
>  	@echo building $@ because of $?
>  	$(Q)$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>  
> -install: $(EXEC) $(EXEC).8
> +install: $(EXEC) $(EXEC).8 kpartx.rules
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
>  	$(Q)$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(libudevdir)
> @@ -41,7 +41,7 @@ uninstall:
>  	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/68-del-part-nodes.rules
>  
>  clean: dep_clean
> -	$(Q)$(RM) core *.o $(EXEC)
> +	$(Q)$(RM) core *.o $(EXEC) kpartx.rules
>  
>  include $(wildcard $(OBJS:.o=.d))
>  
> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules.in
> similarity index 96%
> rename from kpartx/kpartx.rules
> rename to kpartx/kpartx.rules.in
> index 8dd3369..9d87960 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules.in
> @@ -39,6 +39,6 @@ LABEL="mpath_kpartx_end"
>  GOTO="kpartx_end"
>  
>  LABEL="run_kpartx"
> -RUN+="/sbin/kpartx -un -p -part /dev/$name"
> +RUN+="@BINDIR@/kpartx -un -p -part /dev/$name"
>  
>  LABEL="kpartx_end"
> -- 
> 2.45.2

