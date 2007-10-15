From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.23-mm1
Date: Mon, 15 Oct 2007 17:31:52 +1000
Message-ID: <18195.5992.545271.871100@notabene.brown>
References: <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	<64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	<47110500.8050503@garzik.org>
	<64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	<20071013111853.7e67c6c3.akpm@linux-foundation.org>
	<64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
	<20071014113914.7654759d.akpm@linux-foundation.org>
	<64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
	<20071014122613.5bbe4fc3.akpm@linux-foundation.org>
	<4712922F.6010005@redhat.com> <20071015065022.GC5380@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Jens Axboe on Monday October 15
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Torsten Kaiser <just.for.lkml@googlemail.com>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Monday October 15, jens.axboe@oracle.com wrote:
> On Mon, Oct 15 2007, Milan Broz wrote:
> > 
> > clone->bi_size is zero here now, so crypt_free_buffer_pages will not
> > work correctly (previously there was count of processed bytes).
> > 
> > But because it seems that bio cannot be processed partially now, we can
> > simplify crypt_free_buffer_pages to always remove all allocated pages.
> 
> Neil, this doesn't look very good. dm-crypt needs to know the clone io
> size, so ->bi_size was definitely used properly in this context before.
> Now it's gone. Suggestions on how to fix that up?

How about the following - even more code simplification gained by this
approach :-)

I originally had the patch for removing the 'size' argument after a
patch (series) that made bi_size unchanged.   It seemed that patch
would face a harder path upstream so I re-ordered them and missed this
dependency.  Mea Culpa.

> 
> I've been less than impressed with the bi_end_io() patchset so far, it's
> been full of typos and bad conversions. I'm tempted to revert the whole
> thing, clearly it wasn't ready for merge.

I must have missed something ....

I've seen:  A fix for a bi_end_io in jfs that I missed.
            A correction for that fix ("return 0" was remove instead
               of just the '0' removed)
            Some fixed for code that is only in -mm (which I didn't do
              because I thought you wanted it against a non-mm tree).

I think it was definitely ready for merging in -mm.  Possibly not for
mainline just yet.

NeilBrown

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-crypt.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff .prev/drivers/md/dm-crypt.c ./drivers/md/dm-crypt.c
--- .prev/drivers/md/dm-crypt.c	2007-10-15 17:18:20.000000000 +1000
+++ ./drivers/md/dm-crypt.c	2007-10-15 17:21:43.000000000 +1000
@@ -444,32 +444,12 @@ static struct bio *crypt_alloc_buffer(st
 }
 
 static void crypt_free_buffer_pages(struct crypt_config *cc,
-				    struct bio *clone, unsigned int bytes)
+				    struct bio *clone)
 {
-	unsigned int i, start, end;
+	unsigned int i;
 	struct bio_vec *bv;
 
-	/*
-	 * This is ugly, but Jens Axboe thinks that using bi_idx in the
-	 * endio function is too dangerous at the moment, so I calculate the
-	 * correct position using bi_vcnt and bi_size.
-	 * The bv_offset and bv_len fields might already be modified but we
-	 * know that we always allocated whole pages.
-	 * A fix to the bi_idx issue in the kernel is in the works, so
-	 * we will hopefully be able to revert to the cleaner solution soon.
-	 */
-	i = clone->bi_vcnt - 1;
-	bv = bio_iovec_idx(clone, i);
-	end = (i << PAGE_SHIFT) + (bv->bv_offset + bv->bv_len) - clone->bi_size;
-	start = end - bytes;
-
-	start >>= PAGE_SHIFT;
-	if (!clone->bi_size)
-		end = clone->bi_vcnt;
-	else
-		end >>= PAGE_SHIFT;
-
-	for (i = start; i < end; i++) {
+	for (i = 0; i < clone->bi_vcnt; i++) {
 		bv = bio_iovec_idx(clone, i);
 		BUG_ON(!bv->bv_page);
 		mempool_free(bv->bv_page, cc->page_pool);
@@ -539,7 +519,7 @@ static void crypt_endio(struct bio *clon
 	 * free the processed pages
 	 */
 	if (!read_io) {
-		crypt_free_buffer_pages(cc, clone, clone->bi_size);
+		crypt_free_buffer_pages(cc, clone);
 		goto out;
 	}
 
@@ -628,7 +608,7 @@ static void process_write(struct dm_cryp
 		ctx.idx_out = 0;
 
 		if (unlikely(crypt_convert(cc, &ctx) < 0)) {
-			crypt_free_buffer_pages(cc, clone, clone->bi_size);
+			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
 			crypt_dec_pending(io, -EIO);
 			return;
