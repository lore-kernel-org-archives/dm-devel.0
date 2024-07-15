Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405E320EB
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721081346; cv=none; b=sZfUZJDsV7Q/3E5OT9saM9sR0aY8WG0L1cFBt2inECqIVUzuf6rKVSwVUjiNkhKQBZ+pl4At7v55S8vsX96iQtnM/wrh4/Rps2wjuo9+mMS0CB2AbySCr1k1oLHeFRGytP+v4A2sJkJqCA3w/afIO3cMFyXl2HBzw/FvzBTIWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721081346; c=relaxed/simple;
	bh=pgsjwmcK+ZO2hSW5ewsSEYhAlwX62QAK2rzuTPYVU8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CAvEN9Oa4Jx3aZ2E34iDSmquYpgT6t6xJTnyUBtHUoi+2R+L9gI1czgq/9ZaW2WukWSPq+fouYUUedQcgvfasyLFY9qebpqbzekaaFpZ/h8tm/3E6QLO7vCG24SLd5uUuQEPWvy43y6cQ3/8gzVN7X+z1WYWyD+UHYmbELcGXBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F1ONwvEx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F1ONwvEx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721081344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xEylXcvo9UfwQaNfDPrPW3+PBd0puHB2tice0C23SRs=;
	b=F1ONwvExIHdaZbQms0Mt71F2YLnc7fwisyUE/oF+U3/ui4FutdvoJ8YUpcrfMyBv44iQUY
	BkbZoCoNkB4xmAK/zZYIznWl7Z+MFckA8In9yB0AdfoNTZQdGPnYk5WX5FAy0no2DO65v9
	QJsRcoK3jnWOptOKyiVSYVx4Zqm5hBw=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-zcj4Nqd6PEOodSktevehuw-1; Mon,
 15 Jul 2024 18:09:02 -0400
X-MC-Unique: zcj4Nqd6PEOodSktevehuw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F0081955D60;
	Mon, 15 Jul 2024 22:09:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8188A1955F40;
	Mon, 15 Jul 2024 22:09:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FM8wod2095824
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:08:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FM8w342095823;
	Mon, 15 Jul 2024 18:08:58 -0400
Date: Mon, 15 Jul 2024 18:08:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 06/49] kpartx.rules: use @BINDIR@ to locate kpartx
Message-ID: <ZpWd-nPy1SloOaVg@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:14PM +0200, Martin Wilck wrote:
> The path for kpartx should match the installed binary.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  .gitignore                               | 1 +
>  kpartx/Makefile                          | 6 +++---
>  kpartx/{kpartx.rules => kpartx.rules.in} | 2 +-
>  3 files changed, 5 insertions(+), 4 deletions(-)
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
> index 7720a74..849fd36 100644
> --- a/kpartx/Makefile
> +++ b/kpartx/Makefile
> @@ -13,13 +13,13 @@ LIBDEPS += -ldevmapper
>  OBJS := bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
>  	gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
>  
> -all: $(EXEC)
> +all: $(EXEC) kpartx.rules
>  
>  $(EXEC): $(OBJS)
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

