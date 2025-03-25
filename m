Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA32620FC
	for <dm-devel@lists.linux.dev>; Tue, 25 Mar 2025 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905448; cv=none; b=YdeOA8MqPlZjV235VPz9ihUL9gOVi3kTk0p4YthE6qtqESX5bwWyJ3pHnQu0JNzpddnWjtNOFoGKtWop0aeprxlbY8J1ZnT/hb4d4ZbW/JXX2euF4SoCyCOUJLtCnRaf9yAAB1+O4vqXOh+W7M1/KvpJp9ly9TOIH73hWy4XvM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905448; c=relaxed/simple;
	bh=wn1WBoIMzL15p320nXFa8dKndRoz/qSGoUe1u5eIMCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRNIaVxM5Ne6k4KHGGHeHNNNfZv+67OPfhqOij9kMvfnPgXGxUWJAgvpF0NDaNdPw311XY2fhGzqMGv7rzJGlhogjxN1Rr+W70YHReQ9lj7AtWrijEN4UkLKlYbTKhkkXLBGZRlrgi23vOhLTTB+ZNOFI+2TSkjx01wu/Ab1iTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=epTnfdWE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epTnfdWE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742905445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FZoxiXkYnN/E/dxEvlD3+meuAIyG+ElT4G9u+2PW1g=;
	b=epTnfdWEENwwYyAYHojLmn8qP+0Y6tOu92nLJJ9dlTuojm3Z3uU89M60eDUyFcH2ZpgWDL
	VDEfBbn8yPlYpku/dc7fu/8RofQd4QzU+qeaJ7qmUJkm1TPTPlzNYvWcI4I5Acag3yI8Vr
	tbsu2fWuJJvpHaarR6aJOyi5bLmgYtA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-1sbbKYNFPeeJZ9r7Jdz1Wg-1; Tue,
 25 Mar 2025 08:24:00 -0400
X-MC-Unique: 1sbbKYNFPeeJZ9r7Jdz1Wg-1
X-Mimecast-MFC-AGG-ID: 1sbbKYNFPeeJZ9r7Jdz1Wg_1742905438
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1EBC180049D;
	Tue, 25 Mar 2025 12:23:57 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 397CA180A803;
	Tue, 25 Mar 2025 12:23:48 +0000 (UTC)
Date: Tue, 25 Mar 2025 20:23:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z-KgT3Xine0kcVo-@fedora>
References: <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area>
 <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com>
 <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org>
 <Z9k-JE8FmWKe0fm0@fedora>
 <Z9u-489C_PVu8Se1@infradead.org>
 <Z9vGxrPzJ6oswWrS@fedora>
 <Z-KCPvmBO3AeuiDf@dread.disaster.area>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-KCPvmBO3AeuiDf@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Mar 25, 2025 at 09:15:26PM +1100, Dave Chinner wrote:
> On Thu, Mar 20, 2025 at 03:41:58PM +0800, Ming Lei wrote:
> > On Thu, Mar 20, 2025 at 12:08:19AM -0700, Christoph Hellwig wrote:
> > > On Tue, Mar 18, 2025 at 05:34:28PM +0800, Ming Lei wrote:
> > > > On Tue, Mar 18, 2025 at 12:57:17AM -0700, Christoph Hellwig wrote:
> > > > > On Tue, Mar 18, 2025 at 03:27:48PM +1100, Dave Chinner wrote:
> > > > > > Yes, NOWAIT may then add an incremental performance improvement on
> > > > > > top for optimal layout cases, but I'm still not yet convinced that
> > > > > > it is a generally applicable loop device optimisation that everyone
> > > > > > wants to always enable due to the potential for 100% NOWAIT
> > > > > > submission failure on any given loop device.....
> > > > 
> > > > NOWAIT failure can be avoided actually:
> > > > 
> > > > https://lore.kernel.org/linux-block/20250314021148.3081954-6-ming.lei@redhat.com/
> > > 
> > > That's a very complex set of heuristics which doesn't match up
> > > with other uses of it.
> > 
> > I'd suggest you to point them out in the patch review.
> 
> Until you pointed them out here, I didn't know these patches
> existed.
> 
> Please cc linux-fsdevel on any loop device changes you are
> proposing, Ming. It is as much a filesystem driver as it is a block
> device, and it changes need review from both sides of the fence.

Please see the patchset:

https://lore.kernel.org/linux-block/20250322012617.354222-1-ming.lei@redhat.com/

> 
> > > > > Yes, I think this is a really good first step:
> > > > > 
> > > > > 1) switch loop to use a per-command work_item unconditionally, which also
> > > > >    has the nice effect that it cleans up the horrible mess of the
> > > > >    per-blkcg workers.  (note that this is what the nvmet file backend has
> > > > 
> > > > It could be worse to take per-command work, because IO handling crosses
> > > > all system wq worker contexts.
> > > 
> > > So do other workloads with pretty good success.
> > > 
> > > > 
> > > > >    always done with good result)
> > > > 
> > > > per-command work does burn lots of CPU unnecessarily, it isn't good for
> > > > use case of container
> > > 
> > > That does not match my observations in say nvmet.  But if you have
> > > numbers please share them.
> > 
> > Please see the result I posted:
> > 
> > https://lore.kernel.org/linux-block/Z9FFTiuMC8WD6qMH@fedora/
> 
> You are arguing in circles about how we need to optimise for static
> file layouts.
> 
> Please listen to the filesystem people when they tell you that
> static file layouts are a -secondary- optimisation target for loop
> devices.
> 
> The primary optimisation target is the modification that makes all
> types of IO perform better in production, not just the one use case
> that overwrite-specific IO benchmarks exercise.
> 
> If you want me to test your changes, I have a very loop device heavy
> workload here - it currently creates about 300 *sparse* loop devices
> totalling about 1.2TB of capacity, then does all sorts of IO to them
> through both the loop devices themselves and filesystems created on
> top of the loop devices. It typically generates 4-5GB/s of IO
> through the loop devices to the backing filesystem and it's physical
> storage.

The patchset does cover the sparse backfile, and I also provide one test
case in which one completely sparse file is used, and make sure that
there isn't regression in this case.

This patchset is supposed to address Mikulas's case of stable FS mapping,
meantime without introducing regression on other cases, such as
the sparse backing file.

> 
> Speeding up or slowing down IO submission through the loop devices
> has direct impact on the speed of the workload. Using buffered IO
> through the loop device right now is about 25% faster than using
> aio+dio for the loop because there is some amount of re-read and
> re-write in the filesystem IO patterns. That said, AIO+DIO should be
> much faster than it is, hence my interest in making all the AIO+DIO
> IO submission independent of potential blocking operations.
> 
> Hence if you have patch sets that improve loop device performance,
> then you need to make sure filesystem people like myself see those
> patch series so they can be tested and reviewed in a timely manner.
> That means you need to cc loop device patches to linux-fsdevel....

OK, will Cc you and linux-fsdevel in future loop patch submission.


Thanks,
Ming

