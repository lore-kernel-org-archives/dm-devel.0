From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: A small question about Device Mapper
Date: Sun, 23 Aug 2015 20:22:25 -0400
Message-ID: <20150824002225.GA24718@redhat.com>
References: <91E2D863603AD4478F101CE81E76E45D01D2D23C@SHSMSX103.ccr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <91E2D863603AD4478F101CE81E76E45D01D2D23C@SHSMSX103.ccr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Ni, Xun" <xun.ni@intel.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Aug 23 2015 at  3:29am -0400,
Ni, Xun <xun.ni@intel.com> wrote:

> Hi, all:
> 
> I use device mapper to config a thin-provision for a block device, with dmsetup, with the following command:
> 
> Dmsetup create pool -table "0 `blockdev -getsize /dev/sdd1` thin-pool /dev/sdd2 /dev/sdd1 128 0"
> Dmsetup message /dev/mapper/pool 0 "create_thin 0"
> Dmsetup create snap1 -tabe "0 `blockdev -getsize /dev/sdd3` thin /dev/mapper/pool 0 /dev/sdd3"
> 
> Everything works well, but when I reboot the system, the block device is gone, I need to create the pool again...
> 
> Anyone has idea on how to make this config persistent?  I need to boot the kernel , the dm pool device shows after the MD device found.

use lvm to create a thinp device that activates on bootup (see lvmthin
manpage).
