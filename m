Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7914F1E3769
	for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 07:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742456319; cv=none; b=KySsN2mtJ3SCfo87F85WMpVQFqfzHYKDYwzp1jrPDYStptFchYtiGkNJCOBtzfN8pJk8t9R/H1MvNkq/tsSwewBeWidTd9/mBudWb2rTqW0xdPWRzs+fvEEnxIQFfVb/dlFYKP0z1hr7aluAzExZJ6I+0DEBHRuy3y1aAc6OAf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742456319; c=relaxed/simple;
	bh=JHLdkLcUJAeoSjLOjOQ5Yu1UAGtK5l5dDgCqHVL9ySA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=miDwYQVC2KUEFyHxWS+9dBQVC7Vm697M/7oRdMViOZm4rOUin95t/ddn+UO+sUT8gB/Pn+8KlMQN0lfQNhmRhQ/732bLJoF8hzmXJklvqxYKVSHFTiH8ADTvX7TO/PJ08lRCB5IANbOiZVIuArs3UjSeRV5i2LVfuoLeaNwyPZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOZYTct3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOZYTct3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742456316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2fhhdo0Q2kmWfyznvsRRLod+tnwx+qo4Nfy04dgWUo=;
	b=AOZYTct3KAjTFAo355b6lbpaFZKYGFLzF9zqGnct93gPQf22W84/zVNY6o3Nu1Cea8/SOy
	uN5spk0dqFWkcnQ13S0VzH/cu0cEBgfmyaIxsQbkUnFgCCcDBtF2Z8ksUYpjI2i6AMa5GE
	mIhFwevOftHyIj8jnrPe95An2v23IlM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-C8OsfNuvOxiBNBCv_luntA-1; Thu,
 20 Mar 2025 03:38:32 -0400
X-MC-Unique: C8OsfNuvOxiBNBCv_luntA-1
X-Mimecast-MFC-AGG-ID: C8OsfNuvOxiBNBCv_luntA_1742456311
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9AB41956075;
	Thu, 20 Mar 2025 07:38:30 +0000 (UTC)
Received: from fedora (unknown [10.72.120.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A1BCD3001D16;
	Thu, 20 Mar 2025 07:38:23 +0000 (UTC)
Date: Thu, 20 Mar 2025 15:38:18 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Jooyung Han <jooyung@google.com>, Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com, dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH V2 5/5] loop: add hint for handling aio via IOCB_NOWAIT
Message-ID: <Z9vF6vophr8uw66p@fedora>
References: <20250314021148.3081954-1-ming.lei@redhat.com>
 <20250314021148.3081954-6-ming.lei@redhat.com>
 <20250320072247.GD14337@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320072247.GD14337@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Mar 20, 2025 at 08:22:47AM +0100, Christoph Hellwig wrote:
> On Fri, Mar 14, 2025 at 10:11:45AM +0800, Ming Lei wrote:
> > Add hint for using IOCB_NOWAIT to handle loop aio command for avoiding
> > to cause write(especially randwrite) perf regression on sparse file.
> > 
> > Try IOCB_NOWAIT in the following situations:
> > 
> > - backing file is block device
> 
> Why limit yourself to block devices?

It doesn't limit to block device, just submit NOWAIT unconditionally.

I should have added 'OR' among the three lines.

> 
> > - READ aio command
> > - there isn't queued aio non-NOWAIT WRITE, since retry of NOWAIT won't
> > cause contention on WRITE and non-NOWAIT WRITE often implies exclusive
> > lock.
> 
> This reads really odd because to me the list implies that you only
> support reads, but the code also supports writes.  Maybe try to
> explain this more clearly.

Will improve the comment log.

> 
> > With this simple policy, perf regression of randwrte/write on sparse
> > backing file is fixed. Meantime this way addresses perf problem[1] in
> > case of stable FS block mapping via NOWAIT.
> 
> This needs to go in with the patch implementing the logic.

OK.

> 
> > @@ -70,6 +70,7 @@ struct loop_device {
> >  	struct rb_root          worker_tree;
> >  	struct timer_list       timer;
> >  	bool			sysfs_inited;
> > +	unsigned 		queued_wait_write;
> 
> lo_nr_blocking_writes?
> 
> What serializes access to this variable?

The write is serialized by the loop spin lock, and the read is done
via READ_ONCE(), since it is just a hint.

> 
> > +static inline bool lo_aio_need_try_nowait(struct loop_device *lo,
> > +		struct loop_cmd *cmd)
> 
> Drop the need_ in the name, it not only is superfluous, but also
> makes it really hard to read the function name.

OK.


Thanks, 
Ming

