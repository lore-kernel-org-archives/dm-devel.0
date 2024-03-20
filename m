Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21BA2904
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 03:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710903848; cv=none; b=SToqm1YQZaQX5Sbl8ZT8uqQZqZwY4tXSM45fiy0qhyCRt4DB7yNrjn9zH9ELljyUEnT4Jea1TYqEeUakVjJk50SEg53WmIzYTnP8uJemxy63p4RCzaQl3bBGGevCc97KrJljUZmVxgb62F/p2zt8nBFZ+NourcIjpFbaQOJDpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710903848; c=relaxed/simple;
	bh=ZTq5oVNeg4yF44LAzbJ+8jFM3ZqXJHc5Q76nPEL3LsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=I1xSeg2N8KR4gQSYWsBOnFlBBGrRnQS391xug3jpEyOIQZj3X6gy3bSBRJ41U8GiRNlXYxXo7Jj4UqMpTwgFTnm3tNC+leuhNf6EW87tqHYQLVXF8DfjH8dmJ3OGMH7bxumz4oq3oeDFiSMKbXr6hGwbKpStAMXapuKdLAyIwDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bSkMjV1M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bSkMjV1M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710903845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJL4ahuw7CqpMTTSJjR/hKHRbd4S8cd81MvftOA7bKE=;
	b=bSkMjV1MAijp9YHAqC8X/H3dy3dNsWqw+rQYIAIlkkN34zH6w1ffWLd7fAh7MghNhIEBR+
	XBT1m4DAN1UpItQ59lM63fO/lYm3EE1IATZ0Sp1dvBg4k1JV/gDMf2hJOQO4ZKi8ziY++E
	MuGIOqluL7ydAWeD/mlmzmllSCtjQgU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-UhZj76NAPfyREqT5TF7gwQ-1; Tue, 19 Mar 2024 23:04:02 -0400
X-MC-Unique: UhZj76NAPfyREqT5TF7gwQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDFAE8007A3;
	Wed, 20 Mar 2024 03:04:01 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E933210E47;
	Wed, 20 Mar 2024 03:03:56 +0000 (UTC)
Date: Wed, 20 Mar 2024 11:03:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Vasilis Liaskovitis <vliaskovitis@suse.com>
Subject: Re: [RFC Patch] dm: make sure to wait for all dispatched requests in
 __dm_suspend()
Message-ID: <ZfpSFA9NlLKZyBDg@fedora>
References: <20240315231035.26046-1-mwilck@suse.com>
 <ZfmNTK9uODx9YrLL@fedora>
 <821487f4494d34dd1c9686f23306b20f60bacd8a.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <821487f4494d34dd1c9686f23306b20f60bacd8a.camel@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Mar 19, 2024 at 04:41:26PM +0100, Martin Wilck wrote:
> Hello Ming,
> 
> On Tue, 2024-03-19 at 21:04 +0800, Ming Lei wrote:
> > Hello Martin,
> > 
> > On Sat, Mar 16, 2024 at 12:10:35AM +0100, Martin Wilck wrote:
> > > In a recent kernel dump analysis, we found that the kernel crashed
> > > because
> > > dm_rq_target_io tio->ti was pointing to invalid memory in
> > > dm_end_request(),
> > > in a situation where multipathd was doing map reloads because of a
> > > storage
> > > failover. The map of the respective mapped_device had been replaced
> > > by a
> > > different struct dm_table.
> > > 
> > > We obverved this with a 5.3.18 distro kernel, but the code in
> > > question
> > > hasn't change much since then. Basically, we were only missing
> > > b4459b11e840 ("dm rq: don't queue request to blk-mq during DM
> > > suspend"),
> > > which doesn't guarantee that the race I'm thinking of (see below)
> > > can't
> > > happen.
> > > 
> > > When a map is resumed after a table reload, the live table is
> > > swapped, and
> > > the tio->ti member of any live request becomes stale. 
> > > __dm_resume() avoids
> > > this by quiescing the queue and calling dm_wait_for_completion(),
> > > which
> > > waits until blk_mq_queue_inflight() doesn't report any in-flight
> > > requests.
> > > 
> > > However, blk_mq_queue_inflight() counts only "started" requests.
> > > So, if a
> > > request is dispatched before the queue was quiesced, but
> > > dm_wait_for_completion() doesn't observe MQ_RQ_IN_FLIGHT for this
> > > request
> > > because of memory ordering effects, __dm_suspend() may finish
> > > successfully,
> > 
> > Can you explain a bit about the exact memory order which causes
> > MQ_RQ_IN_FLIGHT
> > not observed?
> > 
> > blk-mq quiesce includes synchronize_rcu() which drains all in-flight
> > dispatch, so after blk_mq_quiesce_queue() returns,
> > if blk_mq_queue_inflight() returns 0, it does mean there isn't any
> > active inflight requests.
> > 
> > If there is bug in this pattern, I guess more drivers may have such
> > 'risk'.
> 
> What we know for sure is that there was a bad dm_target reference in
> (struct dm_rq_target_io *tio)->ti:
> 
> crash> struct -x dm_rq_target_io c00000245ca90128
> struct dm_rq_target_io {
>   md = 0xc0000031c66a4000,
>   ti = 0xc0080000020d0080 <fscache_object_list_lock+665632>,
> 
> crash> struct -x dm_target  0xc0080000020d0080
> struct dm_target struct: invalid kernel virtual address:
> c0080000020d0080  type: "gdb_readmem_callback"
> 
> The question is how this could have come to pass. It can only happen
> if tio->ti had been set before the map was reloaded. 
> My theory is that the IO had been dispatched before the queue had been
> quiesced, like this:
> 
> Task A                                 Task B
> (dispatching IO)                       (executing a DM_SUSPEND ioctl to
>                                        resume after DM_TABLE_LOAD)
>                                        do_resume()
>                                          dm_suspend()
>                                            __dm_suspend()
> dm_mq_queue_rq()                         
>    struct dm_target *ti =                
>        md->immutable_target;                  
>                                               dm_stop_queue()
>                                                  blk_mq_quiesce_queue()
>        /* 
>         * At this point, the queue is quiesced, but task A
>         * has alreadyentered dm_mq_queue_rq()
>         */

That shouldn't happen, blk_mq_quiesce_queue() drains all pending
dm_mq_queue_rq() and prevents new dm_mq_queue_rq() from being
called.

>                                               dm_wait_for_completion()
>                                                  blk_mq_queue_inflight()
>        /* 
>         * blk_mq_queue_inflight() doesn't see Task A's 
>         * request because it isn't started yet
>         */
>                                               set_bit(dmf_suspended_flag)
>    dm_start_request(md, rq);             dm_swap_table()
>                                             __bind()
>                                               md->immutable_target = ...
>                                          dm_target_destroy()
>         /* the previous md->immutable_target is freed */
>    init_tio(tio, rq, md);
>         /* the stale ti pointer is assigned to tio->ti */
>    tio->ti = ti;
> 
> dm_mq_queue_rq() contains no synchronization code if 
> md->immutable_target is set, so I think that this can happen, even
> though it looks unlikely. With b4459b11e840 (which was not applied in
> the customer kernel), there would be a
> set_bit(DMF_BLOCK_IO_FOR_SUSPEND) statement before dm_stop_queue(),
> but IMO that the above would still be possible.
> 
> If this can't happen, I have no more ideas how the observed situation
> came to pass. The customer who sent us the core claims that
> he has seen this multiple times already (but we have only this single
> core dump).

Your kernel is v5.3, which is too old, so as Mike suggested, please
try b4459b11e840 ("dm rq: don't queue request to blk-mq during DM
suspend") given blk-mq has too many changes here.

IMO, this issue should happen in upstream kernel.

Thanks,
Ming

