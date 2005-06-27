From: "Zhao Qian" <zhaoqian@aaastor.com>
Subject: [patch] dm-raid1.c patch to fix bug when bio's bi_size
	exceed the region's size
Date: Mon, 27 Jun 2005 12:39:47 +0800
Message-ID: <003401c57ad2$43e243f0$1f000064@polaris>
References: <20050626160004.A9C79734E8@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

under my test, sometimes the bios dispatched to the dm-mirror's bi_size i=
s larger then the dm-mirror target's region size,
here some bi_size when i run bonnie++ on a dm-mirror target(mkfs as ext3)=
, dm-mirror's region size is 2048 bytes:
.........
*************************bi_size(in bytes) - bi_sector
Jun 24 15:07:28 darkstar kernel: Catch it:49152 - 1060816
Jun 24 15:07:28 darkstar kernel: Catch it:49152 - 1070040
Jun 24 15:07:28 darkstar kernel: Catch it:32768 - 1150960
Jun 24 15:07:28 darkstar kernel: Catch it:32768 - 1160184
Jun 24 15:07:28 darkstar kernel: Catch it:49152 - 1176552
Jun 24 15:07:28 darkstar kernel: Catch it:49152 - 1185768
Jun 24 15:07:28 darkstar kernel: Catch it:49152 - 1225704
Jun 24 15:07:28 darkstar kernel: Catch it:49152 - 1234912
Jun 24 15:07:28 darkstar kernel: Catch it:32768 - 1258464
Jun 24 15:07:28 darkstar kernel: Catch it:32768 - 1291256
Jun 24 15:09:14 darkstar kernel: Catch it:131072 - 1920960
Jun 24 15:09:15 darkstar kernel: Catch it:131072 - 1921984
......................
the debug code insert to function queue_bio(struct mirror_set *ms, struct=
 bio *bio, int rw)'s first line:
+       if( (bio->bi_sector>>ms->rh.region_shift)=20
+               !=3D ((bio->bi_sector+((bio->bi_size-1)>>9))>> ms->rh.reg=
ion_shift) )
+       {
+               printk("Catch it:%d - %d\n",bio->bi_size,bio->bi_sector);
+       }

this problem's keypoint is READ/WRITE request to dm-mirror could affect n=
ot only one region, but in current implementation it assumes=20
only one region is affected and locked, others are not locked.=20

for example,

[__________________________MIRROR_1____________________________]
[__________________________MIRROR_2____________________________]
+---------------------+--------------------+-----------------+-----------=
-----------+
|       sync region          |     recovering region|   nosync region   |=
    nosync region          |
+---------------------+--------------------+-----------------+-----------=
-----------+
                                       ^ recover working here now.
 <--------------------------READ bio range-------------------------------=
----------->
In this situation, READ could read nosync mirrror then return corrupted d=
ata.  WRITE has similar problem with it.

Sincerely,
                Zhao Qian <zhaoqian@aaastor.com>
                Du Jun <dujun@aaastor.com>

Patch to solve this problem here:
[root@darkstar src]# diff -u orig/linux-2.6.11/drivers/md/dm-raid1.c linu=
x-2.6.11.11/drivers/md/dm-raid1.c=20
--- orig/linux-2.6.11/drivers/md/dm-raid1.c     2005-03-02 15:38:33.00000=
0000 +0800
+++ linux-2.6.11.11/drivers/md/dm-raid1.c       2005-06-27 11:58:08.00000=
0000 +0800
@@ -76,6 +76,7 @@
        /* hash table */
        rwlock_t hash_lock;
        mempool_t *region_pool;
+       mempool_t *region_pair_pool;
        unsigned int mask;
        unsigned int nr_buckets;
        struct list_head *buckets;
@@ -85,6 +86,9 @@
        struct list_head clean_regions;
        struct list_head quiesced_regions;
        struct list_head recovered_regions;
+
+       spinlock_t region_pair_lock;
+       struct list_head unused_region_pairs;
 };
=20
 enum {
@@ -132,7 +136,32 @@
        kfree(element);
 }
=20
+struct region_pair
+{
+       region_t first;
+       region_t last;
+        struct list_head list;
+};
+
+static struct region_pair *bio_to_region_pair(struct region_hash *rh, st=
ruct bio *bio,struct region_pair *rp)
+{
+        rp->first =3D bio->bi_sector >> rh->region_shift;
+       rp->last =3D (bio->bi_sector+((bio->bi_size-1)>>9)) >> rh->region=
_shift;
+       return rp;
+}
+
+static void *region_pair_alloc(int gfp_mask, void *pool_data)
+{      =20
+        return kmalloc(sizeof(struct region_pair), gfp_mask);
+}
+
+static void region_pair_free(void *element, void *pool_data)
+{      =20
+        kfree(element);
+}=20
+
 #define MIN_REGIONS 64
+#define MIN_REGION_PAIRS 128
 #define MAX_RECOVERY 1
 static int rh_init(struct region_hash *rh, struct mirror_set *ms,
                   struct dirty_log *log, uint32_t region_size,
@@ -173,6 +202,9 @@
        INIT_LIST_HEAD(&rh->quiesced_regions);
        INIT_LIST_HEAD(&rh->recovered_regions);
=20
+        spin_lock_init(&rh->region_pair_lock);
+        INIT_LIST_HEAD(&rh->unused_region_pairs);
+
        rh->region_pool =3D mempool_create(MIN_REGIONS, region_alloc,
                                         region_free, NULL);
        if (!rh->region_pool) {
@@ -181,6 +213,15 @@
                return -ENOMEM;
        }
=20
+        rh->region_pair_pool =3D mempool_create(MIN_REGION_PAIRS, region=
_pair_alloc,
+                                         region_pair_free, NULL);
+        if (!rh->region_pair_pool) {
+                vfree(rh->buckets);
+                rh->buckets =3D NULL;
+               mempool_destroy(rh->region_pool);
+                return -ENOMEM;
+        }
+
        return 0;
 }
=20
@@ -188,6 +229,7 @@
 {
        unsigned int h;
        struct region *reg, *nreg;
+       struct region_pair *pair,*pair_next;
=20
        BUG_ON(!list_empty(&rh->quiesced_regions));
        for (h =3D 0; h < rh->nr_buckets; h++) {
@@ -197,10 +239,15 @@
                }
        }
=20
+       list_for_each_entry_safe( pair,pair_next,&rh->unused_region_pairs=
,list)
+               mempool_free(pair,rh->region_pair_pool);
+
        if (rh->log)
                dm_destroy_dirty_log(rh->log);
        if (rh->region_pool)
                mempool_destroy(rh->region_pool);
+        if (rh->region_pair_pool)
+                mempool_destroy(rh->region_pair_pool);
        vfree(rh->buckets);
 }
=20
@@ -320,9 +367,11 @@
 static void rh_update_states(struct region_hash *rh)
 {
        struct region *reg, *next;
+       struct region_pair *pair,*pair_next;
=20
        LIST_HEAD(clean);
        LIST_HEAD(recovered);
+       LIST_HEAD(unused);
=20
        /*
         * Quickly grab the lists.
@@ -347,6 +396,12 @@
                        list_del(&reg->hash_list);
        }
        spin_unlock(&rh->region_lock);
+
+       spin_lock(&rh->region_pair_lock);
+               list_splice(&rh->unused_region_pairs,&unused);
+               INIT_LIST_HEAD(&rh->unused_region_pairs);
+       spin_unlock(&rh->region_pair_lock);
+
        write_unlock_irq(&rh->hash_lock);
=20
        /*
@@ -367,6 +422,9 @@
=20
        list_for_each_entry_safe (reg, next, &clean, list)
                mempool_free(reg, rh->region_pool);
+
+       list_for_each_entry_safe( pair,pair_next,&unused,list)
+               mempool_free(pair,rh->region_pair_pool);
 }
=20
 static void rh_inc(struct region_hash *rh, region_t region)
@@ -391,9 +449,15 @@
 static void rh_inc_pending(struct region_hash *rh, struct bio_list *bios=
)
 {
        struct bio *bio;
+       struct region_pair rp;
+       region_t r;
=20
-       for (bio =3D bios->head; bio; bio =3D bio->bi_next)
-               rh_inc(rh, bio_to_region(rh, bio));
+       for (bio =3D bios->head; bio; bio =3D bio->bi_next){
+               bio_to_region_pair(rh,bio,&rp);
+               for( r=3Drp.first; r<=3Drp.last;r++ ){
+                       rh_inc(rh, r);
+               }
+       }
 }
=20
 static void rh_dec(struct region_hash *rh, region_t region)
@@ -506,14 +570,14 @@
        rh->log->type->flush(rh->log);
 }
=20
-static void rh_delay(struct region_hash *rh, struct bio *bio)
+static void rh_delay_on_region(struct region_hash *rh, struct bio *bio,r=
egion_t region)
 {
-       struct region *reg;
+        struct region *reg;
=20
-       read_lock(&rh->hash_lock);
-       reg =3D __rh_find(rh, bio_to_region(rh, bio));
-       bio_list_add(&reg->delayed_bios, bio);
-       read_unlock(&rh->hash_lock);
+        read_lock(&rh->hash_lock);
+        reg =3D __rh_find(rh, region);
+        bio_list_add(&reg->delayed_bios, bio);
+        read_unlock(&rh->hash_lock);
 }
=20
 static void rh_stop_recovery(struct region_hash *rh)
@@ -692,17 +756,26 @@
=20
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 {
-       region_t region;
        struct bio *bio;
        struct mirror *m;
+       struct region_pair rp;
+       region_t r;
+       int sync_count;
=20
        while ((bio =3D bio_list_pop(reads))) {
-               region =3D bio_to_region(&ms->rh, bio);
+               bio_to_region_pair(&ms->rh,bio,&rp);
=20
                /*
                 * We can only read balance if the region is in sync.
                 */
-               if (rh_in_sync(&ms->rh, region, 0))
+
+               sync_count =3D 0;
+               for(r=3Drp.first;r<=3Drp.last;r++){
+                       if (rh_in_sync(&ms->rh, r, 0)){
+                               sync_count++;
+                       }
+               }
+               if( sync_count>(rp.last-rp.first) )
                        m =3D choose_mirror(ms, bio->bi_sector);
                else
                        m =3D ms->mirror + DEFAULT_MIRROR;
@@ -779,6 +852,8 @@
        int state;
        struct bio *bio;
        struct bio_list sync, nosync, recover, *this_list =3D NULL;
+       struct region_pair rp;
+       region_t r;
=20
        if (!writes->head)
                return;
@@ -791,23 +866,28 @@
        bio_list_init(&recover);
=20
        while ((bio =3D bio_list_pop(writes))) {
-               state =3D rh_state(&ms->rh, bio_to_region(&ms->rh, bio), =
1);
-               switch (state) {
-               case RH_CLEAN:
-               case RH_DIRTY:
-                       this_list =3D &sync;
-                       break;
-
-               case RH_NOSYNC:
-                       this_list =3D &nosync;
-                       break;
+               bio_to_region_pair(&ms->rh,bio,&rp);
+               this_list =3D &sync;
+               for(r=3Drp.first;r<=3Drp.last;r++){
+                       state =3D rh_state(&ms->rh, r, 1);
+                       switch (state) {
+                       case RH_CLEAN:
+                       case RH_DIRTY:
+                               break;
=20
-               case RH_RECOVERING:
-                       this_list =3D &recover;
-                       break;
+                       case RH_NOSYNC:
+                               this_list =3D &nosync;
+                               break;
+
+                       case RH_RECOVERING:
+                               rh_delay_on_region(&ms->rh,bio,r);
+                               this_list =3D &recover;
+                               break;
+                       }
+                       if( &recover =3D=3D this_list )break;
                }
=20
-               bio_list_add(this_list, bio);
+               if( &recover!=3Dthis_list )bio_list_add(this_list, bio);
        }
=20
        /*
@@ -825,9 +905,6 @@
        while ((bio =3D bio_list_pop(&sync)))
                do_write(ms, bio);
=20
-       while ((bio =3D bio_list_pop(&recover)))
-               rh_delay(&ms->rh, bio);
-
        while ((bio =3D bio_list_pop(&nosync))) {
                map_bio(ms, ms->mirror + DEFAULT_MIRROR, bio);
                generic_make_request(bio);
@@ -1105,9 +1182,10 @@
        struct mirror *m;
        struct mirror_set *ms =3D ti->private;
=20
-       map_context->ll =3D bio->bi_sector >> ms->rh.region_shift;
-
        if (rw =3D=3D WRITE) {
+               struct region_pair *rp  =3D mempool_alloc(ms->rh.region_p=
air_pool, GFP_NOIO);
+               bio_to_region_pair(&ms->rh,bio,rp);
+               map_context->ptr =3D rp;
                queue_bio(ms, bio, rw);
                return 0;
        }
@@ -1128,7 +1206,7 @@
        if (!r && rw =3D=3D READA)
                return -EIO;
=20
-       if (!r) {
+       if ( !r || bio_sectors(bio)>1 ) {
                /* Pass this io over to the daemon */
                queue_bio(ms, bio, rw);
                return 0;
@@ -1145,15 +1223,21 @@
 static int mirror_end_io(struct dm_target *ti, struct bio *bio,
                         int error, union map_info *map_context)
 {
+       region_t region;
        int rw =3D bio_rw(bio);
        struct mirror_set *ms =3D (struct mirror_set *) ti->private;
-       region_t region =3D map_context->ll;
=20
        /*
         * We need to dec pending if this was a write.
         */
-       if (rw =3D=3D WRITE)
-               rh_dec(&ms->rh, region);
+       if (rw =3D=3D WRITE){
+               struct region_pair *rp =3D (struct region_pair *)map_cont=
ext->ptr;
+               for(region=3Drp->first;region<=3Drp->last;region++)
+                       rh_dec(&ms->rh, region);
+               spin_lock_irq(&ms->rh.region_pair_lock);
+               list_add(&rp->list,&ms->rh.unused_region_pairs);
+               spin_unlock_irq(&ms->rh.region_pair_lock);
+       }
=20
        return 0;
 }
