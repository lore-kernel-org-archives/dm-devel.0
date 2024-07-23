Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5CF14F12D
	for <dm-devel@lists.linux.dev>; Tue, 23 Jul 2024 12:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721739117; cv=none; b=NKIkIudRWY9pYwxki2Ly8f0dn6KjGkcLCrpmzdZE1GqjPnWyxzW1tkpwfU0TKb6OKp76ZUNSn67cXsPO6StWxGZrijhh3vQ7fc8TY7zOaJ9yaWTS1inwBjxPjTtKdQJtbomrOlhp7NeBo5cfSX/mPRMAJls6MSir9t0jJtIEgbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721739117; c=relaxed/simple;
	bh=FW3ASI7B4WloxhT43Bd2GKw4fu3amIqaPyLXSn98ITw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=hHBjq8JsnX+4j52uPytdAEWfavvq72fyMhUx2+k3G9363xa8cR9/3LYg1keoeR/DL+94WGIF8ncgDOKtLsK3KwVOtd94bZTQfvucvyik+2K247lXIR2ht3O5PiB2EbhPmFVf1X583hKVCnRjldUqjl3Wy8DgBciH1RsWf5jfa2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tk/IkGAy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tk/IkGAy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721739115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C9ACnWccs//ZrSQH4pXCqAmEw7LzKEedw0HGilN6/H8=;
	b=Tk/IkGAydj0A9+Dm5zlOTsrpx/z5j8XFN++XBuNUFBYUZrVQMEuws6SBPId9sbbHw9jWzp
	A9CWkbGy2kKfaekrgPKOnMKUWb/ff9G++X4kamqWWt6ZlYWkn+vsi8Pc+4veu8OXrCKYjq
	rIV/o370D2S1ZwDDpQ/nflsJDPtKGa8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-H-LNABLUMamD8q3swzcUAg-1; Tue,
 23 Jul 2024 08:51:49 -0400
X-MC-Unique: H-LNABLUMamD8q3swzcUAg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8914D1955D4D;
	Tue, 23 Jul 2024 12:51:47 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87D3E3000192;
	Tue, 23 Jul 2024 12:51:46 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 5F54130C1C17; Tue, 23 Jul 2024 12:51:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 5DD493FD04;
	Tue, 23 Jul 2024 14:51:45 +0200 (CEST)
Date: Tue, 23 Jul 2024 14:51:45 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Khazhismel Kumykov <khazhy@chromium.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <thornber@redhat.com>, 
    Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [RFC PATCH v2] dm ioctl: fix erroneous EINVAL when signaled
In-Reply-To: <20240717231833.2090430-1-khazhy@google.com>
Message-ID: <34139e33-3e7-4895-bd4-2d9f7727e9fb@redhat.com>
References: <CACGdZYKbdyALADEMDV+Vg+eog+UjjgGigEpmJTSKw_64RM8rbA@mail.gmail.com> <20240717231833.2090430-1-khazhy@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Wed, 17 Jul 2024, Khazhismel Kumykov wrote:

> do_resume when loading a new map first calls dm_suspend, which could
> silently fail. When we proceeded to dm_swap_table, we would bail out
> with EINVAL. Instead, attempt to restore new_map and return ERESTARTSYS
> when signaled.
> 
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> ---
>  drivers/md/dm-ioctl.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> v2: don't leak new_map if we can't assign it back to hc.
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index c2c07bfa6471..0591455ad63c 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1181,8 +1181,27 @@ static int do_resume(struct dm_ioctl *param)
>  			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
>  		if (param->flags & DM_NOFLUSH_FLAG)
>  			suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
> -		if (!dm_suspended_md(md))
> -			dm_suspend(md, suspend_flags);
> +		if (!dm_suspended_md(md)) {
> +			r = dm_suspend(md, suspend_flags);
> +			if (r == -EINTR)
> +				r = -ERESTARTSYS;

I'd like to ask why the "EINTR -> ERESTARTSYS" conversion is here and why 
it isn't in dm_suspend?

What do libdevmapper+lvm maintainers think about it? Does lvm hadle EINTR 
by restarting the ioctl syscall? Should we return ERESTARTSYS when suspend 
is interrupted?

Mikulas

