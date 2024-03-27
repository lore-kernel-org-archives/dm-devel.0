Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C160800
	for <dm-devel@lists.linux.dev>; Wed, 27 Mar 2024 00:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711497892; cv=none; b=F6rCCf0C13tgWaWy/15dnnB3ZfVoL4RcddzoQL05sKrcqIwUx8mWWluO46tJAm+m6kuSINfBBVoFWVydiFREaKDrMpzAts4nVHl6Bb9G5sZSJzr+tIgVb27SMDL6hWdoOQDlgGS87caM2qx1AzrrKTDQ8l35sXNALF05J8bWe84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711497892; c=relaxed/simple;
	bh=CsHgOXj91ktGUjV1rSxO/kkSnpEAmfwxs/Z1p6YdnVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RkK+5fBTdxdvYs+abFUJFsFkge+T8WeFYhz2LEKSZOlzDWBcpec4gJA7BZBLiZq3kZabZj4SBoDCqDlZ0byvu4vpDCkfzcv3rL/XzipFhqUdt+wGoyN+AnGVK+pegm0Rl2GQTuG8g35CluKUuu8MO+kS59El0q3rv+n7btckJxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sb8PEbSK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sb8PEbSK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711497889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9Ft6QdsA5WalhjDacw+MCI1eFXZXNaHR/8SJFrdIAXw=;
	b=Sb8PEbSK9iVHpod4UVkRZ+PNJH3lVrvTZnfvfIbG0I2sk5HmeCkkF8l/hrChW1yCPCoiZ7
	ElB4tW0nahrK0fJrAV5x80Fo4VZBFvAxbWBnHq1PDwoS0eJ8FF9prD8yZTHQawzvh+C3Aj
	N2xk+i2Tb3+XAn16AJODLRs78aZo6Q8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-MN0eu0kWO06SpQvlAQIzbw-1; Tue, 26 Mar 2024 20:04:47 -0400
X-MC-Unique: MN0eu0kWO06SpQvlAQIzbw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79385800262;
	Wed, 27 Mar 2024 00:04:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 703A0492BC8;
	Wed, 27 Mar 2024 00:04:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42R04llC1408186
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 20:04:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42R04lJ71408185;
	Tue, 26 Mar 2024 20:04:47 -0400
Date: Tue, 26 Mar 2024 20:04:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 09/11] 11-dm-mpath.rules: simplify PATH_FAILED case
Message-ID: <ZgNin9lSqjb332Xq@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-10-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-10-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:59PM +0100, Martin Wilck wrote:
> This combination of a GOTO and a simple rule can be combined
> into a single rule.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 8833e08..2285853 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -56,14 +56,10 @@ PROGRAM=="@BINDIR@/multipath -U -v1 %k", GOTO="paths_ok"
>  ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
>  LABEL="paths_ok"
>  
> -# Don't mark a device ready on a PATH_FAILED event. even if
> -# DM_NR_VALID_PATHS is greater than 0. Just keep the existing
> -# value
> -ENV{DM_ACTION}=="PATH_FAILED", GOTO="mpath_action"
> -
> -# This event is either a PATH_REINSTATED or a table reload where
> -# there are active paths. Mark the device ready
> -ENV{MPATH_DEVICE_READY}="1"
> +# For PATH_FAILED events, keep the existing value of MPATH_DEVICE_READY.
> +# If it's not PATH_FAILED, this event is either a PATH_REINSTATED or a
> +# table reload where there are active paths. Mark the device ready.
> +ENV{DM_ACTION}!="PATH_FAILED", ENV{MPATH_DEVICE_READY}="1"
>  
>  LABEL="mpath_action"
>  
> -- 
> 2.43.2

