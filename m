From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Multipath target does not shift block offset?
Date: Wed, 16 Feb 2005 10:02:20 -0600
Message-ID: <200502161002.20387.kevcorry@us.ibm.com>
References: <420D8A00.4080900@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <420D8A00.4080900@anu.edu.au>
Content-Disposition: inline
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

On Fri February 11 2005 10:45 pm, Tim Burgess wrote:
> Re the patch from Kevin:
>
> there looks like there is another reference to ti->begin in dm-raid1.c
> that the patch does not remove (in do_write).  I wasn't sure whether to
> leave it there or not, since you were talking about making each target
> unaware of its position within the overall mapped device...?

Oops. You're right, there are some other occurrances of ti->begin in the 
target modules that I missed in my previous patch. I accidentally only 
reviewing the mapping code. But dm-crypt and dm-raid1 each have code in their 
workqueue routines that used that field as well. Here's a new version of last 
week's patch with the two extra fixes.

And now that I think about it, we may want to make a similar patch for the 2.4 
version of DM. I'll try to write one up a little later.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/ltc/
http://evms.sourceforge.net/


--- diff/drivers/md/dm-crypt.c 2005-02-10 13:15:17.000000000 -0600
+++ source/drivers/md/dm-crypt.c 2005-02-16 09:51:42.211358152 -0600
@@ -476,7 +476,7 @@
  int r;
 
  crypt_convert_init(cc, &ctx, io->bio, io->bio,
-                    io->bio->bi_sector - io->target->begin, 0);
+                    io->bio->bi_sector, 0);
  r = crypt_convert(cc, &ctx);
 
  dec_pending(io, r);
@@ -808,7 +808,7 @@
  struct convert_context ctx;
  struct bio *clone;
  unsigned int remaining = bio->bi_size;
- sector_t sector = bio->bi_sector - ti->begin;
+ sector_t sector = bio->bi_sector;
  unsigned int bvec_idx = 0;
 
  io->target = ti;
--- diff/drivers/md/dm-flakey.c 2005-02-10 13:15:17.000000000 -0600
+++ source/drivers/md/dm-flakey.c 2005-02-10 13:06:25.000000000 -0600
@@ -97,7 +97,7 @@
 
  else {
   bio->bi_bdev = f->dev->bdev;
-  bio->bi_sector = f->start + (bio->bi_sector - ti->begin);
+  bio->bi_sector += f->start;
  }
 
  return 1;
--- diff/drivers/md/dm-linear.c 2005-02-10 13:15:17.000000000 -0600
+++ source/drivers/md/dm-linear.c 2005-02-10 13:07:53.000000000 -0600
@@ -71,7 +71,7 @@
  struct linear_c *lc = (struct linear_c *) ti->private;
 
  bio->bi_bdev = lc->dev->bdev;
- bio->bi_sector = lc->start + (bio->bi_sector - ti->begin);
+ bio->bi_sector += lc->start;
 
  return 1;
 }
--- diff/drivers/md/dm-raid1.c 2005-02-10 13:15:17.000000000 -0600
+++ source/drivers/md/dm-raid1.c 2005-02-16 09:52:51.626805400 -0600
@@ -687,7 +687,7 @@
 static void map_bio(struct mirror_set *ms, struct mirror *m, struct bio *bio)
 {
  bio->bi_bdev = m->dev->bdev;
- bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
+ bio->bi_sector += m->offset;
 }
 
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
@@ -764,7 +764,7 @@
   m = ms->mirror + i;
 
   io[i].bdev = m->dev->bdev;
-  io[i].sector = m->offset + (bio->bi_sector - ms->ti->begin);
+  io[i].sector = m->offset + bio->bi_sector;
   io[i].count = bio->bi_size >> 9;
  }
 
--- diff/drivers/md/dm-stripe.c 2005-02-10 13:15:17.000000000 -0600
+++ source/drivers/md/dm-stripe.c 2005-02-10 13:13:50.000000000 -0600
@@ -172,13 +172,12 @@
 {
  struct stripe_c *sc = (struct stripe_c *) ti->private;
 
- sector_t offset = bio->bi_sector - ti->begin;
- sector_t chunk = offset >> sc->chunk_shift;
+ sector_t chunk = bio->bi_sector >> sc->chunk_shift;
  uint32_t stripe = do_div(chunk, sc->stripes);
 
  bio->bi_bdev = sc->stripe[stripe].dev->bdev;
  bio->bi_sector = sc->stripe[stripe].physical_start +
-     (chunk << sc->chunk_shift) + (offset & sc->chunk_mask);
+     (chunk << sc->chunk_shift) + (bio->bi_sector & sc->chunk_mask);
  return 1;
 }
 
--- diff/drivers/md/dm.c 2005-02-10 13:15:17.000000000 -0600
+++ source/drivers/md/dm.c 2005-02-10 13:04:25.000000000 -0600
@@ -366,6 +366,7 @@
   * this io.
   */
  atomic_inc(&tio->io->io_count);
+ clone->bi_sector -= ti->begin;
  r = ti->type->map(ti, clone, &tio->info);
  if (r > 0)
   /* the bio has been remapped so dispatch it */

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
