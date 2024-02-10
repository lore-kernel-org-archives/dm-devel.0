Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FAC2119
	for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 02:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707531582; cv=none; b=tP9TF6yWQ5C/ibYrs9OxbalwWOEDjP2zVQnhMEmAXS0FeXr2jEbZkcyrrcqBO2aQo9xmreHcaCYqQdcvKXGmGBqJpRllf1F+M1gqBSdoMpWPXbzzr6lqGuzS7iwClrlT/ag9kowDxHOK62CfOrBROzSCe7TMQlBomp0+J5yuV+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707531582; c=relaxed/simple;
	bh=dmRZ4bBlHRc7KTD/rVFEi7QdPg9USnt00pLk3+bkUJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=F4+XcdRvGAjkYVlQCu4beosLuWjfaUXBmL5dw5bykZ3yUczbZwgN+IL4h/89szgZJsWpitii14CF8xEXa6G2rwgikb/NUOgt2gh3gFZXzoEIj5tE4D/jX6E6/TEbTJWieCrJBRjqIiP5TgSY40zGiLsyrRZcX4JSCsTYuWuxM94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FdYg9Hzj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FdYg9Hzj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707531580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hgriPsIPASUgIkcBhsA97t9DltNN45/NStkkH3dWDP0=;
	b=FdYg9HzjEQdRbnEWGa3GLf4FacPqdAdC7NLLHwkkQOcmhRBAo9HXwi9WOP/0MdpJ78I7eE
	FBJA54znpKrPGq8uFN2atR5W1p4ACnEguyyoK8hFO5gCtx1b/67XLUJPbiAzAv37K2JZcC
	fmH5ssqYqhxh0vNqGlRU9RBG8UlKYeo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-ZTeG2fwRN9OWS1tDP3vdYg-1; Fri, 09 Feb 2024 21:19:36 -0500
X-MC-Unique: ZTeG2fwRN9OWS1tDP3vdYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85BFD85A589;
	Sat, 10 Feb 2024 02:19:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E3761C02EB3;
	Sat, 10 Feb 2024 02:19:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41A2JaGo352571
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 21:19:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41A2JaGS352570;
	Fri, 9 Feb 2024 21:19:36 -0500
Date: Fri, 9 Feb 2024 21:19:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH v2 5/7] 11-dm-mpath.rules: clear
 DM_DISABLE_OTHER_RULES_FLAG for coldplug events
Message-ID: <ZcbdOB4iB7P4JF5K@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240209232735.9791-1-mwilck@suse.com>
 <20240209232735.9791-6-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240209232735.9791-6-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 10, 2024 at 12:27:33AM +0100, Martin Wilck wrote:
> For all "spurious" events, which includes coldplug events,
> DM_DISABLE_OTHER_RULES_FLAG will be read from the udev DB in
> 10-dm.rules. Thus if a previous event saw the device in suspended
> state, the flag will be set even if the device has meanwhile
> resumed. Reset the flag if none of the conditions hold that
> would cause it to be set in a genuine uevent in 10-dm.rules.
> 
> It would be cleaner to do this in 10-dm.rules directly, but it
> cannot be done easily, because the flag can also have an origin
> inside lvm itself; lvm sets it for various kinds of logical
> volumes. For generic (non-LVM) dm devices, the flag is only set
> in 10-dm.rules though, so doing this is safe for multipath.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index e31107b..8e8741a 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -9,6 +9,13 @@ ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}=="1", \
>  	PROGRAM="/bin/logger -t 11-dm-mpath.rules -p daemon.warning \"Coldplug event for suspended device\"", \
>  	ENV{DM_COLDPLUG_SUSPENDED}="1", GOTO="scan_import"
>  
> +# Coldplug event. DM_UDEV_DISABLE_OTHER_RULES_FLAG has been restored
> +# from DB in 10-dm.rules. If the device is not suspended, clear the flag.
> +# This is safe for multipath where DM_UDEV_DISABLE_OTHER_RULES_FLAG is basically
> +# equivalent to DM_SUSPENDED==1 || DISK_RO==1
> +ACTION=="add", ENV{DM_ACTIVATION}=="1", ENV{DM_SUSPENDED}!="1", ENV{DISK_RO}!="1", \
> +	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="", GOTO="scan_import"
> +
>  # If this uevent didn't come from dm, don't try to update the
>  # device state
>  ENV{DM_COOKIE}!="?*", ENV{DM_ACTION}!="PATH_*", IMPORT{db}="DM_NOSCAN", GOTO="scan_import"
> -- 
> 2.43.0

