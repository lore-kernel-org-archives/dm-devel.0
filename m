Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A51025F783
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 20:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743022127; cv=none; b=SMce6S+Au9eKKXhOqgsFBqset7J6ff60sbZn9AqolWlOcIWDZcVnUn7homhkpgnBSD7rN5BZ3oPekN1FPvv9HUsuwtvumewMUGRB4gthnDX5webcwI3ViM9CepJmaQpE2+bW9b2bVkIYYy7C7tFC5JvsHX4z4pBVfpo2vWzG3qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743022127; c=relaxed/simple;
	bh=Ows7V7fm7LjQIFmtp3vzgYxpdtcBlnHhzX0wvDKSf18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/BLG+AS3xy3P++K/IwpY86jLDDeB3yXfnX+EVv+YWTd6bV7ACVCiwhg+xBc8jFl8ydXKZ35EvQsF4/Q1y6EQQ2nqYIDChRglWZEUvRvjgP6/Rfk8gYlnhAxWGJBRS5HWiyFsGHpvgOTFYdARXNknGMMwK90MEppbZ13Rw9HT7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nqe4apOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nqe4apOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935F9C4CEE2;
	Wed, 26 Mar 2025 20:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743022126;
	bh=Ows7V7fm7LjQIFmtp3vzgYxpdtcBlnHhzX0wvDKSf18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nqe4apOcbfeasQvuu5PCpHnvL9lSCGYhCOGdMmlorQoB58IVfY2bG3joYzm5TXapV
	 oxgMOGiIJFTy/VwEyNvlz6FDojlEEc7GBXskDd0ZpBQOyzYbrTCpVZ+Ib4Sai7Zgk3
	 cJxs/AbtwAzXLNkZpoPdcNFhLbzH6feQOyZCxoakT5EmC1qv0pVPmmW/vyR7qW+T4F
	 4QUq7KfWzIzj6lZkdKySoTSK1Wp1Q5ey6GKHS8VPNWAeB9uZ5dz9ory0/rSnLkQGkK
	 NnKF4+P2a54dN8+Lj9KcT9VkZLrTnlbUv2jcjgODxE3oEuHAya7na7SL0l3LWYXLhf
	 oyccvMQ6LMMDw==
Date: Wed, 26 Mar 2025 13:48:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com,
	dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250326204845.GB6625@sol.localdomain>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
 <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
 <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>

On Wed, Mar 26, 2025 at 07:50:34PM +0100, Mikulas Patocka wrote:
> 
> 
> On Wed, 26 Mar 2025, Eric Biggers wrote:
> 
> > On Wed, Mar 26, 2025 at 09:32:27PM +0800, LongPing Wei wrote:
> > > On 2025/3/26 19:04, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Wed, 26 Mar 2025, LongPing Wei wrote:
> > > > 
> > > > > Calling verity_verify_io in bh for IO of all sizes is not suitable for
> > > > > embedded devices. From our tests, it can improve the performance of 4K
> > > > > synchronise random reads.
> > > > > For example:
> > > > > ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
> > > > >   --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
> > > > >   --filename=/dev/block/mapper/xx-verity
> > > > > 
> > > > > But it will degrade the performance of 512K synchronise sequential reads
> > > > > on our devices.
> > > > > For example:
> > > > > ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
> > > > >   --numjobs=8 --runtime=60 --time_based --group_reporting \
> > > > >   --filename=/dev/block/mapper/xx-verity
> > > > > 
> > > > > A parameter array is introduced by this change. And users can modify the
> > > > > default config by /sys/module/dm_verity/parameters/use_bh_bytes.
> > > > > 
> > > > > The default limits for NONE/RT/BE/IDLE is set to 4096.
> > > > > 
> > > > > Call verity_verify_io directly when verity_end_io is in softirq.
> > > > > 
> > > > > Signed-off-by: LongPing Wei <weilongping@oppo.com>
> > > > 
> > > > Are you sure that 4096 bytes is the correct threshold?
> > > > 
> > > > I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k,
> > > > 256k, 512k and set the default threshold to the largest value where bh
> > > > code performs better than non-bh code.
> > > > 
> > > > Mikulas
> > > > 
> > 
> > 4096 bytes sounds good to me.  As I mentioned elsewhere in the thread
> > (https://lore.kernel.org/dm-devel/20250326164057.GA1243@sol.localdomain/),
> > objections keep getting raised to doing more work in softirq context due to
> > potential impact on real-time tasks.  So while more I/O benchmarks would be
> > interesting, they are also not the whole story and we should probably prefer a
> > more conservative threshold.  Also, dm-verity I/O requests have a bimodal
> > distribution with peaks at 4 KiB (for synchronous reads) and 128 KiB or
> > read_ahead_kb (for readahead) anyway, so most of the impact should come from 4
> > KiB anyway.
> > 
> > 8 KiB could also be reasonable when taking into account multibuffer hashing
> > though, since multibuffer hashing makes hashing two 4 KiB blocks almost as fast
> > as hashing a single 4 KiB block.  (Though multibuffer hashing is currently
> > Android-only, as the crypto maintainer keeps rejecting it upstream.)
> > 
> > - Eric
> 
> OK, so I'll set it to 8KiB.
> 
> Do you think that I should increase this limit to "unlimited" for 
> IOPRIO_CLASS_RT and disable this feature at all for IOPRIO_CLASS_NONE?

IOPRIO_CLASS_NONE means an I/O priority isn't set, so it probably should be
treated the same as IOPRIO_CLASS_BE which is the "normal" priority.

For now I think it makes sense to use 4 or 8 KiB even for IOPRIO_CLASS_RT.  That
covers the single-block request case which is the one that matters most.  We can
bump it up later if we can be shown that something higher is better.  Softirqs
normally get prioritized over all real-time tasks; so while it should be more
acceptable to use them for IOPRIO_CLASS_RT, it's not a perfect solution.

Another concern I have with longer requests is that when dm-verity runs the
verification work in a softirq and finds that a Merkle tree block isn't cached,
it punts the request to a kworker and restarts it from the beginning.  That not
only defeats the point of using softirq context, but it also throws away work
that was done.  I think we could fix it to not throw away work, but having to
fall back at all would still defeat the point of using softirq context.

- Eric
