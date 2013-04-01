From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Track block device users that created dirty pages
Date: Mon, 01 Apr 2013 11:38:36 -0400
Message-ID: <x491uau1csj.fsf@segfault.boston.devel.redhat.com>
References: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1303291042100.23238@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Fri, 29 Mar 2013 12:08:34 -0400 (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <msnitzer@redhat.com>, Christoph Hellwig <chellwig@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Mikulas Patocka <mpatocka@redhat.com> writes:

> The new semantics is: if a process did some buffered writes to the block
> device (with write or mmap), the cache is flushed when the process
> closes the block device. Processes that didn't do any buffered writes to
> the device don't cause cache flush. It has these advantages:
> * processes that don't do buffered writes (such as "lvm") don't flush
>   other process's data.
> * if the user runs "dd" on a block device, it is actually guaranteed
>   that the data is flushed when "dd" exits.

Why don't applications that want data to go to disk just call fsync
instead of relying on being the last process to have had the device
open?

Cheers,
Jeff
