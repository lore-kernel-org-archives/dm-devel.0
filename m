From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD: Add del_timer_sync to mddev_suspend (fix nasty panic)
Date: Tue, 15 May 2012 23:06:14 -0500
Message-ID: <1337141174.4337.8.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: neilb@suse.de, agk@redhat.com, jbrassow@redhat.com
List-Id: dm-devel.ids

Neil,

I've been seeing some really bad panics take place on dm-raid.c.  I've
found that it is because the mddev->safemode_timer is firing after the
mddev structure has been freed.  I've attached a patch to fix the
problem below, but I have some questions (outlined in the patch header).
I also have a debugging patch that prints something during each of the
suspend stages and when md_write_end resets the timer so that you can
see the problem in action - let me know if you want that patch also.

 brassow

Use del_timer_sync to remove timer before mddev_suspend finishes.

We don't want a timer going off after an mddev_suspend is called.  This is
especially true with device-mapper, since it can call the destructor function
immediately following a suspend.  This results in the removal (kfree) of the
structures upon which the timer depends - resulting in a very ugly panic.
Therefore, we add a del_timer_sync to mddev_suspend to prevent this.

<RFC>
While this approach works, it seems that 'md_stop_writes' should handle this
properly.  It calls del_timer_sync already, but then allows writes to /finish/
after it is called.  Finishing writes call md_write_end, which resets the timer.
Why call del_timer_sync at all there?

Device-mapper often makes use of the fact that mapping tables can be swapped
for a particular device.  In these scenarios, it is not uncommon to have I/O
flowing to a device when the following sequence of device-mapper primitives
are issued:
	- presuspend
	- postsuspend
	- dtr
Although I can't seem to find documentation on it, it is my impression that
once the presuspend is complete, no nominal I/O must be allowed through or
pending.  IOW, all I/O must be finished processing or queued.  This does not
include driver issued I/O, like the updating of bitmaps - that I/O must be
completed by the time postsuspend is complete.  (These are unwritten rules,
I think, and the main suspend rule is the important one: No I/O must be allowed
to flow or be pending once a suspend returns.)

dm-raid.c calls 'md_stop_writes' for the purpose of stopping nominal I/O.
It is clear that some writes are still allowed to finish-up after this call
is made.  Is this correct behavior?

dm-raid.c calls 'mddev_suspend' to ensure no I/O (nominal or driver-issued)
is flowing.  This seems to be working as expected.  However, adding the
del_timer_sync here allows us to clean up after any finished writes that
occurred after 'md_stop_writes' - preventing a kernel panic from a possible
'dtr' call that may follow.
</RFC>

RFC-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -391,6 +391,8 @@ void mddev_suspend(struct mddev *mddev)
 	synchronize_rcu();
 	wait_event(mddev->sb_wait, atomic_read(&mddev->active_io) == 0);
 	mddev->pers->quiesce(mddev, 1);
+
+	del_timer_sync(&mddev->safemode_timer);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 


