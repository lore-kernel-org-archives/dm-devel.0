Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E6B6128
	for <dm-devel@lists.linux.dev>; Fri, 27 Oct 2023 20:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BMg8QkAA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698437135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6dr2RKYVS53q6/CzhpRckCaugUEkeVdd/Jo2/0Ho3vU=;
	b=BMg8QkAADA5rw7q9VMYtwtggnVuCUbQGrP3i+ZPNbTIr8qd9KHOsKrh7vcLXgLsey7+Rkf
	czu68tMbDRM3s+L7FY4EBHPa65uTtK2QoXo27oJphFcHrsY5UzfXzQT2p3NzmrPzZ9uYyy
	eLB0cUGC+BMvXlS3DkkZM1fR/PK+Pr8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-473-VNTH_SUGOZKQR-bm1J259A-1; Fri,
 27 Oct 2023 16:05:18 -0400
X-MC-Unique: VNTH_SUGOZKQR-bm1J259A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09A1D3C16DCA;
	Fri, 27 Oct 2023 20:05:18 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFE6240C6F79;
	Fri, 27 Oct 2023 20:05:17 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39RK5H0R049991
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Oct 2023 16:05:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39RK5Hhd049990;
	Fri, 27 Oct 2023 16:05:17 -0400
Date: Fri, 27 Oct 2023 16:05:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH v2 08/14] multipathd.service: require
 modprobe@dm_multipath.service if available
Message-ID: <ZTwX/XzciYqhEmQC@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231026174153.1133-1-mwilck@suse.com>
 <20231026174153.1133-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231026174153.1133-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2023 at 07:41:47PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> systemd v245 and newer provides the modprobe@.service unit, which
> can be used to pull in modules via systemd. This is cleaner than
> loading dm-multipath unconditionally via modules-load.d. Use it
> if the detected systemd version support it.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

I just realized that this should also add multipathd.service to
.gitignore

-Ben

> ---
>  Makefile.inc                                             | 4 +++-
>  multipath/Makefile                                       | 6 ++++--
>  multipathd/Makefile                                      | 4 ++--
>  multipathd/{multipathd.service => multipathd.service.in} | 4 ++--
>  4 files changed, 11 insertions(+), 7 deletions(-)
>  rename multipathd/{multipathd.service => multipathd.service.in} (85%)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 04bfa56..8655cba 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -90,6 +90,8 @@ ORIG_LDFLAGS     := $(LDFLAGS)
>  
>  SYSTEMD_CPPFLAGS := $(if $(SYSTEMD),-DUSE_SYSTEMD=$(SYSTEMD))
>  SYSTEMD_LIBDEPS := $(if $(SYSTEMD),$(if $(shell test $(SYSTEMD) -gt 209 && echo 1),-lsystemd,-lsystemd-daemon))
> +MODPROBE_UNIT := $(shell test "0$(SYSTEMD)" -lt 245 2>/dev/null || \
> +			echo "modprobe@dm_multipath.service")
>  
>  OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
>  WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
> @@ -144,4 +146,4 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
>  
>  %:	%.in
>  	@echo creating $@
> -	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g' $< >$@
> +	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' $< >$@
> diff --git a/multipath/Makefile b/multipath/Makefile
> index 68cb5ce..0efb9b2 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -27,14 +27,16 @@ install:
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 multipath.rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
> -	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
> -	$(Q)$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(tmpfilesdir)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 tmpfiles.conf $(DESTDIR)$(tmpfilesdir)/multipath.conf
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man8
>  	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(mandir)/man8
>  	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(mandir)/man5
>  	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5 $(DESTDIR)$(mandir)/man5
> +	$(Q)$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
> +ifeq ($(MODPROBE_UNIT),)
> +	$(Q)$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
> +endif
>  ifneq ($(SCSI_DH_MODULES_PRELOAD),)
>  	$(Q)$(INSTALL_PROGRAM) -m 644 scsi_dh.conf $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
>  	$(Q)for _x in $(SCSI_DH_MODULES_PRELOAD); do echo "$$_x"; done \
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 0ba6ecb..997b40c 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
>  OBJS += fpin_handlers.o
>  endif
>  
> -all : $(EXEC) $(CLI) $(MANPAGES)
> +all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
>  
>  $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
>  	@echo building $@ because of $?
> @@ -78,7 +78,7 @@ uninstall:
>  	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
>  
>  clean: dep_clean
> -	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES)
> +	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
>  
>  include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
>  
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service.in
> similarity index 85%
> rename from multipathd/multipathd.service
> rename to multipathd/multipathd.service.in
> index 5a9cde1..6d03ff7 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service.in
> @@ -2,8 +2,8 @@
>  Description=Device-Mapper Multipath Device Controller
>  Before=lvm2-activation-early.service
>  Before=local-fs-pre.target blk-availability.service shutdown.target
> -Wants=systemd-udevd-kernel.socket
> -After=systemd-udevd-kernel.socket
> +Wants=systemd-udevd-kernel.socket @MODPROBE_UNIT@
> +After=systemd-udevd-kernel.socket @MODPROBE_UNIT@
>  After=multipathd.socket systemd-remount-fs.service
>  Before=initrd-cleanup.service
>  DefaultDependencies=no
> -- 
> 2.42.0

