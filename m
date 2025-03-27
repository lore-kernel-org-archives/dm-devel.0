Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C561F9FE
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 17:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095126; cv=none; b=hkW2gY/rxOOtdCRIvHpDxt1Ohx1KoLRcjR6HwuUVdPSVGmqJNHR6x8E42RZOwXOs/0TlURbiySwdukSNqAfSfgtzn/lUyBuXPMfy1iXKVw6NB1AeRCEzwPwbtRR/jiBUoGFkbNXWYZzXh625nIYxg+wIaa2DjVNzST3QVYqDXoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095126; c=relaxed/simple;
	bh=TKVcg8iyW05Iqplaj+re4bdenQ1bDgSN9D8AsrCwsCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxBtif6w0CX7wrRUVsLUU6KK9bkd3zvEbOzb+3t8aXgi335VSddykhDBN/tujlmzjZNuEhJI9F+DPcucltqa0Xl29qCRMPz+kNqprfiiM+DfDgIK0xyUX/7O+PbGrnlQfAi6iioKRXQnzl7ZzNugTlQH8P6zs9/wfSm1UEm/DH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7d0UR16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7d0UR16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF233C4CEDD;
	Thu, 27 Mar 2025 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743095126;
	bh=TKVcg8iyW05Iqplaj+re4bdenQ1bDgSN9D8AsrCwsCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B7d0UR16jfZQ39YCLASSa+uMqVArhG3peHFQNK/pp+bTV7d2u9OtvfSERCTgzkpk3
	 7w+NPRNtvfln7IKAOpwGBPY/5TI8VjIcAnzfmoiMUsKQ24o2q8oIDGcVBy57hMMa6U
	 XosQA1k8S8gbMAYm7UaHV2yajieougAhgYpOzLy1fFp/5v+7pkASlMYd6IoNArc2Qd
	 tyVg4RTPE80r3dkOsxcvDxeJqg3eUy8aeK3k92MJ95QourniLs8sIf1/kQwU+T/dk8
	 eqXWFa9bHaWvPpWvGd5F+hiJtk7Pl5pi8BB1L+0H62AdeUP+LoTneBabXiiXUq4B76
	 MTdD9WNoCj3gw==
Date: Thu, 27 Mar 2025 10:05:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com,
	dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250327170524.GF1425@sol.localdomain>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
 <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
 <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
 <20250326204845.GB6625@sol.localdomain>
 <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd421003-2d7f-4d35-aa77-12d319454160@oppo.com>

On Thu, Mar 27, 2025 at 08:52:45AM +0800, LongPing Wei wrote:
> On 2025/3/27 4:48, Eric Biggers wrote:
> > On Wed, Mar 26, 2025 at 07:50:34PM +0100, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Wed, 26 Mar 2025, Eric Biggers wrote:
> > > 
> > > > On Wed, Mar 26, 2025 at 09:32:27PM +0800, LongPing Wei wrote:
> > > > > On 2025/3/26 19:04, Mikulas Patocka wrote:
> > > > > > 
> > > > > > 
> > > > > > On Wed, 26 Mar 2025, LongPing Wei wrote:
> > > > > > 
> > > > > > > Calling verity_verify_io in bh for IO of all sizes is not suitable for
> > > > > > > embedded devices. From our tests, it can improve the performance of 4K
> > > > > > > synchronise random reads.
> > > > > > > For example:
> > > > > > > ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
> > > > > > >    --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
> > > > > > >    --filename=/dev/block/mapper/xx-verity
> > > > > > > 
> > > > > > > But it will degrade the performance of 512K synchronise sequential reads
> > > > > > > on our devices.
> > > > > > > For example:
> > > > > > > ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
> > > > > > >    --numjobs=8 --runtime=60 --time_based --group_reporting \
> > > > > > >    --filename=/dev/block/mapper/xx-verity
> > > > > > > 
> > > > > > > A parameter array is introduced by this change. And users can modify the
> > > > > > > default config by /sys/module/dm_verity/parameters/use_bh_bytes.
> > > > > > > 
> > > > > > > The default limits for NONE/RT/BE/IDLE is set to 4096.
> > > > > > > 
> > > > > > > Call verity_verify_io directly when verity_end_io is in softirq.
> > > > > > > 
> > > > > > > Signed-off-by: LongPing Wei <weilongping@oppo.com>
> > > > > > 
> > > > > > Are you sure that 4096 bytes is the correct threshold?
> > > > > > 
> > > > > > I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k,
> > > > > > 256k, 512k and set the default threshold to the largest value where bh
> > > > > > code performs better than non-bh code.
> > > > > > 
> > > > > > Mikulas
> > > > > > 
> > > > 
> > > > 4096 bytes sounds good to me.  As I mentioned elsewhere in the thread
> > > > (https://lore.kernel.org/dm-devel/20250326164057.GA1243@sol.localdomain/),
> > > > objections keep getting raised to doing more work in softirq context due to
> > > > potential impact on real-time tasks.  So while more I/O benchmarks would be
> > > > interesting, they are also not the whole story and we should probably prefer a
> > > > more conservative threshold.  Also, dm-verity I/O requests have a bimodal
> > > > distribution with peaks at 4 KiB (for synchronous reads) and 128 KiB or
> > > > read_ahead_kb (for readahead) anyway, so most of the impact should come from 4
> > > > KiB anyway.
> > > > 
> > > > 8 KiB could also be reasonable when taking into account multibuffer hashing
> > > > though, since multibuffer hashing makes hashing two 4 KiB blocks almost as fast
> > > > as hashing a single 4 KiB block.  (Though multibuffer hashing is currently
> > > > Android-only, as the crypto maintainer keeps rejecting it upstream.)
> > > > 
> > > > - Eric
> > > 
> > > OK, so I'll set it to 8KiB.
> > > 
> > > Do you think that I should increase this limit to "unlimited" for
> > > IOPRIO_CLASS_RT and disable this feature at all for IOPRIO_CLASS_NONE?
> > 
> > IOPRIO_CLASS_NONE means an I/O priority isn't set, so it probably should be
> > treated the same as IOPRIO_CLASS_BE which is the "normal" priority.
> > 
> > For now I think it makes sense to use 4 or 8 KiB even for IOPRIO_CLASS_RT.  That
> > covers the single-block request case which is the one that matters most.  We can
> > bump it up later if we can be shown that something higher is better.  Softirqs
> > normally get prioritized over all real-time tasks; so while it should be more
> > acceptable to use them for IOPRIO_CLASS_RT, it's not a perfect solution.
> > 
> > Another concern I have with longer requests is that when dm-verity runs the
> > verification work in a softirq and finds that a Merkle tree block isn't cached,
> > it punts the request to a kworker and restarts it from the beginning.  That not
> > only defeats the point of using softirq context, but it also throws away work
> > that was done.  I think we could fix it to not throw away work, but having to
> > fall back at all would still defeat the point of using softirq context.
> > 
> > - Eric
> 
> Hi, Eric
> 
> It seems that verity_prefetch_io doesn't work efficiently.
> dm_bufio_prefetch_with_ioprio
>   __dm_bufio_prefetch
>     blk_start_plug
>     for loop
>       __bufio_new
>       submit_io
>       cond_resched
>     blk_finish_plug
> 
> If more than one hash blocks need to be prefetched, cond_resched will
> be called in each loop and blk_finish_plug will be called at the end.
> 
> The requests for hash blocks may have not been dispatched when the
> requests for data blocks have been completed.

Well, it's always possible for the prefetch I/O to be too slow, but the way it
works does seem to be unnecessarily bad.  The prefetch work runs on a kworker,
which is going to slow things down.  The way it should work is that verity_map()
runs the prefetch work and starts, but doesn't wait for, any I/O that is needed.
(And of course, most of the time no I/O will actually be needed.)

- Eric
