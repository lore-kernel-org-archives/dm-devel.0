Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59CC173
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 22:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711491457; cv=none; b=SO0BXcZD9LXVs6FisEB3p0N6HbjnSJBvb2cTP2bVuOTAa4g/3nVvzrhkSJTa2SJPVN2GQ0ivhD/EmZz8hc4C7vj+U5G9dNMg5BMHwOYS11UXI0rAQLgChiZbPewB72+yptiN5NA/Q9wmQyaQ0o8xfNeYrz6kQHSriCXY/w7mBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711491457; c=relaxed/simple;
	bh=bSB25Wrw/Zhztebq/fj5c3XPoNT9i9sI3DeNm40icNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=eOEvja93ReeSRvOFi8RXn1me6yd1VWtM3P+Uzd5C5ywnJcv6gRo1zzMMRLPqCmOhBkjn82Az00m8wGNP2ALOA2uZiBfN8zoV+ZTqroLt6t1NZAoY+p7u9HaBH59PY02D8lpPfnbos1gNw8Z5dj/zBfJDMNMcmeLKA8Fydh/ewL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8Gopd08; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8Gopd08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711491454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KLXodXYghHgZgpfOitbpYHUOk1vbLCCmnhMqI8i5cSE=;
	b=a8Gopd08IZFqzp1sdnwdRvYfW5FpUxZahZQfohHWjyI8LLxyETA777pRQ8oHvq4CZpb37T
	kkCQk2xr6kF0EJCqdbJc0VncbHp2K1UxATnhZD/tnuIG0KxtAQ4TXyLDjGxuDF7Xo5t5nD
	aOzLyZTLuQyzPy64mDUPLJEG++NIG7c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-PzEiYPI9NgqVJCIoclpILw-1; Tue, 26 Mar 2024 18:17:33 -0400
X-MC-Unique: PzEiYPI9NgqVJCIoclpILw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADADE8007A7;
	Tue, 26 Mar 2024 22:17:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A65DF40F4406;
	Tue, 26 Mar 2024 22:17:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 42QMHWDp1407301
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 26 Mar 2024 18:17:32 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 42QMHWWg1407300;
	Tue, 26 Mar 2024 18:17:32 -0400
Date: Tue, 26 Mar 2024 18:17:32 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Peter Rajnoha <prajnoha@redhat.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 04/11] 11-dm-mpath.rules: adapt MPATH_DEVICE_READY=0
 logic to 10-dm.rules update
Message-ID: <ZgNJfL9ULHJpCzAH@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240324211301.7200-1-mwilck@suse.com>
 <20240324211301.7200-5-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240324211301.7200-5-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 24, 2024 at 10:12:54PM +0100, Martin Wilck wrote:
> With the late patches for 10-dm.rules, DM_UDEV_DISABLE_OTHER_RULES_FLAG isn't
> restored from the udev database any more, so we don't need to restore
> the flag to its original state before it is saved to the db.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/11-dm-mpath.rules.in | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 5259b86..997e3e7 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -84,23 +84,25 @@ ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
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
> +ENV{DM_UDEV_RULES_VSN}!="3",

Can't we do something like:

ENV{DM_UDEV_RULES_VSN}=="1|2",

instead, that wouldn't break on future version number bumps.

> +	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
> +ENV{DM_NOSCAN}="1", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +GOTO="dont_activate"
> +
> +LABEL="mpath_is_ready"
>  
>  # If the device comes back online, set DM_ACTIVATION so that
>  # upper layers do a rescan. If the device is currently suspended,
>  # we have to postpone the activation until the next event.
> -ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
>  ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
>  ENV{DM_SUSPENDED}=="1", GOTO="dont_activate"
>  
> -- 
> 2.43.2

