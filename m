Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B252E3388
	for <dm-devel@lists.linux.dev>; Wed,  5 Mar 2025 03:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741147117; cv=none; b=Gz58og/Iz9Zud8jkpXaSwSr6KY8U/oN2WW6maEYw6tpFA+Zp0yyteRacNlS4yTS7vx8s6kI3x57kJNxmiuFTh8yEptwpLmWm41w5R4HHZ+7vUJzw6zXrhau7EoyZXYFAaigY5s+D0Dd5pv8Qor7UPbPa7kI8GnAiSSubF5K0hXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741147117; c=relaxed/simple;
	bh=LY5DuHpYunf5f3eA/XdyF7Hxk2QhdlwlzyjaAfMXUgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RQY93IpFCxXFRuN95bHdLMCDS2S5Xj25wuZEoB5a+MpbB3VxHLR3m5iuPCKieXz32lha11hxeyT+gB7NMP5OkB4wRjXmUqhpXP5kXN3TUYIV3TMP+zKyBDTg5zA1un3tbSvLyWCRxQ2uSnMv5NGIDlkLy024c6mGIpk0MW92MAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bBsOrncN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bBsOrncN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741147114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjh1hQuW+jeiBBKoKE436K0vWFMdTY1fYMLiqT+RVv8=;
	b=bBsOrncNOacC/0c1m/fGcBG7Z3AbzS5MiHxBfnJCZ7H6aeLwIgwwpw6d+aBt19jX1AUn2q
	4u5GNDaPtd3Znx6EZMgcBMj+pWN041qkfVGRNYyw6zjFlXsLcZZTY3YY6Pf4gINGHQoe3Y
	iCVzwLNaQcCI1SeuY+vfWfbgr8f/1uE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-fAm8sXv3NbqvVCgT-bGYdQ-1; Tue,
 04 Mar 2025 22:58:33 -0500
X-MC-Unique: fAm8sXv3NbqvVCgT-bGYdQ-1
X-Mimecast-MFC-AGG-ID: fAm8sXv3NbqvVCgT-bGYdQ_1741147112
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3405F1954B1B;
	Wed,  5 Mar 2025 03:58:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0622180035E;
	Wed,  5 Mar 2025 03:58:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5253wUh23061987
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 4 Mar 2025 22:58:30 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5253wU073061986;
	Tue, 4 Mar 2025 22:58:30 -0500
Date: Tue, 4 Mar 2025 22:58:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH] libmultipath: remove buggy reinstate_paths function
Message-ID: <Z8fL5nrT5an0eUwY@redhat.com>
References: <20250303195628.2998595-1-bmarzins@redhat.com>
 <a314cad2fc4f78fde0960ba204321fe182ce45d8.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a314cad2fc4f78fde0960ba204321fe182ce45d8.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: olGnbmK3WXa-9iqJm80QEQuNtSqLMAmvwLDhppABSDk_1741147112
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 04, 2025 at 11:30:29PM +0100, Martin Wilck wrote:
> On Mon, 2025-03-03 at 14:56 -0500, Benjamin Marzinski wrote:
> > The purpose of reinstate_paths() is to reinstate all the paths on a
> > multipath device that multipathd thinks are usable, similar to
> > sync_map_state(). However, reinstate_paths() doesn't work correctly.
> > For instance, it will always reinstate every path in enabled (as
> > opposed
> > to active or disabled) pathgroups. This is clearly wrong. It might be
> > badly written code to avoid enabling paths in PATH_GHOST in active
> > pathgroups, but that's just a guess and isn't necessary at any rate.
> > 
> > It's called in two places. The first is when multipath is run with
> > CMD_CREATE. The second is when domap() is run with a mpp->action of
> > ACT_SWITCHPG or ACT_SWITCHPG_RENAME. This case just exists to run
> > extra
> > reinstates for paths that are not in PATH_UP, on pathgroups that are
> > now
> > in the enabled state, instead of the active state. This is old code.
> > I'm
> > not sure if it ever made sense to do this, but it certainly doesn't
> > now.
> > 
> > Multipathd already will make sure that its path states are synced
> > with
> > the kernel states whenever either the paths get checked or a dm event
> > occurs. It makes sense to additionally sync with the kernel state
> > when a
> > multipath device is reloaded, like sync_map_state() currently does,
> > since the path's kernel state will start out of sync with
> > multipathd's
> > state.
> > 
> > However, if multipathd isn't running, I can see the benefit of being
> > able to reinstate paths by running "multipath". So if multipath is
> > run to create or reload multipath devices (CMD_CREATE), it will now
> > call
> > sync_map_state() with a flag to make it behave like reinstate_paths()
> > did (it will only reinstate paths, but never preemptively fail them).
> > I
> > thought about only doing this if check_daemon() said that multipathd
> > wasn't running, but perhaps people are relying on running multipath
> > to reinstate paths before the next scheduled checker run.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> 
> PS: this doesn't look like "stable" material to me. Right?

I don't think so. It's not fixing a bug. I would think code cleanups
don't need to be in the stable branch unless there are stable-worthy
bugfixes that apply on top of them, and its easier to bring back the
cleanup rather than rewrite the bugfix.

-Ben

