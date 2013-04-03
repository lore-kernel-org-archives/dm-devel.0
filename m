From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Track block device users that created dirty pages
Date: Wed, 3 Apr 2013 17:05:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304031656420.31007@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com>
 <x491uau1csj.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x491uau1csj.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <msnitzer@redhat.com>, Christoph Hellwig <chellwig@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 1 Apr 2013, Jeff Moyer wrote:

> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > The new semantics is: if a process did some buffered writes to the block
> > device (with write or mmap), the cache is flushed when the process
> > closes the block device. Processes that didn't do any buffered writes to
> > the device don't cause cache flush. It has these advantages:
> > * processes that don't do buffered writes (such as "lvm") don't flush
> >   other process's data.
> > * if the user runs "dd" on a block device, it is actually guaranteed
> >   that the data is flushed when "dd" exits.
> 
> Why don't applications that want data to go to disk just call fsync
> instead of relying on being the last process to have had the device
> open?
> 
> Cheers,
> Jeff

Because the user may forget to specify "conv=fsync" on dd command line.

Anyway, when using dd to copy partitions, it should either always flush 
buffers on exit or never do it. The current state, when dd mostly flushes 
buffers, but doesn't with very low probability (if it races with lvm or 
udev) is confusing.

If the admin sees that dd flushes buffers on block devices for all his 
trials, he assumes that dd always flushes buffers on block devices. He 
doesn't know that there is a tiny race condition that makes dd not flush 
buffers.

Mikulas
