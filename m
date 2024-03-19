Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDBE171A1
	for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710867225; cv=none; b=oAprBtmfTC7/4/dKSE+1XFd1zv7+ZciGOmWpkMBH+GuVq0WJEPv9hC2+Bsl0P5lZTmO5RJRcQK+HB01oc4HO1Z5HZRfdbA5bMoBQy9rFM4+Gakei+dP18f3TEHbhlerWZIeu0dyahHmvj7yVgoBbuTpsI0G/mNpMY5ajlBgi/hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710867225; c=relaxed/simple;
	bh=dIUwr+uEbJP+Mkgmw1s3K3W230+yUcBsvLBRRJnMP6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7qU4RSqahxfsZZe36Ny+pwUIoBHpvbKvUGjEPuRcvP+CrN8meGA6/nrXj4mroIuSEU18h0fW/Y1idUH45kuRSFHEG+oiJs2Fp8NAVpCCpyzvtd9J9E1aMRjkWk8WXUZUH7Ib6hZL+laqFk1fmwc5q9t2DFu2G6ZHbrTnAqYBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-789f1b59a28so194510185a.3
        for <dm-devel@lists.linux.dev>; Tue, 19 Mar 2024 09:53:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710867222; x=1711472022;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ePg8mtk6IM4KiFuJd2QkPUd3TT8FAyqa2FWhzVNELTk=;
        b=fdsXIHZl5pChIQI8sa2GKBSs6M02t202Ce5+W+KBU0ZGJ9DHcM+9eJuIoBSmuPbckI
         GKNkeiWItRFKAfY/v/TMCk2gvXBkra/VKRiQRziFChA6stmWSJZzIIhtoli5g75zxAvL
         +gTIgFK04GuoLuPrcl133/wUvXULHPmYU3YMRndZfL2C6I7nuHNnRrWThphudGYchNQf
         XTOk0lNMLhKjXuZ6z0ObiBsGLmVvitQ96aOFGJH2cQc/GyfuhgFSycK11Vxk8mAbpIQJ
         pISyxjl2z34Mgt5qvBM4eMM1tRiL+8W14+dwagLLi2K+e/0Zn4RyhGFlo42F7tn7JWda
         xf4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUW/1/q2eD/Va51V+zvHycaVCT9qKtXKEPG0UgXSHuYGjJ9T3CqE1+pxkMgN1tPWH5Iv/S8w/Q/rcpF0CKKwv4YyMFHuyXPBBE=
X-Gm-Message-State: AOJu0YycuuNmdYqvk4JwdDaUGjPGRuN0qLTiZF6YdL1FMnTTcQXqwNzR
	bB2E6jxr3z+taZqxcRRgzK6gxTlUSaZvpIPXTJ0XYNGezj/cq4OSrltN+wEoFw==
X-Google-Smtp-Source: AGHT+IEIlfaE6aBDe8dqzYO7qIQuEyuFHh9ou0z2solDHaXDNjCYTTWCF3Ce5drw8TRm9/opjyfzYA==
X-Received: by 2002:a05:620a:1661:b0:789:e792:5d89 with SMTP id d1-20020a05620a166100b00789e7925d89mr13622153qko.57.1710867222411;
        Tue, 19 Mar 2024 09:53:42 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id e17-20020a05620a12d100b00789e1be910bsm4778474qkl.38.2024.03.19.09.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 09:53:41 -0700 (PDT)
Date: Tue, 19 Mar 2024 12:53:40 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Martin Wilck <mwilck@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Vasilis Liaskovitis <vliaskovitis@suse.com>
Subject: Re: [RFC Patch] dm: make sure to wait for all dispatched requests in
 __dm_suspend()
Message-ID: <ZfnDFEfbLVvh5og-@redhat.com>
References: <20240315231035.26046-1-mwilck@suse.com>
 <ZfmNTK9uODx9YrLL@fedora>
 <821487f4494d34dd1c9686f23306b20f60bacd8a.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <821487f4494d34dd1c9686f23306b20f60bacd8a.camel@suse.com>

On Tue, Mar 19 2024 at 11:41P -0400,
Martin Wilck <mwilck@suse.com> wrote:

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

While I appreciate you making us aware of this crash, I'm really not
interested in going down the rabbit hole of reasoning through fairly
complex concerns unless you have gotten your customer a kernel with
latest fixes (e.g. commit b4459b11e840) and they _still_ crash.

Has that happened?

NOTE: There is also 85067747cf98 ("dm: do not use waitqueue for
request-based DM") but you probably have it since you said other than
missing the changes from commit b4459b11e840 that your dm-rq.c was
same.

Mike
