From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size is changed at the same time
Date: Tue, 18 Sep 2012 13:22:40 -0400
Message-ID: <x49obl3s0tb.fsf@segfault.boston.devel.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<20120628111541.GB17515@quack.suse.cz>
	<Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	<x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	<x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	<1343508252.2626.13184.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
	<1343556630.2626.13257.camel@edumazet-glaptop>
	<1343586962.2626.13266.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
	<x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
	<x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Tue, 18 Sep 2012 13:04:58 -0400 (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org, lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> writes:

> Hi Jeff
>
> Thanks for testing.
>
> It would be interesting ... what happens if you take the patch 3, leave 
> "struct percpu_rw_semaphore bd_block_size_semaphore" in "struct 
> block_device", but remove any use of the semaphore from fs/block_dev.c? - 
> will the performance be like unpatched kernel or like patch 3? It could be 
> that the change in the alignment affects performance on your CPU too, just 
> differently than on my CPU.

I'll give it a try and report back.

> What is the CPU model that you used for testing?

http://ark.intel.com/products/53570/Intel-Xeon-Processor-E7-2860-%2824M-Cache-2_26-GHz-6_40-GTs-Intel-QPI%29

Cheers,
Jeff
