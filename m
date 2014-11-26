From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
Date: Wed, 26 Nov 2014 16:28:27 +1030
Message-ID: <87bnnuy03g.fsf@rustcorp.com.au>
References: <20141120190058.GA31214@redhat.com> <20141120203044.GA9078@redhat.com> <20141120211521.GA846@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141120211521.GA846@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:
> On Thu, Nov 20 2014 at  3:30pm -0500,
> Michael S. Tsirkin <mst@redhat.com> wrote:
>
>> On Thu, Nov 20, 2014 at 02:00:59PM -0500, Mike Snitzer wrote:
>> > virtio_blk incorrectly established -1U as the default for these
>> > queue_limits.  Set these limits to sane default values to avoid crashing
>> > the kernel.
> ...
>> > Attempting to mkfs.xfs against a thin device from this thin-pool quickly
>> > resulted in fs/direct-io.c:dio_send_cur_page()'s BUG_ON.
>> 
>> Why exactly does it BUG_ON?
>> Did some memory allocation fail?
>
> No idea, kernel log doesn't say.. all it has is "kernel BUG" pointing to
> fs/direct-io.c:dio_send_cur_page()'s BUG_ON.
>
> I could dig deeper on _why_ but honestly, there really isn't much point.

There is *always* a point in understanding the code you are modifying.

> virtio-blk doesn't get to live in fantasy-land just because it happens
> to think it is limitless.

Calm down please.

We don't have a sector limit.  We have a segment limit, which is set
above this line.

Cheers,
Rusty.
