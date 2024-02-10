Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB18663C
	for <dm-devel@lists.linux.dev>; Sat, 10 Feb 2024 02:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707532731; cv=none; b=SWqov2s+adOuvruT39eAq28pH2rJDbiC3wn11KfL7rHNWSKtgzGYYVxXgKq/dZoe8MbfWGgDu/MP+7xXHS8tcVI+T/11K0GlAGB8vjv8DR5bBPk6rAZGif4MbWwFssRN7H9iWhlD3LbuDeCoo5y45dJp19+mQnluSyw1SO5+Kk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707532731; c=relaxed/simple;
	bh=ip4WYhM1sK0AkPKu4HzbXzSKKQ3cthk6rcc4SadmULs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=O6CrBqbuq3LNiCqWR3zP4I3d1OVOAdBG18xufa+Ea78ZmlH7lO1vNZCzR2IDDxIuLlESlhcHWbaS7xtpSay8WMez95SPhBcIfy9AkbiLKze0B0xD6ovYx1kr7xYmqD4Kxk45auJ5co5Uko7MzvHZrJJqyYCeoKKOgfzNkFS9bqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z2nfFj6H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z2nfFj6H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707532728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2MzcuDW1npGjwzn2gtIcmk+rLC2k83t1aJC1hL49vQs=;
	b=Z2nfFj6HDkR8IEJjhJBmCtCqqHGrJp9yAaevEZsHWcZjnrwJxSY3Ex6DbfW4vPrJlgmdu5
	W96LDlkRIVgVje94yFyeZY4gZsEh33dWrYZGUtS8kJoGWLz4iZnR6oBGX5NGFySia1C8Eq
	FkCeiA66ME1KtZLeX44lfrxCijzVBEg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-hz4AdJrCPi2U9ZgLGAtLlg-1; Fri, 09 Feb 2024 21:38:45 -0500
X-MC-Unique: hz4AdJrCPi2U9ZgLGAtLlg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0787B828CE2;
	Sat, 10 Feb 2024 02:38:45 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1C10AD69;
	Sat, 10 Feb 2024 02:38:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 41A2cieL352722
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Feb 2024 21:38:44 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 41A2ciFM352721;
	Fri, 9 Feb 2024 21:38:44 -0500
Date: Fri, 9 Feb 2024 21:38:44 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, linux-lvm@lists.linux.dev,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: [PATCH v2 6/7] 11-dm-mpath.rules: Don't force activation while
 device is suspended
Message-ID: <ZcbhtFJkq2syENL4@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240209232735.9791-1-mwilck@suse.com>
 <20240209232735.9791-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240209232735.9791-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 10, 2024 at 12:27:34AM +0100, Martin Wilck wrote:
> If paths become available while the device is suspended, don't
> activate. Another uevent will arrive when the device is resumed.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/11-dm-mpath.rules.in | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
> index 8e8741a..4141833 100644
> --- a/multipath/11-dm-mpath.rules.in
> +++ b/multipath/11-dm-mpath.rules.in
> @@ -92,10 +92,16 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
>  ENV{MPATH_DEVICE_READY}=="0", \
>  	ENV{.MPATH_SAVE_DISABLE_OTHER_RULES_FLAG}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}", \
>  	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
> +
>  # If the device comes back online, set DM_ACTIVATION so that
> -# upper layers do a rescan.
> -ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
> -	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
> +# upper layers do a rescan. If the device is currently suspended,
> +# we have to postpone the activation until the next event.
> +ENV{MPATH_DEVICE_READY}=="0", GOTO="dont_activate"
> +ENV{.MPATH_DEVICE_READY_OLD}!="0", GOTO="dont_activate"
> +ENV{DM_SUSPENDED}==1, ENV{MPATH_DEVICE_READY}="0", GOTO="dont_activate"
> +
> +ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
> +LABEL="dont_activate"
>  
>  # The code to check multipath state ends here. We need to set
>  # properties and symlinks regardless whether the map is usable or
> -- 
> 2.43.0

