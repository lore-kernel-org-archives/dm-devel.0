From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm zoned: update atime for new buffer zones
Date: Wed, 15 Jul 2020 09:20:59 +0000
Message-ID: <52331d4f09d161dad64b85cad26ef620c04196de.camel@wdc.com>
References: <20200715081752.28130-1-hare@suse.de>
	<CY4PR04MB37511C00F22BDC73456FC252E77E0@CY4PR04MB3751.namprd04.prod.outlook.com>
	<a2aac870-d8a1-ab95-0c6e-b4e474f62ae9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a2aac870-d8a1-ab95-0c6e-b4e474f62ae9@suse.de>
Content-Language: en-US
Content-ID: <13AE1C8067F3064DBDCBF1288AF8B5FB@namprd04.prod.outlook.com>
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

On Wed, 2020-07-15 at 11:09 +0200, Hannes Reinecke wrote:
> On 7/15/20 10:49 AM, Damien Le Moal wrote:
> > On 2020/07/15 17:18, Hannes Reinecke wrote:
> > > When a new buffer zone is allocated in dmz_handle_buffered_write()
> > > we should update the 'atime' to inform reclaim that this zone has
> > > been accessed.
> > > Otherwise we end up with the pathological case where the first write
> > > allocates a new buffer zone, but the next write will start reclaim
> > > before processing the bio. As the atime is not set reclaim declares
> > > the system idle and reclaims the zone. Then the write will be processed
> > > and re-allocate the very same zone again; this repeats for every
> > > consecutive write, making for a _very_ slow mkfs.
> > > 
> > > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > ---
> > >  drivers/md/dm-zoned-target.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> > > index cf915009c306..b32d37bef14f 100644
> > > --- a/drivers/md/dm-zoned-target.c
> > > +++ b/drivers/md/dm-zoned-target.c
> > > @@ -297,6 +297,9 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
> > >  	if (dmz_is_readonly(bzone))
> > >  		return -EROFS;
> > >  
> > > +	/* Tell reclaim we're doing some work here */
> > > +	dmz_reclaim_bio_acc(bzone->dev->reclaim);
> > > +
> > >  	/* Submit write */
> > >  	ret = dmz_submit_bio(dmz, bzone, bio, chunk_block, nr_blocks);
> > >  	if (ret)
> > 
> > This is without a cache device, right ? Otherwise, since the cache device has no
> > reclaim, it would not make much sense.
> > 
> > In fact, I think that the atime timestamp being attached to each device reclaim
> > structure is a problem. We do not need that since we always trigger reclaim for
> > all drives. We only want to see if the target is busy or not, so atime should be
> > attached to struct dmz_metadata.
> > 
> > That will simplify things since we will not need to care about which zone/which
> > device is being accessed to track activity. We can just have:
> > 
> > 	dmz_reclaim_bio_acc(dmz->metadata);
> > 
> > Thoughts ?
> > 
> Well, I might be off the mark with this patch, but I did run into the
> the mentioned pathological behaviour; there was exactly _one_ zone
> cached, all I/O was going into that zone, and reclaim (seemed) to be
> busy with that very zone.
> The latter is actually conjecture, as I did _not_ get any messages from
> the reclaim on that device.
> I've seen idle messages from reclaim on the other devices, but reclaim
> from one device was suspiciously silent.
> And I/O went through, but _dead_ slow. All writes, mind (that was during
> mkfs time), so I gathered it might be due to the atime accounting not
> being done correctly.

What is your drive configuration and FS on the target ?

What about this:

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-
metadata.c
index b298fefb022e..4196ec5469bf 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -202,6 +202,9 @@ struct dmz_metadata {
        struct list_head        reserved_seq_zones_list;
 
        wait_queue_head_t       free_wq;
+
+       /* Last target access time */
+       unsigned long           atime;
 };
 
 #define dmz_zmd_info(zmd, format, args...)     \
@@ -354,6 +357,19 @@ bool dmz_dev_is_dying(struct dmz_metadata *zmd)
        return false;
 }
 
+/*
+* For BIO accounting to track the target idle time.
+*/
+void dmz_bio_acc(struct dmz_metadata *zmd)
+{
+       zmd->atime = jiffies;
+}
+
+unsigned long dmz_atime(struct dmz_metadata *zmd)
+{
+       return zmd->atime;
+}
+
 /*
  * Lock/unlock mapping table.
  * The map lock also protects all the zone lists.
@@ -2888,6 +2904,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int
num_dev,
        strcpy(zmd->devname, devname);
        zmd->dev = dev;
        zmd->nr_devs = num_dev;
+       zmd->atime = jiffies;
        zmd->mblk_rbtree = RB_ROOT;
        init_rwsem(&zmd->mblk_sem);
        mutex_init(&zmd->mblk_flush_lock);
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-
reclaim.c
index 9c0ecc9568a4..f70281a1ea8b 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -24,9 +24,6 @@ struct dmz_reclaim {
        int                     dev_idx;
 
        unsigned long           flags;
-
-       /* Last target access time */
-       unsigned long           atime;
 };
 
 /*
@@ -355,7 +352,7 @@ static void dmz_reclaim_empty(struct dmz_reclaim
*zrc, struct dm_zone *dzone)
  */
 static inline int dmz_target_idle(struct dmz_reclaim *zrc)
 {
-       return time_is_before_jiffies(zrc->atime + DMZ_IDLE_PERIOD);
+       return time_is_before_jiffies(dmz_atime(zrc->metadata) +
DMZ_IDLE_PERIOD);
 }
 
 /*
@@ -561,7 +558,6 @@ int dmz_ctr_reclaim(struct dmz_metadata *zmd,
                return -ENOMEM;
 
        zrc->metadata = zmd;
-       zrc->atime = jiffies;
        zrc->dev_idx = idx;
 
        /* Reclaim kcopyd client */
@@ -620,14 +616,6 @@ void dmz_resume_reclaim(struct dmz_reclaim *zrc)
        queue_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
 }
 
-/*
- * BIO accounting.
- */
-void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc)
-{
-       zrc->atime = jiffies;
-}
-
 /*
  * Start reclaim if necessary.
  */
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-
target.c
index 42aa5139df7c..d4785bc8341b 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -404,6 +404,9 @@ static void dmz_handle_bio(struct dmz_target *dmz,
struct dm_chunk_work *cw,
 
        dmz_lock_metadata(zmd);
 
+       /* For reclaim, to track idle time */
+       dmz_bio_acc(zmd);
+
        /*
         * Get the data zone mapping the chunk. There may be no
         * mapping for read and discard. If a mapping is obtained,
@@ -420,7 +423,6 @@ static void dmz_handle_bio(struct dmz_target *dmz,
struct dm_chunk_work *cw,
        if (zone) {
                dmz_activate_zone(zone);
                bioctx->zone = zone;
-               dmz_reclaim_bio_acc(zone->dev->reclaim);
        }
 
        switch (bio_op(bio)) {
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 22f11440b423..30eaeb2ac9df 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -211,6 +211,9 @@ unsigned int dmz_nr_chunks(struct dmz_metadata
*zmd);
 bool dmz_check_dev(struct dmz_metadata *zmd);
 bool dmz_dev_is_dying(struct dmz_metadata *zmd);
 
+void dmz_bio_acc(struct dmz_metadata *zmd);
+unsigned long dmz_atime(struct dmz_metadata *zmd);
+
 #define DMZ_ALLOC_RND          0x01
 #define DMZ_ALLOC_CACHE                0x02
 #define DMZ_ALLOC_SEQ          0x04
@@ -274,7 +277,6 @@ int dmz_ctr_reclaim(struct dmz_metadata *zmd,
struct dmz_reclaim **zrc, int idx)
 void dmz_dtr_reclaim(struct dmz_reclaim *zrc);
 void dmz_suspend_reclaim(struct dmz_reclaim *zrc);
 void dmz_resume_reclaim(struct dmz_reclaim *zrc);
-void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc);
 void dmz_schedule_reclaim(struct dmz_reclaim *zrc);
 
 /*
@@ -289,7 +291,7 @@ bool dmz_check_bdev(struct dmz_dev *dmz_dev);
  */
 static inline void dmz_deactivate_zone(struct dm_zone *zone)
 {
-       dmz_reclaim_bio_acc(zone->dev->reclaim);
+       dmz_bio_acc(zone->dev->metadata);
        atomic_dec(&zone->refcount);
 }

Does that solve the problem ? (completely untested)

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research
