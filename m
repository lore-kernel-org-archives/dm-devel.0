From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCHv3 00/11] dm-zoned: metadata version 2
Date: Sat, 11 Apr 2020 20:30:02 +0800
Message-ID: <4052464c-cf93-3e22-3050-58183b9ae564@oracle.com>
References: <20200409064527.82992-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200409064527.82992-1-hare@suse.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/9/20 2:45 PM, Hannes Reinecke wrote:
> Hi all,
> 
> this patchset adds a new metadata version 2, which brings the following
> improvements:
> - UUIDs and labels: Adding three more fields to the metadata containing
>   the dm-zoned device UUID and label, and the device UUID. This allows
>   for an unique identification of the devices, so that several dm-zoned
>   sets can coexist and have a persistent identification.
> - Extend random zones by an additional regular disk device: A regular
>   block device can be added together with the zoned block device, providing
>   additional (emulated) random write zones. With this it's possible to
>   handle sequential zones only devices; also there will be a speed-up if
>   the regular block device resides on a fast medium. The regular block device
>   is placed logically in front of the zoned block device, so that metadata
>   and mapping tables reside on the regular block device, not the zoned device.
> - Tertiary superblock support: In addition to the two existing sets of metadata
>   another, tertiary, superblock is written to the first block of the zoned
>   block device. This superblock is for identification only; the generation
>   number is set to '0' and the block itself it never updated. The additional
>   metadate like bitmap tables etc are not copied.
> 
> To handle this, some changes to the original handling are introduced:
> - Zones are now equidistant. Originally, runt zones were ignored, and
>   not counted when sizing the mapping tables. With the dual device setup
>   runt zones might occur at the end of the regular block device, making
>   direct translation between zone number and sector/block number complex.
>   For metadata version 2 all zones are considered to be of the same size,
>   and runt zones are simply marked as 'offline' to have them ignored when
>   allocating a new zone.
> - The block number in the superblock is now the global number, and refers to
>   the location of the superblock relative to the resulting device-mapper
>   device. Which means that the tertiary superblock contains absolute block
>   addresses, which needs to be translated to the relative device addresses
>   to find the referenced block.
> 
> There is an accompanying patchset for dm-zoned-tools for writing and checking
> this new metadata.
> 
> As usual, comments and reviews are welcome.
> 
> Changes to v2:
> - Kill dmz_id()
> - Include reviews from Damien
> - Sanitize uuid handling as suggested by John Dorminy
> 

This series looks good to me, feel free to add my
Reviewed-by: Bob Liu <bob.liu@oracle.com>

By the way, have you completed the patches for regular device support?
I was considering rebase my previous patches to this series but not sure is it still necessary.

Regards,
Bob

> Hannes Reinecke (11):
>   dm-zoned: store zone id within the zone structure and kill dmz_id()
>   dm-zoned: use array for superblock zones
>   dm-zoned: store device in struct dmz_sb
>   dm-zoned: move fields from struct dmz_dev to dmz_metadata
>   dm-zoned: introduce dmz_metadata_label() to format device name
>   dm-zoned: remove 'dev' argument from reclaim
>   dm-zoned: replace 'target' pointer in the bio context
>   dm-zoned: use dmz_zone_to_dev() when handling metadata I/O
>   dm-zoned: add metadata logging functions
>   dm-zoned: ignore metadata zone in dmz_alloc_zone()
>   dm-zoned: metadata version 2
> 
>  drivers/md/dm-zoned-metadata.c | 601 ++++++++++++++++++++++++---------
>  drivers/md/dm-zoned-reclaim.c  |  89 ++---
>  drivers/md/dm-zoned-target.c   | 273 ++++++++-------
>  drivers/md/dm-zoned.h          |  29 +-
>  4 files changed, 659 insertions(+), 333 deletions(-)
> 
