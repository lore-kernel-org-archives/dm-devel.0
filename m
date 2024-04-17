Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0A51649D1
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713371489; cv=none; b=SkCxuoDIbkmm4SI89RQG7+S40w0B362GnLGQfNAIjHCFERETuP5JSzJEdIevePkqZh6kK/t5SFeGke6s7a2dN/Gzblt+UZJJKPTfSChgRI2sanHzbVGzHr/YaLTbq1sMZ/20hWO5O/G2aYokP4kFFf6LlAh7PhZydl8TVsA8ZkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713371489; c=relaxed/simple;
	bh=oRJmJDBnbb7cE2brR6dl76P5LK2zQCvp0LZZTKWwo/0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TsUPOjFu3qO8N4shEeNkRRI5UJVXrZd/Q4tiWem5sa6AoSal14I2duip/aiahRVhoxiQ6ySvcL7KW1bSfzl5b2fHWI0Es83+jOzoWiVmNd7cFyyInhyqATpzL4dsbvBgvjD7piYKS2WH328eJGTWGNJ6qA9G1xzr676JonHHQ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iBuesZBJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iBuesZBJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713371486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZlPQpTKDhE0AxETHvxS2mC29zGtgspnJJkZTl/Ld1zA=;
	b=iBuesZBJlDvNWAf1aJN4rkp0+2uBqECN4+fMLtSI29sO5JKxobcN01A+kVbLHp1x+FooES
	vZDqqtG4qmfGM7aEvon8UAb0O86FPaqPjy/yzoM+T2R1wZOclUjmybQcVdS+Mr6vpGY1yZ
	WYFx97jtuBNm6Z0dNG3TNU2eyMZq6eo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-Pj2DAvCNP16DJBya_ASzjA-1; Wed, 17 Apr 2024 12:31:23 -0400
X-MC-Unique: Pj2DAvCNP16DJBya_ASzjA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D35830E7F;
	Wed, 17 Apr 2024 16:31:23 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 101B751EF;
	Wed, 17 Apr 2024 16:31:23 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id EC50830BFED5; Wed, 17 Apr 2024 16:31:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id E63363FB54;
	Wed, 17 Apr 2024 18:31:22 +0200 (CEST)
Date: Wed, 17 Apr 2024 18:31:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Mike Snitzer <msnitzer@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, 
    Guangwu Zhang <guazhang@redhat.com>, dm-devel@lists.linux.dev, 
    linux-block@vger.kernel.org
Subject: Re: [PATCH v3] dm-io: don't warn if flush takes too long time
In-Reply-To: <e86c972f-4acc-4b89-9872-b5f92606cfd9@kernel.dk>
Message-ID: <cb981b28-40c9-d175-ad13-4bee1a1422eb@redhat.com>
References: <754d1973-31cb-d3ca-1f6f-2d35b96364db@redhat.com> <e86c972f-4acc-4b89-9872-b5f92606cfd9@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5



On Wed, 17 Apr 2024, Jens Axboe wrote:

> On 4/17/24 3:05 AM, Mikulas Patocka wrote:
> > There was reported hang warning when using dm-integrity on the top of loop
> > device on XFS on a rotational disk. The warning was triggered because
> > flush on the loop device was too slow.
> > 
> > There's no easy way to reduce the latency, so I made a patch that shuts
> > the warning up.
> > 
> > There's already a function blk_wait_io that avoids the hung task warning.
> > This commit moves this function from block/blk.h to
> > include/linux/completion.h, renames it to wait_for_completion_long_io
> > (because it is not dependent on the block layer at all) and uses it in
> > dm-io instead of wait_for_completion_io.
> 
> Change looks fine to me, but while at it, let's just move it into
> blk-core.c and make it public, no need for this function to be a static
> inline.
> 
> -- 
> Jens Axboe

I think we should move it to ./kernel/sched/completion.c. Because the 
function has no dependency on the block layer.

I'll send a patch that does it.

Mikulas

