Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B910F7FA
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 01:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707440685; cv=none; b=HE/j1pu73DIkWRUImEV+QAHDIVjxUfY5VoTP/8Yf19wc+ZHqvxj5Jyv755KfqjC1LWyevQerxRQNsd62WDcC+9nF+0sOO1rTtW98F+OjDIHQ2n03AzvKulzcy4yyDTDv0MBOA7NtUGcUfZ1Usutp8V0wdIs/oHOycRDZOTA4Z8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707440685; c=relaxed/simple;
	bh=lLQEV+kiGQtdDAKWeYoeD9/1g5jR42PXEmdjUxPe/xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Qsww2l9tyTBz65Dy8vYjZmVE8/jaobGQ/Z1E7vE/hcS4A/ezw950bc0u8UcNPijGkawYhvrIG/O+UKWprmz+vxwVZXxp7jE2H68wobmYrELdPZ5hFRXGtEpIKB7Q0UMbVODlAXy7fNjBCB0D9IQZ7B2/rU3w0aaYTmjdD9q4jzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gsk35IhM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gsk35IhM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707440682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjRPm8jL9KkbZyUkPbuJw/SChlNNGRV13N0SkacPZdE=;
	b=gsk35IhMkQisx9ijo0/ukYSwgmHOYsRZMux1LL9mXHB64zwG5maMovCsr0rMAYyZxyumJp
	dluvJdY/0mlD7c3GyRYoIGO0ApB6soXcLUzCWqny4t8Y4hm7q+UNfrO4s+sjiMV/PSogZy
	6+IRQxCYjTqX+WiZysb9qINYDL2cQQU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-9W-L7XgLNEutSrxuqUsNxw-1; Thu, 08 Feb 2024 20:04:40 -0500
X-MC-Unique: 9W-L7XgLNEutSrxuqUsNxw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5BB510201EA;
	Fri,  9 Feb 2024 01:04:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE3871C02EB3;
	Fri,  9 Feb 2024 01:04:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41914dnb338646
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Feb 2024 20:04:39 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41914dxw338645;
	Thu, 8 Feb 2024 20:04:39 -0500
Date: Thu, 8 Feb 2024 20:04:39 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 5/6] multipath: udev rules: use configured $(bindir) in
 udev rules
Message-ID: <ZcV6JwJTZjfRTSoj@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240205124638.17877-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2024 at 01:46:37PM +0100, Martin Wilck wrote:
> This allows us to remove the lumsy MPATH_SBIN_PATH property and
> related tests.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  .gitignore                                            | 1 +
>  Makefile.inc                                          | 2 +-
>  multipath/{11-dm-mpath.rules => 11-dm-mpath.rules.in} | 5 +----
>  multipath/Makefile                                    | 2 +-
>  multipath/multipath.rules.in                          | 5 +----
>  5 files changed, 5 insertions(+), 10 deletions(-)
>  rename multipath/{11-dm-mpath.rules => 11-dm-mpath.rules.in} (97%)
> 
> diff --git a/.gitignore b/.gitignore
> index 6890e4a..049ffe8 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -16,6 +16,7 @@ multipath/multipath
>  multipath/multipath.8
>  multipath/multipath.conf.5
>  multipath/multipath.rules
> +multipath/11-dm-mpath.rules
>  multipath/tmpfiles.conf
>  multipathd/multipathd
>  multipathd/multipathd.8
> diff --git a/Makefile.inc b/Makefile.inc
> index 06bdd5e..3bcc7c2 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -148,4 +148,4 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
>  
>  %:	%.in
>  	@echo creating $@
> -	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g' $< >$@
> +	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g;s/@MODPROBE_UNIT@/'$(MODPROBE_UNIT)'/g;s:@BINDIR@:'$(bindir)':g' $< >$@
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules.in
> similarity index 97%
> rename from multipath/11-dm-mpath.rules
> rename to multipath/11-dm-mpath.rules.in
> index 2706809..38a0132 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -35,16 +35,13 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0", \
>  # This may not be reliable, as events aren't necessarily received in order.
>  ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
>  
> -ENV{MPATH_SBIN_PATH}="/sbin"
> -TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
> -
>  # Don't run multipath -U during "coldplug" after switching root,
>  # because paths are just being added to the udev db.
>  ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="paths_ok"
>  
>  # Check the map state directly with multipath -U.
>  # This doesn't attempt I/O on the device.
> -PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -U -v1 %k", GOTO="paths_ok"
> +PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
>  ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
>  LABEL="paths_ok"
>  
> diff --git a/multipath/Makefile b/multipath/Makefile
> index 0efb9b2..f8c1f5e 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -5,7 +5,7 @@ include ../Makefile.inc
>  
>  EXEC      := multipath
>  MANPAGES  := multipath.8 multipath.conf.5
> -GENERATED := $(MANPAGES) multipath.rules tmpfiles.conf
> +GENERATED := $(MANPAGES) multipath.rules tmpfiles.conf 11-dm-mpath.rules
>  
>  CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir)
>  CFLAGS += $(BIN_CFLAGS)
> diff --git a/multipath/multipath.rules.in b/multipath/multipath.rules.in
> index 03fa4d7..780bf85 100644
> --- a/multipath/multipath.rules.in
> +++ b/multipath/multipath.rules.in
> @@ -18,9 +18,6 @@ GOTO="end_mpath"
>  
>  LABEL="test_dev"
>  
> -ENV{MPATH_SBIN_PATH}="/sbin"
> -TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
> -
>  # FIND_MULTIPATHS_WAIT_UNTIL is the timeout (in seconds after the
>  # epoch).
>  IMPORT{db}="FIND_MULTIPATHS_WAIT_UNTIL"
> @@ -31,7 +28,7 @@ IMPORT{db}="DM_MULTIPATH_DEVICE_PATH"
>  
>  # multipath -u sets DM_MULTIPATH_DEVICE_PATH and,
>  # if "find_multipaths smart", also FIND_MULTIPATHS_WAIT_UNTIL.
> -IMPORT{program}=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
> +IMPORT{program}=="@BINDIR@/multipath -u %k", \
>  	ENV{.MPATH_CHECK_PASSED}="1"
>  
>  # case 1: this is definitely multipath
> -- 
> 2.43.0

