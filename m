Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07696339AD
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 23:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UhqN+NQh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698277405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UIhNtWOjEyn89XKE4I7uO6fn3OUMd95AXrItoUQHjmM=;
	b=UhqN+NQhs+uv8PDdq9DooUNlV7l2bL0CN+udnp076aQSLwdIsKg9oaeSjQcsP03tV1tpfU
	Vy5U48MbnjrjrC5go6FMVYabc9xhpNOqoYaCrGmR7Sae3XJzzgUhLSTib6eFODWfzO+4RU
	ISg4Fte14e0tbrGZfzCVnjCQ1cPXDlY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-C3RU_cvoOHy33jBKZC5Vuw-1; Wed, 25 Oct 2023 19:43:21 -0400
X-MC-Unique: C3RU_cvoOHy33jBKZC5Vuw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7188E185A782;
	Wed, 25 Oct 2023 23:43:21 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69E66492BFA;
	Wed, 25 Oct 2023 23:43:21 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39PNhLWA032324
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Oct 2023 19:43:21 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39PNhLMg032323;
	Wed, 25 Oct 2023 19:43:21 -0400
Date: Wed, 25 Oct 2023 19:43:21 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 5/6] multipath-tools: systemd: require
 modprobe@dm_multipath.service
Message-ID: <ZTmoGcvnggb5EGxv@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231024164937.14684-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2023 at 06:49:36PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since 92f0893 ("multipath-tools: install modules-load.d/multipath.conf"), we
> use modules-load.d to load the dm-multipath module early on. That isn't
> optimal, because the module will always be loaded, even if multipathd is
> not running.
> 
> Use systemd's "modprobe@.service" instead to make sure the module is loaded
> before multipathd starts. If "multipath -u" is invoked from udev rules
> before multipathd.service has been started, it will access the socket,
> which will autostart multipathd via socket activation and cause the
> dm-multipath module to be loaded.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/Makefile            | 2 --
>  multipath/modules-load.conf   | 3 ---
>  multipathd/multipathd.service | 2 ++
>  3 files changed, 2 insertions(+), 5 deletions(-)
>  delete mode 100644 multipath/modules-load.conf
> 
> diff --git a/multipath/Makefile b/multipath/Makefile
> index 68cb5ce..a69262b 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -28,7 +28,6 @@ install:
>  	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
> -	$(Q)$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man8
> @@ -44,7 +43,6 @@ endif
>  uninstall:
>  	$(Q)$(RM) $(DESTDIR)$(bindir)/$(EXEC)
>  	$(Q)$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
> -	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
>  	$(Q)$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
>  	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
>  	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
> diff --git a/multipath/modules-load.conf b/multipath/modules-load.conf
> deleted file mode 100644
> index b517d32..0000000
> --- a/multipath/modules-load.conf
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -# load dm-multipath early, both multipathd and multipath depend on it
> -# (note that multipath may be called from udev rules!)
> -dm-multipath
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> index 5a9cde1..40cf32c 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -3,6 +3,8 @@ Description=Device-Mapper Multipath Device Controller
>  Before=lvm2-activation-early.service
>  Before=local-fs-pre.target blk-availability.service shutdown.target
>  Wants=systemd-udevd-kernel.socket
> +Requires=modprobe@dm_multipath.service
> +After=modprobe@dm_multipath.service
>  After=systemd-udevd-kernel.socket
>  After=multipathd.socket systemd-remount-fs.service
>  Before=initrd-cleanup.service
> -- 
> 2.42.0

