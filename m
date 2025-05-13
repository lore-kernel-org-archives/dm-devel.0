Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0A1E990E
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747159762; cv=none; b=lHPFGXsqkz0mU62wwij26NukM3RBXE50ivYo0aqAf/YAg88dRoeHkBldgG0yftEkEHgoGSYlYGbWsNldazuSUMxO8Uuy+dSmSaOuHwBK7zHK/5de78cpTjwImUeo0o53UjT+mvRxBW1cXeB2l01Qy2F/tq8WiC7xg8VhZ0v/3ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747159762; c=relaxed/simple;
	bh=y6FyTOrryxqsZyhvx5jnt21SOMn4MMX/6nM16WUR55A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hGfmBPRkBB9hlLoLVzWoWiJEYZFoojxCHEtcNZduALCJTx5b5uMa0c8EnE0GtalydUKSId+urG8cF90go0T5ZcKqqtGuHMY6J0itM7ocdRhWGoX+8ibmZ2pPk6ec/2WeZ7ZF8XfAZ8ux2brD4hQGWRaNAbf1+8ln3EsdJzF1C3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i/wGvYk+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i/wGvYk+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747159759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNMocb49YwKkQlzCF1mYy+YEqKi321BJUdcZHDQPRzI=;
	b=i/wGvYk+TDP/zOAPqcPLGFj6rKNwbjjo9wU69NAUSjqU0Qhx1hniLlRwhY+CK2IfNfST7i
	WwSApQD+XYN+Yf8ZOga4MB/HZgTzOnMFssxtRttBGdZBWhyrEPpuCnYOp1l8mhU/5w5BZc
	yzGb1GUc3vyfae5AXrL3+zvEvw3bZK4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-1QA8j8jPNqSUrBMM73mDuA-1; Tue,
 13 May 2025 14:09:17 -0400
X-MC-Unique: 1QA8j8jPNqSUrBMM73mDuA-1
X-Mimecast-MFC-AGG-ID: 1QA8j8jPNqSUrBMM73mDuA_1747159756
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67A77195DE38;
	Tue, 13 May 2025 18:09:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDF2130001A1;
	Tue, 13 May 2025 18:09:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54DI9Eo83648763
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 14:09:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54DI9DeZ3648762;
	Tue, 13 May 2025 14:09:13 -0400
Date: Tue, 13 May 2025 14:09:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
        dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
        snitzer@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
Message-ID: <aCOKyZU5T8HxGzM_@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
 <ecff74ca-f3a5-4848-8836-54f1d7810aca@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ecff74ca-f3a5-4848-8836-54f1d7810aca@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, May 13, 2025 at 08:30:55AM +0200, Hannes Reinecke wrote:
> On 5/12/25 17:18, Kevin Wolf wrote:
> > Am 08.05.2025 um 15:51 hat Martin Wilck geschrieben:
> > > Hello Kevin,
> > > 
> > > [I'm sorry for the previous email. It seems that I clicked "send" in
> > > the wrong window].
> > > 
> > > On Tue, 2025-04-29 at 18:50 +0200, Kevin Wolf wrote:
> > > > Multipath cannot directly provide failover for ioctls in the kernel
> > > > because it doesn't know what each ioctl means and which result could
> > > > indicate a path error. Userspace generally knows what the ioctl it
> > > > issued means and if it might be a path error, but neither does it
> > > > know
> > > > which path the ioctl took nor does it necessarily have the privileges
> > > > to
> > > > fail a path using the control device.
> > > 
> > > Thanks for this effort.
> > > 
> > > I have some remarks about your approach. The most important one is that
> > > the DM_MPATH_PROBE_PATHS_CMD ioctl appears to be a dangerous command.
> > > It sends IO to possibly broken paths and waits for it to complete. In
> > > the common error case of a device not responding, this might cause the
> > > code to hang for a long time in the kernel ioctl code path, in
> > > uninterruptible sleep (note that these probing commands will be queued
> > > after other possibly hanging IO). In the past we have put a lot of
> > > effort into other code paths in multipath-tools and elsewhere to avoid
> > > this kind of hang to the extent possible. It seems to me that your set
> > > re-introduces this risk.
> > 
> > That's a fair point. I don't expect this code to be fully final, another
> > thing that isn't really optimal (as mentioned in the comment message) is
> > that we're not probing paths in parallel, potentially adding up timeouts
> > from multiple paths.
> > 
> > I don't think this is a problem of the interface, though, but we can
> > improve the implementation keeping the same interface.
> > 
> > Maybe I'm missing something, but I think the reason why it has to be
> > uninterruptible is just that submit_bio_wait() has the completion on the
> > stack? So I suppose we could just kmalloc() some state, submit all the
> > bios, let the completion callback free it, and then we can just stop
> > waiting early (i.e. wait_for_completion_interruptible/killable) and let
> > the requests complete on their own in the background.
> > 
> > Would this address your concerns or is there another part to it?
> > 
> Not really. There are two issues which ultimately made us move away
> from read I/O as path checkers:
> 
> - Spurious timeouts due to blocked or congested submission
> - Error handling delays and stalls
> 
> When using normal read/write functions for path checking you are
> subjected to normal I/O processing rules, ie I/O is inserted
> at the end of the submission queue. If the system is busy the
> path checker will time out prematurely without ever having reached
> the target. One could avoid that by extending the timeout, but that
> would make the path checker unreliable.

I get your complaint in general, but this interface is just giving users
the ability to probe the active pathgroup by sending normal IOs to its
paths.  Presumably, they won't use it if they are already sending normal
IOs to the multipath device, since this is just duplicating the effect
of those IOs. 
 
> But the real issue is error handling. Path checker are precisely there
> to check if the path is healthy, and as such _will_ be subjected
> to error handling (or might even trigger error handling itself).
> The thing about error handling is that you can only return affected
> commands once error handling is complete, as only then you can be
> sure that no DMA is pending on the buffers and one can free/re-use
> the associated pages.
> On SCSI error handling can be an _extremely_ lengthy affair
> (we had reports for over one hour), and the last thing you want is
> to delay your path checker for that time.

I can send a patch that will keep probe_active_paths() from holding the
work_mutex. This means that probe_active_paths() won't delay
multipath_message(), so the path checkers will not be effected by this.

> (And besides, I didn't even mention the third problem with I/O-based
> path checkers, namely that the check entirely the wrong thing; we
> are not interested whether we can do I/O, we are interested in whether
> we can send commands. In the light of eg ALUA these are two very
> different things.)

I actually disagree with this. There are issues with IO based checkers,
but in general, what we care about is paths being able to do IO, not
sending commands. All the improvements on the directio checker were made
because we still need it. For instance, some SCSI devices will claim
they are usable when you run a SCSI Test Unit Ready command, but they
aren't able to actually handle IO. These paths will have their state
ping-pong back and forth as multipathd restores them and the kernel uses
them and immeditately fails them again. The solution is often to switch
multipathd to the directio checker, since it verifies that the path can
actually handle IO. It's problematic when dealing with paths that need
to be initialized before accepting IO, but that's why this patch only
checks the paths in the active pathgroup. 
 
> > > Apart from that, minor observations are that in patch 2/2 you don't
> > > check whether the map is in queueing state, and I don't quite
> > > understand why you only check paths in the map's active path group
> > > without attempting a PG failover in the case where all paths in the
> > > current PG fail.
> > 
> > Ben already fixed up the missing check.
> > 
> > Not attempting PG failover was also his suggestion, on the basis that it
> > would be additional work for no real benefit when you can only submit
> > requests for the current PG anyway. If userspace retries the SG_IO, it
> > will already pick a different PG, so having the kernel do the same
> > doesn't really improve anything.
> > 
> Precisely.
> 
> I think the best way forward here is to have a 'post_ioctl' handler
> (much like we have a pre_ioctl handler nowadays).
> This would check the return code from the ioctl, and invalidate the
> current path if there was an I/O error.
> That way the user can resubmit the ioctl, until all paths are exhausted.
> For that to work we need to agree on two error codes, one for
> 'path failed, retry' and one for 'path failed, no retry possible'.
> Resetting path status will be delegated to multipathd, but then that's
> its main task anyway.

Isn't this basically the idea that Martin had, here:
https://lore.kernel.org/all/20210628151558.2289-1-mwilck@suse.com/

If this was acceptable, I would be all for it. But we often can't even
tell if an SG_IO has failed without decoding the scsi status/sense data,
and that got shot down when Martin posted patches to do it. Thus, we
have a general solution that has nothing to do with SG_IO ioctls and
will work for any type of path device, any time a user wants to verify
the state of the active paths.

-Ben

> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke                  Kernel Storage Architect
> hare@suse.de                                +49 911 74053 688
> SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
> HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

