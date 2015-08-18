From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Tue, 18 Aug 2015 15:17:45 -0700
Message-ID: <1439936265.30705.11.camel@ssi>
References: <1439103347.7880.3.camel@hasee>
	<20150809070128.GA25739@infradead.org> <1439104707.7880.8.camel@hasee>
	<20150810150216.GA22719@redhat.com>
	<CAF1ivSZFCVRDQf-N0JOBweX4se3iZZJzUCR_Uqdq1AV3Vd+Srg@mail.gmail.com>
	<CAF1ivSaAX8sHFyaW69da8arm4fpLD-T656GgV3-KYQxt0H_DYg@mail.gmail.com>
	<20150818144505.GA15832@redhat.com> <1439919178.28022.3.camel@ssi>
	<20150818195925.GA17273@redhat.com> <1439932605.30705.6.camel@ssi>
	<20150818212257.GA17700@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150818212257.GA17700@redhat.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Thornber <ejt@redhat.com>, device-mapper@redhat.com, Christoph Hellwig <hch@lst.de>, development <dm-devel@redhat.com>, Kent@redhat.com, Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

On Tue, 2015-08-18 at 17:22 -0400, Mike Snitzer wrote:
> On Tue, Aug 18 2015 at  5:16pm -0400,
> Ming Lin <mlin@kernel.org> wrote:
> 
> > On Tue, 2015-08-18 at 15:59 -0400, Mike Snitzer wrote:
> > > On Tue, Aug 18 2015 at  1:32pm -0400,
> > > Ming Lin <mlin@kernel.org> wrote:
> > > 
> > > > On Tue, 2015-08-18 at 10:45 -0400, Mike Snitzer wrote:
> > > > > On Tue, Aug 18 2015 at  3:04am -0400,
> > > > > Ming Lin <mlin@kernel.org> wrote:
> > > > > 
> > > > > > On Mon, Aug 17, 2015 at 10:09 PM, Ming Lin <mlin@kernel.org> wrote:
> > > > > > > On Mon, Aug 10, 2015 at 8:02 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > > > > > >> p.s. I'll be working with Joe Thornber on optimizing DM (particularly
> > > > > > >> dm-thinp and dm-cache) once this patchset is included upstream.  You'll
> > > > > > >> see I've already added a couple WIP dm-thinp patches ontop.
> > > > > > >
> > > > > > > Hi Mike,
> > > > > > >
> > > > > > > Just to avoid duplicated work.
> > > > > > > Are you going to work on the dm-thinp/dm-cache discard rewritten?
> > > > > > 
> > > > > > Seems dm-stripe discard also needs rewrite.
> > > > > 
> > > > > Can you elaborate on what you feel needs re-writing in these targets?
> > > > 
> > > > dm-stripe also require discard size to be a multiple of chunk size.
> > > > See output of below debug patch for 4G discard.
> > > > 
> > > > root@bee:~# blkdiscard -o 0 -l 4294967296 /dev/striped_vol_group/striped_logical_volume
> > > > 
> > > > root@bee:~# dmesg |grep DEBUG
> > > > [   13.110224] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > [   13.113723] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > [   13.117098] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > [   13.120424] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > [   13.123800] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > [   13.127027] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > [   13.130161] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
> > > > 
> > > > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > > > index bd40292..1cab2ba 100644
> > > > --- a/block/blk-lib.c
> > > > +++ b/block/blk-lib.c
> > > > @@ -82,7 +82,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
> > > >  			break;
> > > >  		}
> > > >  
> > > > -		req_sects = min_t(sector_t, nr_sects, MAX_BIO_SECTORS);
> > > > +		req_sects = min_t(sector_t, nr_sects, UINT_MAX>>9);
> > > >  		end_sect = sector + req_sects;
> > > >  
> > > >  		bio->bi_iter.bi_sector = sector;
> > > > diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> > > > index 484029d..a288bc2 100644
> > > > --- a/drivers/md/dm-stripe.c
> > > > +++ b/drivers/md/dm-stripe.c
> > > > @@ -273,6 +273,8 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
> > > >  		return DM_MAPIO_REMAPPED;
> > > >  	} else {
> > > >  		/* The range doesn't map to the target stripe */
> > > > +		printk("DEBUG: discard ignored: stripe chunk size %dK bytes, bio size %d bytes\n",
> > > > +			sc->chunk_size>>1, bio->bi_iter.bi_size);
> > > >  		bio_endio(bio);
> > > >  		return DM_MAPIO_SUBMITTED;
> > > >  	}
> > > 
> > > This is expected.  If a discard is only 512 bytes and the chunk size is
> > > 128K then every discard will only ever hit one stripe.
> > 
> > The discard was actually 4G bytes.
> > # blkdiscard -o 0 \
> >       -l 4294967296 /dev/striped_vol_group/striped_logical_volume
> > 
> > In the above debug patch, I changed MAX_BIO_SECTORS to UINT_MAX>>9
> > to show the problem.
> > 
> > The 512 bytes comes from blkdev_issue_discard() split the 4G bytes to
> > (UINT_MAX>>9) sectors + 1 sector.
> > 
> > > 
> > > So each discard will have N - 1 "discard ignored" messages (when N is #
> > > of stripes in the dm-stripe device).  So in your test device I'd assume
> > > you have 8 stripes.
> > 
> > Yes.
> > 
> > > 
> > > Basically your debugging looks like it is _very_ prone to false
> > > positives here.  The dm-stripe code is working as expected.
> > 
> > With current 2G cap in blkdev_issue_discard(), dm-stripe works OK.
> > But if in future we change it to UINT_MAX, then dm-stripe discard will
> > have problem as dm-thinp/dm-cache.
> 
> No you're still missing my point.  dm-stripe isn't dropping the partial
> discard completely.  It is just that the discard only applies to one of
> the 8 stripes in your test.
> 
> With the 2G cap it just so happens that each discard hits each stripe.

Ah, yes, not I got it. dm-strip works as expected with UINT_MAX cap.
I should debug with below patch. 

diff --git a/block/blk-lib.c b/block/blk-lib.c
index bd40292..1cab2ba 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -82,7 +82,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			break;
 		}
 
-		req_sects = min_t(sector_t, nr_sects, MAX_BIO_SECTORS);
+		req_sects = min_t(sector_t, nr_sects, UINT_MAX>>9);
 		end_sect = sector + req_sects;
 
 		bio->bi_iter.bi_sector = sector;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 484029d..85142b2 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -270,9 +270,12 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
 		bio->bi_iter.bi_sector = begin +
 			sc->stripe[target_stripe].physical_start;
 		bio->bi_iter.bi_size = to_bytes(end - begin);
+		printk("DEBUG: stripe %d, discard sector [%ld, %ld]\n", target_stripe,
+			bio->bi_iter.bi_sector, (bio->bi_iter.bi_sector + (bio->bi_iter.bi_size>>9) - 1));
 		return DM_MAPIO_REMAPPED;
 	} else {
 		/* The range doesn't map to the target stripe */
+		printk("DEBUG: stripe %d, discard ignored\n", target_stripe);
 		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
 	}


[   17.471687] DEBUG: stripe 0, discard sector [2048, 264191]
[   17.473380] DEBUG: stripe 1, discard sector [2048, 264191]
[   17.474919] DEBUG: stripe 2, discard sector [2048, 264191]
[   17.476457] DEBUG: stripe 3, discard sector [2048, 264191]
[   17.478032] DEBUG: stripe 4, discard sector [2048, 264191]
[   17.479551] DEBUG: stripe 5, discard sector [2048, 264191]
[   17.481064] DEBUG: stripe 6, discard sector [2048, 264191]
[   17.482607] DEBUG: stripe 7, discard sector [2048, 264191]

[   17.484136] DEBUG: stripe 0, discard sector [264192, 526335]
[   17.485669] DEBUG: stripe 1, discard sector [264192, 526335]
[   17.487226] DEBUG: stripe 2, discard sector [264192, 526335]
[   17.488778] DEBUG: stripe 3, discard sector [264192, 526335]
[   17.490388] DEBUG: stripe 4, discard sector [264192, 526335]
[   17.491998] DEBUG: stripe 5, discard sector [264192, 526335]
[   17.493613] DEBUG: stripe 6, discard sector [264192, 526335]
[   17.495199] DEBUG: stripe 7, discard sector [264192, 526335]

[   17.496725] DEBUG: stripe 0, discard sector [526336, 788479]
[   17.498168] DEBUG: stripe 1, discard sector [526336, 788479]
[   17.499574] DEBUG: stripe 2, discard sector [526336, 788479]
[   17.500902] DEBUG: stripe 3, discard sector [526336, 788479]
[   17.502341] DEBUG: stripe 4, discard sector [526336, 788479]
[   17.503734] DEBUG: stripe 5, discard sector [526336, 788479]
[   17.505347] DEBUG: stripe 6, discard sector [526336, 788479]
[   17.506984] DEBUG: stripe 7, discard sector [526336, 788479]

[   17.508485] DEBUG: stripe 0, discard sector [788480, 1050623]
[   17.509998] DEBUG: stripe 1, discard sector [788480, 1050623]
[   17.511567] DEBUG: stripe 2, discard sector [788480, 1050623]
[   17.513118] DEBUG: stripe 3, discard sector [788480, 1050623]
[   17.514665] DEBUG: stripe 4, discard sector [788480, 1050623]
[   17.516246] DEBUG: stripe 5, discard sector [788480, 1050623]
[   17.517830] DEBUG: stripe 6, discard sector [788480, 1050623]
[   17.519398] DEBUG: stripe 7, discard sector [788480, 1050622]

[   17.520802] DEBUG: stripe 0, discard ignored
[   17.521953] DEBUG: stripe 1, discard ignored
[   17.523167] DEBUG: stripe 2, discard ignored
[   17.524321] DEBUG: stripe 3, discard ignored
[   17.525544] DEBUG: stripe 4, discard ignored
[   17.526737] DEBUG: stripe 5, discard ignored
[   17.527876] DEBUG: stripe 6, discard ignored
[   17.529024] DEBUG: stripe 7, discard sector [1050623, 1050623]
