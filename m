Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4971C9EB1
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 19:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741030934; cv=none; b=d+31dJdmfYs+x7pj1gvbozUOB2M99lJ5sMfzQOuwxR76S2kP4d87Nl0yV4TxEZ6Mhhm4xk2hJH/j/pwoaTJX0jpxQoykuliPM5QY3SGsPtRvyDOADaaQZk1ZI/T0BEDdYS/OjOdhbGY9hv0HEJ73+9+41TexVJNZsZTCelRA8A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741030934; c=relaxed/simple;
	bh=9sLTvg+hR/5f8O2VeCMMdY6n9Vu6OU4rpi+p/O+qriU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ZeymuO7lauD6by+acc+JQtDLtWkruYYE5sWzAXU6eO2IyOza5aKC5taS+3uemKRruW0Wl2c4enWuhP0F4J0Daf6zfzz188AKT3xMPzfdZiO54KtXWWU9V6sHhvf4cfYFvZ0UOD5dnmpaSSLbxV/AHct+3YIt981UsApQBXdUy2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8Qqj0mN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8Qqj0mN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741030931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tjwh/FUHacMUHH3nQwEacbB/UbCHT8i1WstkcGOKFr0=;
	b=M8Qqj0mNuM6zkx4HXOhkRPIvg0ZY9mm0xPMBzaEvi1Q+laRnBc5wcrVdkgxTGHijWx0jNE
	BT0TAIY+Jzprudu83UWeDsDN4Nj8ZQbUYycikb5sPv54xwCrPv6Wauj83Va6bte/R4kzSg
	T+p/VtrH65F1D6InPpzrC+sqQbBtfII=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-55-Hx9kGaTUNuy6xHaQsqnB6w-1; Mon,
 03 Mar 2025 14:42:07 -0500
X-MC-Unique: Hx9kGaTUNuy6xHaQsqnB6w-1
X-Mimecast-MFC-AGG-ID: Hx9kGaTUNuy6xHaQsqnB6w_1741030926
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 200CE1800872;
	Mon,  3 Mar 2025 19:42:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7727B1800359;
	Mon,  3 Mar 2025 19:42:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 523Jg46G2998146
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 3 Mar 2025 14:42:04 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 523Jg3HK2998145;
	Mon, 3 Mar 2025 14:42:03 -0500
Date: Mon, 3 Mar 2025 14:42:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] multipathd: fix hang during shutdown with queuing maps
Message-ID: <Z8YGC5oP9zFM79DC@redhat.com>
References: <20250227174104.206721-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250227174104.206721-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -FNuiEi_FvEx4pOIdXv_UZCN6IRtkOrzwzLw3mxqfQQ_1741030926
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2025 at 06:41:04PM +0100, Martin Wilck wrote:
> Since c9689b6 ("multipathd: Remove dependency on
> systemd-udev-settle.service"), multipathd.service starts very early during
> boot, which in systemd's service ordering logic means that it is stopped
> late. While this is generally a good thing, it means that, when systemd
> unmounts file systems and tears down the block device stack, multipathd
> is still running. Therefore our "queue_without_daemon" logic, which disables
> queuing when multipathd exits, isn't effective yet. If there are any
> multipath maps that are in queueing state at this point in time, the system
> may hang indefinitely.
> 
> To fix that, add a new service which starts later (and thus stops earlier) and
> disables queueing on all multipath maps during shutdown. Similar to lvm2's
> blk-availability.service, the service does nothing when started.
> 
> Fixes: c9689b6 ("multipathd: Remove dependency on systemd-udev-settle.service")

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/Makefile                       | 6 ++++--
>  multipathd/multipathd-queueing.service.in | 9 +++++++++
>  multipathd/multipathd.service.in          | 2 +-
>  3 files changed, 14 insertions(+), 3 deletions(-)
>  create mode 100644 multipathd/multipathd-queueing.service.in
> 
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 61cf1af..4bcee6b 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
>  OBJS += fpin_handlers.o
>  endif
>  
> -all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
> +all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket $(EXEC)-queueing.service
>  
>  $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
>  	@echo building $@ because of $?
> @@ -64,6 +64,7 @@ install:
>  ifdef SYSTEMD
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
> +	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC)-queueing.service $(DESTDIR)$(unitdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).socket $(DESTDIR)$(unitdir)
>  endif
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man8
> @@ -74,11 +75,12 @@ uninstall:
>  	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC) $(DESTDIR)$(bindir)/$(CLI)
>  	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
>  	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(CLI).8
> +	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC)-queueing.service
>  	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).service
>  	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
>  
>  clean: dep_clean
> -	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
> +	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC)-queueing.service $(EXEC).socket
>  
>  include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
>  
> diff --git a/multipathd/multipathd-queueing.service.in b/multipathd/multipathd-queueing.service.in
> new file mode 100644
> index 0000000..18b0ca6
> --- /dev/null
> +++ b/multipathd/multipathd-queueing.service.in
> @@ -0,0 +1,9 @@
> +[Unit]
> +Description=Enable queuing for multipath maps
> +After=local-fs.target remote-fs.target multipathd.service
> +
> +[Service]
> +Type=oneshot
> +RemainAfterExit=yes
> +ExecStart=/bin/true
> +ExecStop=@BINDIR@/multipathd disablequeueing maps
> diff --git a/multipathd/multipathd.service.in b/multipathd/multipathd.service.in
> index b6a25b3..eb58943 100644
> --- a/multipathd/multipathd.service.in
> +++ b/multipathd/multipathd.service.in
> @@ -2,7 +2,7 @@
>  Description=Device-Mapper Multipath Device Controller
>  Before=lvm2-activation-early.service
>  Before=local-fs-pre.target blk-availability.service shutdown.target
> -Wants=systemd-udevd-kernel.socket @MODPROBE_UNIT@
> +Wants=systemd-udevd-kernel.socket multipathd-queueing.service @MODPROBE_UNIT@
>  After=systemd-udevd-kernel.socket @MODPROBE_UNIT@
>  After=multipathd.socket systemd-remount-fs.service
>  Before=initrd-cleanup.service
> -- 
> 2.48.1

