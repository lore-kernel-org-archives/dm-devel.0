Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6948A7FF
	for <dm-devel@lists.linux.dev>; Wed, 27 Mar 2024 00:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711497824; cv=none; b=Mpd1/U5HtAjfzYxBgYP4eAV4o80kkyYk86JJQX1LFGqb5x9f9IRUg7AhYVBLJDfLo/h4raT6KYxYoigimpoqjtDgWTJlquxT26xXUVbU+0w/UXLL/e5hcfvbVmoef3DM70uZoPfhR87LA856GPrbM1HPLHwpu+SyYW77c88BOyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711497824; c=relaxed/simple;
	bh=Y7txHa5pJu9TfCj3YzhXcFRcZIrFjowanGw4yJRV15w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=iH8ZkSO9ea5yaHRLeeqfiSuBwvbPC8lWme+B3+Obu3Meaig7mPbjLPHCKGXhCdazE5JUN1/fjM9U+nMqNIDhyNqoP5cB7co1NLwEBjVnRd0Mn3Z0GaJioEehx3RSOu1iNgMiBNPEhhrp1SZN+nMVwe/gz+JEPXBDkunWEDI3YuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FwcD4eXh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FwcD4eXh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711497821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IFV42BrMPAaPfa+0/ds2eUhLja10I1JIhLEDCyTDMAY=;
	b=FwcD4eXh09BLgg59zwaSRb+coRQxQCxAVGm90UI3aWfBBjW4z9G9v3rUlih/mJ3pFItF+L
	Da9HbbOt2asEjHQ/wPMQxDS0W4SKaVC8sp3Y30sqxRDwoW9As/8sK9AIGVUCTls/8RjiS0
	jcKTDSsEgnROs1nQsuegxcgwGSEaCrs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-iEmv0wy6MF6vcpt0qzSsPw-1; Tue, 26 Mar 2024 20:03:37 -0400
X-MC-Unique: iEmv0wy6MF6vcpt0qzSsPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DB7F872801;
	Wed, 27 Mar 2024 00:03:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 169B33C24;
	Wed, 27 Mar 2024 00:03:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42R03aON1408174
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 20:03:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42R03aER1408173;
	Tue, 26 Mar 2024 20:03:36 -0400
Date: Tue, 26 Mar 2024 20:03:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/11] 11-dm-mpath.rules: replace DM_NOSCAN by .DM_NOSCAN
Message-ID: <ZgNiWJNvQVfKJ6VG@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-9-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-9-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:58PM +0100, Martin Wilck wrote:
> We don't need to restore DM_NOSCAN from the db anymore, so we can rename
> it to .DM_NOSCAN, making it a temporary property.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index c4b5685..8833e08 100644
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
>  ENV{DM_UDEV_RULES_VSN}!="3",
>  	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
> -ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +ENV{.DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
>  GOTO="dont_activate"
>  
>  LABEL="mpath_is_ready"
> @@ -132,7 +132,7 @@ ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", GOTO="import_end"
>  ENV{DM_UDEV_RULES_VSN}=="3", GOTO="import_end"
>  
>  # Don't import the properties from db if we will run blkid later.
> -ENV{DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
> +ENV{.DM_NOSCAN}!="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}!="1", GOTO="import_end"
>  
>  IMPORT{db}="ID_FS_TYPE"
>  IMPORT{db}="ID_FS_USAGE"
> @@ -148,6 +148,9 @@ LABEL="import_end"
>  # Reset previous DM_COLDPLUG_SUSPENDED if activation happens now
>  ENV{.DM_SUSPENDED}!="1", ENV{DM_ACTIVATION}=="1", ENV{DM_COLDPLUG_SUSPENDED}=""
>  
> +# device-mapper rules v2 compatibility for 13-dm-disk.rules
> +ENV{DM_UDEV_RULES_VSN}!="3", ENV{DM_NOSCAN}="$env{.DM_NOSCAN}"
> +

Again, I'd prefer

ENV{DM_UDEV_RULES_VSN}="1|2"

>  # Multipath maps should take precedence over their members.
>  ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
>  
> -- 
> 2.43.2

