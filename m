Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9113C7FF
	for <dm-devel@lists.linux.dev>; Wed, 27 Mar 2024 00:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711497993; cv=none; b=NLN8IaQb/E//lHo6C7a4GQZJEN9XwyZ/LeZcnrD00vTHg90L/lroFTndKo6Yj76BEtvBr5BpH41qOizuZEcLwZUHM+FMLZm8x9h+ISBE75Wppo74CbMmkci/OPU/5FWsaXFmx8Ds+RQjCWv+NuoLGpmK2ulfrUXU9FKe/lp5EaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711497993; c=relaxed/simple;
	bh=kyL3cnNdmkxOvnrYFYuc6HIpB9cxhO4KiifAgM871K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=YSZ1+tXCA72JDKsSDb7Rq2+bDtTCVH0SqGcFbkZ21yjcFnwhWr7y3VxMTUr3fN87IXV+JEaZNmZg61PYBP6nBYThdcmw9IKJ6kbfyThjgVV9mzYEnmaxIdqOAw1I36PUlAu6nDzqIC4N6rr9WgzhISXIAO3UF8+T0JdnQRrituU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dG6GqAHH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dG6GqAHH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711497990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sa3TQNLMUpxKyg1NVkRDXBxEunLA0FBCs9eIhuU58qc=;
	b=dG6GqAHHc3Ku2J2iKe9T8U5JN8Srn/1Hod9efabQV9ofca4TCYuRMm507HdjOJvXOPF3we
	aoH1qdHyLtduGCMSm9jiFAXLWG8vt34XycbHBbiyiO/onyOhxFx/lktgQuH0E0CC6WkL4Z
	y6+CVm//E1sEBjDx0tEvj+TIG2SZOuY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-Kb0tvG_-PgSpcDRaE7eeYQ-1; Tue, 26 Mar 2024 20:06:28 -0400
X-MC-Unique: Kb0tvG_-PgSpcDRaE7eeYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9110185A783;
	Wed, 27 Mar 2024 00:06:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2506202451F;
	Wed, 27 Mar 2024 00:06:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42R06RVx1408204
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 20:06:27 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42R06RjA1408203;
	Tue, 26 Mar 2024 20:06:27 -0400
Date: Tue, 26 Mar 2024 20:06:27 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 10/11] 11-dm-mpath.rules: make label names more intuitive
Message-ID: <ZgNjA71p4mXZHhhP@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-11-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-11-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:13:00PM +0100, Martin Wilck wrote:
> The labels "dont_activate" and "scan_import" denote the same code line.
> Remove "dont_activate". Improve two misleading label names.
> 
> Substitutions:
>    dont_activate -> scan_import
>    force_activation -> check_mpath_ready
>    mpath_action -> check_mpath_unchanged
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 2285853..526cca8 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -30,7 +30,7 @@ LABEL="mpath_coldplug_end"
>  # device below at mpath_is_ready, which is correct.
>  ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
>  	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> -	GOTO="force_activation"
> +	GOTO="check_mpath_ready"
>  
>  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
>  
> @@ -38,13 +38,13 @@ ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
>  # table with no active devices. If this happens, mark the
>  # device not ready
>  ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0", \
> -	GOTO="mpath_action"
> +	GOTO="check_mpath_unchanged"
>  
>  # If the last path has failed mark the device not ready
>  # Note that DM_NR_VALID_PATHS is only set for PATH_FAILED|PATH_REINSTATED
>  # events.
>  # This may not be reliable, as events aren't necessarily received in order.
> -ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
> +ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="check_mpath_unchanged"
>  
>  # Don't run multipath -U during "coldplug" after switching root,
>  # because paths are just being added to the udev db.
> @@ -53,7 +53,8 @@ ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="paths_ok"
>  # Check the map state directly with multipath -U.
>  # This doesn't attempt I/O on the device.
>  PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
> -ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
> +ENV{MPATH_DEVICE_READY}="0", GOTO="check_mpath_unchanged"
> +
>  LABEL="paths_ok"
>  
>  # For PATH_FAILED events, keep the existing value of MPATH_DEVICE_READY.
> @@ -61,7 +62,7 @@ LABEL="paths_ok"
>  # table reload where there are active paths. Mark the device ready.
>  ENV{DM_ACTION}!="PATH_FAILED", ENV{MPATH_DEVICE_READY}="1"
>  
> -LABEL="mpath_action"
> +LABEL="check_mpath_unchanged"
>  
>  # A previous coldplug event occurred while the device was suspended.
>  # Activation might have been partially skipped. Activate the device now,
> @@ -70,7 +71,7 @@ IMPORT{db}="DM_COLDPLUG_SUSPENDED"
>  ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
>  	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
>  	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
> -	GOTO="force_activation"
> +	GOTO="check_mpath_ready"
>  
>  # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
>  # Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
> @@ -86,7 +87,7 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
>  ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
>  	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
>  
> -LABEL="force_activation"
> +LABEL="check_mpath_ready"
>  
>  ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
>  # Do not initiate scanning if no path is available,
> @@ -100,18 +101,17 @@ ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
>  ENV{DM_UDEV_RULES_VSN}!="3",
>  	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
>  ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> -GOTO="dont_activate"
> +GOTO="scan_import"
>  
>  LABEL="mpath_is_ready"
>  
>  # If the device comes back online, set DM_ACTIVATION so that
>  # upper layers do a rescan. If the device is currently suspended,
>  # we have to postpone the activation until the next event.
> -ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
> -ENV{.DM_SUSPENDED}=="1", GOTO="dont_activate"
> +ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="scan_import"
> +ENV{.DM_SUSPENDED}=="1", GOTO="scan_import"
>  
>  ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
> -LABEL="dont_activate"
>  
>  # The code to check multipath state ends here. We need to set
>  # properties and symlinks regardless whether the map is usable or
> -- 
> 2.43.2

