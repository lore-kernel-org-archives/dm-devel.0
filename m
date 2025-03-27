Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3C3213E7C
	for <dm-devel@lists.linux.dev>; Thu, 27 Mar 2025 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743094681; cv=none; b=rLdkdxCAs++cn/aGw5pQBGHYx+26gqIJd8dOD8ByQMrhtU09hdt3tcPwNA4o2UkC6GQMLmQQrostPltz+JNDHYIVbE5dlkINajbwjhIu2cj+RPOrifTdfdPxuPIDSwgXw8faT2f/8Bc1yaTFKFvtRGI2XPeM7nB1peuXgwsg6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743094681; c=relaxed/simple;
	bh=78pCBw5ztbQAjGRm7Ke01mK5ZwmY4ACokzzVrYE+TEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahr9akZOSaRyzgUxh+GOeIRuc5UrgEmbP70P7wvGx6S2TCCTSXXqOX8mTao8JHdWrjJuCcTfULjXGSDq1L0lcn+X0vRqz2qZoB81QFj0J+iJD37sLIXvJ5pL6N7CSCiY05AyBNtEAeblZzKAcbq7meCQZ4wzY/jnd5Tfjbp3JGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pf3soBZI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pf3soBZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD33C4CEDD;
	Thu, 27 Mar 2025 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743094681;
	bh=78pCBw5ztbQAjGRm7Ke01mK5ZwmY4ACokzzVrYE+TEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pf3soBZIPeY4Vo8lFQxMlGna32ncAbB8Um3DEZSuNntXRPEeffVv1YuiKQCMXgWgL
	 18x0mWlv3VSdFETRDrsk9UjKHbVcucf6EWjxBVaD7ESmlmu13AmxMdE2Bby+4J5ZmC
	 ND65h7c0Nb3J1Z+zg21wXp2SKVLW+Lx6Pmxj4B4DPk7vDTXe09BOFmAyioNkM+Z1j+
	 0fEuQUCZ/2dhg6K9VyhaKDIS/FFJUPZcSlIU8C+rapg5W74Jxm56KTTMw0gwYOvGB7
	 wlCJA9P5k1+RcX28Iv4M2F5FfCkXIanlyKp73VaAUQrX95cBsJZhoOzXKzcIegm40J
	 0mEKXkVub7jkA==
Date: Thu, 27 Mar 2025 09:57:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: LongPing Wei <weilongping@oppo.com>
Cc: snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	guoweichao@oppo.com, bvanassche@acm.org
Subject: Re: [PATCH v3] dm-verity: support block number limits for different
 ioprio classes
Message-ID: <20250327165759.GE1425@sol.localdomain>
References: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
 <20250327021819.1623099-1-weilongping@oppo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250327021819.1623099-1-weilongping@oppo.com>

On Thu, Mar 27, 2025 at 10:18:19AM +0800, LongPing Wei wrote:
>  try_verify_in_tasklet
>      If verity hashes are in cache, verify data blocks in kernel tasklet instead
> -    of workqueue. This option can reduce IO latency.
> +    of workqueue. This option can reduce IO latency.

The above is really overdue for an update (tasklets aren't actually used
anymore), but that can be done in a separate patch...

> + The size limits could be configured

could => can

> +	if (static_branch_unlikely(&use_bh_wq_enabled) && io->v->use_bh_wq &&
> +		verity_use_bh(bio->bi_iter.bi_size, ioprio)) {

bi_size is always 0 here since the iterator was already advanced.

dm_verity_io::n_blocks needs to be used instead.

- Eric
