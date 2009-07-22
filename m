From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/2] Disable partition scan
Date: Wed, 22 Jul 2009 17:53:17 +0100
Message-ID: <1248281597.14407.171.camel@breeves.fab.redhat.com>
References: <20090722080129.E9393D340B@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090722080129.E9393D340B@pentland.suse.de>
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
Cc: Alasdair Kergon <agk@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, 2009-07-22 at 10:01 +0200, Hannes Reinecke wrote:
> Worse, it might trigger I/O errors as the partition table might not
> be accessible (eg for the passive path of a multipath device) or
> even invalid (eg for RAID0 dmraid).

Not that it removes the need or motivation for this patch but the case
of an array partition table being mis-interpreted by the kernel for a
RAID member device should no longer trigger I/O errors. Kernels since
2.6.27 should truncate any over-size partitions to the size of the
device:

commit ac0d86f5809598ddcd6bfa0ea8245ccc910e9eac
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Wed Oct 15 22:04:21 2008 -0700

    block: sanitize invalid partition table entries
    
    We currently follow blindly what the partition table lies about the
    disk, and let the kernel create block devices which can not be
    accessed.
    Trying to identify the device leads to kernel logs full of:
      sdb: rw=0, want=73392, limit=28800
      attempt to access beyond end of device
[snip]

I've tested this patch with a few dmraid setups that previously spat I/O
errors whenever something probed a member device. Although this isn't
exactly a solution it does quiet down the log noise (I'd thought about
submitting a patch to dmraid to issue a BLKPG_DEL_PARTITION for each
partition on each member device that it discovers but didn't get around
to doing anything about it yet).

Regards,
Bryn.
