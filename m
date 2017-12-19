From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v5] dm: add unstriped target
Date: Tue, 19 Dec 2017 13:16:48 -0700
Message-ID: <20171219201647.vqmsmj2l26o7sldj@sbauer-Z170X-UD5>
References: <cover.1513618685.git.heinzm@redhat.com>
	<1513639353-7231-1-git-send-email-snitzer@redhat.com>
	<20171219183511.wdbr3kmz5fw2f4lr@sbauer-Z170X-UD5>
	<20171219200353.GA65364@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171219200353.GA65364@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 19, 2017 at 03:03:53PM -0500, Mike Snitzer wrote:
> On Tue, Dec 19 2017 at  1:35P -0500,
> Scott Bauer <scott.bauer@intel.com> wrote:
> 
> > On Mon, Dec 18, 2017 at 06:22:33PM -0500, Mike Snitzer wrote:
> > 
> > > +	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1) {
> >                         ^ should be argv[4]
> > > +		ti->error = "Invalid striped device offset";
> > > +		goto err;
> > > +	}
> > > +	uc->physical_start = start;
> > 
> > Hi Mike,
> > Sorry for the bombardment of emails. I think I've fixed the last
> > problem. Above is the last issue.
> > 
> > Below is a patch you can apply that will fix up the sector switch, I
> > had mentioned in the previous mail, as well as the wrong argv usage
> > from above.
> > 
> > I still have not solved the NULL pointer issue, i'll continue to
> > investigate that. Unless you have an idea of why that is occuring.
> 
> See below for incremental patch that should fix the NULL pointer, please
> test and I'll fold it in, along with your incremental.
> 
> Thanks!
> 
> > You can trigger it without having to create/remove/create. Just a
> > creation with a bad (odd length) target length will do it.
> > 
> > If you don't want this patch but want me to do a v6 I can do that as
> > well.
> 
> I'll take it, no worries on sending out v6.

Functionally the code is good now -- Thank you very much for the help.
The last thing is I need to fix up the bash script in documentation.
I *really* have to work on this other project for the rest of the day.
Do you care if we land this now, and I will just submit a small fixup
of the Documentation tomorrow?

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index b6f641dcbdee..7a8fd1bfbdad 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -47,7 +47,6 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	sector_t width, tmp_len;
 	unsigned long long start;
 	char dummy;
-	int r = -EINVAL;
 
 	if (argc != 5) {
 		ti->error = "Invalid number of arguments";
@@ -86,13 +85,12 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
-	r = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &uc->dev);
-	if (r) {
+	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &uc->dev)) {
 		ti->error = "Couldn't get striped device";
 		goto err;
 	}
 
-	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1) {
+	if (sscanf(argv[4], "%llu%c", &start, &dummy) != 1) {
 		ti->error = "Invalid striped device offset";
 		goto err;
 	}
@@ -114,8 +112,7 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err;
 	}
 
-	r = dm_set_target_max_io_len(ti, uc->chunk_size);
-	if (r) {
+	if (dm_set_target_max_io_len(ti, uc->chunk_size)) {
 		ti->error = "Failed to set max io len";
 		goto err;
 	}
@@ -124,7 +121,7 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 err:
 	cleanup_unstripe(uc, ti);
-	return r;
+	return -EINVAL;
 }
 
 static void unstripe_dtr(struct dm_target *ti)
@@ -139,11 +136,12 @@ static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
 	struct unstripe_c *uc = ti->private;
 	sector_t sector = bio->bi_iter.bi_sector;
 
+	/* Shift us up to the right "row" on the stripe */
+	sector += uc->unstripe_width * (sector >> uc->chunk_shift);
+
 	/* Account for what stripe we're operating on */
 	sector += uc->unstripe_offset;
 
-	/* Shift us up to the right "row" on the stripe */
-	sector += uc->unstripe_width * (sector >> uc->chunk_shift);
 	return sector;
 }
 
