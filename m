From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache with zero hit rate
Date: Wed, 31 Jul 2013 16:25:22 -0400
Message-ID: <20130731202522.GD18513@redhat.com>
References: <20130731185017.GA13215@uio.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130731185017.GA13215@uio.no>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 31 2013 at  2:50pm -0400,
Steinar H. Gunderson <sgunderson@bigfoot.com> wrote:

> Hi,
> 
> I recently set up dm-cache below my main LVM, so that /dev/md2 (a RAID-0 of
> two SSDs) has an LVM with /dev/mapper/cache-blocks and
> /dev/mapper/cache-metadata, which then back /dev/md1 (a RAID-6 of rotating
> disks), where my main LVM, including the root device etc., lies.
> 
> After a fair amount of fighting with udev and initramfs-tools, plus upping
> the block size to 2048 since 512 complained about not enough RAM (on a 24GB
> machine!), this seems to boot up and work, but I seem to get absolutely zero
> cache hits.

Kudos to you for hacking that to work.

> dmsetup table for the device:
> 
>   cache: 0 23440891904 cache 254:0 254:1 9:1 2048 1 writeback default 4 random_threshold 8 sequential_threshold 512
> 
> dmsetup status for it:
> 
>   cache: 0 23440891904 cache 913/8192 0 170976 0 9614 0 0 0 0 0 2 migration_threshold 2048 4 random_threshold 8 sequential_threshold 512
> 
> Note in particular 0/170976 cached reads and 0/9614 cached writes.

Yeah, no promotions, translates to all misses.
 
> Is this normal? Is there any good reason why an LVM on top of a dm-cache
> device would not be supported? Or do I just need to wait a few more
> hours/weeks/days until it starts being aggressive?

Please see the recent "dm-cache warming thread":
https://www.redhat.com/archives/dm-devel/2013-July/msg00133.html

That isn't to say we cannot take steps to be more aggressive; but we'll
need more context for what you're doing.

A normal system boot is likely predominantly read once, and/or (as Joe
pointed out) the page cache could be masking subsequent reads.

If you're doing write heavy workloads are they being elided by the
sequential_threshold?

Try a git checkout, and switch branches a few times (e.g. checkout v3.1,
then v3.8, then v3.2, then v3.9, then v3.1, etc).
