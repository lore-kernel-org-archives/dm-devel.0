From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 13/13] dm-zoned: metadata version 2
Date: Tue, 28 Apr 2020 13:37:40 -0400
Message-ID: <20200428173740.GD17285@redhat.com>
References: <20200420100824.124618-1-hare@suse.de>
	<20200420100824.124618-14-hare@suse.de>
	<BY5PR04MB6900EA4ACB7303A1D5889C0EE7AC0@BY5PR04MB6900.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BY5PR04MB6900EA4ACB7303A1D5889C0EE7AC0@BY5PR04MB6900.namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 28 2020 at  6:54am -0400,
Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
 
> With this, everything works fine for single and dual device case.

Cool.

Hannes, pleasee fold Damien's changes in for v3, thanks!

> But I only did very light testing (formating witth ext4, mounting,
> running simple fio, unmount). I also noticed this message on dmzadm
> --start:
> 
> [ 2707.268812] device-mapper: zoned metadata: (253:0): Using 3233664 B for zone
> information
> [ 2707.921500] device-mapper: zoned metadata: (dmz-sdj): DM-Zoned metadata version 2
> [ 2707.929865] device-mapper: zoned metadata: (dmz-sdj): DM UUID
> 01149f45-1391-d44d-803a-7830d7d62b12
> [ 2707.939457] device-mapper: zoned metadata: (dmz-sdj): DM Label dmz-sdj
> [ 2707.946371] device-mapper: zoned metadata: (nvme1n1): Regular block device
> [ 2707.953616] device-mapper: zoned metadata: (nvme1n1):   uuid
> df2c308c-9c98-1845-afad-6bf80bd0ad4a
> [ 2707.963097] device-mapper: zoned metadata: (nvme1n1):   976773168 512-byte
> logical sectors (offset 0)
> [ 2707.972940] device-mapper: zoned metadata: (nvme1n1):   1864 zones of 524288
> 512-byte logical sectors (offset 0)
> [ 2707.983747] device-mapper: zoned metadata: (sdj): Host-managed zoned block device
> [ 2707.991852] device-mapper: zoned metadata: (sdj):   uuid
> f842e365-53b6-4942-ad00-954e50bec940
> [ 2708.001004] device-mapper: zoned metadata: (sdj):   29297213440 512-byte
> logical sectors (offset 977272832)
> [ 2708.011380] device-mapper: zoned metadata: (sdj):   55880 zones of 524288
> 512-byte logical sectors (offset 1864)
> [ 2708.022184] device-mapper: zoned metadata: (dmz-sdj):   57744 zones of 524288
> 512-byte logical sectors
> [ 2708.032116] device-mapper: zoned metadata: (dmz-sdj):   4 metadata zones
> [ 2708.039212] device-mapper: zoned metadata: (dmz-sdj):   57724 data zones for
> 57724 chunks
> [ 2708.048018] device-mapper: zoned metadata: (dmz-sdj):     2383 random zones
> (2383 unmapped)
> [ 2708.057023] device-mapper: zoned metadata: (dmz-sdj):     55340 sequential
> zones (55340 unmapped)
> [ 2708.066509] device-mapper: zoned metadata: (dmz-sdj):   16 reserved
> sequential data zones
> [ 2708.112529] device-mapper: zoned: (dmz-sdj): Target device: 30264000512
> 512-byte logical sectors (3783000064 blocks)

Not liking how chatty DM zoned metadata has become... can that be
removed and the proper .status updates be provided?  (yes I know zoned
never provided .status but this series should introduce a basic one
early in the series, that should've always been there, and then update
it for v2 metadata).

> [ 2708.125465] device-mapper: table: 253:0: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> [ 2708.142332] device-mapper: table: 253:0: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> [ 2708.159659] device-mapper: table: 253:0: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> [ 2708.176600] device-mapper: table: 253:0: adding target device sdj caused an
> alignment inconsistency: physical_block_size=4096, logical_block_size=4096,
> alignment_offset=0, start=0
> 
> Which I think comes from the fact that I mixed a 4Kn SMR drive with a 512B
> sector M.2 NVMe drive. The different sector size seem to generate this. I have
> not dig further yet.

I'd have to dig further myself to understand the disposition of these
messages... if it is born of of 512 vs 4096 I'm missing why the
.iterate_devices isn't properly establishing limits that are compatible
with your combined 512 and 4096 hybrid.. e.g. require 4096 to satisfy
the 4K device's constraints.

Mike
