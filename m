From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache questions
Date: Tue, 10 Dec 2013 09:50:19 +0000
Message-ID: <20131210095019.GB32555@debian>
References: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <093f01cef54a$fdf044d0$f9d0ce70$@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 09, 2013 at 05:56:03PM -0800, Paul B. Henson wrote:
> I'm building a small virtualization server for which I'd like to avail of
> ssd caching to increase performance. While there seems to be an increasing
> plethora of options for ssd caching under linux, I'd like to stick with
> something that's part of the mainline kernel, which I think restricts the
> playing field down to bcache or dm-cache.
> 
> After reviewing the dm-cache documentation and mailing list archives, I had
> a few questions I hope somebody might be able to answer; I apologize in
> advance if any of them are silly or something I should've already found on
> my own.
> 
> I've got four WD RE4 2TB drives that I plan to configure as RAID10 for the
> data device, and two Samsung 840 Pro 256GB SSD's that I plan to configure as
> RAID1 for the cache device. I'd like to set up write back caching to improve
> both read and write performance. I was going to set up lvm on top of the
> cached device and then use lv's as the backing store for kvm virtual
> machines.
> 
> Is dm-cache considered ready for production deployment? From what I
> understand, there are plans to add support for managing dm-cache to lvm2,
> and without that it's a bit cryptic to use/set up. I see that Fedora has
> deferred including support for dm-cache into their distribution pending that
> lvm2 support, but other than easing configuration/management, are there any
> reasons not to go ahead and deploy dm-cache in production now working with
> it directly rather than through lvm2?

I've just found a serious bug that causes metadata space to be used up
too quickly.  So hold off until I get a patch together later this week.

> What is the recommended kernel version for using dm-cache? Would 3.10LTS be
> suitable, or would it be better at this point to be running the latest
> stable, eg 3.12.x now, and then 3.13.x once 3.12 goes EOL, to be sure to
> have the latest bug fixes and performance enhancements?
> 
> >From reviewing the documentation, in addition to the origin/backing device
> and the cache device, a third device is necessary for metadata. Per the
> documentation the rationale for having a separate device for metadata rather
> than simply using the cache device is so that the metadevice can be
> configured with different redundancy; the example given is that perhaps it
> could be mirrored. I'm confused though as to what utility there is an having
> a metadata device with a different level of redundancy than the cache
> device. If the metadata device is mirrored, and the cache device is not, you
> will still be able to access the metadata should the cache device fail, but
> given the cache device has failed, what are you going to do with it?

The metadata is stored in btrees, damaging a high level node in this
btree can lose an awful lot of mappings.  So I recommend mirroring it.
dm-cache using the same metadata library as dm-thin, where commonly
people would want to put the metadata on SSD and the data on a
spindle.  Your volume manage (eg, LVM2) should be doing this
transparently for you.

> What are the performance requirements of the metadevice? For my system, I
> can either put it on the cache device, on the origin device, or I have
> another mirror of two USB sticks used for /boot that it could go on.
> Intuitively it seems the metadata device should be fast/low latency, so my
> first guess would be the best location would be on the SSD mirror I'm using
> for cache. Based on the examples I've seen, you can either partition the
> device into two pieces to separate metadata from cache, or use dm-linear,
> I'm thinking I'll go with partitioning as that seems simpler and I'm more
> familiar with it, although I suppose that will result in a little bit of
> waste for the partition table and alignment.

Personally I'd use linear, since it allows you to resize easily.

> With bcache, they recommend selecting the bucket size and block size based
> on the specifications of your SSD, is there any similar recommended
> alignment with the underlying SSD for selecting dm-cache block size? The SSD
> I am using has a 1024k erase block size and an 8k page size. Or should be
> block size be tuned based more on the size of the origin device relative to
> the cache device and your expected I/O sizes, with no particular regard for
> the physical characteristics of your SSD ?

bcache is log based, and so uses the ssds more efficiently.  For
dm-cache I'd say your IO patterns, and size of the hotspots were the
dominant factor.

> >From what I've read, the rule of thumb algorithm for sizing your metadata
> device is 4 MB + ( 16 bytes * nr_blocks ). Is that still accurate? So, if I
> hypothetically selected a 256k block size, I would calculate it as:
> 
> # blockdev --getsize64 /dev/md2          (ssd mirror)
> 255926140928
> 
> 4194304 + (16 * 255926140928 / 262144)  = 19814796
> 
> So I would need to make a partition of size approximately 19MB for the
> metadata? Then, assuming I partitioned md2 into md2p1 (metadata) and md2p2
> (cache), and my origin device was md3, I could create the cache device via:

Yes, but go crazy and round up to 128m since it's so small.

> 
> # blockdev --getsz /dev/md3 
> 7813531648
> 
> # dmsetup create md3-cached --table '0 7813531648 cache /dev/md2p1
> /dev/md2p2 /dev/md3 512 1 writeback default 0'
> 
> For shutdown, you should then arrange to run 'dmsetup suspend md3-cached'
> at reboot/halt so it goes down cleanly? From what I read, dm-cache should be
> reasonably robust in the face of a crash/panic, so this is really more of an
> optimization as opposed to a hard requirement?

Definitely shut down cleanly.  This allows the policy plugin to write
it's 'hint' array that will improve performance on reload.  For
example the default 'mq' policy stores the hit counts for the cached
blocks.

> Just a couple more miscellaneous questions :), is there any way to switch
> between modes/policies without downtime on the cache device? For example, if
> one of the SSD's failed and you wanted to switch to write through mode
> rather than write back until you replaced it and the mirror was healthy
> again?

Use the normal suspend, reload, resume cycle.

> Is there any support or integration with SSD TRIM for the cache device? Not
> necessarily in real-time, as that can degrade performance, but occasionally
> in batch ala fstrim for filesystems, to get dm-cache to TRIM all of the not
> in use blocks at that time in order to optimize the SSD garbage collector?

dm-cache both passes down trim messages, and keeps track of discarded
origin blocks in it's metadata to avoid redundant io on promotion/demotion.

> If you have read this far, thank you very much :), I'm sorry for such a long
> message, but I'm trying to wrap my head around this and be sure I have a
> good understanding before using it.

No problem, yell if you need more help.

- Joe
