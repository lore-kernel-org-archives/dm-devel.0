From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Tue, 18 Aug 2015 10:32:58 -0700
Message-ID: <1439919178.28022.3.camel@ssi>
References: <20150801163356.GA21478@redhat.com>
	<yq18u9liwhj.fsf@sermon.lab.mkp.net> <1439099990.7880.0.camel@hasee>
	<20150809064128.GB2436@infradead.org> <1439103347.7880.3.camel@hasee>
	<20150809070128.GA25739@infradead.org> <1439104707.7880.8.camel@hasee>
	<20150810150216.GA22719@redhat.com>
	<CAF1ivSZFCVRDQf-N0JOBweX4se3iZZJzUCR_Uqdq1AV3Vd+Srg@mail.gmail.com>
	<CAF1ivSaAX8sHFyaW69da8arm4fpLD-T656GgV3-KYQxt0H_DYg@mail.gmail.com>
	<20150818144505.GA15832@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150818144505.GA15832@redhat.com>
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

On Tue, 2015-08-18 at 10:45 -0400, Mike Snitzer wrote:
> On Tue, Aug 18 2015 at  3:04am -0400,
> Ming Lin <mlin@kernel.org> wrote:
> 
> > On Mon, Aug 17, 2015 at 10:09 PM, Ming Lin <mlin@kernel.org> wrote:
> > > On Mon, Aug 10, 2015 at 8:02 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> > >> p.s. I'll be working with Joe Thornber on optimizing DM (particularly
> > >> dm-thinp and dm-cache) once this patchset is included upstream.  You'll
> > >> see I've already added a couple WIP dm-thinp patches ontop.
> > >
> > > Hi Mike,
> > >
> > > Just to avoid duplicated work.
> > > Are you going to work on the dm-thinp/dm-cache discard rewritten?
> > 
> > Seems dm-stripe discard also needs rewrite.
> 
> Can you elaborate on what you feel needs re-writing in these targets?

dm-stripe also require discard size to be a multiple of chunk size.
See output of below debug patch for 4G discard.

root@bee:~# blkdiscard -o 0 -l 4294967296 /dev/striped_vol_group/striped_logical_volume

root@bee:~# dmesg |grep DEBUG
[   13.110224] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
[   13.113723] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
[   13.117098] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
[   13.120424] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
[   13.123800] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
[   13.127027] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes
[   13.130161] DEBUG: discard ignored: stripe chunk size 128K bytes, bio size 512 bytes

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
index 484029d..a288bc2 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -273,6 +273,8 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
 		return DM_MAPIO_REMAPPED;
 	} else {
 		/* The range doesn't map to the target stripe */
+		printk("DEBUG: discard ignored: stripe chunk size %dK bytes, bio size %d bytes\n",
+			sc->chunk_size>>1, bio->bi_iter.bi_size);
 		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
 	}

> 
> This is the basic initial cleanup I had in mind for dm-thinp:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.4&id=cb0aca0a6bfad6b7f7146dde776f374082a73db6
> 
> A much more involved refactoring of the dm-cache and dm-thinp targets to
> eliminate the need for splitting will involve bio-prison range locking
> and a new metadata format for both targets to express ranges as opposed
> to blocks.  This line of work is on Joe's radar but it is much further
> out given the associated on-disk metadata format change.
> 
> That aside, I do need to look at DM core to see how we can do things
> differently so that block core's bio_split() et al is doing the
> splitting rather than DM core having a role.
> 
> I'd prefer to be the one working these DM changes.  But if you have
> ideas of how things should be cleaned up I'd be happy to consider them.
> 
> Thanks,
> Mike
