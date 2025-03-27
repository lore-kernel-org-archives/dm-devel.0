Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E4C17BB21
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743096913; cv=none; b=OsFYyLxq3w8QOezw2mrecnHgqUsyd6IIgfotc+cE+V2oDQ5Waf+ERX2oS3ZW+ESn+5ZAndXy/VBbVEMPh3QkgieqfG2Qt9BDqwQSQfthcca8ADuV3B8Dz8LNp4kV5HC0UDAE2M3px7oOnCn0XX7hVM9yDXGJi6r2pphLopC/SUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743096913; c=relaxed/simple;
	bh=7z9LBJgc225Nvcs+BkLH0U/4IKtORBmFb0HscvPPTs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fq+xm2C5GtrMWJvEVzkRepvQd7TTbfyglhcErgpB4Uz5vKVyfduqxepOsCgdB9/liau/DtyEsGLg1JFeA9reU+U+ASVZL2rQnT/9xTooNcvgFUblCrJXkIc5cyX5t+8V0HbtE8Od8TgPAgdXQS3jGOnvSGiQqaVUGNhZXrV+ODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jGE6gq6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jGE6gq6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFB7C4CEDD;
	Thu, 27 Mar 2025 17:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743096913;
	bh=7z9LBJgc225Nvcs+BkLH0U/4IKtORBmFb0HscvPPTs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jGE6gq6aaaEdDUnfbsgpESAGNps5zQ53v2oWGtpliqwBd4jaMzVxE2Wnt+wOZHJBn
	 h8M/zHb3tgN4D8bi0OybUhSQBdRRH1XySAxbTxhJcHX2E00Ia9TB6J6fi3NLZPQbx1
	 EBaGpkDx+TAh/hhruvxbv1xx9xwJ0x9D6KTKhDMI3RtIPZop0+hNEshq3D/8/TEE+k
	 gpcCf7ErRhacJ+C93u90LHa9kKCTrzoSBQvfp32Q0GLSXaEosSCksa4Zut+1VvdTus
	 wT0aRcd8Af+duoOp6YWkqXJtOh2NySs+ZAuK5VNUwUijGW6LwAm8Ex/GdwcmsYdOJ0
	 vJnR5JY/IV5yQ==
Date: Thu, 27 Mar 2025 17:35:10 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com,
	dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250327173510.GA3371050@google.com>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
 <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
 <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
 <20250326204845.GB6625@sol.localdomain>
 <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com>
 <20250327170524.GF1425@sol.localdomain>
 <6421ae31-5b4a-f35a-724c-1970ec3ab06b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6421ae31-5b4a-f35a-724c-1970ec3ab06b@redhat.com>

On Thu, Mar 27, 2025 at 06:12:22PM +0100, Mikulas Patocka wrote:
> 
> 
> On Thu, 27 Mar 2025, Eric Biggers wrote:
> 
> > > Hi, Eric
> > > 
> > > It seems that verity_prefetch_io doesn't work efficiently.
> > > dm_bufio_prefetch_with_ioprio
> > >   __dm_bufio_prefetch
> > >     blk_start_plug
> > >     for loop
> > >       __bufio_new
> > >       submit_io
> > >       cond_resched
> > >     blk_finish_plug
> > > 
> > > If more than one hash blocks need to be prefetched, cond_resched will
> > > be called in each loop and blk_finish_plug will be called at the end.
> > > 
> > > The requests for hash blocks may have not been dispatched when the
> > > requests for data blocks have been completed.
> > 
> > Well, it's always possible for the prefetch I/O to be too slow, but the way it
> > works does seem to be unnecessarily bad.  The prefetch work runs on a kworker,
> > which is going to slow things down.  The way it should work is that verity_map()
> > runs the prefetch work and starts, but doesn't wait for, any I/O that is needed.
> > (And of course, most of the time no I/O will actually be needed.)
> > 
> > - Eric
> 
> dm-verity used to prefetch from the verity_map function, but it caused a 
> deadlock - 3b6b7813b198b578aa7e04e4047ddb8225c37b7f - so, it was moved to 
> a workqueue.

Interesting.  Unfortunately I think the workqueue makes it way worse.

In principle there is no need for it to block for anything.  If it would have to
block, it just should just continue on.

- Eric
