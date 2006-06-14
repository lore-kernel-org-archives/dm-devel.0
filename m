From: Arno Wagner <wagner@tik.ee.ethz.ch>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Wed, 14 Jun 2006 05:58:01 +0200
Message-ID: <20060614035801.GA24236@tik.ee.ethz.ch>
References: <20060613235316.7f982af7@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060613235316.7f982af7@localhost>
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

WD drives are misdesigned in some way that they need sometimes
very long to respond to commands. I think it is a quality issue.
WD itself has "RAID ready" drives that don't do this. 

I have run TB sized arrays of Seagate and Maxtor drives with
Linux software RAID for years now and never, ever had this issue.
My advice is to dump the WD drives and get others.

Arno


On Tue, Jun 13, 2006 at 11:53:16PM +0200, Tom Wirschell wrote:
> I'm trying to setup a poor man's RAID5 array that uses 11 200 GB Western
> Digital harddisks. Two of them are the PATA Caviar SE 2000JB drives and
> the other ten are SATA Caviar 2000JD drives.
> Both PATA and 2 of the SATA drives are connected to the mainboard, an
> ASUS PSCH-L with an Intel E7210+6300ESB chipset. The other drives were
> previously connected to 2 Promise FastTrak S150 TX4's which I've since
> replaced in favor of the 8-port SuperMicro AOC-SAT2-MV8 card in the
> hopes of fixing the issue I'm having, but to no avail.
> 
> I want to create a RAID5 array of these drives. Unfortunately after a
> varying amount of time of moderate use (though never more than 24 hours)
> one of the drives not connected to the 6300ESB just out of the blue
> shuts itself down, eventually followed by another at which point the
> array is dead.
> 
> When the drive shuts down I can hear the familiar click from the drive
> cutting its power, and after a bit the following gets logged:
> 
> ata9: commant timeout
> 
> when using the Promise controllers. The machine locks hard at this
> point. With the SuperMicro card the machine remains usable, but the
> drives are never to be heared from again. The following is logged:
> 
> ata14: no device found (phy stat 00000000)
> sd 13:0:0:0: SCSI error: return code = 0x40000
> end_request: I/O errorm dev sdi, sector 390716676
> raid5: Disk failure on sdi2, disabling device.
> 
> Pretty much every time it's a different disk, and I'm unable to revive
> that disk without a reboot.
> I brought this issue to the attention of some WD support people who're
> basically telling me that the RAID software is impatient. This being
> desktop drives, they're not particularly fast (which I don't need them
> to be) and not equally fast either, hovering between 20 and 30 MB/s
> for writing. Haven't tried to measure reading yet.
> 
> When I mount the drives as separate partitions I can play with them to
> my heart's content. As a test I filled up 5 drives, copied the data to
> the other 5 drives (I'm using the 11th drive, a PATA one, for Linux
> itself ATM) and vice versa. As I'm writing this I'm running Bonnie++ in
> parallel on these partitions and so far everything's solid as a rock.
> 
> Besides the Promise controllers I've replaced the powersupply (500W
> HuntKey to a 550W Antec TruePower II), all SATA data cables, all SATA
> power cables...
> I've tried striping instead of RAID5 but that didn't help either.
> To the best of my ability I've ruled out hardware faults. The only
> thing I can think of now is that the RAID5 module, for whatever reason,
> is _telling_ the drive to shutdown, but I can't imagine that happening
> without some serious logging going on.
> 
> Hopefully someone on this list can help me get this problem sorted?
> 
> When I was using the Promise controllers I was using version
> 2.6.11.12, and later 2.6.16.14 of the kernel. When I switched to the
> SuperMicro card I had to upgrade to 2.6.17-rc5.
> 
> Any suggestions would be greatly appreciated.
> 
> Kind regards,
> 
> Tom Wirschell
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Arno Wagner, Dipl. Inform., CISSP --- CSG, ETH Zurich, wagner@tik.ee.ethz.ch 
GnuPG:  ID: 1E25338F  FP: 0C30 5782 9D93 F785 E79C  0296 797F 6B50 1E25 338F
----
Cuddly UI's are the manifestation of wishful thinking. -- Dylan Evans
Windows is the "under-3" toy of the OS world. -- Matthew D. Fuller
