Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C1E1096C
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 11:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJ6Mr80b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698837804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EeFxVPDwX8rUrPW3tfvqgv2hmUJKD8elj+/gexXEcLQ=;
	b=ZJ6Mr80b1Wpee15bUpuhuvJEehAQ+LRkMCSo9nAlbTnYJ828flLwCeoYFbeaz5bktt32mQ
	9FhP1H41CF7SqUH2DI2Q2emorsMe8/XwcTniyANOG/3ftI68VMxaOS556Sxxpw5NH1nCys
	Y55Yltek1h1BK/WiV83ERA6X5N+igto=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-NeK5-0WEMAKRnchMuU24-g-1; Wed,
 01 Nov 2023 07:23:19 -0400
X-MC-Unique: NeK5-0WEMAKRnchMuU24-g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20AD63811F2F;
	Wed,  1 Nov 2023 11:23:18 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 842BD10F4C;
	Wed,  1 Nov 2023 11:23:09 +0000 (UTC)
Date: Wed, 1 Nov 2023 19:23:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>,
	Marek =?iso-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
	Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUI1GSSL4vdsFVHq@fedora>
References: <20231030155603.k3kejytq2e4vnp7z@quack3>
 <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>
 <ZUG0gcRhUlFm57qN@mail-itl>
 <ZUHE52SznRaZQxnG@fedora>
 <ab02413f-4bf2-4d92-baf7-62fbd106f5df@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab02413f-4bf2-4d92-baf7-62fbd106f5df@suse.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Wed, Nov 01, 2023 at 11:15:02AM +0100, Hannes Reinecke wrote:
> On 11/1/23 04:24, Ming Lei wrote:
> > On Wed, Nov 01, 2023 at 03:14:22AM +0100, Marek Marczykowski-Górecki wrote:
> > > On Wed, Nov 01, 2023 at 09:27:24AM +0800, Ming Lei wrote:
> > > > On Tue, Oct 31, 2023 at 11:42 PM Marek Marczykowski-Górecki
> > > > <marmarek@invisiblethingslab.com> wrote:
> > > > > 
> > > > > On Tue, Oct 31, 2023 at 03:01:36PM +0100, Jan Kara wrote:
> > > > > > On Tue 31-10-23 04:48:44, Marek Marczykowski-Górecki wrote:
> > > > > > > Then tried:
> > > > > > >   - PAGE_ALLOC_COSTLY_ORDER=4, order=4 - cannot reproduce,
> > > > > > >   - PAGE_ALLOC_COSTLY_ORDER=4, order=5 - cannot reproduce,
> > > > > > >   - PAGE_ALLOC_COSTLY_ORDER=4, order=6 - freeze rather quickly
> > > > > > > 
> > > > > > > I've retried the PAGE_ALLOC_COSTLY_ORDER=4,order=5 case several times
> > > > > > > and I can't reproduce the issue there. I'm confused...
> > > > > > 
> > > > > > And this kind of confirms that allocations > PAGE_ALLOC_COSTLY_ORDER
> > > > > > causing hangs is most likely just a coincidence. Rather something either in
> > > > > > the block layer or in the storage driver has problems with handling bios
> > > > > > with sufficiently high order pages attached. This is going to be a bit
> > > > > > painful to debug I'm afraid. How long does it take for you trigger the
> > > > > > hang? I'm asking to get rough estimate how heavy tracing we can afford so
> > > > > > that we don't overwhelm the system...
> > > > > 
> > > > > Sometimes it freezes just after logging in, but in worst case it takes
> > > > > me about 10min of more or less `tar xz` + `dd`.
> > > > 
> > > > blk-mq debugfs is usually helpful for hang issue in block layer or
> > > > underlying drivers:
> > > > 
> > > > (cd /sys/kernel/debug/block && find . -type f -exec grep -aH . {} \;)
> > > > 
> > > > BTW,  you can just collect logs of the exact disks if you know what
> > > > are behind dm-crypt,
> > > > which can be figured out by `lsblk`, and it has to be collected after
> > > > the hang is triggered.
> > > 
> > > dm-crypt lives on the nvme disk, this is what I collected when it
> > > hanged:
> > > 
> > ...
> > > nvme0n1/hctx4/cpu4/default_rq_list:000000000d41998f {.op=READ, .cmd_flags=, .rq_flags=IO_STAT, .state=idle, .tag=65, .internal_tag=-1}
> > > nvme0n1/hctx4/cpu4/default_rq_list:00000000d0d04ed2 {.op=READ, .cmd_flags=, .rq_flags=IO_STAT, .state=idle, .tag=70, .internal_tag=-1}
> > 
> > Two requests stays in sw queue, but not related with this issue.
> > 
> > > nvme0n1/hctx4/type:default
> > > nvme0n1/hctx4/dispatch_busy:9
> > 
> > non-zero dispatch_busy means BLK_STS_RESOURCE is returned from
> > nvme_queue_rq() recently and mostly.
> > 
> > > nvme0n1/hctx4/active:0
> > > nvme0n1/hctx4/run:20290468
> > 
> > ...
> > 
> > > nvme0n1/hctx4/tags:nr_tags=1023
> > > nvme0n1/hctx4/tags:nr_reserved_tags=0
> > > nvme0n1/hctx4/tags:active_queues=0
> > > nvme0n1/hctx4/tags:bitmap_tags:
> > > nvme0n1/hctx4/tags:depth=1023
> > > nvme0n1/hctx4/tags:busy=3
> > 
> > Just three requests in-flight, two are in sw queue, another is in hctx->dispatch.
> > 
> > ...
> > 
> > > nvme0n1/hctx4/dispatch:00000000b335fa89 {.op=WRITE, .cmd_flags=NOMERGE, .rq_flags=DONTPREP|IO_STAT, .state=idle, .tag=78, .internal_tag=-1}
> > > nvme0n1/hctx4/flags:alloc_policy=FIFO SHOULD_MERGE
> > > nvme0n1/hctx4/state:SCHED_RESTART
> > 
> > The request staying in hctx->dispatch can't move on, and nvme_queue_rq()
> > returns -BLK_STS_RESOURCE constantly, and you can verify with
> > the following bpftrace when the hang is triggered:
> > 
> > 	bpftrace -e 'kretfunc:nvme_queue_rq  { @[retval, kstack]=count() }'
> > 
> > It is very likely that memory allocation inside nvme_queue_rq()
> > can't be done successfully, then blk-mq just have to retry by calling
> > nvme_queue_rq() on the above request.
> > 
> And that is something I've been wondering (for quite some time now):
> What _is_ the appropriate error handling for -ENOMEM?

It is just my guess.

Actually it shouldn't fail since the sgl allocation is backed with
memory pool, but there is also dma pool allocation and dma mapping.

> At this time, we assume it to be a retryable error and re-run the queue
> in the hope that things will sort itself out.

It should not be hard to figure out why nvme_queue_rq() can't move on.

> But if they don't we're stuck.
> Can we somehow figure out if we make progress during submission, and (at
> least) issue a warning once we detect a stall?

It needs counting on request retry, and people often hate to add something
to request or bio in fast path. Also this kind of issue is easy to show
in blk-mq debugfs or bpftrace.


Thanks, 
Ming

