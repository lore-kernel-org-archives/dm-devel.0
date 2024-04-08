Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D3C147C63
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712601623; cv=none; b=jwNnfi2U7kM2DpVSX+8LvN4EKVw66QM6jb0m1b01jrxjn3B8O2GUf+BodhZjoK7RglpqvdK7OdieDaqpNUwKNF+KsenIM2UKYwrbtyo07ESKPOT7zmtatT4RE/sMOXvKSDq6oHK/U/bVXv72FZTE6nAPvLPtguXXvThhr/asjqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712601623; c=relaxed/simple;
	bh=IPPstbh+FghK1J2ZxVoPJIGMg/Dpj0CnH7BxdMtOY8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=JLcAdtOFhqwfZZcGIZ0b1bPLdaz8Wuh5duHI4Krpyd8brnfSwVUGn1xZytp0qVnvacheP/5vGzunlvGaymQrM7idbZAYbpNgwnzxJOiyv2i6N76VqNSBnuCk8u7Uec5pLcQgHLdFgeatl+VGNsvsmBMHjktL64XRf6llsS67VRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dDQ0+8qB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDQ0+8qB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712601619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UltA0jWNulZZJsYxCBcZGHT7QkLLKJB50m2OLeiKzt4=;
	b=dDQ0+8qBPTM6rMxNih6C3rgHrUs1RHm37PQCjDAUSZnJUiqZl9HRQchPZ1q9MpKNr9OzC0
	Ym2TtHU8Xe4b0DMvHS8L6IXjst57wjVbb/9gDHvXWWEGbnsLXpwK60Ge9c2KAHMKRvyZxM
	2bCYBIk5glV4+n6zdbGYDoT98fxQRaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-gXZ5hh5HMF2IeeDaQrcJZQ-1; Mon, 08 Apr 2024 14:40:17 -0400
X-MC-Unique: gXZ5hh5HMF2IeeDaQrcJZQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C248800219;
	Mon,  8 Apr 2024 18:40:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44EFA210FD26;
	Mon,  8 Apr 2024 18:40:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 438IeHag1818599
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Apr 2024 14:40:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 438IeG941818598;
	Mon, 8 Apr 2024 14:40:16 -0400
Date: Mon, 8 Apr 2024 14:40:16 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 07/11] 11-dm-mpath.rules: replace DM_SUSPENDED by
 .DM_SUSPENDED
Message-ID: <ZhQ6ECWVu7imvOqk@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
 <20240404173814.3143-8-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240404173814.3143-8-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 07:38:10PM +0200, Martin Wilck wrote:
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 95126bf..efc6416 100644
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
> @@ -17,7 +20,7 @@ ENV{DM_UDEV_RULES_VSN}!="1|2", ENV{.DM_SUSPENDED}!="1", GOTO="scan_import"
>  # from DB in 10-dm.rules. If the device is not suspended, clear the flag.
>  # This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
>  # equivalent to DM_SUSPENDED==1 || DISK_RO==1
> -ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
> +ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{.DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
>  	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
>  LABEL="mpath_coldplug_end"
>  
> @@ -68,7 +71,7 @@ LABEL="mpath_action"
>  # Activation might have been partially skipped. Activate the device now,
>  # i.e. disable the MPATH_UNCHANGED logic and set DM_ACTIVATION=1.
>  IMPORT{db}="DM_COLDPLUG_SUSPENDED"
> -ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{DM_SUSPENDED}!="1", \
> +ENV{DM_COLDPLUG_SUSPENDED}=="1", ENV{.DM_SUSPENDED}!="1", \
>  	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0", \
>  	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.notice \"Forcing activation of previously suspended device\"", \
>  	GOTO="force_activation"
> @@ -111,7 +114,7 @@ LABEL="mpath_is_ready"
>  # In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
>  # MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
>  ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
> -ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
> +ENV{.DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
>  
>  ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
>  LABEL="dont_activate"
> @@ -145,7 +148,7 @@ IMPORT{db}="ID_PART_GPT_AUTO_ROOT"
>  LABEL="import_end"
>  
>  # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
> -ENV{DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
> +ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
>  
>  # Multipath maps should take precedence over their members.
>  ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
> -- 
> 2.44.0

