From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
 checks
Date: Thu, 4 Mar 2010 18:59:21 +0100
Message-ID: <20100304175921.GD3670@soda.linbit>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
 <20100228184634.GI5768@kernel.dk>
 <874okyf4iw.fsf@openvz.org>
 <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
 <87wrxtkzwu.fsf@openvz.org>
 <20100303191613.GB18480@redhat.com>
 <87lje9kx9i.fsf@openvz.org>
 <20100303200734.GW5768@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100303200734.GW5768@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Mar 03, 2010 at 09:07:34PM +0100, Jens Axboe wrote:
> > 2) What statement "bio_add_page() must accept at least one page"
> >    exactly means?
> >    IMHO this means that bio_add_page() must accept at least
> >    one page with len (PAGE_SIZE - offset). Or more restricted
> >    statemnt that first bio_add_page() must be always successfull.
> 
> It's really 'first add must succeed', the restriction being that you
> cannot rely on that first add being more than a single page. So the rule
> is that you must accept at least a page at any offset if the bio is
> currently empty, since we know that a page is typically our IO
> granularity.

Speaking of...

dm_set_device_limits is still doing things wrong here, I think.

I posted this about two years ago, but somehow it got lost
and I lost it from my focus as well.
Reading this post reminded me ... there was something:

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b22feb..bc34901 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -519,10 +519,22 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	 * smaller I/O, just to be safe.
 	 */
 
-	if (q->merge_bvec_fn && !ti->type->merge)
+	if (q->merge_bvec_fn && !ti->type->merge) {
 		limits->max_sectors =
 			min_not_zero(limits->max_sectors,
 				     (unsigned int) (PAGE_SIZE >> 9));
+
+		/* Restricting max_sectors is not enough.
+		 * If someone uses bio_add_page to add 8 disjunct 512 byte
+		 * partial pages to a bio, it would succeed,
+		 * but could still cross a border of whatever restrictions
+		 * are below us (raid0 stripe boundary).  An attempted
+		 * bio_split would not succeed, because bi_vcnt is 8.
+		 * E.g. the xen io layer is known to trigger this.
+		 */
+		limits->max_segments = 1;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);


Thanks,
	Lars
