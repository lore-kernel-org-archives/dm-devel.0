Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707C31A2632
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 16:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743008018; cv=none; b=rjrIKT3BJTkllDR1/VRBid4wzE5dWffrzJF05G0333N5p+Pu99fYXGm5JkpCFUUz6NRidSdL7Bggg4GagJ0EER3tmkss8nlil1lk806Bbz9c9/HOgg1lsvPRJ61vGs6LWv9w/I4cUOL53YfHyVgk9XKT5llBuBkh+OGuxrpLe4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743008018; c=relaxed/simple;
	bh=NxUn8sQjqcGf9fhijK7QlSX9GFj3QurmhFIpsmbJn84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBpgxYZCSOLZax7A1a7QKdHuG5aHTYgavarxlykruyFwGblh5PFfdkMz3b/Lto1x09Be2UvSnJGESQNa7v5DFJPJgzjjsDSie2zuYpxn37yiuSoCX32wz+l/UTh/u5Z9zeX5IceHxqDFYeg2tM96Bi+ECyOG9K1F4j0BNN5mr9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+qfxyrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+qfxyrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF717C4CEE2;
	Wed, 26 Mar 2025 16:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743008017;
	bh=NxUn8sQjqcGf9fhijK7QlSX9GFj3QurmhFIpsmbJn84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o+qfxyrKmPwmiHtj9x1bjUZLFnntSt2M0MkMyisP0l6TZMCkX5TnU4G0iqlIIdDvz
	 8gsvSwtNtJGhkjDfkEXLdzZRnEHEOjFgl0NEp6bQ0jXzwlhB/EY6w9dKaGwwM7vv7n
	 xGvPepxYwKGbeUac4KYb3NBEW/WUZzNYn/R3MP9SKR2Idqstc+4iLAjVFB1nUAH6Vx
	 cwzl9o9BaM6uLe/oPPutIXXUC7aFEKBLsgVx4Qn6ouD8D3fVLAgFhh34I104+NEm/9
	 hNhWMusznmSIpBfT6r0puAJAOzZAmU11Cv+DgeHjVee3td1xIo2XipY8EptRZuRPir
	 X2ftOC8wZlVQQ==
Date: Wed, 26 Mar 2025 09:53:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com,
	dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250326165336.GB1243@sol.localdomain>
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
 <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>

On Wed, Mar 26, 2025 at 09:32:27PM +0800, LongPing Wei wrote:
> On 2025/3/26 19:04, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 26 Mar 2025, LongPing Wei wrote:
> > 
> > > Calling verity_verify_io in bh for IO of all sizes is not suitable for
> > > embedded devices. From our tests, it can improve the performance of 4K
> > > synchronise random reads.
> > > For example:
> > > ./fio --name=rand_read --ioengine=psync --rw=randread --bs=4K \
> > >   --direct=1 --numjobs=8 --runtime=60 --time_based --group_reporting \
> > >   --filename=/dev/block/mapper/xx-verity
> > > 
> > > But it will degrade the performance of 512K synchronise sequential reads
> > > on our devices.
> > > For example:
> > > ./fio --name=read --ioengine=psync --rw=read --bs=512K --direct=1 \
> > >   --numjobs=8 --runtime=60 --time_based --group_reporting \
> > >   --filename=/dev/block/mapper/xx-verity
> > > 
> > > A parameter array is introduced by this change. And users can modify the
> > > default config by /sys/module/dm_verity/parameters/use_bh_bytes.
> > > 
> > > The default limits for NONE/RT/BE/IDLE is set to 4096.
> > > 
> > > Call verity_verify_io directly when verity_end_io is in softirq.
> > > 
> > > Signed-off-by: LongPing Wei <weilongping@oppo.com>
> > 
> > Are you sure that 4096 bytes is the correct threshold?
> > 
> > I suggest that you run the benchmarks for 4k, 8k, 16k, 32k, 64k, 128k,
> > 256k, 512k and set the default threshold to the largest value where bh
> > code performs better than non-bh code.
> > 
> > Mikulas
> > 

4096 bytes sounds good to me.  As I mentioned elsewhere in the thread
(https://lore.kernel.org/dm-devel/20250326164057.GA1243@sol.localdomain/),
objections keep getting raised to doing more work in softirq context due to
potential impact on real-time tasks.  So while more I/O benchmarks would be
interesting, they are also not the whole story and we should probably prefer a
more conservative threshold.  Also, dm-verity I/O requests have a bimodal
distribution with peaks at 4 KiB (for synchronous reads) and 128 KiB or
read_ahead_kb (for readahead) anyway, so most of the impact should come from 4
KiB anyway.

8 KiB could also be reasonable when taking into account multibuffer hashing
though, since multibuffer hashing makes hashing two 4 KiB blocks almost as fast
as hashing a single 4 KiB block.  (Though multibuffer hashing is currently
Android-only, as the crypto maintainer keeps rejecting it upstream.)

- Eric
