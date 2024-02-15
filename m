Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F763FEF
	for <dm-devel@lists.linux.dev>; Thu, 15 Feb 2024 03:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707966316; cv=none; b=tZOB13UHT99ctv+/Xr+hk/eEQ7zvjiLxJIlckymkfpkn6M7vYxj7qWT+pIyPhK6gjBLJCpS6qidUw7EfDlUuCXXcklXBBrj0DFTdS42k4j2fvgVVslRMEakm5bH6TTT/zqgY2F3sDon1vB8k4naAsyR2AlVbHlJajgfL6O8KjHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707966316; c=relaxed/simple;
	bh=VcOR1g8JVzORymOrDjnHbeCkaKHWD+3bwWHLwvzxOgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ciIBrULP4EhwHMVZ7wUfy5qMtRgMw1K7jU0laE+1H1+5iA4cIwJbJi+kaZms8/759aZh3BKkmUSc0uhxhB0YIg4ffE0/2lnDwXvNIt7Ny72Lyu0qBIDXzdGZDxrK+OyNUC6n9YyekP77XEtYnf/wy2X03Q2kBisVPgVUfPmo2nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAD+cQlO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAD+cQlO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707966313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RQCBvaFS+LmyOsL8PqaYomgZRJycpjLkOfddFdlNW9Q=;
	b=iAD+cQlOXFHXgTyWNJ/VDgFV57sE4wqu6g2bKO6YWrLaDLTkUoW6+DBpnrkuz9hpJLU1ZN
	N0umhWP7DoqcOkloZfLCaOgZD46EhLtj72k266Mpdbp1S3Rch3SiOSH3G24Kazzl3O1o0S
	fNTt3AG4X9MA9e1XriGfcAFyO96XtUo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-L2CVD4dAOkCXCdVwzoYEQw-1; Wed, 14 Feb 2024 22:05:08 -0500
X-MC-Unique: L2CVD4dAOkCXCdVwzoYEQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AE5C84C65B;
	Thu, 15 Feb 2024 03:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 154D140C9444;
	Thu, 15 Feb 2024 03:05:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41F357oj416441
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 14 Feb 2024 22:05:07 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41F357BD416440;
	Wed, 14 Feb 2024 22:05:07 -0500
Date: Wed, 14 Feb 2024 22:05:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH v3] 11-dm-mpath.rules: handle reloads during coldplug
 events
Message-ID: <Zc1_Y02vEdqiaHrz@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240210171327.11811-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240210171327.11811-1-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 10, 2024 at 06:13:27PM +0100, Martin Wilck wrote:
> If a map reload happens while udev is processing rules for a coldplug
> event, DM_SUSPENDED may be set if the respective test in 10-dm.rules
> happens while the device is suspened. This will cause the rules for all
> higher block device layers to be skipped. Record this situation in an udev
> property. The reload operation will trigger another "change" uevent later,
> which would normally be treated as a reload, and be ignored without
> rescanning the device. If a previous "coldplug while suspended" situation is
> detected, perform a full device rescan instead.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> ---
> Changes wrt v3:
>  - restore DM_COLDPLUG_SUSPENDED from DB lest it get lost
>    (Ben Marzinski)
> 
> ---
>  multipath/11-dm-mpath.rules.in | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index fd8d202..30d6e78 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -5,9 +5,16 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
>  IMPORT{db}="MPATH_DEVICE_READY"
>  
> +# Coldplug event while device is suspended (e.g. during a reload)
> +ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
> +	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
> +	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
> +
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
> -ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
> +ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
> +	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> +	GOTO="scan_import"
>  
>  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
>  
> @@ -43,6 +50,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
>  ENV{MPATH_DEVICE_READY}="1"
>  
>  LABEL="mpath_action"
> +
> +# A previous coldplug event occurred while the device was suspended.
> +# Activation might have been partially skipped. Activate the device now,
> +# i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
> +IMPORT{db}="DM_COLDPLUG_SUSPENDED"
> +ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{DM_SUSPENDED}!="1", \
> +	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
> +	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
> +	GOTO="force_activation"
> +
>  # DM_SUBSYSTEM_UDEV_FLAG0 is the "RELOAD" flag for multipath subsystem.
>  # Drop the DM_ACTIVATION flag here as mpath reloads tables if any of its
>  # paths are lost/recovered. For any stack above the mpath device, this is not
> @@ -57,6 +74,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
>  ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
>  	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
>  
> +LABEL="force_activation"
> +
>  # Do not initiate scanning if no path is available,
>  # otherwise there would be a hang or IO error on access.
>  # We'd like to avoid this, especially within udev processing.
> @@ -99,6 +118,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
>  
>  LABEL="import_end"
>  
> +# Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
> +ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
> +
>  # Multipath maps should take precedence over their members.
>  ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
>  
> -- 
> 2.43.0

