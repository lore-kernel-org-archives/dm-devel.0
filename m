From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Multipath target does not shift block offset?
Date: Thu, 10 Feb 2005 13:23:30 -0600
Message-ID: <200502101323.30143.kevcorry@us.ibm.com>
References: <420AEAE4.8090506@anu.edu.au>
	<20050210171832.GC14093@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050210171832.GC14093@agk.surrey.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thursday 10 February 2005 11:18 am, Alasdair G Kergon wrote:
> On Thu, Feb 10, 2005 at 04:02:28PM +1100, Tim Burgess wrote:
> > However, dm appears to be trying
> > to map the range 286749488-573498975 of the dm device to the same
> > offsets in the sde/sdm device.
> >
> > Is this what was intended?
>
> No.
>
> In dm-mpath.c try adding to multipath_map() at the top of the function:
>
>   bio->bi_sector = (bio->bi_sector - ti->begin);

Actually, now that you point this out, I think this responsibility should
really be handled by the core driver's I/O path instead of each target
module. There's really no reason for the target modules to care or even
know about the presence of multiple targets within a device table. We can
move this line into the core's __map_bio() and get rid of a lot of
duplicate code. Here's a patch to demonstrate what I'm talking about.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/


--- diff/drivers/md/dm-crypt.c 2005-02-10 13:15:17.521210768 -0600
+++ source/drivers/md/dm-crypt.c 2005-02-10 13:05:48.847662288 -0600
@@ -808,7 +808,7 @@
  struct convert_context ctx;
  struct bio *clone;
  unsigned int remaining = bio->bi_size;
- sector_t sector = bio->bi_sector - ti->begin;
+ sector_t sector = bio->bi_sector;
  unsigned int bvec_idx = 0;
 
  io->target = ti;
--- diff/drivers/md/dm-flakey.c 2005-02-10 13:15:17.471218368 -0600
+++ source/drivers/md/dm-flakey.c 2005-02-10 13:06:25.068155936 -0600
@@ -97,7 +97,7 @@
 
  else {
   bio->bi_bdev = f->dev->bdev;
-  bio->bi_sector = f->start + (bio->bi_sector - ti->begin);
+  bio->bi_sector += f->start;
  }
 
  return 1;
--- diff/drivers/md/dm-linear.c 2005-02-10 13:15:17.557205296 -0600
+++ source/drivers/md/dm-linear.c 2005-02-10 13:07:53.098773248 -0600
@@ -71,7 +71,7 @@
  struct linear_c *lc = (struct linear_c *) ti->private;
 
  bio->bi_bdev = lc->dev->bdev;
- bio->bi_sector = lc->start + (bio->bi_sector - ti->begin);
+ bio->bi_sector += lc->start;
 
  return 1;
 }
--- diff/drivers/md/dm-raid1.c 2005-02-10 13:15:17.540207880 -0600
+++ source/drivers/md/dm-raid1.c 2005-02-10 13:09:39.481600600 -0600
@@ -687,7 +687,7 @@
 static void map_bio(struct mirror_set *ms, struct mirror *m, struct bio *bio)
 {
  bio->bi_bdev = m->dev->bdev;
- bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
+ bio->bi_sector += m->offset;
 }
 
 static void do_reads(struct mirror_set *ms, struct bio_list *reads)
--- diff/drivers/md/dm-stripe.c 2005-02-10 13:15:17.492215176 -0600
+++ source/drivers/md/dm-stripe.c 2005-02-10 13:13:50.842387952 -0600
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
 
--- diff/drivers/md/dm.c 2005-02-10 13:15:17.508212744 -0600
+++ source/drivers/md/dm.c 2005-02-10 13:04:25.069398520 -0600
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
