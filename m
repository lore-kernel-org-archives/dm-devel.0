Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C505E488766
	for <dm-devel@lists.linux.dev>; Fri,  2 Oct 2026 13:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790946218; cv=none; b=adKvryPNIDvt8sQi74OIg/yNGu5zM7WhVFaG/4Xt5a/znG6j/awLtZyE4fteiPauy/I5aTbdCdDQplyneGEvziODsLj8cXq8MBGVcHeUgIoCRKdIaYoUMiwcNb6L4p6nx1mQfRbiWWYOq2Lhp1qrM8vrLvIoSjEOJpaeEKyhilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790946218; c=relaxed/simple;
	bh=HCUaEAIGAg6w/EH0mq4V5yxVF39FNf3VT+ZNbgripuM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fsxIqmjg6UExQBLI5t1KT/aZn5H3WDpi/5kKYq8/mJjIEbj5DUi5H6xoFf22CSZFo+6kj5nf6pz2H8j+wuTtM9F3+fJ3AITkcRomnkRhSocnZ8ayW2whAIJXvrCBK3Qw1XWMSVAG36pLukBd+WrxEIJR4rzcEfJl7TIZReoJ9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EwHayb10; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EwHayb10"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790946210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/YoDne9gv8CyiY34FvVfIFIf4CxuQKs48NaJzHyRuBc=;
	b=EwHayb107AASNuJtWg1pJmZzd4Ld8SZGB0bOz7yXs9ScCCMjLsWKJzJiUqdu427bWHvAaE
	/J0BcTsCpRWH07xyKyl7ZU+YrVKkwbojte3cCr2YE3Kc7UNsm+kfx3KbLrpEA+Ws9SLAHD
	kkRQe3zCQysLLDmyUA2gTwaGVWePx8c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-FocfahYxMvGccvgYsF5vjQ-1; Fri,
 02 Oct 2026 09:03:27 -0400
X-MC-Unique: FocfahYxMvGccvgYsF5vjQ-1
X-Mimecast-MFC-AGG-ID: FocfahYxMvGccvgYsF5vjQ_1790946206
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 00CB51955D93;
	Fri,  2 Oct 2026 13:03:26 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E596B1956087;
	Fri,  2 Oct 2026 13:03:24 +0000 (UTC)
Date: Fri, 2 Oct 2026 15:03:22 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Henry Wong <henry@stuffedcow.net>
cc: dm-devel@lists.linux.dev
Subject: Re: [PATCH 2/2] dm-writecache: Add evict_clean_blocks option to
 allow read hits on clean blocks
In-Reply-To: <7e9b1afd-2249-4303-81c5-758f26e8f83e@stuffedcow.net>
Message-ID: <a628dc70-e9de-a638-5207-37afd0a00493@redhat.com>
References: <20260907214648.3691695-1-henry@stuffedcow.net> <20260907214648.3691695-3-henry@stuffedcow.net> <925889dd-c3ed-db47-48bb-a0b347752c09@redhat.com> <7e9b1afd-2249-4303-81c5-758f26e8f83e@stuffedcow.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aKTK_Z6_jszDchqfShbdl04Fw1-k94Kqg9S1frmfoQU_1790946206
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 21 Sep 2026, Henry Wong wrote:

> Hi Mikulas,
> 
> I understand that the original motivation for dm-writecache is for use as a
> write buffer to absorb write bursts quickly onto non-volatile storage, and I
> think there was an implicit assumption that the size of the dm-writecache
> doesn't tend exceed the page cache size. In this scenario, recently-written
> data will indeed still be in the page cache and there isn't a need for
> dm-writecache to serve reads.
> 
> My use case is a system with small RAM (~32 GB) with huge dm-writecache
> (~1TB). Here, "recently-written" means within the last few days, and the
> writecache is so big that "recently-written" data won't fit in the page cache.
> It's intended to target the usage pattern of "New data is written to disk,
> manipulated a few times over a few days, and then archived". A huge
> dm-writecache basically lets me keep the last few days of work cached.
> 
> It's possible to achieve this effect by setting the watermark levels high and
> keeping the cache dirty. But keeping the cache dirty for multiple days
> increases the risk of data loss, and setting the watermark levels high reduces
> the ability to absorb a large write burst if it happens. Having a "clean"
> state allows cleaning the cache quickly while still having the "last 3 days of
> work are probably cached" behaviour.

Hi

I started to test and review your patch and it crashes immediatelly in the 
persistent-memory mode.

[  755.171158] kernel BUG at drivers/md/dm-writecache.c:2138!
BUG_ON(g->state != WC_VALID_DIRTY)


Also, there's a minor bug - these two lines should be added to 
writecache_status, so that the arg counter is consistent with the number 
of args.
                if (!wc->evict_clean_blocks)
                        extra_args += 2;



Please, test and fix the pmem mode:

download the current device mapper tree from:

git clone git://git.kernel.org:/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
git checkout remotes/origin/for-next

(note that this repository contains important fixes for the dm-writecache 
persistent memory mode, persistent memory mode doesn't work in the 
upstream kernel).

enable the persistent memory mode in the kernel config:
In Device drivers, select
	NVDIMM (Non-Volatile Memory Device) Support
	DAX: direct access to differentiated memory
In Processor type and features, select
	Support non-standard NVDIMMs and ADR protected memory

Add the argument "memmap" to the kernel command line, for example 
"memmap=1G!4G" - this creates an emulated persistent memory device with 
the size "1GiB" at address "4GiB" (you must have more than 5GiB of 
memory). This persistent memory device will obviously lose data on power 
failure, but it's good for testing if you don't have real persistent 
memory.

After reboot, you should see a device /dev/pmem0 that should have 1GiB 
size.

Download the "fsx" filesystem stress-testing tool.

Try these commands, they trigger the BUG:
# modprobe brd rd_size=524288
# dmsetup create lin1 <<EOF
0 1048576 linear /dev/ram0 0
1048576 1048576 linear /dev/ram1 0
2097152 1048576 linear /dev/ram2 0
EOF
# dd if=/dev/zero of=/dev/pmem0 bs=4k count=1 oflag=direct
# dmsetup create wb --table "0 3145728 writecache p /dev/mapper/lin1 /dev/pmem0 1024 0"
# mkfs.ext4 -b 1024 -E orphan_file_size=524288 /dev/mapper/wb
# sleep 1
# dmsetup remove wb
# dmsetup create wb --table "0 3145728 writecache p /dev/mapper/lin1 /dev/pmem0 1024 4 autocommit_time 2 evict_clean_blocks 0"
# fsck.ext4 -fn -C0 /dev/mapper/wb
# mount -t ext4 /dev/mapper/wb /mnt/test
# truncate -s 1400001536 /mnt/test/file
# fsx -Z -r 1024 -w 1024 -R -W -l 1400001536 -L /mnt/test/file

Mikulas

