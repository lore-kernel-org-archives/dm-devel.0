From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] Introduce percpu rw semaphores
Date: Mon, 30 Jul 2012 20:00:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1207301955370.4547@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz> <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
 <1343508252.2626.13184.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
 <20120730170013.GA4778@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120730170013.GA4778@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org, lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 30 Jul 2012, Paul E. McKenney wrote:

> On Sun, Jul 29, 2012 at 01:13:34AM -0400, Mikulas Patocka wrote:
> > On Sat, 28 Jul 2012, Eric Dumazet wrote:
> > > On Sat, 2012-07-28 at 12:41 -0400, Mikulas Patocka wrote:
> 
> [ . . . ]
> 
> > > (bdev->bd_block_size should be read exactly once )
> > 
> > Rewrite all direct and non-direct io code so that it reads block size just 
> > once ...
> 
> For whatever it is worth, the 3.5 Linux kernel only has about ten mentions
> of bd_block_size, at least according to cscope.
> 
> 							Thanx, Paul

plus 213 uses of i_blkbits (which is derived directly from bd_block_size). 
45 of them is in fs/*.c and mm/*.c

Mikulas
