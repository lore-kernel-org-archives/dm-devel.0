Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CCB16E898
	for <dm-devel@lists.linux.dev>; Mon,  1 Jul 2024 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859286; cv=none; b=bp/CK3aT7E1jjNfBcrxt5X+b+ZhT7CHKKSchtApdYDu2tyh0Z7Nr4m4kDruzPS2x/6lQkyJhLDG1C3k4Xr09hubo6Retb6G12uXDjfiA2NU/xwNnlgmOdvmA5wyBEDwXQQEznwC3PIV06YOchD1dDBszAPoqlv+OdYiT9Tx6dng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859286; c=relaxed/simple;
	bh=1074NkyrzjK+N/zlpTwOa6iXRybR3Xps3w+HbTYTPV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ARZBksChd6wWETPJlaIVF0t+MvKOZJ+0csbVkjtnOMRRIUdS6t+sNeDcmgwlM9fYiGl7eEVahGnmAvnM+r3A2rJEJQ4J2Jy2/JxrfNwF6vjEK4DGgtPVXCScV2mWlc3ffvLugIhza5QjPiClPUX6VnNd/VIcqywV4Yb1TaLdVlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N0eW9SF8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N0eW9SF8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719859284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/Vuy+81Rfm3kEwYfokz7uAV3fBjgLq6wgCBEPUKkFk=;
	b=N0eW9SF8yU945S+JEwzmvXKm+pxzhBbX+kbGiR/ch1q5d7t7LxIzErYYw36M/+4HygUTWs
	xtEPIFsQ1lnKofuqxngY6MqGPvCEVt7sAmfBAAw4ZsdF2zPu3FFQewOnD3K+32gN2nOSHm
	QByMhdC5ZvzXljK5Gf6kC54+knm5s4Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-7tgPJynJOmiEU-29SKsqtQ-1; Mon,
 01 Jul 2024 14:41:20 -0400
X-MC-Unique: 7tgPJynJOmiEU-29SKsqtQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C26B19560BA;
	Mon,  1 Jul 2024 18:41:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E460A1956089;
	Mon,  1 Jul 2024 18:41:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 461IfHhC1600207
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Jul 2024 14:41:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 461IfHHQ1600206;
	Mon, 1 Jul 2024 14:41:17 -0400
Date: Mon, 1 Jul 2024 14:41:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
Message-ID: <ZoL4TX2evkCyK4pT@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
 <20240605232254.623290-4-bmarzins@redhat.com>
 <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
 <Zn2wW55XxNn4ju2e@redhat.com>
 <Zn2xzs0uxpWmIMyh@redhat.com>
 <cd066f0b8d24626b0370e4a97dbf1471351dbab9.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cd066f0b8d24626b0370e4a97dbf1471351dbab9.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 27, 2024 at 11:31:56PM +0200, Martin Wilck wrote:
> On Thu, 2024-06-27 at 14:39 -0400, Benjamin Marzinski wrote:
> > On Thu, Jun 27, 2024 at 02:33:00PM -0400, Benjamin Marzinski wrote:
> > > On Thu, Jun 27, 2024 at 09:47:33AM +0200, Martin Wilck wrote:
> > > > On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:


> > > Normally, check_path() will find out and resolve the issue within
> > > seconds. However, if the multipath device lost all its path
> > > devices,
> > > then check_path() won't ever call set_no_path_retry() on it
> > 
> > Err... It won't ever call update_multipath_strings(), which is
> > what will sync the mpp->features string with the kernel and make
> > set_no_path_retry() do the right thing.
> 
> Yeah, check_path() is not the right place for handling maps with no
> paths.
> 
> I have thought for a long time that the periodic checker, instead of
> blindly going through the paths vec, should follow the multipath vec,
> handle each path of the mpp in turn, and when that's done, act on the
> map. If we did it this way, we could also handle the special case of an
> empty map in the checker loop.

Not handling the multipath updated every check_path() makes a lot of
sense. I personally think it's fine, and even a good thing, to
periodically resync the daemon's mpp state with the kernel state, just
to make sure we didn't hit a corner case, since we know that they are
possible.  However, doing it once per checker interval makes more sence
than doing it once for every path per checker interval. I don't think
that buys us anything. We could even do it once every max checker
interval or something.

The only real thing that resyncing on every path check changes is that
it lowers the chance that we could think the path is up while we check
it, when in reality the kernel has already marked it down but we haven't
gotten the event yet. Most of the time when the kernel finds that the
path is down, and immediately after that, the path checker finds that
it's up, it's problem with the path checker not correctly capturing the
actual usability of the path, and we're just going to ping-pong or mark
it as marginal. So there's rarely any advantage in doing this for every
path. 


> Are you suggesting that we call refresh_multipath() (or
> update_multipath_table()) from set_no_path_retry()?

Not exactly. check_path() already calls update_multipath_strings() which
is refresh_multipath() but without the unnecessary call to
dm_get_info(). We probably are calling dm_get_info() more often than we
need to be already. But if we could remove that from
refresh_multipath(), and only call it when necessary(), we could
probably switch all the calls where we sync the state and then call
set_no_path_retry() to use a renamed setup_multipath().


> Before 0f850db ("multipathd: clean up set_no_path_retry"), multipathd
> would always set queue_if_no_path to the value it deemed correct, and I
> think this was ok, and generally race-free. IIUC, the main purpose of
> 0f850db was to avoid unnecessary message ioctls (which would cause
> locking and flag manipulation in the kernel).
> 
> 0f850db introduced the check of the current features string as cached
> by multipathd. Later we added some patches to be more confident that
> this cached string correctly reflects the kernel state, but we can
> never by 100% sure, of course.
> 
> But if we now call refresh_multipath() every time in
> set_no_path_retry(), we'll be replacing one DM ioctl (the original
> dm_message()) with multiple ioctls, while still maintaining a race
> window. That wouldn't make sense to me.

My purpose in writing 0f850db wasn't to cut down on ioctls. It was to
keep set_no_path_retry() from incorrectly handling queueing in cases
where no_path_retry was set to a number, and the device had no usable
paths.  My purpose in this patch is also to make sure
set_no_path_retry() does the right thing. Obviously, this one is more of
a corner case, and if instead we were occasionally resyncing with the
kernel even when a multipath device had no paths, that would solve this
issue, and I'd be fine with dropping this patch.

So unless it conflicts with work you're already doing, I'll send a new
patchset that changes checkerloop() to pull the multipath device
updating work out of check_path(). I'm not sure that it makes a lot of
sense to change how we loop through the paths, since check_path() does
work on some paths that aren't assigned to a multipath device. Plus
different paths in a multipath device will need checking at different
times depending on their states anyway, so you can't just go through all
the paths at once.

-Ben
 
> > > 
> > > Granted, there is an unavoidable race here. It's always possible
> > > that
> > > after multipathd updates the features string, it gets changed
> > > outside of
> > > its control. But this cuts the window down to something small
> > > instead
> > > of anytime after you lost all your paths. Any if you get unlucky
> > > enough
> > > to hit that window, you can just rerun the command and it will
> > > work.
> > > 
> > > My main reason for wanting this is that cli_disable_queueing() (and
> > > friends) is not a command you run all the time. It's a command to
> > > run
> > > when you are cleaning up a mess. It doesn't have to be fast. It has
> > > to
> > > work when things are stuck.
> > > 
> > > Thoughts?
> 
> I remain somewhat confused how this should be handled in general; see
> above. But I won't insist on rejecting your patch.
> 
> Martin

