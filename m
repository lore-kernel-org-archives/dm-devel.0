From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] Fix I/O counts in vmstat
Date: Wed, 21 Mar 2012 11:50:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1203211148220.23047@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com>
 <4F69A798.4000200@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F69A798.4000200@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Wed, 21 Mar 2012, Jun'ichi Nomura wrote:

> Hi Mikulas,
> 
> > The decision whether bio is counted or not is made by the code that
> > submits the bio. This leads to some problems:
> 
> How about convering dm targets to use generic_make_request?

The problem would be raid1 resynchronization. There are no incoming bios 
when resynchronizing, but the administrator still needs to see the 
resynchronization workload in vmstat. The code path that submits bios for 
resynchronization is the same as the path that handles write requests.

Also dm-over-loop would still result in double-counting, even if we use 
generic_make_request in dm.

Mikulas

> Since submit_bio counts vm events, it seems natural for
> caller to decide which function to use.
> Device driver does not know whether the requested I/O is
> for vm-to-device or device-to-device.
> We could still use iostat to measure throughput of individual
> block devices. 
> 
> Thanks,
> -- 
> Jun'ichi Nomura, NEC Corporation
> 
