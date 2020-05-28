From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv2 00/15] dm-zoned: multi-device support
Date: Thu, 28 May 2020 04:20:05 +0000
Message-ID: <7b6bfa146c5ea2684d20dda7b0920d21fd0a1820.camel@wdc.com>
References: <20200527062225.72849-1-hare@suse.de>
	<20200527134110.GB19310@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200527134110.GB19310@redhat.com>
Content-Language: en-US
Content-ID: <4A262ECE94DC6846909F5A033B05032F@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-05-27 at 09:41 -0400, Mike Snitzer wrote:
> On Wed, May 27 2020 at  2:22am -0400,
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > Hi all,
> > 
> > here's the second version of my patchset to support multiple zoned
> > drives with dm-zoned.
> > This patchset:
> > - Converts the zone array to using xarray for better scalability
> > - Separates out shared structures into per-device structure
> > - Enforce drive-locality for allocating and reclaiming zones
> > - Lifts the restriction of 2 devices to handle an arbitrary number
> >   of drives.
> > 
> > This gives me a near-perfect scalability by increasing the write
> > speed from 150MB/s (for a cache and one zoned drive) to 300MB/s
> > (for a cache and two zoned drives).
> > 
> > Changes to v1:
> > - Include reviews from Damien
> > - Reshuffle patches
> > 
> > Hannes Reinecke (15):
> >   dm-zoned: add debugging message for reading superblocks
> >   dm-zoned: secondary superblock must reside on the same devices than
> >     primary superblock
> >   dm-zoned: improve logging messages for reclaim
> >   dm-zoned: add a 'reserved' zone flag
> >   dm-zoned: convert to xarray
> >   dm-zoned: temporary superblock for tertiary devices
> >   dm-zoned: add device pointer to struct dm_zone
> >   dm-zoned: add metadata pointer to struct dmz_dev
> >   dm-zoned: allocate dm devices dynamically
> >   dm-zoned: per-device reclaim
> >   dm-zoned: move random and sequential zones into struct dmz_dev
> >   dm-zoned: support arbitrary number of devices
> >   dm-zoned: allocate zone by device index
> >   dm-zoned: select reclaim zone based on device index
> >   dm-zoned: prefer full zones for reclaim
> > 
> >  drivers/md/dm-zoned-metadata.c | 448 ++++++++++++++++++++++++-----------------
> >  drivers/md/dm-zoned-reclaim.c  |  95 +++++----
> >  drivers/md/dm-zoned-target.c   | 169 ++++++++++------
> >  drivers/md/dm-zoned.h          |  77 ++++---
> >  4 files changed, 481 insertions(+), 308 deletions(-)
> 
> Would you still like to wait until the 5.9 merge window?
> 
> Or would you prefer to see these changes land for 5.8 so as to limit the
> variants of related code that needs to be supported?
> 
> If you and Damien are OK with 5.8 (and testing backs that up) then I
> should be able to get it to land.

Yes, it would be nice to have all the recent changes under dm-zoned V2.
I just reviewed Hannes V2 series and I am running tests right now. So
far so good. Will send results by the end of my day.

What is your deadline for a final series to make it to 5.8 ? This end
of week ? If Hannes has time to rework another round, we should be good
then.

Thanks.

> 
> Let me know, thanks.
> Mike
> 

-- 
Damien Le Moal
Western Digital Research
