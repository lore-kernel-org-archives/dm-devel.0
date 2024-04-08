Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00769144D1A
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 18:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712602066; cv=none; b=OIOdNXzt2Xa2AKzuilnxX7pilfXwKtqOC8DXFihfL8jJv7OKnIsNlxkDg79TlsQ2hgPU2CMY7QLivFqg55U/ZFCQJkbeH+vZZ8JhTsbXxx0wJVYTZyAXss8YBuGcTmkZEtCsaU2GFLwEZS0B/emLc9sPQrZ0Pm+6oehpixLDXb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712602066; c=relaxed/simple;
	bh=chIpzK/fwziwQn4KN9ta6zKXEbW9e7PLUPIaxbqejXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=rrARyQHDgvoLPTYboXTVS/nHas1tbCM12cGZJ7DXyrOcyhK1maoBU1/8+dxSpZv3K6ha3Ft1KaG2nJRYHFxsszLG/CE1wL9k6p0wlHsDgeDjT7yLmEAM2C+tQ0etceCMZd307p06F62UFupt/81w2NxlZI7c3EnRdjT8ptj8t20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JIPJLv1j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JIPJLv1j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712602063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K4rKv2QnbiGjMtmT3sXuNcelARnes1e2/sagWXz52zw=;
	b=JIPJLv1jp+5Zj1h4t05Jc9RWayGwLGSJAxX9HSFCTk3o452Da7oPNIc+k9D/IcDNyyw6sl
	pHtJVQnPMzssmQoiQrIK2Mr4Qjl1vI/76xZP7+5cRCM69jAZ+ivPGfHSZWSEn3+bl6IPLY
	EyhMqDjPv/rsF4K9uLTrKJ+e5hybVkM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-atGGHafcNFCxNVmITTjvnA-1; Mon, 08 Apr 2024 14:47:39 -0400
X-MC-Unique: atGGHafcNFCxNVmITTjvnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EECE38007AD;
	Mon,  8 Apr 2024 18:47:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E65DA47E;
	Mon,  8 Apr 2024 18:47:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 438Ilc9j1818695
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 8 Apr 2024 14:47:38 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 438Ilc5M1818694;
	Mon, 8 Apr 2024 14:47:38 -0400
Date: Mon, 8 Apr 2024 14:47:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 08/11] 11-dm-mpath.rules: replace DM_NOSCAN by
 .DM_NOSCAN
Message-ID: <ZhQ7yrm3jfG4v4zc@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240404173814.3143-1-mwilck@suse.com>
 <20240404173814.3143-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240404173814.3143-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2024 at 07:38:11PM +0200, Martin Wilck wrote:
> We don't need to restore DM_NOSCAN from the db anymore, so we can rename
> it to .DM_NOSCAN, making it a temporary property.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index efc6416..ec55435 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -96,14 +96,14 @@ ENV{MPATH_DEVICE_READY}!="0", GOTO="mpath_is_ready"
>  # Do not initiate scanning if no path is available,
>  # otherwise there would be a hang or IO error on access.
>  # We'd like to avoid this, especially within udev processing.
> -# This is communicated to later rules in DM_NOSCAN.
> +# This is communicated to later rules in .DM_NOSCAN.
>  # Likewise, skip all foreign rules if no path is available.
>  # Use DM_UDEV_DISABLE_OTHER_RULES_FLAG to communicate this
>  # to upper layers. With dm rules < v3, save the original value here;
>  # it will be restored in a late udev rule.
>  ENV{DM_UDEV_RULES_VSN}=="1|2", \
>  	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
> -ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
>  GOTO="dont_activate"
>  
>  LABEL="mpath_is_ready"
> @@ -134,7 +134,7 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
>  ENV{DM_UDEV_RULES_VSN}!="1|2", GOTO="import_end"
>  
>  # Don't import the properties from db if we will run blkid later.
> -ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
> +ENV{.DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
>  
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
> @@ -150,6 +150,9 @@ LABEL="import_end"
>  # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
>  ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
>  
> +# device-mapper rules v2 compatibility for 13-dm-disk.rules
> +ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_NOSCAN}="$env{.DM_NOSCAN}"
> +

You missed a DM_UDEV_RULES_VSN change here.

-Ben

>  # Multipath maps should take precedence over their members.
>  ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
>  
> -- 
> 2.44.0

