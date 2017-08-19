From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Sat, 19 Aug 2017 13:34:15 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708191318110.2380@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
	<CAGnHSEm2Jz35Em6h-a8ofXr9ApgBKJq5mOCG9ZtN4+FuRxj8Aw@mail.gmail.com>
	<alpine.LRH.2.02.1708142007510.24994@file01.intranet.prod.int.rdu2.redhat.com>
	<CAGnHSEnrTnvrkNdYJodSL51VUA+=FemdXEMnQ30rVwjCOHMoYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAGnHSEnrTnvrkNdYJodSL51VUA+=FemdXEMnQ30rVwjCOHMoYA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tom Yan <tom.ty89@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, hch@lst.de, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Wed, 16 Aug 2017, Tom Yan wrote:

> What I find suspicious is `blkdiscard -z` the underlying device does
> not lead to those warning (while it takes the same amount of time), it
> makes me wonder if it's like, the dm layer is not doing certain thing
> it should do to inform the block layer or whatsoever that the action
> is ongoing as expected (like, notify about the completion of each
> "part" of the request). There must be a reason that doing it to a SCSI
> device directly does not trigger such warning, no?

If you issue a single ioctl that takes extreme amount of time - the kernel 
warns about being blocked for extreme amount of time - what else should it 
do?

You can change submit_bio_wait to call wait_for_completion_io_timeout 
instead of wait_for_completion_io (and retry if the timeout was hit) - 
that will shut the warning up, but it won't speed up the operation.

The zeroing operation can't be made interruptible easily because if you 
the operation were interrupted, there would be pending bios left.

> Also when cat or cp /dev/zero to the crypt does cause any problem,

cp /dev/zero generates large amount of small write syscalls (so every 
single syscall completes quickly). blkdiscard -z generates one 
long-lasting syscall that clears the whole device.

> doesn't that to some extent show that the approach
> __blkdev_issue_zeroout taken isn't proper/general enough?
> 
> >
> > So, it's probably bug in error handling in the underlying device (or in
> > dm-crypt). Was the device that experienced errors the same as the root
> > device of the system?
> >
> 
> I am not sure. It was two separate drives. The root device was a
> usb-storage thumb drive and the drive used for blkdiscard trial was a
> SATA drive on a uas adapter. Both of them are connected to a USB 2.0
> hub. It might be just the hub having hiccup.
> 
> >
> > The number of in-flight bios could be also limited in next_bio (because if
> > you have really small memory and large device, the memory could be
> > exhausted by the allocation of bio structures). But this is not your case.
> >
> 
> Is the dm layer "aware of" next_bio? I mean, apparently what next_bio
> does seems to be "chaining up" bios (of the whole request, which could
> be the size of a disk or so), and when the chain reaches the dm layer,
> it seems that it wasn't splited (in the "processing" sense, not
> "alignment" sense, if you know what I mean) again properly.

The chained bios arrive independently to the dm layer and the dm layer 
doesn't care about how they are changed.

> > Note that no pages are allocated in function that does the zeroing
> > (__blkdev_issue_zeroout). The function creates large number of bios and
> > all the bios point to the same page containing all zeroes. The memory
> > allocation happens when dm-crypt attempts to allocate pages that hold the
> > encrypted data.
> >
> 
> Yeah I know that. And that's where comes the problem. Shouldn't
> dm-crypt decide how much to hold base on the capability of the
> underlying device instead of the available memory? (e.g. blocks per
> command, command per queue, maximum numbers of queues...)

Changing the memory limit in dm-crypt doesn't change the number of bios 
that dm-crypt receives. If you lower the memory limit, you decrease 
performance (because there would be less parallelism) and you gain 
nothing. It won't solve the long-wait problem.

> > There are other cases where dm-crypt can cause memory exhaustion, so the
> > fix in dm-crypt is appropriate. Another case where it blows the memory is
> > when you create a device that has an odd number of sectors (so block size
> > 512 is used), use dm-crypt on this device and write to the encrypted
> > device using the block device's page cache. In this case, dm-crypt
> > receives large amount of 512-byte bios, allocates a full 4k page for each
> > bio and it also exhausts memory. This patch fixes this problem as well.
> >
> 
> I am not saying that this patch is like totally wrong though. It's
> just that it seems to be more of a supplement / precaution in case
> things go terribly wrong, but not a fix that deals with the problem
> under the hood.
> 
> P.S. I am sorry if any of these are non-sensical. I don't really know
> much about how the block layer or the dm layer work. What I said are
> pretty much base on instinct so don't mind me if I sounded naive.

Mikulas
