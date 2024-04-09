Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A929F12FB38
	for <dm-devel@lists.linux.dev>; Tue,  9 Apr 2024 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712680748; cv=none; b=F5itLXABT6g0ElEyYJlSQRsl3FeaJt3cUlbSxNv+B9I8M66u4W28MIq1+S7FIbwKDjhmDClz/YZrTGBqlfoNUfJS7eDizsIOQnDN4y9DeZRQA6whu14qN7T67RdquRa/9+rYy1ebw/waRNy8aI4FWEYveY9F6Y9AfutjY42lK+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712680748; c=relaxed/simple;
	bh=cKpIw6m++dVLpJ0Wi6zVLEhX5oUc/qFF2u8rcR6RKrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=CJlBWFoUI/VKTaiojaNc5YrnGsHFhXZ1j9f2+9T/doSUUn32H3RTKOo8kgQzTi2ySUD5r1EWkfHqjnPI/wgbMWwREn1IQBgq5sw5WtyOFnu9+znRxYm4/jD15+wKwMuy48KPTSEsn+9RqX8n6ZpiJB3lyqdcAz4TKrdCY1PQcPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZJuCkuAG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJuCkuAG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712680745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOALl9/g9KVqOaMYwP9lGlyJXeW7PyQ8v/qufAxE0cE=;
	b=ZJuCkuAGIZSifX1VKpDyfu5pgdX6YshaEARgq2WN+3syEnA8LgziubjzH6k5XEJ6kojbcs
	ykSS8cyV5ny7lK4Er1VF61u6jaRNZ/Di24H3w3g8R9PUy9oVEZKlLViWcHf1P0N2GaZ4/M
	m3Bofqwa51mmTBz6VRSd6dyhOtRwyI8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-MFVD6rK4MsiY2eTBg6N8SQ-1; Tue, 09 Apr 2024 12:39:01 -0400
X-MC-Unique: MFVD6rK4MsiY2eTBg6N8SQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEFE7811002;
	Tue,  9 Apr 2024 16:39:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8F5E40B4979;
	Tue,  9 Apr 2024 16:39:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 439Gd0KQ1829730
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 9 Apr 2024 12:39:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 439Gd0MJ1829729;
	Tue, 9 Apr 2024 12:39:00 -0400
Date: Tue, 9 Apr 2024 12:39:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 08/12] 11-dm-mpath.rules: replace DM_NOSCAN by
 .DM_NOSCAN
Message-ID: <ZhVvJClr37ayTfYh@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240409140813.26774-1-mwilck@suse.com>
 <20240409140813.26774-2-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240409140813.26774-2-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 09, 2024 at 04:08:13PM +0200, Martin Wilck wrote:
> We don't need to restore DM_NOSCAN from the db anymore, so we can rename
> it to .DM_NOSCAN, making it a temporary property.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index efc6416..3ae3c05 100644
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
> +ENV{DM_UDEV_RULES_VSN}=="1|2", ENV{DM_NOSCAN}="$env{.DM_NOSCAN}"
> +
>  # Multipath maps should take precedence over their members.
>  ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
>  
> -- 
> 2.44.0

