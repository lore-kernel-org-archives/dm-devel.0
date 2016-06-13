From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Mon, 13 Jun 2016 18:57:57 -0400
Message-ID: <20160613225756.GA18417@redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: agk@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, linux-nvdimm@ml01.01.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jun 13 2016 at  6:21pm -0400,
Toshi Kani <toshi.kani@hpe.com> wrote:

> This patch-set adds DAX support to device-mapper dm-linear devices
> used by LVM.  It works with LVM commands as follows:
>  - Creation of a logical volume with all DAX capable devices (such
>    as pmem) sets the logical volume DAX capable as well.
>  - Once a logical volume is set to DAX capable, the volume may not
>    be extended with non-DAX capable devices.
> 
> The direct_access interface is added to dm and dm-linear to map
> a request to a target device.
> 
>  - Patch 1-2 introduce GENHD_FL_DAX flag to indicate DAX capability.
>  - Patch 3-4 add direct_access functions to dm and dm-linear.
>  - Patch 5-6 set GENHD_FL_DAX to dm when all targets are DAX capable.
> 
> ---
> Toshi Kani (6):
>  1/6 genhd: Add GENHD_FL_DAX to gendisk flags
>  2/6 block: Check GENHD_FL_DAX for DAX capability
>  3/6 dm: Add dm_blk_direct_access() for mapped device
>  4/6 dm-linear: Add linear_direct_access()
>  5/6 dm, dm-linear: Add dax_supported to dm_target
>  6/6 dm: Enable DAX support for mapper device

Thanks a lot for doing this.  I recently added it to my TODO so your
patches come at a great time.

I'll try to get to reviewing/testing your work by the end of this week.

Mike
