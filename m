Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FED55FBAF
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712600012; cv=none; b=RJi23tWU/G7tPn46jO+A3BTd6FEvzogzI0JcVEDJq/QmcehhtT36hcByv3NkKZC1/DdPJ2HWCOAK25SeqXU8+8mxWHhn+tUrSJqO6WwNxHC+BkFgH39NamYfBur0GcxyLysV/u3tleOiql7RDzTih8+4uNdiSerevl0dHwTn2J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712600012; c=relaxed/simple;
	bh=ur43Z2LVKW5dKF57l4aV5Hjy2Fl5tblNBCQ2isc4IHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LFZwwsrHTD19EfOYJ/JP7HcWZ8+Ez0438kDytZkBmqtnFu9/hGATklVjhBtH0i2t/ClCm0FF8v43nqXEycXTNzKo1/au3gkvYfkiKwthV34NHEZMz93zJUPeXVGotT+1XIedqcrBSHpMBVXFpPOJAFWFCVXr0DILtj1wvkISXx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g6CK9YNv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g6CK9YNv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712600010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=blfwEODL5cFWLVI3BHMD8OtBFrXX34Cm5pavQJxtQqs=;
	b=g6CK9YNv+2KEy8/FY/Yljr635DZd8yw81bnxF+qYWn+LMPctZ3s9GlXrJWkKXpRrBlBkvq
	GFCdpGo+F7VhSNMm52Em0W4kMEHlmkcjOWInErGPpdOcKDVL8c0wkf/w9lgpSsFsB5FBOJ
	Voc2HONYTkbpLLKZdCyZgKShxx8RysM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-Ovwq47PuMxGAx9Ui-A2wvQ-1; Mon,
 08 Apr 2024 14:13:26 -0400
X-MC-Unique: Ovwq47PuMxGAx9Ui-A2wvQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6744228B6AAE;
	Mon,  8 Apr 2024 18:13:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FCE4492BC7;
	Mon,  8 Apr 2024 18:13:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 438IDQXL1818370
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Apr 2024 14:13:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 438IDPL01818369;
	Mon, 8 Apr 2024 14:13:25 -0400
Date: Mon, 8 Apr 2024 14:13:25 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 04/11] 11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0
 logic to 10-dm.rules update
Message-ID: <ZhQzxVNUHuvvmoJs@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
 <20240404173814.3143-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240404173814.3143-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 07:38:07PM +0200, Martin Wilck wrote:
> With the late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG isn't
> restored from the udev database any more, so we don't need to restore
> the flag to its original state before it is saved to the db.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 4386b6c..2f909c3 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -19,7 +19,7 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
>  # Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
> -# device below at force_activation, which is correct.
> +# device below at mpath_is_ready, which is correct.
>  ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
>  	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
>  	GOTO="force_activation"
> @@ -84,25 +84,27 @@ ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
>  
>  LABEL="force_activation"
>  
> +ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
>  # Do not initiate scanning if no path is available,
>  # otherwise there would be a hang or IO error on access.
>  # We'd like to avoid this, especially within udev processing.
> -ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
> -
> -# Skip all foreign rules if no path is available.
> +# This is communicated to later rules in DM_NOSCAN.
> +# Likewise, skip all foreign rules if no path is available.
>  # Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
> -# to upper layers. The original value will be restored in a late
> -# udev rule.
> -ENV{MPATH_DEVICE_READY}=="0", \
> -	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
> -	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +# to upper layers. With dm rules < v3, save the original value here;
> +# it will be restored in a late udev rule.
> +ENV{DM_UDEV_RULES_VSN}=="1|2", \
> +	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
> +ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +GOTO="dont_activate"
> +
> +LABEL="mpath_is_ready"
>  
>  # If the device comes back online, set DM_ACTIVATION so that
>  # upper layers do a rescan. If the device is currently suspended,
>  # we have to postpone the activation until the next event.
>  # In this case, we have to set MPATH_DEVICE_READY=0; otherwise, the
>  # MPATH_UNCHANGED logic will cause later rules to skipped in the next event.
> -ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
>  ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
>  ENV{DM_SUSPENDED}=="1", ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
>  
> -- 
> 2.44.0

