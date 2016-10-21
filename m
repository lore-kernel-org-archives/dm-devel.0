From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: device mapper and the BLKFLSBUF ioctl
Date: Fri, 21 Oct 2016 16:00:22 -0400
Message-ID: <20161021200022.GA12580@redhat.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 21 2016 at  2:33pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I found a bug in dm regarding the BLKFLSBUF ioctl.
> 
> The BLKFLSBUF ioctl can be called on a block device and it flushes the 
> buffer cache. There is one exception - when it is called on ramdisk, it 
> actually destroys all ramdisk data (it works like a discard on the full 
> device).
> 
> The device mapper passes this ioctl down to the underlying device, so when 
> the ioctl is called on a logical volume, it can be used to destroy the 
> underlying volume group if the volume group is on ramdisk.
> 
> For example:
> # modprobe brd rd_size=1048576
> # pvcreate /dev/ram0
> # vgcreate ram_vg /dev/ram0
> # lvcreate -L 16M -n ram_lv ram_vg
> # blockdev --flushbufs /dev/ram_vg/ram_lv
> 	--- and now the whole volume group is gone, all data on the 
> 		ramdisk were replaced with zeroes
> 
> The BLKFLSBUF ioctl is only allowed with CAP_SYS_ADMIN, so there shouldn't 
> be security implications with this.
> 
> Whan to do with it? The best thing would be to drop this special ramdisk 
> behavior and make the BLKFLSBUF ioctl flush the buffer cache on ramdisk 
> like on all other block devices. But there may be many users having 
> scripts that depend on this special behavior.
> 
> Another possibility is to stop the device mapper from passing the 
> BLKFLSBUF ioctl down.

If anything DM is being consistent with what the underlying device is
meant to do.

brd_ioctl() destroys the data in response to BLKFLSBUF.. I'm missing why
this is a DM-specific problem.
