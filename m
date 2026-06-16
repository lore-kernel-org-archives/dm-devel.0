Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A9A44CAF9
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625333; cv=none; b=ECQjg2XMVLcWXXEhtKp0ejNfGhSZZPRqo3+u2PKg/y4EmcwbK/aw09cGVd1vFa3Q5Re8jns0upj0EZvlQGR+6StCMZEu+L338dVUVam4N+OLm13eS68APMKS1adGCmURQ8V8bBsOzNX17uWZY9lT2RBTEnzEevCU38YIUEJrzYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625333; c=relaxed/simple;
	bh=WP91IeHuUIc6ZGlOcFFWbT2AeT1Qzim81H43vwAOJG8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=l/2stvp3Zr1gIsNQfcd3oaGxOkYJIa1JO3DFlIlrePp4Pxl+zm7Qv9TTKI1hZIFT+r4VXtG9wGGw242nF5bFKCSWjQtjsZbWwVDE11dQKQfrQcb7wckHMl79YjyBlzbXcgHoxbi9zvvsryRuLLvMglrhPYvGPFpywns1cy13GMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wf1jKI05; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wf1jKI05"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781625331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ii/SeXD5SgFlrLanbpF8iZMQ+mdyR9RNtehZhznQDVM=;
	b=Wf1jKI05L2xe7jGCgt+DomYbO/UuKrb+uTaou4oh7TixOwzZqLRDOl2g9bq/klBblDR6fz
	OmfbTFMUz/bJiR55OTbW1UhZFMq+54B25Hn1Ln6l//jW/pDF7Te50YlqHHc2Zbk0sA+3v5
	nTa1FTIhRUTcr/6ZQitUD4IqtuciBsA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-SVIt8UCGOyuA4XXrQNRblQ-1; Tue,
 16 Jun 2026 11:55:27 -0400
X-MC-Unique: SVIt8UCGOyuA4XXrQNRblQ-1
X-Mimecast-MFC-AGG-ID: SVIt8UCGOyuA4XXrQNRblQ_1781625325
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE501802670;
	Tue, 16 Jun 2026 15:55:24 +0000 (UTC)
Received: from [10.44.32.53] (unknown [10.44.32.53])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4B8719560A2;
	Tue, 16 Jun 2026 15:55:21 +0000 (UTC)
Date: Tue, 16 Jun 2026 17:55:13 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Vjaceslavs Klimovs <vklimovs@gmail.com>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>, 
    Thorsten Leemhuis <regressions@leemhuis.info>, kbusch@kernel.org, 
    trnka@scm.com, Zdenek Kabelac <zdenek.kabelac@gmail.com>, 
    linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
    Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: Repeatable, raid1+O_DIRECT, hang/warn
In-Reply-To: <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
Message-ID: <27311df3-2c46-08be-825a-157ea906bdb2@redhat.com>
References: <ai7rnH20IYeSmY8s@gallifrey> <165d3195-c81d-4760-870b-23a9a3b3b72c@leemhuis.info> <ai_1LYtofh1fwD-N@gallifrey> <CAC_j7i0eDccVWzPeRafM50mZEOFHPz2cwd=RZqqx6TK2EVRFvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: Mgd8Jyyd3fjaNV9ZXglPx6PKM_gKuXP1uwEQz_VqoWM_1781625325
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi


On Mon, 15 Jun 2026, Vjaceslavs Klimovs wrote:

> Hi Dave, all,
> 
> I'm one of the original reporters and very much a user, not a block/dm
> developer, so please sanity-check all of this.
> 
> Your trace looks like what the two earlier reports hit: a read reaching
> a leaf device with sectors > 0 but phys_seg 0 (an empty bio). One aside
> that may help read the trace: blk_io_trace.error is a __u16, so the
> bracketed values on your C lines are errnos as u16 (65514 = -EINVAL,
> 65531 = -EIO).
> 
> The WARN itself is new, the bad bio isn't. bio_add_page() only started
> rejecting len == 0 in 643893647cac ("block: reject zero length in
> bio_add_page()", v7.1-rc1); on 7.0.8 the same empty bio tripped
> scsi_alloc_sgtables()'s !nr_segs instead, which matches what you saw.
> That fits your "not a recent regression": the condition is older, v7.1
> just made it loud.
> 
> For Tomas's and my reports (QEMU O_DIRECT to the LV block device) the
> origin looks like 5ff3f74e145a ("block: simplify direct io validity
> check", v6.18): blkdev_dio_invalid() now checks only aggregate
> ki_pos | count alignment and dropped the per-segment
> bdev_iter_is_aligned() walk, so a degenerate or misaligned O_DIRECT no
> longer gets -EINVAL at the fops boundary. But your reproducer reads a
> file, which goes through the filesystem O_DIRECT path and never calls
> blkdev_dio_invalid(), and still makes the empty bio. So it isn't only
> that one entry point.

I thought that reverting 5ff3f74e145a and re-introducing the alignment 
check in block/fops.c:blkdev_dio_invalid would fix it - but it wouldn't.

The same problem existed even before 5ff3f74e145a, with the pvmove 
command.

Suppose that the administrator needs to move a logical volume from one 
disk to another and uses pvmove. Pvmove inserts a new dm-mirror target 
underneath the logical volume and uses it to copy the data. Now, the 
dm-mirror target crashes whenever it receives bio with unaligned vectors.

So, I think that the proper way to fix this is to teach dm-mirror/dm-io to 
deal with unaligned bio vectors and handle them properly.

Mikulas

