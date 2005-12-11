From: Toon van der Pas <toon@hout.vanvergehaald.nl>
Subject: Re: What's the status on I/O-stats for dm block devices?
Date: Sun, 11 Dec 2005 15:03:35 +0100
Message-ID: <20051211140335.GA9080@shuttle.vanvergehaald.nl>
References: <20051122223701.GA23045@shuttle.vanvergehaald.nl>
	<20051123000356.GG26394@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051123000356.GG26394@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi, I took the time today to compile an -mm kernel (2.6.15-rc5-mm1)
and apply your patches...

On Wed, Nov 23, 2005 at 12:03:56AM +0000, Alasdair G Kergon wrote:
> On Tue, Nov 22, 2005 at 11:37:03PM +0100, Toon van der Pas wrote:
> > See: http://bugme.osdl.org/show_bug.cgi?id=1806
>  
> I wasn't aware of that, but you'll see there's been some work on this
> recently:
> 
>   http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
>     dm-disk-statistics*
> 
> If people can test these patches and report back, I'm hoping to submit them 
> for 2.5.16.
> 
>   dm-disk-statistics-basic.patch
>   dm-disk-statistics-timing.patch
> 
> Additional patches for the latest -mm kernels:
>   dm-disk-statistics-basic-mm.patch
>   dm-disk-statistics-timing-mm.patch

These patches applied with some fuzz.
The statistics seem to work now. These are the results.

*** Before the patch: ***

# cat /proc/diskstats | grep dm
 253    0 dm-0 0 0 0 0 0 0 0 0 0 0 0
 253    1 dm-1 0 0 0 0 0 0 0 0 0 0 0
 253    2 dm-2 0 0 0 0 0 0 0 0 0 0 0
 253    3 dm-3 0 0 0 0 0 0 0 0 0 0 0
 253    4 dm-4 0 0 0 0 0 0 0 0 0 0 0
 253    5 dm-5 0 0 0 0 0 0 0 0 0 0 0
 253    6 dm-6 0 0 0 0 0 0 0 0 0 0 0

# cat /sys/block/dm-*/stat
       0        0        0        0        0        0        0        0        0        0        0
       0        0        0        0        0        0        0        0        0        0        0
       0        0        0        0        0        0        0        0        0        0        0
       0        0        0        0        0        0        0        0        0        0        0
       0        0        0        0        0        0        0        0        0        0        0
       0        0        0        0        0        0        0        0        0        0        0
       0        0        0        0        0        0        0        0        0        0        0

*** After the patch: ***

# cat /proc/diskstats | grep dm
 254    0 dm-0 1110 0 40394 11444 1 0 8 8 0 3480 11452
 254    1 dm-1 51 0 418 280 14 0 112 12 0 284 292
 254    2 dm-2 11 0 82 68 1 0 8 12 0 80 80
 254    3 dm-3 98 0 802 1064 381 0 3048 1872 0 1336 2936
 254    4 dm-4 26 0 202 120 88 0 704 280 1 144 400
 254    5 dm-5 1 0 8 12 0 0 0 0 0 12 12
 254    6 dm-6 0 0 0 0 0 0 0 0 0 0 0

# cat /sys/block/dm-*/stat
    1110        0    40394    11444        1        0        8        8        0     3480    11452
      51        0      418      280       14        0      112       12        0      284      292
      11        0       82       68        1        0        8       12        0       80       80
      98        0      802     1064      381        0     3048     1872        0     1336     2936
      25        0      194      120       80        0      640      280        0      144      400
       1        0        8       12        0        0        0        0        0       12       12
       0        0        0        0        0        0        0        0        0        0        0

I don't know what else to do.
Switched back to my regular gentoo-sources kernel.
(the nvidia modules don't work with -mm kernels)

Why don't you submit these patches to Andrew Morton for inclusion in -mm?
That way your patches would get much more exposure...

Thanks for device-mapper and LVM2!
Regards,
Toon.
