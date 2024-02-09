Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57965A787
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707505428; cv=none; b=Xt54nuvQHvqn6knh5dZYKRP79rEmXfpuC3YbYq0p0xxpEiZYEBhqjaUKKObb/DferfURpSZ1AM4aMYsScQs7db7lk9xm4JCBMuvweBVtqVURpgxkYbfDW4aTxRvIy01G/Oj8WKVwlhLQQhqN9WzkPrXrAjx8ZBKRLIWJ71a3/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707505428; c=relaxed/simple;
	bh=bd80ddu95jXMbasLjg2euP8r1JnMkOKnJq0SLsJdS30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=BIqY0XnxT9uRfCQklfjg2qTYaSNn6irFffxbsNpbXLdSWMG3W5mcTwnPB7jSXkhhyn+dKKruee5om0prGAPPXg9WIIbqAW2qBZqsvhjReerbt1HPJqu235l5XXSH+TSWfpQb3VAs3HeHpELXNE2OvX+sL08Y8mVxQPsUKad3aVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SyOhg0A6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SyOhg0A6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707505425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hM26hAWBfWdeXgOBLxW4Dv+2HiALbNcg2tN6INKt3MQ=;
	b=SyOhg0A6QYxuqtiuSxywPs72fIzuMVthrAub7B8cLrZ6Qc+2hgGJ3o4KM6ab/wPrSxRcw6
	thXi/Fd7kW+N01cLnY2htzpEpds/tP57dRSr8fCRH6QuszRbYMJRXFpuzVc4UIfR66Cgcu
	dCIaopvbpVB88A60IXDLbYsAkR+BKGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-RI2jEmAoNgahajBFNkGQ1Q-1; Fri, 09 Feb 2024 14:03:43 -0500
X-MC-Unique: RI2jEmAoNgahajBFNkGQ1Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7314D84AF83;
	Fri,  9 Feb 2024 19:03:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69A17492BC6;
	Fri,  9 Feb 2024 19:03:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 419J3hKE348581
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 14:03:43 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 419J3gjP348580;
	Fri, 9 Feb 2024 14:03:42 -0500
Date: Fri, 9 Feb 2024 14:03:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 3/6] 11-dm-mpath.rules: handle reloads during coldplug
 events
Message-ID: <ZcZ3DnlAYmiQjeaT@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240209165513.7661-1-mwilck@suse.com>
 <20240209165513.7661-4-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240209165513.7661-4-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 09, 2024 at 05:55:10PM +0100, Martin Wilck wrote:
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
> ---
>  multipath/11-dm-mpath.rules.in | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 05c4294..3b2c3e1 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -11,8 +11,13 @@ ENV{DM_COOKIE}=="?*", GOTO="check_ready"
>  ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
>  
>  ENV{DM_NOSCAN}!="?*", IMPORT{db}="DM_NOSCAN"
> -GOTO="scan_import"
>  
> +# Coldplug event while device is suspended (e.g. during a reload)
> +ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
> +	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
> +	ENV{DM_COLDPLUG_SUSPENDED}="1"
> +
> +GOTO="scan_import"
>  LABEL="check_ready"
>  
>  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
> @@ -49,6 +54,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
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
> @@ -63,6 +78,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
>  ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
>  	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
>  
> +LABEL="force_activation"
> +
>  # Do not initiate scanning if no path is available,
>  # otherwise there would be a hang or IO error on access.
>  # We'd like to avoid this, especially within udev processing.
> @@ -105,6 +122,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
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

