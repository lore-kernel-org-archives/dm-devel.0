From: CaT <cat@zip.com.au>
Subject: Re: 2.6.16.20/dm: can't create more then one snapshot of an lv
Date: Tue, 20 Jun 2006 10:54:05 +1000
Message-ID: <20060620005405.GY2059@zip.com.au>
References: <20060619020040.GX2059@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964787AbWFTAxP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060619020040.GX2059@zip.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 19, 2006 at 12:00:40PM +1000, CaT wrote:
> I am attempting to create multiple snapshots of an lv ontop of a raid-5
> software raid device and ext3+dir_index and resize_inode for the fs.
> The kernel is a pure 64bit compile with Debian Sarge amd64 running on
> top of it. The kernel is monolithic and I'm using lvm2 2.01.03-5 with
> devmapper 1.01.
> 
> This works under 2.6.15.7. Under 2.6.16.20 I get this:

2.6.17 also fails.

More info: The failing kernels can deal with multiple pre-created
snapshots but the moment I try to create one it freezes as below. Mounting
another snapshotted volume at the time this is frozen freezes mount.

After reboot the snapshot it froze on making is available to the system
(though the reboot fails on shutdown as it cannot unmount anything).

> # lvcreate --snapshot --size 50G --name snap-13 --permission r --verbose /dev/backups/main
>     Setting chunksize to 16 sectors.
>     Finding volume group "backups"
>     Creating logical volume snap-13
>     Archiving volume group "backups" metadata.
>     Creating volume group backup "/etc/lvm/backup/backups"
>     Found volume group "backups"
>     Loading backups-snap--13
>     Zeroing start of logical volume "snap-13"
>     Found volume group "backups"
>     Removing backups-snap--13
>     Found volume group "backups"
>     Found volume group "backups"
>     Found volume group "backups"
>     Loading backups-main-real
>     Loading backups-snap--12-cow
>     Loading backups-snap--12
> *freeze*

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
