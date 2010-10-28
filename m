From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: use revalidate_disk to update device size after
	set_capacity
Date: Thu, 28 Oct 2010 18:18:02 -0400
Message-ID: <20101028221802.GA1364@redhat.com>
References: <20101019220711.GA25169@redhat.com>
	<4CBE813B.6050105@ce.jp.nec.com>
	<20101028011658.GA13690@redhat.com>
	<4CC96970.7010903@ce.jp.nec.com>
	<20101028195432.GA23063@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101028195432.GA23063@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 28 2010 at  3:54pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Oct 28 2010 at  8:15am -0400,
> Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> > Though I can't point out actual problem,
> > I think it's deadlock-prone to take bd_mutex in dm_swap_table.
> > 
> > There are already codes which do I/O while holding bd_mutex,
> > e.g. block/ioctl.c, though the code is not called for dm,
> > so we can' just set a general rule "Don't do I/O while holding bd_mutex".
> 
> Right, it would work provided we had that understanding within DM.

I think I misunderstood what you were saying as: no code does I/O to DM
while holding bd_mutex so we _can_ just set the general rule....

But re-reading your mail made me realize you were likely saying the
opposite?  e.g. your can' was meant to be can't.

So even though we currently can't see a real deadlock associated with
using ->bd_mutex directly you're contending there is potential for one
(may already be one in hiding or one could be introduced in the future).

That is fine, best to be conservative.

> I'll cleanup the patch from my previous mail to include some in-code
> comments and re-post it.  Please ack it if you agree that direct use of
> bd_mutex in __set_size() is a reasonable fix given the current code.

Taking a step back, don't we already have adequate locking for
__set_size's i_size_write() via dm_swap_table's md->suspend_lock?

So something like the following?

Mike
---
 drivers/md/dm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..e71b8a1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1996,9 +1996,8 @@ static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
+	/* i_size_write() is protected by md->suspend_lock */
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
 /*
