Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A9C15359A
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714665941; cv=none; b=u7zPa+ae91uvkawwlXMmBmjlRD56aA+AlGtlYG43kg/YkbfOTmp6owU/0MyvBQlCn58W08Hl/OhMeBSAV54o3C+L5vIY4dkAI/Xq6GeUpzR5no6pt28ylA7OcVlcVKuy8b7HTTdPUPSlQoFDrhQAyhbLmT8VRhhmB1wh7qPGZxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714665941; c=relaxed/simple;
	bh=beAgqHKPPhNzJtncMNV1sedFva1so2V1I19I9GtrBXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=XoxwBYuzSkZhZb3mlDrIz1hdIXvfW+mvoIYyS6owsJ3a6kQk6RH87FCx9VmOgWtk1/tLqutKZYlsBSUwnE/eGBCuz/3mew2RS/80wv1r4LEnraElNvReExjazAf83fKq+WOQfxv/GqKEudMngn0NMRc+srw92YSct3ZP9wANF7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OjCoZMIY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OjCoZMIY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714665938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mU/iH1py0v4N3yGMO+1OF4lR42hossy+3/W76HfRurk=;
	b=OjCoZMIY/YDvfWJQMgrTOTizSoAVlC3kSHkYEYh+M0ehY+KuUS6U0UzWCDpuv4mNNYE3XE
	y7KpEjoM/HpduN8ft9ydDkgbhJuPU6jh5CrPk+aJXf5R7NTgkmXzLVye/FET4gOiedeod7
	Nmpl12EPQDscubX3wJMgBkoGTjiQme0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-PXVeqoVAN16MbaIJdAkl2w-1; Thu, 02 May 2024 12:05:37 -0400
X-MC-Unique: PXVeqoVAN16MbaIJdAkl2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2C45803505;
	Thu,  2 May 2024 16:05:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A837A40B497A;
	Thu,  2 May 2024 16:05:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 442G5a8U2403110
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 May 2024 12:05:36 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 442G5a5O2403109;
	Thu, 2 May 2024 12:05:36 -0400
Date: Thu, 2 May 2024 12:05:36 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        device-mapper development <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v2 4/5] libmultipath: pad dev_loss_tmo to avoid race with
 no_path_retry
Message-ID: <ZjO50C2hB8MilnHV@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
 <20240425233517.2125142-5-bmarzins@redhat.com>
 <9ee49b7c07938b38e39161a5a9143a472b01bff6.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <9ee49b7c07938b38e39161a5a9143a472b01bff6.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 02, 2024 at 05:14:56PM +0200, Martin Wilck wrote:
> On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
> > Currently multipath makes sure that dev_loss_tmo is at least as long
> > as
> > the configured no path queueing time. The goal is to make sure that
> > path
> > devices aren't removed while the multipath device is still queueing
> > in
> > hopes that they will become usable again.
> > 
> > This is racy. Multipathd may take longer to check the paths than
> > configured. If strict_timing isn't set, it will definitely take
> > longer.
> > To account for this, pad the minimum dev_loss_tmo value by five
> > seconds
> > (one default checker interval) plus one second per minute of no path
> > queueing time.
> 
> What's the rationale for the "one second per minute" part?
> It feels kind of arbitrary to me, and I don't find it obvious that we
> need larger padding for larger timeouts.

The way the checker works, without strict_timing, we do all the checking
work, and then we wait for a second. Obviously, the checking work takes
time, so every nominal one second checker loop will in reality take
longer than a second. The larger you have configured (no_path_retry *
checkint), the further away the actual time when we disable queueing
will be from (no_path_retry * checkint) seconds.

With strict_timing on, things work better. As long as the checking work
doesn't take more than a second, you will stay fairly close to one
second per loop, but even still, it can be longer. nanosleep() will
sleep till at least the time specified. If multipathd is not running as
a realtime process, it will usually sleep for longer.

Also, if the checker work takes longer than a second, then strict_timing
will make sure that the loop takes (close to) exactly 2 (or whatever the
next number is) seconds. However, retry_count_tick() still only ticks
down by 1 for each loop. This means that the real time before queueing
is disabled can diverge from (no_path_retry * checkint). And again, the
longer you've configured it to wait, the more it diverges.

I thought about passing ticks to retry_count_tick(), so that it would
correctly deal with these multi-tick loops, but this can cause it to
diverge from the actual number of retries attempted, in a way that would
mean we disable queueing before the desired number of retries have
occurred, which is a bigger problem, IMHO.  No matter how long the
checker work takes, you will only ever do one path check per loop. In
the worse case, say that the checker work (or anything else in
multipathd) gets stuck for a couple of minutes. You would only do one
path check, but hundreds of ticks would be passed to the
retry_count_tick(), meaning that you could disable queueing after only
one retry. Now you could limit the number of ticks you passed to
retry_count_tick(), but even still, if the a path was 1 tick away from
being checked, and the checker work took 3 seconds, you would still pass
3 ticks to retry_count_tick(), which would cause it to start to diverge
from the actual time it takes for the path to do the configured amount
of retries.

We could improve retry_count_tick(), so that it actually tracks the
number of retries you did, but that still leaves the problems when
either strict_timing isn't on or multipathd isn't a realtime process.
It seemed easier to just say, the longer you have configured multipathd
to wait to disable queueing, the more the time when it actually disables
queueing can diverge from the configured time.

The number I picked for the rate of divergence is just a guest, and if
you don't like it, I'm fine with removing it. After all, the whole point
of this patchset is to make sure that the worst thing that can happen if
paths disappear while we are still queueing is that a multipath device
isn't autoremoved.

-Ben

> 
> Regards
> Martin

