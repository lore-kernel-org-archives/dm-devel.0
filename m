Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DB323CB
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 22:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711490627; cv=none; b=QP8hyoo17pBSn78NgU+gPyduB8WlPJarrIPZFyVc2pvtp9gYSIjrm/m6fEomRmkXP/vird8iSq6tpqfETpewOLNtVqv3NN48T/Ct8IstqzDOrTdYCye75LkywRHaiswZGAinNuRAFamvCwUvH7LiGnDIBmDYc39H9ZCFkvbhBN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711490627; c=relaxed/simple;
	bh=eQ1lXV3qapjiVZeJrk4IexVU2KAt8LpsCQe00CXuPxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=OV5r3btwIB1rk98p0jQUg5Vkn+Cfd88zrwjq1hjRfRlbo1Uu2KHgGcT3W3LUJddeseK3Pr0SrwyPRaDh88tWDv2rm80GbmxZIil1BQrBWnBYWoio878EZIQ7JmmyS1g8e4XSVb8nRSXoGLXrfZF5v36YwbMx/i81zSO/d9fP/60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KdAlEjom; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdAlEjom"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711490624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kMh5ykAM64Kbv1aEtmhtdQ1JwvUv+pjWy1bsoeQbgcw=;
	b=KdAlEjomMY0zgrddmx/1S7cSdOnX4JXF2UzGmWYhEEZvE1TASTMGvV6EG5Bh1aOenCk+0y
	crdLCB+RYrmPx6/ZrE6zcLSiXREJCFO0AZ8orLJTk41v1lMuQ5hzUH/EZ/g9rNx3rxdUDr
	DQ/Zcvpe4rUvxKa9gI3ZFQhG/Pgfwww=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-Cy3ZogJRMrOmh5LpU5B1aQ-1; Tue, 26 Mar 2024 18:03:43 -0400
X-MC-Unique: Cy3ZogJRMrOmh5LpU5B1aQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B74BD811E81;
	Tue, 26 Mar 2024 22:03:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB2533C21;
	Tue, 26 Mar 2024 22:03:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QM3gBj1407173
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 18:03:42 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QM3gq11407172;
	Tue, 26 Mar 2024 18:03:42 -0400
Date: Tue, 26 Mar 2024 18:03:42 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 02/11] 11-dm-mpath.rules: don't import DM_NOSCAN from
 udev db
Message-ID: <ZgNGPsAz_H22VEaj@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-3-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-3-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:52PM +0100, Martin Wilck wrote:
> DM_NOSCAN is our "output" flag for 13-dm-disk.rules, and it should
> be treated the same way as DM_UDEV_DISABLE_OTHER_RULES_FLAG, which
> isn't imported from the udev database. The state that we need to
> remember is MPATH_DEVICE_READY, which we've already imported above,
> and we will set the "output" flags accordingly in the "force_activation"
> code path further down.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 3f23108..11b5adf 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -18,9 +18,11 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1
>  
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
> +# Note that .MPATH_DEVICE_READY_OLD=="" here. Thus we won't activate the
> +# device below at mpath_is_ready, which is correct.

Do you mean "force_activation" instead of "mpath_is_ready"?

-Ben

>  ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", \
> -	IMPORT{db}="DM_NOSCAN", IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> -	GOTO="scan_import"
> +	IMPORT{db}="DM_COLDPLUG_SUSPENDED", \
> +	GOTO="force_activation"
>  
>  ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
>  
> -- 
> 2.43.2

