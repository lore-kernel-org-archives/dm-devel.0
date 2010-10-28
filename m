From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: use revalidate_disk to update device size after
	set_capacity
Date: Thu, 28 Oct 2010 15:54:32 -0400
Message-ID: <20101028195432.GA23063@redhat.com>
References: <20101019220711.GA25169@redhat.com>
	<4CBE813B.6050105@ce.jp.nec.com>
	<20101028011658.GA13690@redhat.com>
	<4CC96970.7010903@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4CC96970.7010903@ce.jp.nec.com>
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

On Thu, Oct 28 2010 at  8:15am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Mike,
> 
> (10/28/10 10:16), Mike Snitzer wrote:
> > But in my limited testing of the proposed patch (above), using linear DM
> > target over DM mpath, I haven't seen any problems.  I was doing IO in
> > parallel to the resize.  Notice with the patch we now see the following
> > messages (dm-0 is the mpath device, dm-1 is the linear):
> 
> There is FIFREEZE ioctl, which calls freeze_super.
> So if you mix a process doing FIFREEZE (xfs_freeze?) in your test,
> I think you hit the deadlock like this:
> 
>   process A              process B
>   -----------------------------------------------
>                          suspend dm dev
>   ioctl(FIFREEZE)
>     freeze_super()
>       hold s_umount
>       sync_filesystems()
>         wait for I/O flowing..
> 
>                          resume dm dev
>                            __set_size
>                              revalidate_disk()
>                                hold bd_mutex
>                                flush_disk()
>                                  wait for s_umount

OK, I didn't consider FIFREEZE ioctl..

But regardless, I think it is now clear that we must avoid using
revalidate_disk() while a DM device is suspended.

> > But I haven't yet fully understood why check_disk_size_change's use of
> > bdev->bd_mutex sufficiently protects access to bdev->bd_inode->i_size
> > (unless all access to bdev->bd_inode->i_size takes bdev->bd_mutex; DM
> > being an exception?).
> 
> i_size_read/write uses seqcount to protect the reads from
> accessing incomplete write.
> But the seqcount itself needs protection. Otherwise concurrent
> writes will break the seqcount scheme.
> So i_size_write()s need mutual exclusion, but not all accesses do.
> That's my understanding from the comments in include/linux/fs.h.

Correct, but my point was that revalidate_disk protects the
bdev->bd_inode->i_size i_size_write() with bdev->bd_mutex.

Whereas quite a few non-block driver i_size_write() callers use the
inode's i_mutex; as DM currently does with md->bdev->bd_inode->i_mutex.

As we now know, using md->bdev->bd_inode->i_mutex is prone to deadlock
against fsync.

> > Given how naive I am on these core block paths there is more analysis
> > needed to verify/determine the proper fix for DM device resize (while
> > the device is suspended).
> > 
> > Could be the following patch be sufficient? (avoids potential for IO
> > while device is suspended -- final patch would need comments explaining
> > why revalidate_disk was avoided)
> 
> Though I can't point out actual problem,
> I think it's deadlock-prone to take bd_mutex in dm_swap_table.
> 
> There are already codes which do I/O while holding bd_mutex,
> e.g. block/ioctl.c, though the code is not called for dm,
> so we can' just set a general rule "Don't do I/O while holding bd_mutex".

Right, it would work provided we had that understanding within DM.

> Also, even if I/O is not done under bd_mutex, it might be blocked by
> other. For example, though currently nobody can call revalidate_disk for dm,

Hmm, that was a strange example, as you pointed out, considering the
fictional revalidate_disk caller.  I was proposing using bd_mutex
directly -- independent of revalidate_disk and its associated flushing.

> If __set_size() could be done in later stage of do_resume(),
> we can use revalidate_disk() for dm, too.
> What do you think?

I think it would be incorrect to make a new DM table live without first
adjusting the size of the DM device to reflect the new table.  Could
result in racing IO to the end of a device which would cause IO errors
like "access beyond end of device".

So our only option would be to change the device's size _before_
do_resume's dm_suspend().  But then if dm_swap_table() fails we'd need
to revert back to the old size -- which is clearly awkward.

I think updating the device's size within dm_swap_table() really is the
most logical place.

I'll cleanup the patch from my previous mail to include some in-code
comments and re-post it.  Please ack it if you agree that direct use of
bd_mutex in __set_size() is a reasonable fix given the current code.

Mike
