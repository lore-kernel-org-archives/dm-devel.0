From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: recent bdi changes result in WARN_ON on luksClose /
	dm
Date: Mon, 14 Sep 2009 11:05:33 +0200
Message-ID: <20090914090533.GU14984@kernel.dk>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
	<20090912195212.GF14984@kernel.dk>
	<20090912195839.GG14984@kernel.dk>
	<20090913091337.GA21969@Chamillionaire.breakpoint.cc>
	<20090913175717.GO14984@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090913175717.GO14984@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Sep 13 2009, Jens Axboe wrote:
> On Sun, Sep 13 2009, Sebastian Andrzej Siewior wrote:
> > * Jens Axboe | 2009-09-12 21:58:40 [+0200]:
> > 
> > >Don't count this as a real fix, I'll investigate closer on monday. Does
> > >the warning go away with this hack? It'll ensure that pending dirty
> > >inodes are flushed.
> > 
> > That warning goes away but another pops up:
> 
> Oh right, just goes to show that it's doing this backwards. We need the
> umount rwsem for WB_SYNC_ALL. I'll look at this tomorrow.

I think the safest option is to ensure that we just move these entries
to our default bdi, which doesn't go away. This should fix the warning,
can you test whether it works as well?

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index fd93566..27f82dc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -668,7 +668,17 @@ void bdi_destroy(struct backing_dev_info *bdi)
 {
 	int i;
 
-	WARN_ON(bdi_has_dirty_io(bdi));
+	/*
+	 * Splice our entries to the default_backing_dev_info, if this
+	 * bdi disappears
+	 */
+	if (bdi_has_dirty_io(bdi)) {
+		struct bdi_writeback *dst = &default_backing_dev_info.wb;
+
+		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
+		list_splice(&bdi->wb.b_io, &dst->b_io);
+		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
+	}
 
 	bdi_unregister(bdi);
 

-- 
Jens Axboe
