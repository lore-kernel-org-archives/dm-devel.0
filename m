From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: [Consult-list] Re: dm-multipath has great throughput
	but we'd like more!
Date: Mon, 22 May 2006 10:31:00 -0500
Message-ID: <20060522153100.GB15718@www.ewilts.org>
References: <1147935929.27006.57.camel@baggage>
	<d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>
	<1147938254.27006.65.camel@baggage>
	<1147939464.3183.15.camel@nstrug.surrey.redhat.com>
	<1147945356.3183.39.camel@nstrug.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1147945356.3183.39.camel@nstrug.surrey.redhat.com>
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
Cc: consult-list@redhat.com
List-Id: dm-devel.ids

On Thu, May 18, 2006 at 11:42:36AM +0200, Nicholas C. Strugnell wrote:
> write throughput to EVA 8000 (8GB write cache), host DL380 with 2x2Gb/s
> HBAs, 2GB RAM
> 
> testing 4GB files:
> 
> on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root
> 
> ext3: 129MB/s sd=0.43
> 
> ext2: 202MB/s sd=21.34
> 
> on raw: 216MB/s sd=3.93  (dd if=/dev/zero of=/dev/mpath/3600508b4001048ba0000b00001400000 bs=4k count=1048576)
> 
> 
> NB I did not have exclusive access to the SAN or this particular storage
> array - this is a big corp. SAN network under quite heavy load and disk
> array under moderate load - not even sure if I had exclusive access to
> the disks. All values averaged over 20 runs. 

Since I manage a half-dozen EVAs, I'll pretend I actually know something
about them :-).  First, there are multiple ways of setting up the LUNs
on the frame - anywhere from a small LUN with RAID5 to a large LUN with
raid 0.  The differences should be significant.  A small RAID5 LUN will
give you very limited balancing across physical disks.  Because of the
virtualization of the disks within the frame, you most definitely do not
have exclusive access to the physical disks.  It's quite possible that
your raid 5 partition is on the same physical disk as a very busy
database.  The EVA spreads the lun across multiple spindles - the larger
the lun, the more spindles you can get working for you.

If you can, get the storage group to assign you a large raid 0 lun and
redo your tests.  You should see different results.

        .../Ed

-- 
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
