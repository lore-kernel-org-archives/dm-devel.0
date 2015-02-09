From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: fix multipath regression due to initializing wrong
 request
Date: Mon, 9 Feb 2015 12:35:15 -0500
Message-ID: <20150209173514.GA14199@redhat.com>
References: <20150209163856.GA12781@posteo.de>
 <20150209164855.GB1599@redhat.com>
 <alpine.LNX.2.00.1502091651310.15481@localhost.lm.intel.com>
 <20150209171311.GC1599@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150209171311.GC1599@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@kernel.dk>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Feb 09 2015 at 12:13P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Feb 09 2015 at 12:07pm -0500,
> Keith Busch <keith.busch@intel.com> wrote:
> 
> > Oh, we're not going rebase the series with the correction? I'm concerned
> > someone biscecting a completely unrelated problem might step on this
> > commit. Up to you guys. It's my fault, so I'll deal with the consequences.
> 
> Rebasing this late (3.20 merge already opened) is generally not done.
> Unfortunately we'll just have to suck it up and deal with the fallout
> during bisect -- would wager very few are bisecting with multipath as
> the focus of their test.

Jens and I discussed this further and given that linux-block breaks
dm-multipath it is best to fix linux-block and let Linus resolve the
merge when I send him the linux-dm pull.

Here is the patch to fix the regression:

From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 9 Feb 2015 12:21:54 -0500
Subject: [PATCH] dm: fix multipath regression due to initializing wrong request

Commit febf715 ("block: require blk_rq_prep_clone() be given an
initialized clone request") introduced a regression by calling
blk_rq_init() on the original request rather than the clone
request that is passed to setup_clone().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f251633..71e6b73 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1719,7 +1719,7 @@ static int setup_clone(struct request *clone, struct request *rq,
 {
 	int r;
 
-	blk_rq_init(NULL, rq);
+	blk_rq_init(NULL, clone);
 	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
 			      dm_rq_bio_constructor, tio);
 	if (r)
-- 
1.9.3 (Apple Git-50)
