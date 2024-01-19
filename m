Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6411E862
	for <dm-devel@lists.linux.dev>; Fri, 19 Jan 2024 08:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705653733; cv=none; b=k30h/m72ZN2kLJL9sa64XG9ykRQI0dKhMjWg6dZixXpOfIkoNvlktEjCfgAPCLGDoOQQTgFxZly12YGkdgK3aidoWThD7vtaG+MULrzGY1Mst6yk8ehMrC2WSf0n09mPrxj4a3qV3hDQr2CXAbNot+WU0th8KEd9wsB4CWedIN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705653733; c=relaxed/simple;
	bh=enRZTZ3A/5sPOqR7e0wgcPMlzxpsSHc7+zk9ab9y1H8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DuZXCGOHz87qAUdpF1P6mAN/8J/ElKVTTkymu2rXxwbVz1rw2u7ohQ13Bw0mNA7e4cPTXVxQ8dVeBNpUOaGopXzmXYOMXdtwPN/tEq0wKNLtPd7dGFac+nJHwyJ2rTL9YrLQ2rXtESwTzZH67ycSGklPWc6BFjD6TIfEaOf2U1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bEQRenmb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bEQRenmb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705653730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iZwuvLGmOYB4Vf9wQkXsFnJm7UNiZ3ky5C2IOeAmnx0=;
	b=bEQRenmb1V0Wdyiwe7qTFn7SGplajTTHQYNZpcWnNW1MfWwY5tQDR2qw/a/yEIDO9oRwBk
	F4CM9zfUxlmwW6/rho3w8pdsMuEkP+ie47AdfUyNU2xBJFv2rFszAE3mZY1uvdV/EC0vvo
	aTD7A4t+xGlOTafz0gcs0J2dcUFAu2g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-Sqz9YkkjMUu6uMmdzNElJQ-1; Fri, 19 Jan 2024 03:42:07 -0500
X-MC-Unique: Sqz9YkkjMUu6uMmdzNElJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C18E83535E;
	Fri, 19 Jan 2024 08:42:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.42])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61B8F40C1430;
	Fri, 19 Jan 2024 08:42:02 +0000 (UTC)
Date: Fri, 19 Jan 2024 16:41:58 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Li Nan <linan666@huaweicloud.com>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	ming.lei@redhat.com
Subject: Re: [PATCH v3 0/4] brd discard patches
Message-ID: <Zao1PNip1SRVB4Rp@fedora>
References: <2dacc73-854-e71c-1746-99b017401c9a@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dacc73-854-e71c-1746-99b017401c9a@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Hi Mikulas,

On Thu, Aug 10, 2023 at 12:07:07PM +0200, Mikulas Patocka wrote:
> Hi
> 
> Here I'm submitting the ramdisk discard patches for the next merge window. 
> If you want to make some more changes, please let me now.

brd discard is removed in f09a06a193d9 ("brd: remove discard support")
in 2017 because it is just driver private write_zero, and user can get same
result with fallocate(FALLOC_FL_ZERO_RANGE).

Also you only mentioned the motivation in V1 cover-letter:

https://lore.kernel.org/linux-block/alpine.LRH.2.02.2209151604410.13231@file01.intranet.prod.int.rdu2.redhat.com/

```
Zdenek asked me to write it, because we use brd in the lvm2 testsuite and
it would be benefical to run the testsuite with discard enabled in order
to test discard handling.
```

But we have lots of test disks with discard support: loop, scsi_debug,
null_blk, ublk, ..., so one requestion is that why brd discard is
a must for lvm2 testsuite to cover (lvm)discard handling?

The reason why brd didn't support discard by freeing pages is writeback
deadlock risk, see:

commit f09a06a193d9 ("brd: remove discard support")

-static void discard_from_brd(struct brd_device *brd,
-                       sector_t sector, size_t n)
-{
-       while (n >= PAGE_SIZE) {
-               /*
-                * Don't want to actually discard pages here because
-                * re-allocating the pages can result in writeback
-                * deadlocks under heavy load.
-                */
-               if (0)
-                       brd_free_page(brd, sector);
-               else
-                       brd_zero_page(brd, sector);
-               sector += PAGE_SIZE >> SECTOR_SHIFT;
-               n -= PAGE_SIZE;
-       }
-}

However, you didn't mention how your patches address this potential
risk, care to document it? I can't find any related words about
this problem.

BTW, your patches looks more complicated than the original removed
discard implementation. And if the above questions get addressed,
I am happy to provide review on the following patches.


Thanks,
Ming

