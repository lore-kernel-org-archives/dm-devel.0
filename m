From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: dm: use revalidate_disk to update device size after
	set_capacity
Date: Thu, 28 Oct 2010 21:15:44 +0900
Message-ID: <4CC96970.7010903@ce.jp.nec.com>
References: <20101019220711.GA25169@redhat.com>
	<4CBE813B.6050105@ce.jp.nec.com>
	<20101028011658.GA13690@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101028011658.GA13690@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

(10/28/10 10:16), Mike Snitzer wrote:
> But in my limited testing of the proposed patch (above), using linear DM
> target over DM mpath, I haven't seen any problems.  I was doing IO in
> parallel to the resize.  Notice with the patch we now see the following
> messages (dm-0 is the mpath device, dm-1 is the linear):

There is FIFREEZE ioctl, which calls freeze_super.
So if you mix a process doing FIFREEZE (xfs_freeze?) in your test,
I think you hit the deadlock like this:

  process A              process B
  -----------------------------------------------
                         suspend dm dev
  ioctl(FIFREEZE)
    freeze_super()
      hold s_umount
      sync_filesystems()
        wait for I/O flowing..

                         resume dm dev
                           __set_size
                             revalidate_disk()
                               hold bd_mutex
                               flush_disk()
                                 wait for s_umount

> But I haven't yet fully understood why check_disk_size_change's use of
> bdev->bd_mutex sufficiently protects access to bdev->bd_inode->i_size
> (unless all access to bdev->bd_inode->i_size takes bdev->bd_mutex; DM
> being an exception?).

i_size_read/write uses seqcount to protect the reads from
accessing incomplete write.
But the seqcount itself needs protection. Otherwise concurrent
writes will break the seqcount scheme.
So i_size_write()s need mutual exclusion, but not all accesses do.
That's my understanding from the comments in include/linux/fs.h.

> Given how naive I am on these core block paths there is more analysis
> needed to verify/determine the proper fix for DM device resize (while
> the device is suspended).
> 
> Could be the following patch be sufficient? (avoids potential for IO
> while device is suspended -- final patch would need comments explaining
> why revalidate_disk was avoided)

Though I can't point out actual problem,
I think it's deadlock-prone to take bd_mutex in dm_swap_table.

There are already codes which do I/O while holding bd_mutex,
e.g. block/ioctl.c, though the code is not called for dm,
so we can' just set a general rule "Don't do I/O while holding bd_mutex".

Also, even if I/O is not done under bd_mutex, it might be blocked by
other. For example, though currently nobody can call revalidate_disk for dm,

  process A              process B             process C
  ----------------------------------------------------------
                                               suspend dm dev
  freeze_super()
    hold s_umount
    sync_filesystems()
      wait for I/O flowing..

                         revalidate_disk()
                           hold bd_mutex
                           flush_disk()
                             wait for s_umount

                                               resume dm dev
                                                 __set_size
                                                   wait for bd_mutex

If __set_size() could be done in later stage of do_resume(),
we can use revalidate_disk() for dm, too.
What do you think?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
