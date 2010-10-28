From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: use revalidate_disk to update device size after
	set_capacity
Date: Wed, 27 Oct 2010 21:16:59 -0400
Message-ID: <20101028011658.GA13690@redhat.com>
References: <20101019220711.GA25169@redhat.com>
	<4CBE813B.6050105@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4CBE813B.6050105@ce.jp.nec.com>
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

Hi Jun'ichi,

Thanks for your note.  It took me a while to set aside some time to look
at this closer.  Please see my response inlined below.

On Wed, Oct 20 2010 at  1:42am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> (10/20/10 07:07), Mike Snitzer wrote:
> > Avoid taking md->bdev->bd_inode->i_mutex to update the DM block device's
> > size.  Doing so eliminates the potential for deadlock if an fsync is
> > racing with a device resize.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index f934e98..fd315a7 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1995,10 +1995,7 @@ static void event_callback(void *context)
> >  static void __set_size(struct mapped_device *md, sector_t size)
> >  {
> >  	set_capacity(md->disk, size);
> > -
> > -	mutex_lock(&md->bdev->bd_inode->i_mutex);
> > -	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
> > -	mutex_unlock(&md->bdev->bd_inode->i_mutex);
> > +	revalidate_disk(md->disk);
> >  }
> 
> Some concerns/questions:
> 
> - revalidate_disk() calls bdget() inside it.
>   Does bdget() no longer block on I/O?
>   Sometime ago, bdget() has been blocked by I_LOCK,
>   where process holding I_LOCK blocked by resize.
>   Since I_LOCK has disappeared, I suspect this might not
>   be a valid concern anymore.
>   FYI, past discussion on this topic:
>   http://www.redhat.com/archives/dm-devel/2007-October/msg00134.html
>   (it's not my intention to push the patch in the above URL)

OK, thanks for the pointer.

Yes, I agree with you, seems there is no longer any obvious potential
for bdget to block on IO.

> - revalidate_disk() ends up with get_super():
>     revalidate_disk
>       check_disk_size_change
>         flush_disk
>           __invalidate_device
>             get_super
>   and get_super() takes sb->s_umount.
>   OTOH, there are codes which wait on I/O holding s_umount
>   exclusively. E.g. freeze_super() calls sync_filesystem().
>   So it seems there is a possible deadlock if you use
>   revalidate_disk from dm_swap_table.

Doesn't seem like a freeze_super of a particular DM device would
conflict with revalidate_disk relative to sb->s_umount.  But it is
concerning that revalidate_disk is calling flush_disk while the DM
device is suspended (though in practice this doesn't cause a problem):

dm_suspend() - flushes any outstanding IO.
  lock_fs
    freeze_bdev
      freeze_super
	down_write(&sb->s_umount);
        sync_filesystem
	up_write(&sb->s_umount);

dm_swap_table()
  __bind
    __set_size
      revalidate_disk
        check_disk_size_change
          flush_disk
            __invalidate_device
              get_super
	        down_read(&sb->s_umount);
		up_read(&sb->s_umount);

dm_resume()
  unlock_fs
    thaw_bdev
      thaw_super
        down_write(&sb->s_umount);
	deactivate_locked_super
	  up_write(&s->s_umount);

> I've been away from that part of the code for a while.
> So it's nice if the above is just a false alarm...

Clearly warrants further analysis.

check_disk_size_change() takes bdev->bd_mutex while changing
bdev->bd_inode->i_size (rather than bdev->bd_inode->i_mutex). This is
what attracted me to revalidate_disk (in addition to the rest of the
block drivers using it for resize -- thanks to Neil Brown for pointing
it out).

But in my limited testing of the proposed patch (above), using linear DM
target over DM mpath, I haven't seen any problems.  I was doing IO in
parallel to the resize.  Notice with the patch we now see the following
messages (dm-0 is the mpath device, dm-1 is the linear):

dm-0: detected capacity change from 0 to 10737418240
dm-1: detected capacity change from 0 to 8589934592
...
dm-1: detected capacity change from 8589934592 to 9663676416
dm-1: detected capacity change from 9663676416 to 9667870720

But I haven't yet fully understood why check_disk_size_change's use of
bdev->bd_mutex sufficiently protects access to bdev->bd_inode->i_size
(unless all access to bdev->bd_inode->i_size takes bdev->bd_mutex; DM
being an exception?).

Given how naive I am on these core block paths there is more analysis
needed to verify/determine the proper fix for DM device resize (while
the device is suspended).

Could be the following patch be sufficient? (avoids potential for IO
while device is suspended -- final patch would need comments explaining
why revalidate_disk was avoided)

Mike

---
 drivers/md/dm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..248794a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1996,9 +1996,9 @@ static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
+	mutex_lock(&md->bdev->bd_mutex);
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
+	mutex_unlock(&md->bdev->bd_mutex);
 }
 
 /*
