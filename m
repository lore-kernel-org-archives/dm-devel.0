Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741EE804
	for <dm-devel@lists.linux.dev>; Fri,  9 Feb 2024 01:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707440641; cv=none; b=aRmOSDRgYULf/GAywL2OtHHCsX58QGw6NkMrtnZzury8+VSm0Knkmz+2+aRQhvmGxI+/7asD+t4DruVX7xhPBd3pHJJBQlK1PtJkFzLpLFShg6PPmfcogPdLLJnsWsYK42wJXD22XNQRSe0K3QFP6qC5eArDhU0SzLYdIMjItlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707440641; c=relaxed/simple;
	bh=v/REqhH+CtNlfzSjK8f8nju29ie07dyKVXS0Y2Nz1JE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LvzWM9Ddyv2pSHHFbKS27cCcqP4FgA7hGZl3pRnNCwzHWM6muXXcVctzic0h4K7VaEOuh8K1IUyNu6SiXKERebAf0MLdXU2JW7egzcnNd4p0zuLBAP7y5+dHYN9Eel2qVEonWb57H0MpOg2mkn4vScdTTJaqxsyvhRkfCm+BD+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NThtCdEh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NThtCdEh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707440638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6RItae2ixq0t5fVRzcp9Q6SAuhitnwgk2lxySUzfa2Q=;
	b=NThtCdEhHLfwN2ejGlBE7i3oTxVVUgC92YK/hwM6dJztU9fICt+hmK2KzXc2257D5yjj6F
	sunhrNbv0uLbq4NofRBii9yyNUe5e9wosK9AKs6cU1N51pfgGt1IUJGn8qFTtyP2R7zjYa
	Wgqhu0y55sQWyXo96ezAt5kIYXT6+6I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-upQ1tzzCNR6nVlrzsjnCdQ-1; Thu,
 08 Feb 2024 20:03:55 -0500
X-MC-Unique: upQ1tzzCNR6nVlrzsjnCdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF9DF3C02B82;
	Fri,  9 Feb 2024 01:03:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A92671C02EB3;
	Fri,  9 Feb 2024 01:03:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41913sZ9338637
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Feb 2024 20:03:54 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41913svl338636;
	Thu, 8 Feb 2024 20:03:54 -0500
Date: Thu, 8 Feb 2024 20:03:54 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH 4/6] 11-dm-mpath.rules: handle reloads during coldplug
 events
Message-ID: <ZcV5-kpJ2ZylDGBP@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240205124638.17877-1-mwilck@suse.com>
 <20240205124638.17877-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240205124638.17877-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2024 at 01:46:36PM +0100, Martin Wilck wrote:
> If a map reload happens while udev is processing rules for a coldplug
> event, DM_SUSPENDED may be set if the respective test in 10-dm.rules
> happens while the device is suspened. This will cause the rules for all
> higher block device layers to be skipped. Record this situation in an udev
> property. The reload operation will trigger another "change" uevent later,
> which would normally be treated as a reload, and be ignored without
> rescanning the device. If a previous "coldplug while suspended" situation is
> detected, perform a full device rescan instead.

For what it's worth, this seems reasonable. But I do see the issue you
pointed out where we can't trust DM_SUSPENDED.  Perhaps we could track
in multipathd if an add event occured for a path between when we issued
a reload, and when we got the change event (unfortunately, change events
can occur for things other than reloads that multipathd triggers, and
the only way I know to accurately associate a uevent with a reload is by
using dm udev cookies. We have those turned off in multipathd and I
think it would be a good bit of work to turn them back on without
causing lots of waiting with locks held in multipathd). 
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
> index 8fc4a6f..2706809 100644
> --- a/multipath/11-dm-mpath.rules
> +++ b/multipath/11-dm-mpath.rules
> @@ -9,8 +9,13 @@ ENV{DM_ACTION}=="PATH_*", GOTO="check_ready"
>  
>  ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="?*", IMPORT{db}="DM_UDEV_DISABLE_OTHER_RULES_FLAG"
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
>  IMPORT{db}="DM_DISABLE_OTHER_RULES_FLAG_OLD"
> @@ -53,6 +58,16 @@ ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
>  ENV{MPATH_DEVICE_READY}="1"
>  
>  LABEL="mpath_action"
> +
> +# A previous coldplug event occured while the device was suspended.
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
> @@ -67,6 +82,8 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
>  ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
>  	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
>  
> +LABEL="force_activation"
> +
>  # Do not initiate scanning if no path is available,
>  # otherwise there would be a hang or IO error on access.
>  # We'd like to avoid this, especially within udev processing.
> @@ -103,6 +120,9 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
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

