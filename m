From: Neil Brown <neilb@suse.de>
Subject: Re: Q: md-RAID1 creation with I/O error (attempt to
 access beyond end of device)
Date: Tue, 30 Nov 2010 11:07:25 +1100
Message-ID: <20101130110725.5f2d2407@notabene.brown>
References: <4CC03D24020000A100010898@gwsmtp1.uni-regensburg.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CC03D24020000A100010898@gwsmtp1.uni-regensburg.de>
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
Cc: Ulrich.Windl@rz.uni-regensburg.de, open-iscsi <open-iscsi@googlegroups.com>
List-Id: dm-devel.ids

On Thu, 21 Oct 2010 13:16:20 +0200 "Ulrich Windl"
<Ulrich.Windl@rz.uni-regensburg.de> wrote:

> Hi,
> 
> not an iSCSI question, but maybe here's the right audience: I had sucessfully created a RAID1 using mdadm, multipath, iSCSI and some SAN storage on SLES10 SP3+Updates on x86_64. When I tried to do the same thing on a comparable machine, the RAID could not be created, because something tried to access the disk at a bad position. I reapeated the attempt with another set of disks of the same size, and it also failed.

You need an updated version of mdadm.  The fix for this was committed to
SLES10-SP3 in early August this year, so you need an update since then.
However as far as I can tell an update hasn't been released yet... I should
probably look into that.

But you can work-around by explicitly setting the bitmap chunk size.
Anything larger than 64K will do.  I generally suggest a much bigger bitmap
chunk size these days. so maybe add
   --bitmap-chunk=65536
(which is 64Meg) to the --create line.

The source-code fix is:


--- mdadm-2.6.orig/super0.c
+++ mdadm-2.6/super0.c
@@ -833,7 +833,7 @@ static int add_internal_bitmap0(struct s
 	 * size is in sectors,  chunk is in bytes !!!
 	 */
 	unsigned long long bits;
-	unsigned long long max_bits = 60*1024*8;
+	unsigned long long max_bits = (60*1024 - sizeof(bitmap_super_t))*8;
 	unsigned long long min_chunk;
 	int chunk = *chunkp;
 	mdp_super_t *sb = sbv;

--- mdadm-2.6.orig/super0.c
+++ mdadm-2.6/super0.c
@@ -833,7 +833,7 @@ static int add_internal_bitmap0(struct s
 	 * size is in sectors,  chunk is in bytes !!!
 	 */
 	unsigned long long bits;
-	unsigned long long max_bits = 60*1024*8;
+	unsigned long long max_bits = (60*1024 - sizeof(bitmap_super_t))*8;
 	unsigned long long min_chunk;
 	int chunk = *chunkp;
 	mdp_super_t *sb = sbv;

Your bitmap comes to 59.9998K and there is only room for 59.75K.

(If you have a support contract and want to log a call to get an official
update, please mention bnc#579170)

NeilBrown


> 
> Details:
> # mdadm --verbose --create /dev/md5 --raid-devices=2 --level=raid1 --bitmap=internal --assume-clean /dev/mapper/EVA1_L232_host05 /dev/mapper/EVA2_L232_host05
> mdadm: /dev/mapper/EVA1_L232_host05 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu Oct 21 12:26:18 2010
> mdadm: /dev/mapper/EVA2_L232_host05 appears to be part of a raid array:
>     level=raid1 devices=2 ctime=Thu Oct 21 12:26:18 2010
> mdadm: size set to 31457216K
> Continue creating array? y
> mdadm: RUN_ARRAY failed: Input/output error
> mdadm: stopped /dev/md5
> hostname:~ # tail -24 /var/log/messages                                         Oct 21 12:28:05 hostname kernel: md: md5 stopped.
> Oct 21 12:28:07 hostname kernel: md: md5 stopped.
> Oct 21 12:29:46 hostname kernel: md: bind<dm-21>
> Oct 21 12:29:46 hostname kernel: md: bind<dm-14>
> Oct 21 12:29:46 hostname kernel: raid1: raid set md5 active with 2 out of 2 mirrors
> Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date (0 < 1) -- forcing full recovery
> Oct 21 12:29:46 hostname kernel: md5: bitmap file is out of date, doing full recovery
> Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
> Oct 21 12:29:46 hostname kernel: dm-14: rw=8, want=62914568, limit=62914560
> Oct 21 12:29:46 hostname kernel: attempt to access beyond end of device
> Oct 21 12:29:46 hostname kernel: dm-21: rw=8, want=62914568, limit=62914560
> Oct 21 12:29:46 hostname kernel: md5: bitmap initialized from disk: read 15/16 pages, set 489472 bits, status: -5
> Oct 21 12:29:46 hostname kernel: md5: failed to create bitmap (-5)
> Oct 21 12:29:46 hostname kernel: md: pers->run() failed ...
> Oct 21 12:29:46 hostname kernel: md: md5 stopped.
> Oct 21 12:29:46 hostname kernel: md: unbind<dm-14>
> Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-14)
> Oct 21 12:29:46 hostname kernel: md: unbind<dm-21>
> Oct 21 12:29:46 hostname kernel: md: export_rdev(dm-21)
> 
> hostname:~ # mdadm --query -X /dev/mapper/EVA2_L232_host05
> mdadm: WARNING: bitmap file is not large enough for array size 62914432!
> 
>         Filename : /dev/mapper/EVA2_L232_host05
>            Magic : 6d746962
>          Version : 4
>             UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
>           Events : 0
>   Events Cleared : 0
>            State : Out of date
>        Chunksize : 64 KB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 31457216 (30.00 GiB 32.21 GB)
>           Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
> hostname:~ # mdadm --query -X /dev/mapper/EVA1_L232_host05
> mdadm: WARNING: bitmap file is not large enough for array size 62914432!
> 
>         Filename : /dev/mapper/EVA1_L232_host05
>            Magic : 6d746962
>          Version : 4
>             UUID : c522ab5a:24f292a0:0b3d7356:64ade12a
>           Events : 0
>   Events Cleared : 0
>            State : Out of date
>        Chunksize : 64 KB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 31457216 (30.00 GiB 32.21 GB)
>           Bitmap : 489472 bits (chunks), 489472 dirty (100.0%)
> 
> "blockdev --getsize" reports "62914560" for each LUN being used.
> 
> Regards,
> Ulrich
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
