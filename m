From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Wed, 16 Aug 2017 00:51:06 +0800
Message-ID: <CAGnHSEnrTnvrkNdYJodSL51VUA+=FemdXEMnQ30rVwjCOHMoYA@mail.gmail.com>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
	<CAGnHSEm2Jz35Em6h-a8ofXr9ApgBKJq5mOCG9ZtN4+FuRxj8Aw@mail.gmail.com>
	<alpine.LRH.2.02.1708142007510.24994@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1708142007510.24994@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com, hch@lst.de, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On 15 August 2017 at 08:20, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> It happens because encryption is too slow, it takes more than 120 seconds
> to clear the device. I don't know what else it should do. It is not easy
> to interrupt the operation because you would then have to deal with
> dangling bios.
>

What I find suspicious is `blkdiscard -z` the underlying device does
not lead to those warning (while it takes the same amount of time), it
makes me wonder if it's like, the dm layer is not doing certain thing
it should do to inform the block layer or whatsoever that the action
is ongoing as expected (like, notify about the completion of each
"part" of the request). There must be a reason that doing it to a SCSI
device directly does not trigger such warning, no?

Also when cat or cp /dev/zero to the crypt does cause any problem,
doesn't that to some extent show that the approach
__blkdev_issue_zeroout taken isn't proper/general enough?

>
> So, it's probably bug in error handling in the underlying device (or in
> dm-crypt). Was the device that experienced errors the same as the root
> device of the system?
>

I am not sure. It was two separate drives. The root device was a
usb-storage thumb drive and the drive used for blkdiscard trial was a
SATA drive on a uas adapter. Both of them are connected to a USB 2.0
hub. It might be just the hub having hiccup.

>
> The number of in-flight bios could be also limited in next_bio (because if
> you have really small memory and large device, the memory could be
> exhausted by the allocation of bio structures). But this is not your case.
>

Is the dm layer "aware of" next_bio? I mean, apparently what next_bio
does seems to be "chaining up" bios (of the whole request, which could
be the size of a disk or so), and when the chain reaches the dm layer,
it seems that it wasn't splited (in the "processing" sense, not
"alignment" sense, if you know what I mean) again properly.

>
> Note that no pages are allocated in function that does the zeroing
> (__blkdev_issue_zeroout). The function creates large number of bios and
> all the bios point to the same page containing all zeroes. The memory
> allocation happens when dm-crypt attempts to allocate pages that hold the
> encrypted data.
>

Yeah I know that. And that's where comes the problem. Shouldn't
dm-crypt decide how much to hold base on the capability of the
underlying device instead of the available memory? (e.g. blocks per
command, command per queue, maximum numbers of queues...)

>
> There are other cases where dm-crypt can cause memory exhaustion, so the
> fix in dm-crypt is appropriate. Another case where it blows the memory is
> when you create a device that has an odd number of sectors (so block size
> 512 is used), use dm-crypt on this device and write to the encrypted
> device using the block device's page cache. In this case, dm-crypt
> receives large amount of 512-byte bios, allocates a full 4k page for each
> bio and it also exhausts memory. This patch fixes this problem as well.
>

I am not saying that this patch is like totally wrong though. It's
just that it seems to be more of a supplement / precaution in case
things go terribly wrong, but not a fix that deals with the problem
under the hood.

P.S. I am sorry if any of these are non-sensical. I don't really know
much about how the block layer or the dm layer work. What I said are
pretty much base on instinct so don't mind me if I sounded naive.
