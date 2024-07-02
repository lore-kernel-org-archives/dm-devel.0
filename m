Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1BB2F4A
	for <dm-devel@lists.linux.dev>; Tue,  2 Jul 2024 18:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719943863; cv=none; b=Khdx30sdrLHiiN/tG2FuUcW2HOUq7q9L1xUoky8tUJjdf/Q91vKerRmUjQgjOwOjF+CU65Ciom1jjuAh0v8Zhi4KB2MCDBGM1a6FjoTp38T364DJnsjOqP3LLGdbrnW2oTWu++Qxc7hApto03J2elw900EARbxbyHnSgpaS3vbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719943863; c=relaxed/simple;
	bh=7X+08PcOZhcsRPAh+uqXhOkqx/0AQgvuXVfaT4dpdPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=ghT+/mGH0JCRcwXmVkB2ADUUvv3MFI0GbpocuarplxsE4wnAkeSoXyjEnR+oFs8oxtxRHpLFvjclN2qS2YtV4oTGRW3PJemTXRuZO1cqgf6Fr+yEaaSqjQsu8UP0p+tjR7K6mLAVWStqgglii0aC5cOSZLRW4X+iY7SP/v7tYKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RdNX72lv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RdNX72lv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719943860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V2A3mNlocVqb3+xr3j6VXPwML3XYulLTOWSFGPrCPr0=;
	b=RdNX72lvUzMPMki9C/uua6f0GgcNqWZBP3WPKw4moErUvG5yln3gR4XFEgOIoiVhjQ6DRl
	rLVL9ojYT4YA0UtC6T1q6FC7mkqX6AIXv5JbxB4Qdj8CgGZ62s59bOm8dyPNoC1n8BsIn8
	rZCx4q2ezyT2VLjkSaSojpfZOsuWNHU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-118-1azF47UhP4WH2MO42U7T9Q-1; Tue,
 02 Jul 2024 14:10:56 -0400
X-MC-Unique: 1azF47UhP4WH2MO42U7T9Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 865EA19560B1;
	Tue,  2 Jul 2024 18:10:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DC0B19560AA;
	Tue,  2 Jul 2024 18:10:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 462IArgo1636715
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Jul 2024 14:10:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 462IArUa1636714;
	Tue, 2 Jul 2024 14:10:53 -0400
Date: Tue, 2 Jul 2024 14:10:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
Message-ID: <ZoRCrVoNbIntNH__@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
 <20240605232254.623290-4-bmarzins@redhat.com>
 <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
 <Zn2wW55XxNn4ju2e@redhat.com>
 <Zn2xzs0uxpWmIMyh@redhat.com>
 <cd066f0b8d24626b0370e4a97dbf1471351dbab9.camel@suse.com>
 <ZoL4TX2evkCyK4pT@redhat.com>
 <d9c5652f9f0a17db466354d4b5d10ca04a959215.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9c5652f9f0a17db466354d4b5d10ca04a959215.camel@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 02, 2024 at 09:34:17AM +0200, Martin Wilck wrote:
> On Mon, 2024-07-01 at 14:41 -0400, Benjamin Marzinski wrote:
> > 
> > 
> > 
> > My purpose in writing 0f850db wasn't to cut down on ioctls. It was to
> > keep set_no_path_retry() from incorrectly handling queueing in cases
> > where no_path_retry was set to a number, and the device had no usable
> > paths.  My purpose in this patch is also to make sure
> > set_no_path_retry() does the right thing. Obviously, this one is more
> > of
> > a corner case, and if instead we were occasionally resyncing with the
> > kernel even when a multipath device had no paths, that would solve
> > this
> > issue, and I'd be fine with dropping this patch.
> 
> That sounds good.
> 
> > So unless it conflicts with work you're already doing, I'll send a
> > new
> > patchset that changes checkerloop() to pull the multipath device
> > updating work out of check_path(). I'm not sure that it makes a lot
> > of
> > sense to change how we loop through the paths, since check_path()
> > does
> > work on some paths that aren't assigned to a multipath device. 
> > Plus
> > different paths in a multipath device will need checking at different
> > times depending on their states anyway, so you can't just go through
> > all
> > the paths at once.
> 
> While I agree that syncing the map state just once per checkerloop and
> map is the right thing, I believe we should do it as soon as we have
> checked all paths that need to be checked for the given map. And that's
> most easily done by looping over the mpath vector, like this:
> 
> for each mpp
>     for each path in mpp
>         if path needs to be checked:
>             check path
>     sync mpp

Huh? Are you suggesting syncing the mpp state every second? That would
be an increase in the number of ioctls we're doing in many cases. For
instance, a 4 path device with all paths working and a default
configuration will sync the map 4 times for every 20 seconds.
Unfortunately, it's possible that all these syncs would happend in a
clump and then we'd wait 20 seconds to rapidly sync 4 times again.  An 8
path device with all paths down would sync 8 times every 5 seconds. In
this case syncing once a second would be less work, but in general this
looks like multipathd doing more ioctls. 

The primary purpose of these periodic syncs is to protect us from
external changes that don't trigger a dm event. This is a rare enough
thing that syncing every max_checkint seems often enough. So is "sync
mpp" just shorthand for "sync mpp if it needs to be synced", or is there
some benefit that I'm overlooking to sync every second?

> 
> for each path
>     if (!pp->mpp and path needs to be checked)
>           check path
> 
> Of course we could do this in multiple steps and move the mpp sync out
> of the path loop first, like you suggested. But if we do this, there
> may be a considerable time delay between checking the paths of a given
> map and syncing the related mpp state, especially on systems with a
> large number of devices, and that might be problematic.
>
> Path status changes are asynchronous by nature, and thus whatever we do
> will not be perfect. IMO it makes sense to do all checks related to a
> given map in as short a time interval as possible. This way we are most
> likely to get a consistent picture of the current state of the map in
> question in the kernel.

I'm not against your idea, but the way to code is now, even doing your
mpp loop doesn't really guarantee that. Just because all the paths get
checked every 20 seconds, doesn't mean that they will be ready to be
checked on the same second. For paths that get added after the multipath
device is created, this is often not the case. And even if the paths
start in sync, there are multiple reasons why they can drop out of sync.

But it we wanted to, we probably could fix that and space the checkers
out better at the same time. I don't think it would be that hard to make
the paths change their next check tick by a second every so often so that
all the paths in the same state from a given multipath device run their
checkers at the same time. We could even make the different multipath
devices spread out when they are checked, so that they aren't trying to
all run their checkers at once.

I'll take a stab at this in my updated patchset.

-Ben

> In the long run, I think what we should do is use asynchronous checkers
> exclusively. And instead of waiting a millisecond for them to complete
> synchronously, we should trigger the path check on all paths (that need
> to be checked) in one go, then wait for all checkers to complete (this
> is the difficult part, I know), and then go over all the results, again
> without waiting for anything.
> 
> Another project I've been wanting to do for a long time :-/
> 
> Regards
> Martin
> 

