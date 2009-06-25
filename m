From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is
	misaligned
Date: Thu, 25 Jun 2009 11:41:20 -0400
Message-ID: <20090625154120.GA22616@redhat.com>
References: <200906250904.57149.elendil@planet.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200906250904.57149.elendil@planet.nl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frans Pop <elendil@planet.nl>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thu, Jun 25 2009 at  3:04am -0400,
Frans Pop <elendil@planet.nl> wrote:

> During boot of 2.6.31-rc1 on an arm EABI system I got the following errors:
> 
> device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> device-mapper: table: 254:0: target device sda6 is misaligned
> device-mapper: table: 254:0: target device sda6 is misaligned
> device-mapper: table: 254:1: target device sda6 is misaligned
> device-mapper: table: 254:1: target device sda6 is misaligned
> 
> The boot did complete successfully. A boot with 2.6.30 just previously was
> clean, and when I reboot back into 2.6.30 the messages are gone again.
> 
> The system has a single volume group with two logical volumes.
> 
> Please advise and let me know what additional info is needed.

Even though the messages don't contain "warning", and probably should,
they are printed via DMWARN().

These warnings are a function of device-mapper now being
topology-aware.  This means that your LVs are likely misaligned relative
to the underlying hardware.  Given that you're using partitions I'd
wager they are the source of the misalignment.  But there could be a bug
lurking somewhere.

Please provide the output from the following commands:

pvs -o +pe_start

cat /sys/block/sda/sda6/alignment_offset
cat /sys/block/sda/queue/physical_block_size
cat /sys/block/sda/queue/logical_block_size

If you could also provide the same info for all other PVs that are in
the VG that would be appreciated.

Mike
