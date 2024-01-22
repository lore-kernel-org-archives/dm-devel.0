Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61DD1366
	for <dm-devel@lists.linux.dev>; Mon, 22 Jan 2024 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705941018; cv=none; b=WH7m9fTBWRI5S/9Ppb8wAZvY+u514tE5yGvgy64tbLzFlc0cymGqBZorAfoHZnLKN5CK9idxx+9B4gBEU0vUVRn1csFb4U1BPNtPjIBd89U4We2K8lFHuVnsVhEezkdXraSKR8DwJqZ7Z3m4wa1iCLVaThrs1PJjA+bfwXTG8Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705941018; c=relaxed/simple;
	bh=FkeU1P4Kg6q0fZ6PmJzlGNg2n2Hty/oMxcKzx2UOhlQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=G3AuNCYt6m+c8sRUBDxCfDTTZbfFtQgR37H+Yv/oeDPYzYvdtutTzTygWQ+Qt3kHukBz2brlgV7lJcnAxqbKexEvW4pjQi4VE91cOdnAxbT6dsBGW6VTyxUFUsjlJC1NTcaUGuXxlB4lVXBdL4rnIcvQRBGUa91jPY6vsoQ6M44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M91NIq+v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M91NIq+v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705941015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gh5n5hMcdVsHj3TbGR4iAicOuNL7iE5wuH4NHtg9SMQ=;
	b=M91NIq+vtGofetGeaUUIpb7MelGbz3AYSGfo6HXUOiJTAXsN8sCeNw0SWcCw7CeEnkqb8d
	S40eYor5PwoxwH7yogfdo6mRPrt6xB88++so4fgw4fxte8n18jubcoU/l03nu5NQqdr/74
	UKKamJN4s758owYGgpAQ8B5Hp/Bqe8k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-pFhktqY5NmG4MXBEsctt1w-1; Mon, 22 Jan 2024 11:30:09 -0500
X-MC-Unique: pFhktqY5NmG4MXBEsctt1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E55686EB4B;
	Mon, 22 Jan 2024 16:30:08 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 41CFF111DCF0;
	Mon, 22 Jan 2024 16:30:08 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id E373D30B9D67; Mon, 22 Jan 2024 16:30:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id DF3763FB50;
	Mon, 22 Jan 2024 17:30:07 +0100 (CET)
Date: Mon, 22 Jan 2024 17:30:07 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>, Li Nan <linan666@huaweicloud.com>, 
    Christoph Hellwig <hch@infradead.org>, 
    Chaitanya Kulkarni <chaitanyak@nvidia.com>, linux-block@vger.kernel.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH v3 0/4] brd discard patches
In-Reply-To: <Zao1PNip1SRVB4Rp@fedora>
Message-ID: <dc9e648b-6c5f-9642-8892-b48dbc893c6@redhat.com>
References: <2dacc73-854-e71c-1746-99b017401c9a@redhat.com> <Zao1PNip1SRVB4Rp@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="185210117-1207581628-1705941007=:2579516"
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185210117-1207581628-1705941007=:2579516
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hi


On Fri, 19 Jan 2024, Ming Lei wrote:

> Hi Mikulas,
> 
> On Thu, Aug 10, 2023 at 12:07:07PM +0200, Mikulas Patocka wrote:
> > Hi
> > 
> > Here I'm submitting the ramdisk discard patches for the next merge window. 
> > If you want to make some more changes, please let me now.
> 
> brd discard is removed in f09a06a193d9 ("brd: remove discard support")
> in 2017 because it is just driver private write_zero, and user can get same
> result with fallocate(FALLOC_FL_ZERO_RANGE).
> 
> Also you only mentioned the motivation in V1 cover-letter:
> 
> https://lore.kernel.org/linux-block/alpine.LRH.2.02.2209151604410.13231@file01.intranet.prod.int.rdu2.redhat.com/
> 
> ```
> Zdenek asked me to write it, because we use brd in the lvm2 testsuite and
> it would be benefical to run the testsuite with discard enabled in order
> to test discard handling.
> ```
> 
> But we have lots of test disks with discard support: loop, scsi_debug,
> null_blk, ublk, ..., so one requestion is that why brd discard is
> a must for lvm2 testsuite to cover (lvm)discard handling?

We should ask Zdenìk Kabeláè about it - he is expert about the lvm2 
testsuite.

> The reason why brd didn't support discard by freeing pages is writeback
> deadlock risk, see:
> 
> commit f09a06a193d9 ("brd: remove discard support")
> 
> -static void discard_from_brd(struct brd_device *brd,
> -                       sector_t sector, size_t n)
> -{
> -       while (n >= PAGE_SIZE) {
> -               /*
> -                * Don't want to actually discard pages here because
> -                * re-allocating the pages can result in writeback
> -                * deadlocks under heavy load.
> -                */
> -               if (0)
> -                       brd_free_page(brd, sector);
> -               else
> -                       brd_zero_page(brd, sector);
> -               sector += PAGE_SIZE >> SECTOR_SHIFT;
> -               n -= PAGE_SIZE;
> -       }
> -}
> 
> However, you didn't mention how your patches address this potential
> risk, care to document it? I can't find any related words about
> this problem.

The writeback deadlock can happen even without discard - if the machine 
runs out of memory while writing data to a ramdisk. But the probability is 
increased when discard is used, because pages are freed and re-allocated 
more often.

Generally, the admin should make sure that the machine has enough 
available memory when creating a ramdisk - then, the deadlock can't 
happen.

Ramdisk has no limit on the number of allocated pages, so when it runs out 
of memory, the oom killer will try to kill unrelated processes and the 
machine will hang. If there is risk of overflowing the available memory, 
the admin should use tmpfs instead of a ramdisk - tmpfs can be configured 
with a limit and it can also swap out pages.

> BTW, your patches looks more complicated than the original removed
> discard implementation. And if the above questions get addressed,
> I am happy to provide review on the following patches.

My patches actually free the discarded pages. The original discard 
implementation just overwrote the pages with zeroes without freeing them.

Mikulas

> 
> 
> Thanks,
> Ming
> 
--185210117-1207581628-1705941007=:2579516--

