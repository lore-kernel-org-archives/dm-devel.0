Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206C81E378C
	for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 07:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742455374; cv=none; b=X8aZK5WLxiX/2XdcI6DFiAhZldQu1+oM8NMZ+VAvAp0UcGhbYWFZB75tZy5e6Jrt4KQZj2Ts/rx1ZBQbHuVeP08MmsMUxKb7tkZS/ZPglRKRiB6skfkiZiMhWqgQHQZGVwbXoRwzQpwwLHYhvdUcpItsDTxWgmaa3klJH9JUj4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742455374; c=relaxed/simple;
	bh=1NtmUVULZrUCtBCvtUtAuctlbaaULHBj1F+ACYhcZO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gbn6Rr5kJYQnJXMYJyk39MNUx3+RMKpsBLRIuAHhqwaUskqPgyZguEK4LhZTtAL1iu0xgdK9Fv/+xKCTLbw8Vk4KfTqpWlJ9BYV9mxMKAnkKUA7lvQaVgTRg0YJWhJyz/EAfWIoC0gUMIluEJwq12hCvKMU+RB4/kBZ1+SMoIPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4A22668AA6; Thu, 20 Mar 2025 08:22:48 +0100 (CET)
Date: Thu, 20 Mar 2025 08:22:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH V2 5/5] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <20250320072247.GD14337@lst.de>
References: <20250314021148.3081954-1-ming.lei@redhat.com> <20250314021148.3081954-6-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314021148.3081954-6-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 14, 2025 at 10:11:45AM +0800, Ming Lei wrote:
> Add hint for using IOCB_NOWAIT to handle loop aio command for avoiding
> to cause write(especially randwrite) perf regression on sparse file.
> 
> Try IOCB_NOWAIT in the following situations:
> 
> - backing file is block device

Why limit yourself to block devices?

> - READ aio command
> - there isn't queued aio non-NOWAIT WRITE, since retry of NOWAIT won't
> cause contention on WRITE and non-NOWAIT WRITE often implies exclusive
> lock.

This reads really odd because to me the list implies that you only
support reads, but the code also supports writes.  Maybe try to
explain this more clearly.

> With this simple policy, perf regression of randwrte/write on sparse
> backing file is fixed. Meantime this way addresses perf problem[1] in
> case of stable FS block mapping via NOWAIT.

This needs to go in with the patch implementing the logic.

> @@ -70,6 +70,7 @@ struct loop_device {
>  	struct rb_root          worker_tree;
>  	struct timer_list       timer;
>  	bool			sysfs_inited;
> +	unsigned 		queued_wait_write;

lo_nr_blocking_writes?

What serializes access to this variable?

> +static inline bool lo_aio_need_try_nowait(struct loop_device *lo,
> +		struct loop_cmd *cmd)

Drop the need_ in the name, it not only is superfluous, but also
makes it really hard to read the function name.

Also the inline looks spurious.

> +LOOP_ATTR_RO(nr_wait_write);

nr_blocking_writes?

> +static inline void loop_inc_wait_write(struct loop_device *lo, struct loop_cmd *cmd)

Overly long line.

> +	if (cmd->use_aio){

missing whitespace.

> +		struct request *rq = blk_mq_rq_from_pdu(cmd);
> +
> +		if (req_op(rq) == REQ_OP_WRITE)
> +			lo->queued_wait_write += 1;


	if (cmd->use_aio && req_op(blk_mq_rq_from_pdu(cmd)) == REQ_OP_WRITE)
			lo->queued_wait_write++;

> +	}
> +}
> +
> +static inline void loop_dec_wait_write(struct loop_device *lo, struct loop_cmd *cmd)
> +{
> +	lockdep_assert_held(&lo->lo_mutex);
> +
> +	if (cmd->use_aio){
> +		struct request *rq = blk_mq_rq_from_pdu(cmd);
> +
> +		if (req_op(rq) == REQ_OP_WRITE)
> +			lo->queued_wait_write -= 1;
> +	}
> +}

All the things above apply here as well.

