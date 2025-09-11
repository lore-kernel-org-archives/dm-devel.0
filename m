Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8BA35A2B1
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757609775; cv=none; b=qo0xMSbmFaZrz/4pbF1qPaxZ0BXx7lP324g0XoEu3AdiM9kepMY2CkM0EzMKajD2tJAhkVhrIgFt0Ga86/0BHMInJWALIm9MreJayMacE9S7BBXA7esQGAtGgUAadGbTJRuPLCpO04kbTvzi4uUtX7QJu5CDXlEK9omddNacylw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757609775; c=relaxed/simple;
	bh=kb8tfJAP+5QjGTMlDP2MX1+fZJYqXtioYR/1Vr4qJCY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=WAgxPp6zybK8Rt/mYZ5YNe+OUAPwWbMCFzmT3jd+gIun4ziZnILWOx0uqWkjA+UyDAzs5u83znegf3ET+teunvERu2gyhrDQOD1imq+RdjzyPkZ/3dcwEbZOqyLGZCSeJp1bZrHdUoHCND/tIwzub7KBpeZbqigqVsOBOzYRIc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQEIgoMR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQEIgoMR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757609771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qoJXZxcI6tGZcYgRMJicGx9NIfCPu9EtVNUsxFdv5zg=;
	b=VQEIgoMRuJsSncV5WM4PXbTpPXx74Zzo6msTLTpaNrjS05I4pXPe/eUdpo5dSfpejJUDZf
	067twYWDHxaiPzBoFPClVkC2zYjFvsR3h1kcUi2kXwUOe7kHoMJQFAZYDE1PsBtw7rpUJT
	ZWty2umd3hBorJfcp6fdedie7KwrwUQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-274Ie_INNA6UIAzDjWlobw-1; Thu,
 11 Sep 2025 12:56:07 -0400
X-MC-Unique: 274Ie_INNA6UIAzDjWlobw-1
X-Mimecast-MFC-AGG-ID: 274Ie_INNA6UIAzDjWlobw_1757609766
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B42571800350;
	Thu, 11 Sep 2025 16:56:06 +0000 (UTC)
Received: from [10.44.32.12] (unknown [10.44.32.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 451D419560B1;
	Thu, 11 Sep 2025 16:56:05 +0000 (UTC)
Date: Thu, 11 Sep 2025 18:56:01 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Robert Beckett <bob.beckett@collabora.com>
cc: dm-devel <dm-devel@lists.linux.dev>, 
    linux-block <linux-block@vger.kernel.org>, kernel <kernel@collabora.com>
Subject: Re: deadlock when swapping to encrypted swapfile
In-Reply-To: <199343ab2a7.11b1e13e161813.4990067961195858029@collabora.com>
Message-ID: <60e5d1ec-3c9d-c6d2-e2c0-9e718e9a0ad0@redhat.com>
References: <1992a9545eb.1ec14bf0659281.6434647558731823661@collabora.com> <2d517844-b7bf-3930-e811-e073ec347d4a@redhat.com> <1992f628105.2bf0303b1373545.4844645742991812595@collabora.com> <a7872ca2-be14-0720-190c-c03d4ddf7a5d@redhat.com>
 <199343ab2a7.11b1e13e161813.4990067961195858029@collabora.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12



On Wed, 10 Sep 2025, Robert Beckett wrote:

>  > > Yeah, unfortunately we are currently restricted to using a swapfile due to many units already shipped with that.
>  > > We have longer term plans to dynamically allocate the swapfiles as neded based on a new query for estimated size
>  > > required for hibernation etc. Moving to swap partition is just not viable currently.
>  > 
>  > You can try the dm-loop target that I created some times ago. It won't be 
>  > in the official kernel because the Linux developers don't like the idea of 
>  > creating fixed mapping for a file, but it may work better for you. Unlike 
>  > the in-kernel loop driver, the dm-loop driver doesn't allocate memory when 
>  > processing reads and write.
> 
> oh interesting. I hadn't seen that.
> I was discussing a quick idea of potentially adding a new fallocate mode bit to request contiguous non-moveable
> block assignment as it pre-allocates, which filesystems could then implement support for.

You can ask the VFS maintainers about this, but I think they'll reject it.

> Then use the known
> file range with dm-crypt directly instead of going via the block device.
> I guess this is roughly analaguous to that idea.
> 
> I see that dm-loop is very old at this point. Do you know the rationale for rejection?

The reason was that the filesystem developers think that the filesystems 
should have freedom to move the allocated blocks around.

The dm-loop patch sets the flag S_SWAPFILE to prevent that from happening, 
but they don't want more code to use this flag.

> was there any hope to get it included with more work?

No - because they don't like the idea of creating a map of file blocks in 
advance.

One could rework the dm-loop patch to use standard filesystem methods read 
and write, but then it would allocate memory when processing requests and 
it would be unsuitable for swapping.

> If the main objection was regarding file spans that they can't gurantee persist, maybe a new fallocate based
> contrace with the filesystems could aleviate the worries? 
> 
> 
>  > 
>  > Create a swap file on the filesystem, load the dm-loop target on the top 
>  > of that file and then create dm-crypt on the top of the dm-loop target. 
>  > Then, run mkswap and swapon on the dm-crypt device.
>  > 
>  > > I tried halving /sys/module/dm_mod/parameters/swap_bios but it didn't help, which based on your more recent
>  > > reply is not unexpected.
>  > > 
>  > > I have a work around for now, which is to run a userland earlyoom daemon. That seems to get in and oomkill in time.
>  > > I guess another option would be to have the swapfile in a luks encrypted partition, but that equally is not viable for
>  > > steamdeck currently.
>  > > 
>  > > However, I'm still interested in the longer term solution of fixing the kernel so that it can handle scenarios
>  > > like this no matter how ill advised they may be. Telling users not to do something seems like a bad solution :)
>  > 
>  > You would have to rewrite the filesystems not to allocate memory when 
>  > processing reads and writes. I think that this is not feasible.
>  > 
>  > > Do you have any ideas about the unreliable kernel oomkiller stepping in? I definitely fill ram and swap, seems like
>  > > it should be firing.
>  > 
>  > I think that the main problem with the OOM killer is that it sometimes 
>  > doesn't fire for big applications.
> 
> perhaps oom_kill_allocating_task helps in that scenario?
> in this lockup scenario I don't see oomkiller starting at all. It looks like it soft
> locks and never feels the need to step in.
> Perhaps because it sees some (tiny) amount of forward progress with
> some swapout requests completing?

If you are swapping to an encrypted file, it may deadlock even before you 
exhaust the memory and swap.

>  > I think that using userspace OOM killer is appropriate to prevent this 
>  > problem with the kernel OOM killer. 
> 
> Turns out I spoke too soon on the userland earloom daemon being a solution.
> It worked for some patterns, but not others.
> It mostly worked well when swap was either pre-filled with data greater than it's
> threshold so as soon as ram is exhausted it stepped in, or when the allocations are
> sufficiently spaced for it to fill greater than it's threshold without many more
> outstanding swapouts before it gets to evaluate again.
> 
> For now the only really reliable way to work around is to disable memory
> overcommit, but we really don't want to go looking down that route as it 
> will have all sorts of other impacts.

You can allocate a file, use e4defrag to reduce the number of fragments, 
then use the FS_IOC_FIEMAP ioctl to find out the location of the file and 
then use the dm-linear target to map the file - and place encryption and 
swapping on the top of that.

If you have control over the whole device and make sure that no one moves 
the file, it should work.

Note that you can't use device mapper on a block device that has 
filesystem mounted, so you'll have to add one dm-linear device underneath 
the filesystem.

Mikulas

