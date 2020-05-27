From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2 00/15] dm-zoned: multi-device support
Date: Wed, 27 May 2020 09:41:11 -0400
Message-ID: <20200527134110.GB19310@redhat.com>
References: <20200527062225.72849-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200527062225.72849-1-hare@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 27 2020 at  2:22am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
> 
> here's the second version of my patchset to support multiple zoned
> drives with dm-zoned.
> This patchset:
> - Converts the zone array to using xarray for better scalability
> - Separates out shared structures into per-device structure
> - Enforce drive-locality for allocating and reclaiming zones
> - Lifts the restriction of 2 devices to handle an arbitrary number
>   of drives.
> 
> This gives me a near-perfect scalability by increasing the write
> speed from 150MB/s (for a cache and one zoned drive) to 300MB/s
> (for a cache and two zoned drives).
> 
> Changes to v1:
> - Include reviews from Damien
> - Reshuffle patches
> 
> Hannes Reinecke (15):
>   dm-zoned: add debugging message for reading superblocks
>   dm-zoned: secondary superblock must reside on the same devices than
>     primary superblock
>   dm-zoned: improve logging messages for reclaim
>   dm-zoned: add a 'reserved' zone flag
>   dm-zoned: convert to xarray
>   dm-zoned: temporary superblock for tertiary devices
>   dm-zoned: add device pointer to struct dm_zone
>   dm-zoned: add metadata pointer to struct dmz_dev
>   dm-zoned: allocate dm devices dynamically
>   dm-zoned: per-device reclaim
>   dm-zoned: move random and sequential zones into struct dmz_dev
>   dm-zoned: support arbitrary number of devices
>   dm-zoned: allocate zone by device index
>   dm-zoned: select reclaim zone based on device index
>   dm-zoned: prefer full zones for reclaim
> 
>  drivers/md/dm-zoned-metadata.c | 448 ++++++++++++++++++++++++-----------------
>  drivers/md/dm-zoned-reclaim.c  |  95 +++++----
>  drivers/md/dm-zoned-target.c   | 169 ++++++++++------
>  drivers/md/dm-zoned.h          |  77 ++++---
>  4 files changed, 481 insertions(+), 308 deletions(-)

Would you still like to wait until the 5.9 merge window?

Or would you prefer to see these changes land for 5.8 so as to limit the
variants of related code that needs to be supported?

If you and Damien are OK with 5.8 (and testing backs that up) then I
should be able to get it to land.

Let me know, thanks.
Mike
