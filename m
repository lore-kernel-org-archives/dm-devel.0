From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 13/15] dm-zoned: allocate zone by device index
Date: Sun, 31 May 2020 08:54:40 +0000
Message-ID: <53b683b85375e5827dc98c54da4b131acbbbad49.camel@wdc.com>
References: <20200527062225.72849-1-hare@suse.de>
	<20200527062225.72849-14-hare@suse.de>
	<f38d9c9802239e3021b602af8c178428d72e791b.camel@wdc.com>
	<2966c1c2-86e9-2be3-09b8-3ab7cdb29d6a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2966c1c2-86e9-2be3-09b8-3ab7cdb29d6a@suse.de>
Content-Language: en-US
Content-ID: <49EAB7312E50A849AE8AFDE04BE75B6C@namprd04.prod.outlook.com>
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

On Fri, 2020-05-29 at 17:48 +0200, Hannes Reinecke wrote:
> On 5/28/20 6:08 AM, Damien Le Moal wrote:
> > On Wed, 2020-05-27 at 08:22 +0200, Hannes Reinecke wrote:
> > > When allocating a zone we should pass in an indicator on which
> > > device the zone should be allocated; this increases performance
> > > for a multi-device setup as then reclaim can allocate zones on
> > > the device for which reclaim is running.
> > > 
> > > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > ---
> > >   drivers/md/dm-zoned-metadata.c | 17 +++++++++++------
> > >   drivers/md/dm-zoned-reclaim.c  |  3 ++-
> > >   drivers/md/dm-zoned.h          |  3 ++-
> > >   3 files changed, 15 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> > > index 689c1dd7ab20..0d65af94309a 100644
> > > --- a/drivers/md/dm-zoned-metadata.c
> > > +++ b/drivers/md/dm-zoned-metadata.c
> > > @@ -2045,7 +2045,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
> > >   			goto out;
> > >   
> > >   		/* Allocate a random zone */
> > > -		dzone = dmz_alloc_zone(zmd, alloc_flags);
> > > +		dzone = dmz_alloc_zone(zmd, 0, alloc_flags);
> > >   		if (!dzone) {
> > >   			if (dmz_dev_is_dying(zmd)) {
> > >   				dzone = ERR_PTR(-EIO);
> > > @@ -2151,7 +2151,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
> > >   		goto out;
> > >   
> > >   	/* Allocate a random zone */
> > > -	bzone = dmz_alloc_zone(zmd, alloc_flags);
> > > +	bzone = dmz_alloc_zone(zmd, 0, alloc_flags);
> > >   	if (!bzone) {
> > >   		if (dmz_dev_is_dying(zmd)) {
> > >   			bzone = ERR_PTR(-EIO);
> > > @@ -2182,11 +2182,12 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
> > >    * Get an unmapped (free) zone.
> > >    * This must be called with the mapping lock held.
> > >    */
> > > -struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
> > > +struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned int dev_idx,
> > > +			       unsigned long flags)
> > >   {
> > >   	struct list_head *list;
> > >   	struct dm_zone *zone;
> > > -	unsigned int dev_idx = 0;
> > > +	int i = 0;
> > >   
> > >   again:
> > >   	if (flags & DMZ_ALLOC_CACHE)
> > > @@ -2202,8 +2203,12 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
> > >   		 */
> > >   		if (!(flags & DMZ_ALLOC_RECLAIM))
> > >   			return NULL;
> > > -		if (dev_idx < zmd->nr_devs) {
> > > -			dev_idx++;
> > > +		/*
> > > +		 * Try to allocate from other devices
> > > +		 */
> > > +		if (i < zmd->nr_devs) {
> > > +			dev_idx = (dev_idx + 1) % zmd->nr_devs;
> > 
> > Hu ? You deleted dev_idx declaration above...
> > 
> It's now the function argument ...

Oops... Yes, missed that...

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research
