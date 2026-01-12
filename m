Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12E837BE7E
	for <dm-devel@lists.linux.dev>; Mon, 12 Jan 2026 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238881; cv=none; b=n/nWPffgWncEWv81+5BuTI6W2YbjvAUPqJEZtfhrXyTlUc8wyf6xLnSt9zQ/pKyn6KUjLLb0akhkcJRRVFW8RbUxsBBbL9IpUYEUxqbBbAF0GlQP5/7754ffaM7JlrC34nlnLhTkLMjBcD0cL9sYHa5drZOXfxSTjlQoHVtIkHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238881; c=relaxed/simple;
	bh=rhZp3FhpkdvJFqfyP0R3sWiIkQM5geDMCm3gNb14hxo=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rCCuxrC7jXJG+TnDyH0uCPuCZHcWzckNXs7eX4GOT3TsjuI4/KF6si1HpIPJMDSEtX4YbQStuwq+PeSKlHVYhjraxERn3Dg+9c6jdebqL8D8vxt28Zwgxdgwx2Z6m8hHUQDYsgSAXjqY6xP3Msz+2KM9h1hQ41dsim3XkuoAQug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WOpce43/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WOpce43/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768238878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UYlFYflaiicRhHjlBUOwOc9xyibnzsVwIEkt7Cu3ORY=;
	b=WOpce43/cbbJQI3z+CIQNgk4W0NVpcLZXRQget+9L7lmVQ5TlfigsifInL0Ilbm3NBEvz7
	3gSnuTv/y2uzEOg+rhSqVoNrHdC6L3JhMnFs8SlpRz44dIVuBU+TrSE/PfwiWGZ5CWdR+L
	zytkXDP3xDBSzIWetRoPhbOoBDVgCPo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-UMTWbY2IMdG5Or4frSzUwg-1; Mon,
 12 Jan 2026 12:27:54 -0500
X-MC-Unique: UMTWbY2IMdG5Or4frSzUwg-1
X-Mimecast-MFC-AGG-ID: UMTWbY2IMdG5Or4frSzUwg_1768238873
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0124718002CF;
	Mon, 12 Jan 2026 17:27:53 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D29EF30001A2;
	Mon, 12 Jan 2026 17:27:50 +0000 (UTC)
Date: Mon, 12 Jan 2026 18:27:45 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ding Hui <dinghui@sangfor.com.cn>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, hch@lst.de, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: remove fake timeout to avoid leak request
In-Reply-To: <61d6db2d-30f8-4c20-8fca-60a0cb9f3baa@sangfor.com.cn>
Message-ID: <a0f67a16-42fc-81ce-9ae8-1f14f5e10f7b@redhat.com>
References: <20251220120350.10750-1-dinghui@sangfor.com.cn> <61d6db2d-30f8-4c20-8fca-60a0cb9f3baa@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Mon, 12 Jan 2026, Ding Hui wrote:

> Hi,
> 
> Sorry for this ping mail as there is no feedback from maintainers, just in
> case the patch was forgotten somewhere.
> 
> And it has already received a Reviewed-by from Christoph last month.

Hi

I committed the patch - it is in the linux-dm git, branch for-next.

Mikulas

> On 2025/12/20 20:03, Ding Hui wrote:
> > Since commit 15f73f5b3e59 ("blk-mq: move failure injection out of
> > blk_mq_complete_request"), drivers are responsible for calling
> > blk_should_fake_timeout() at appropriate code paths and opportunities.
> > 
> > However, the dm driver does not implement its own timeout handler and
> > relies on the timeout handling of its slave devices.
> > 
> > If an io-timeout-fail error is injected to a dm device, the request
> > will be leaked and never completed, causing tasks to hang indefinitely.
> > 
> > Reproduce:
> > 1. prepare dm which has iscsi slave device
> > 2. inject io-timeout-fail to dm
> >     echo 1 >/sys/class/block/dm-0/io-timeout-fail
> >     echo 100 >/sys/kernel/debug/fail_io_timeout/probability
> >     echo 10 >/sys/kernel/debug/fail_io_timeout/times
> > 3. read/write dm
> > 4. iscsiadm -m node -u
> > 
> > Result: hang task like below
> > [  862.243768] INFO: task kworker/u514:2:151 blocked for more than 122
> > seconds.
> > [  862.244133]       Tainted: G            E       6.19.0-rc1+ #51
> > [  862.244337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
> > this message.
> > [  862.244718] task:kworker/u514:2  state:D stack:0     pid:151   tgid:151
> > ppid:2      task_flags:0x4288060 flags:0x00080000
> > [  862.245024] Workqueue: iscsi_ctrl_3:1 __iscsi_unbind_session
> > [scsi_transport_iscsi]
> > [  862.245264] Call Trace:
> > [  862.245587]  <TASK>
> > [  862.245814]  __schedule+0x810/0x15c0
> > [  862.246557]  schedule+0x69/0x180
> > [  862.246760]  blk_mq_freeze_queue_wait+0xde/0x120
> > [  862.247688]  elevator_change+0x16d/0x460
> > [  862.247893]  elevator_set_none+0x87/0xf0
> > [  862.248798]  blk_unregister_queue+0x12e/0x2a0
> > [  862.248995]  __del_gendisk+0x231/0x7e0
> > [  862.250143]  del_gendisk+0x12f/0x1d0
> > [  862.250339]  sd_remove+0x85/0x130 [sd_mod]
> > [  862.250650]  device_release_driver_internal+0x36d/0x530
> > [  862.250849]  bus_remove_device+0x1dd/0x3f0
> > [  862.251042]  device_del+0x38a/0x930
> > [  862.252095]  __scsi_remove_device+0x293/0x360
> > [  862.252291]  scsi_remove_target+0x486/0x760
> > [  862.252654]  __iscsi_unbind_session+0x18a/0x3e0 [scsi_transport_iscsi]
> > [  862.252886]  process_one_work+0x633/0xe50
> > [  862.253101]  worker_thread+0x6df/0xf10
> > [  862.253647]  kthread+0x36d/0x720
> > [  862.254533]  ret_from_fork+0x2a6/0x470
> > [  862.255852]  ret_from_fork_asm+0x1a/0x30
> > [  862.256037]  </TASK>
> > 
> > Remove the blk_should_fake_timeout() check from dm, as dm has no
> > native timeout handling and should not attempt to fake timeouts.
> > 
> > Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> > ---
> >   drivers/md/dm-rq.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > index a6ca92049c10..5e0854669614 100644
> > --- a/drivers/md/dm-rq.c
> > +++ b/drivers/md/dm-rq.c
> > @@ -278,8 +278,7 @@ static void dm_complete_request(struct request *rq,
> > blk_status_t error)
> >   	struct dm_rq_target_io *tio = tio_from_request(rq);
> >     	tio->error = error;
> > -	if (likely(!blk_should_fake_timeout(rq->q)))
> > -		blk_mq_complete_request(rq);
> > +	blk_mq_complete_request(rq);
> >   }
> >     /*
> 
> -- 
> Thanks,
> - Ding Hui
> 

