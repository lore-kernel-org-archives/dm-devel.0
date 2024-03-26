Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189321E534
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 23:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711496215; cv=none; b=GAoXZXqG119FEo7f1ZV5nZI4NfI8ikXsD3aWxd9asgU3pLWoa5s2ZhHNB04o58tkgrO/UFStqkowbOvkjlWH2aoclKkAoU5EDYesiM5JrFNfYkWbmar/AjVss9zMqjuC4bXRh4d59dUG2urP3Jmvz8pkyOttgv8vu3KLafd8E7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711496215; c=relaxed/simple;
	bh=dRGeZCdxWTWPh9BIvk4N2J0UPTkT/xpIcnbO65l8w2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=KNNmioiTHZQZE+HnlH5kOtHgwUasYHR7EzimNjHxdOLnWWCWx3HGrXPXlFMFM13ovxwYiJh9NyoH4dCnVxekK3iP5jphijIQB3/gWHnGr9zMi8mCirGX2gSz7UkpJOup9vfh31GXAtqyeIyC44Hbj9yQgFfthee/NpBUQzDbVzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNL5E7r4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNL5E7r4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711496212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aKf1oAEqnkqOt0UkofxMhnIwffMiXbkc66t99tQZJvo=;
	b=FNL5E7r4s16eKHqp+pUV5x5eO+iFha/4mw8G9zPFyRb2GHuXELOW1/7Szjh4/AOzl/98c3
	T1p1p0IHFzyBN1vPPj5D+ucnsrFwAKBHslkPFUc/EqEt0AobO8wMTENqB9JCSWnIeAOM/c
	bAgVMBGagJSmEXw09ymV8z044FPBUjo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-MYFWnfu2O5ydnObky15Jeg-1; Tue, 26 Mar 2024 19:36:48 -0400
X-MC-Unique: MYFWnfu2O5ydnObky15Jeg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7496A8007A3;
	Tue, 26 Mar 2024 23:36:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CE72492BD4;
	Tue, 26 Mar 2024 23:36:48 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QNamTC1407949
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 19:36:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QNam2S1407948;
	Tue, 26 Mar 2024 19:36:48 -0400
Date: Tue, 26 Mar 2024 19:36:48 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 07/11] 11-dm-mpath.rules: replace DM_SUSPENDED by
 .DM_SUSPENDED
Message-ID: <ZgNcEA-pxlpvqqr6@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-8-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-8-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:57PM +0100, Martin Wilck wrote:
> With the late changes to the device mapper rules, DM_SUSPENDED
> is not exported any more. Use .DM_SUSPENDED instead.
> 
> Note that although 11-dm-mpath.rules is not a part of lvm2, it
> can be considered as part of the device-mapper layer (everything
> before 13-dm-disk.rules can), and is thus allowed to use
> .DM_SUSPENDED. In practice .DM_SUSPENDED is equivalent to
> DM_UDEV_DISABLE_OTHER_RULES_FLAG for multipath devices, but
> using .DM_SUSPENDED here makes the intention more obvious.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 8f22954..c4b5685 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -4,8 +4,11 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_end"
>  
>  IMPORT{db}="MPATH_DEVICE_READY"
>  
> +# device-mapper rules v2 compatibility
> +ENV{.DM_SUSPENDED}!="?*", ENV{.DM_SUSPENDED}="$env{DM_SUSPENDED}"
> +
>  # Coldplug event while device is suspended (e.g. during a reload)
> -ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
> +ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{.DM_SUSPENDED}=="1", \
>  	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
>  	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
>  
> @@ -17,7 +20,7 @@ ENV{DM_UDEV_RULES_VSN}=="3", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
>  # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
>  # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
>  # equivalent to DM_SUSPENDED==1 || DISK_RO==1
> -ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
> +ENV{DM_UDEV_RULES_VSN}!="3", ENV{.DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
>  	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
>  LABEL="mpath_coldplug_end"
>  
> @@ -68,7 +71,7 @@ LABEL="mpath_action"
>  # Activation might have been partially skipped. Activate the device now,
>  # i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
>  IMPORT{db}="DM_COLDPLUG_SUSPENDED"
> -ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{DM_SUSPENDED}!="1", \
> +ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \

When I reviewed patch 0001, I wondered if it was o.k. to not force
DM_ACTIVATION to "1" if a device had previously been suspended when
MPATH_DEVICE_READY switched to "1". I thought it might it might be o.k.
because there would be another event when the device resumed, which
would have DM_ACTIVATION set to "1". But if that's the case then we
shouldn't need to worry about a device being suspended when a coldplug
happens. We will get an event when the device resumes, and there's not
much we can do until it gets resumed at any rate. So either patch 0001
is wrong or we can remove this DM_COLDPLUG_SUSPENDED forced activation
code or I'm missing some important difference between the two.

-Ben

>  	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
>  	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
>  	GOTO="force_activation"
> @@ -109,7 +112,7 @@ LABEL="mpath_is_ready"
>  # upper layers do a rescan. If the device is currently suspended,
>  # we have to postpone the activation until the next event.
>  ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
> -ENV{DM_SUSPENDED}=="1", GOTO="dont_activate"
> +ENV{.DM_SUSPENDED}=="1", GOTO="dont_activate"
>  
>  ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
>  LABEL="dont_activate"
> @@ -143,7 +146,7 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
>  LABEL="import_end"
>  
>  # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
> -ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
> +ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
>  
>  # Multipath maps should take precedence over their members.
>  ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
> -- 
> 2.43.2

