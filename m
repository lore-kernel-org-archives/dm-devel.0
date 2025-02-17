Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F2D13AA5D
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 22:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739832780; cv=none; b=WI5jI48dKEM7SuuX/RSaBN2ehuTWgHbLvr1axFe6BDxzHu9/TPfM9vScwZyaj71kc6vGISVygMbNKWP3X7YP0dlhL2QM+TPhWZhGAG8vca10/WW6Z3E6QsaBDNKO7Dhnw+X3n0YpZCy1lyJCncZSMLx7M5XREP2U1TgslG5CwUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739832780; c=relaxed/simple;
	bh=2JwNtwY+/dZqoAFfZbHbpeMyz66jZEdSKHfupbBVuck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QhGiFQRTwL3+CAqsXNsIZplMB5uYDAEYU+TTvQ/hhU+Q8bXRqqNSEul/WHYphMmD55Kf7rkJU6iromp2CzZcIEZplyiIGaDKM1Z66JoS0zlsJfpwqRFCxrC8CzEHyO0LALjnTUy1l73rvVufecSqSV6n2vqkSAwJ2ETKLPGiow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wio2w2m3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wio2w2m3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739832777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dDuuCTaUA5NTn5tQ8FMMNA5C9VqfvaOxBpXoQn3wnAE=;
	b=Wio2w2m3EL6Th+ezUIhPIl+45Nzan24/s8KsftfnRNs574ktgvukN85U93gnCWXYqokrX4
	7he3HUlqwyxwWxW7iyRgQgCdiHq6L4kRpMhwEq4ltDQ/SE/TN6G4t6PsqyafpJMhDtIwjZ
	zTC1kGKd1HNSIqKDbpHZX2Fq0YwIbQs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-qpxWG2akPGWdC-7E4eNypw-1; Mon,
 17 Feb 2025 17:52:54 -0500
X-MC-Unique: qpxWG2akPGWdC-7E4eNypw-1
X-Mimecast-MFC-AGG-ID: qpxWG2akPGWdC-7E4eNypw_1739832773
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEE9F1800878;
	Mon, 17 Feb 2025 22:52:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59F381955BCB;
	Mon, 17 Feb 2025 22:52:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 51HMqogA3049914
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 17:52:51 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 51HMqoOc3049913;
	Mon, 17 Feb 2025 17:52:50 -0500
Date: Mon, 17 Feb 2025 17:52:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        Alice Frosi <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 02/10] multipath-tools: add helper
 mpath_fill_sockaddr__()
Message-ID: <Z7O9wklP13F-d90g@redhat.com>
References: <20250214221011.136762-1-mwilck@suse.com>
 <20250214221011.136762-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250214221011.136762-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QypVrULuYBbu203T2zG3urRDf41U_StR23s_73h2CA0_1739832773
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2025 at 11:10:03PM +0100, Martin Wilck wrote:
> Create a static new helper function which is used by both libmpathcmd
> and libmpathutil and fills in the socket address name from the compile-time
> default. The function is able to handle both abstract and pathname sockets,
> but more changes are needed to make the latter actually work.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  .gitignore                                    |  1 +
>  Makefile.inc                                  |  7 ++--
>  create-config.mk                              |  1 +
>  libmpathcmd/mpath_cmd.c                       | 11 ++-----
>  libmpathcmd/mpath_fill_sockaddr.c             | 32 +++++++++++++++++++
>  libmpathutil/uxsock.c                         | 15 ++++-----
>  multipathd/Makefile                           |  4 +--
>  ...multipathd.socket => multipathd.socket.in} |  2 +-
>  8 files changed, 51 insertions(+), 22 deletions(-)
>  create mode 100644 libmpathcmd/mpath_fill_sockaddr.c
>  rename multipathd/{multipathd.socket => multipathd.socket.in} (87%)
> 
> diff --git a/.gitignore b/.gitignore
> index 4548cfb..6a1f6fc 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -24,6 +24,7 @@ multipathd/multipathd
>  multipathd/multipathd.8
>  multipathd/multipathc
>  multipathd/multipathd.service
> +multipathd/multipathd.socket
>  mpathpersist/mpathpersist
>  mpathpersist/mpathpersist.8
>  abi.tar.gz
> diff --git a/Makefile.inc b/Makefile.inc
> index 76efeb9..4015006 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -79,7 +79,7 @@ libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr
>  kernel_incdir	:= /usr/include
>  sysdir_bin      := $(sys_execprefix)bin
>  
> -abstract_socket := /org/kernel/linux/storage/multipathd
> +abstract_socket := @/org/kernel/linux/storage/multipathd
>  
>  ifeq ($(V),)
>  Q		:= @
> @@ -117,7 +117,9 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
>  		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
>  		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
>  		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" \
> -		   -DDEFAULT_SOCKET=\"$(abstract_socket)\" -MMD -MP
> +		   -DDEFAULT_SOCKET=\"$(abstract_socket)\" \
> +		   -DWSTRINGOP_TRUNCATION=$(if $(WSTRINGOP_TRUNCATION),1,0) \
> +		   -MMD -MP
>  CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
>  		   -fexceptions
>  BIN_CFLAGS	:= -fPIE -DPIE
> @@ -170,4 +172,5 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
>  		-e 's:@SYSDIR_BIN@:'$(sysdir_bin)': g' \
>  		-e 's:@RUNTIME_DIR@:'$(runtimedir)':g' \
>  		-e 's/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' \
> +		-e 's,@MPATH_SOCKET@,'$(abstract_socket)',g' \
>  		$< >$@
> diff --git a/create-config.mk b/create-config.mk
> index ab163ed..f05fdab 100644
> --- a/create-config.mk
> +++ b/create-config.mk
> @@ -191,6 +191,7 @@ $(TOPDIR)/config.mk:	$(multipathdir)/autoconfig.h
>  	@echo "ERROR_DISCARDED_QUALIFIERS := $(call TEST_CC_OPTION,-Werror=discarded-qualifiers,)" >>$@
>  	@echo "WNOCLOBBERED := $(call TEST_CC_OPTION,-Wno-clobbered -Wno-error=clobbered,)" >>$@
>  	@echo "WFORMATOVERFLOW := $(call TEST_CC_OPTION,-Wformat-overflow=2,)" >>$@
> +	@echo "WSTRINGOP_TRUNCATION := $(call TEST_CC_OPTION,-Wstringop-truncation)" >>$@
>  	@echo "W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)" >>$@
>  	@echo "W_URCU_TYPE_LIMITS := $(call TEST_URCU_TYPE_LIMITS)" >>$@
>  	@echo "ENABLE_LIBDMMP := $(ENABLE_LIBDMMP)" >>$@
> diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> index a38e8b6..5a39471 100644
> --- a/libmpathcmd/mpath_cmd.c
> +++ b/libmpathcmd/mpath_cmd.c
> @@ -24,11 +24,13 @@
>  #include <sys/socket.h>
>  #include <sys/un.h>
>  #include <poll.h>
> +#include <stddef.h>
>  #include <string.h>
>  #include <errno.h>
>  #include <fcntl.h>
>  
>  #include "mpath_cmd.h"
> +#include "mpath_fill_sockaddr.c"
>  
>  /*
>   * keep reading until its all read
> @@ -101,14 +103,6 @@ int mpath_connect__(int nonblocking)
>  	struct sockaddr_un addr;
>  	int flags = 0;
>  
> -	memset(&addr, 0, sizeof(addr));
> -	addr.sun_family = AF_LOCAL;
> -	addr.sun_path[0] = '\0';
> -	strncpy(&addr.sun_path[1], DEFAULT_SOCKET, sizeof(addr.sun_path) - 1);
> -	len = strlen(DEFAULT_SOCKET) + 1 + sizeof(sa_family_t);
> -	if (len > sizeof(struct sockaddr_un))
> -		len = sizeof(struct sockaddr_un);
> -
>  	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
>  	if (fd == -1)
>  		return -1;
> @@ -119,6 +113,7 @@ int mpath_connect__(int nonblocking)
>  			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
>  	}
>  
> +	len = mpath_fill_sockaddr__(&addr, DEFAULT_SOCKET);
>  	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
>  		int err = errno;
>  
> diff --git a/libmpathcmd/mpath_fill_sockaddr.c b/libmpathcmd/mpath_fill_sockaddr.c
> new file mode 100644
> index 0000000..750ef3e
> --- /dev/null
> +++ b/libmpathcmd/mpath_fill_sockaddr.c
> @@ -0,0 +1,32 @@
> +/*
> + * Copyright (c) 2025 SUSE LLC
> + * SPDX-license-identifier: LGPL-2.1-or-newer
> + */
> +
> +static size_t mpath_fill_sockaddr__(struct sockaddr_un *addr, const char *name)
> +{
> +	size_t len;
> +
> +	addr->sun_family = AF_LOCAL;
> +
> +	if (name[0] != '@') {
> +		/* Pathname socket. This should be NULL-terminated. */
> +		strncpy(&addr->sun_path[0], name, sizeof(addr->sun_path) - 1);
> +		addr->sun_path[sizeof(addr->sun_path) - 1] = '\0';
> +		len = offsetof(struct sockaddr_un, sun_path) + strlen(name) + 1;
> +	} else {
> +		addr->sun_path[0] = '\0';
> +		/*

Nitpick: These comment lines are needlessly longer than 80 characters,
but otherwise, everything's fine.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> +		 * The abstract socket's name doesn't need to be NULL terminated.
> +		 * Actually, a trailing NULL would be considered part of the socket name.
> +		 */
> +#pragma GCC diagnostic push
> +#if WSTRINGOP_TRUNCATION
> +#pragma GCC diagnostic ignored "-Wstringop-truncation"
> +#endif
> +		strncpy(&addr->sun_path[1], &name[1], sizeof(addr->sun_path) - 1);
> +#pragma GCC diagnostic pop
> +		len = offsetof(struct sockaddr_un, sun_path) + strlen(name);
> +	}
> +	return len > sizeof(*addr) ? sizeof(*addr) : len;
> +}
> diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
> index 2135476..12c4608 100644
> --- a/libmpathutil/uxsock.c
> +++ b/libmpathutil/uxsock.c
> @@ -6,12 +6,15 @@
>   */
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <string.h>
>  #include <unistd.h>
>  #include <stdarg.h>
> +#include <stddef.h>
>  #include <fcntl.h>
>  #include <sys/ioctl.h>
>  #include <sys/types.h>
>  #include <sys/socket.h>
> +#include <sys/stat.h>
>  #include <sys/un.h>
>  #include <poll.h>
>  #include <signal.h>
> @@ -33,6 +36,8 @@
>  static int _recv_packet(int fd, char **buf, unsigned int timeout,
>  			ssize_t limit);
>  
> +#include "../libmpathcmd/mpath_fill_sockaddr.c"
> +
>  /*
>   * create a unix domain socket and start listening on it
>   * return a file descriptor open on the socket
> @@ -63,15 +68,7 @@ int ux_socket_listen(const char *name)
>  		return -1;
>  	}
>  
> -	memset(&addr, 0, sizeof(addr));
> -	addr.sun_family = AF_LOCAL;
> -	addr.sun_path[0] = '\0';
> -	len = strlen(name) + 1;
> -	if (len >= sizeof(addr.sun_path))
> -		len = sizeof(addr.sun_path) - 1;
> -	memcpy(&addr.sun_path[1], name, len);
> -
> -	len += sizeof(sa_family_t);
> +	len = mpath_fill_sockaddr__(&addr, name);
>  	if (bind(fd, (struct sockaddr *)&addr, len) == -1) {
>  		condlog(3, "Couldn't bind to ux_socket, error %d", errno);
>  		close(fd);
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 997b40c..61cf1af 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -41,7 +41,7 @@ ifeq ($(FPIN_SUPPORT),1)
>  OBJS += fpin_handlers.o
>  endif
>  
> -all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
> +all : $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
>  
>  $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
>  	@echo building $@ because of $?
> @@ -78,7 +78,7 @@ uninstall:
>  	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
>  
>  clean: dep_clean
> -	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service
> +	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES) $(EXEC).service $(EXEC).socket
>  
>  include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
>  
> diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket.in
> similarity index 87%
> rename from multipathd/multipathd.socket
> rename to multipathd/multipathd.socket.in
> index 6a62f5f..c0e86c3 100644
> --- a/multipathd/multipathd.socket
> +++ b/multipathd/multipathd.socket.in
> @@ -7,7 +7,7 @@ ConditionVirtualization=!container
>  Before=sockets.target
>  
>  [Socket]
> -ListenStream=@/org/kernel/linux/storage/multipathd
> +ListenStream=@MPATH_SOCKET@
>  
>  [Install]
>  # Socket activation for multipathd is disabled by default.
> -- 
> 2.48.1

