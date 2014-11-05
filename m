From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Tue, 4 Nov 2014 20:16:19 -0500
Message-ID: <20141105011619.GA11411@redhat.com>
References: <20141028134012.GA25229@redhat.com>
	<20141028141749.GD25229@redhat.com>
	<20141028143742.GE25229@redhat.com>
	<20141028171003.GG25229@redhat.com>
	<20141028224753.GA29288@redhat.com>
	<20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 03 2014 at  7:17pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Nov 3, 2014 6:27 PM, "Mikulas Patocka" <mpatocka@redhat.com> wrote:
> >
> >
> >
> > On Tue, 28 Oct 2014, Mike Snitzer wrote:
> >
> > > I pushed rebased versions of these patches to linux-dm.git's
> > > 'dm-for-3.19' branch (and pulled into 'for-next' purely to get the
> > > kernel.org autobuilders testing the code).  See top 3 commits here:
> > >
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19
> > >
> > > I'm open to any and all changes or dropping code entirely; so me staging
> > > like this is just to keep the review ball rolling as quickly as
> > > possible.
> > >
> > > But in particular we need to get Mikulas' and Bryn's feedback on how the
> > > dm_internal_{suspend,resume} changes impact dm-stats.
> > >
> > > Mike
> >
> > Hi
> >
> > As I said on irc - it is not correct to take a mutex from one syscall and
> > drop the mutex from another syscall.
> 
> I didn't modify that aspect of dm_internal_suspend+resume.  I only extended
> the interface to other targets via export.
> 
> > I hope Joe can use the bio prison to block bios while the pool is
> > suspended.
> 
> We'll see.

Joe said today: "bio-prison thing isn't going to work, since we need the
worker thread to complete as part of the [thin-pool] suspend".

And the following patch fixes the locking issue you raised:

From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 4 Nov 2014 15:38:59 -0500
Subject: [PATCH] dm: leverage DM_INTERNAL_SUSPEND_FLAG instead of abusing suspend_lock

Update dm_internal_{suspend,resume} to always take and release the
mapped_device's suspend_lock.

Also update dm_{suspend,resume} to be aware of potential for
DM_INTERNAL_SUSPEND_FLAG to be set and respond accordingly by
interruptibly waiting for the DM_INTERNAL_SUSPEND_FLAG to be cleared.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 38cea89..ac0dcad 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,6 +19,7 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/delay.h>
+#include <linux/wait.h>
 
 #include <trace/events/block.h>
 
@@ -2827,6 +2828,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
 	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
 
+retry:
 	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
 
 	if (dm_suspended_md(md)) {
@@ -2834,6 +2836,15 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}
 
+	if (dm_suspended_internally_md(md)) {
+		/* already internally suspended, wait for internal resume */
+		mutex_unlock(&md->suspend_lock);
+		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		if (r)
+			return r;
+		goto retry;
+	}
+
 	map = rcu_dereference(md->map);
 
 	r = __dm_suspend(md, map, do_lockfs, noflush, true);
@@ -2876,10 +2887,20 @@ int dm_resume(struct mapped_device *md)
 	int r = -EINVAL;
 	struct dm_table *map = NULL;
 
+retry:
 	mutex_lock(&md->suspend_lock);
 	if (!dm_suspended_md(md))
 		goto out;
 
+	if (dm_suspended_internally_md(md)) {
+		/* already internally suspended, wait for internal resume */
+		mutex_unlock(&md->suspend_lock);
+		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		if (r)
+			return r;
+		goto retry;
+	}
+
 	map = rcu_dereference(md->map);
 	if (!map || !dm_table_get_size(map))
 		goto out;
@@ -2911,13 +2932,13 @@ static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_fla
 	struct dm_table *map = NULL;
 	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
 
+	mutex_lock(&md->suspend_lock);
 	if (WARN_ON(dm_suspended_internally_md(md)))
-		return; /* disallow nested internal suspends! */
+		goto out; /* disallow nested internal suspends! */
 
-	mutex_lock(&md->suspend_lock);
 	if (dm_suspended_md(md)) {
 		set_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
-		return; /* nest suspend */
+		goto out; /* nest suspend */
 	}
 
 	map = rcu_dereference(md->map);
@@ -2928,6 +2949,8 @@ static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_fla
 	set_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
 
 	dm_table_postsuspend_targets(map);
+out:
+	mutex_unlock(&md->suspend_lock);
 }
 
 void dm_internal_suspend(struct mapped_device *md)
@@ -2946,13 +2969,12 @@ void dm_internal_resume(struct mapped_device *md)
 {
 	struct dm_table *map = NULL;
 
+	mutex_lock(&md->suspend_lock);
 	if (WARN_ON(!dm_suspended_internally_md(md)))
-		return;
+		goto done;
 
-	if (dm_suspended_md(md)) {
-		clear_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
-		goto done; /* resume from nested suspend */
-	}
+	if (dm_suspended_md(md))
+		goto done_clear_bit; /* resume from nested suspend */
 
 	map = rcu_dereference(md->map);
 	if (WARN_ON(!map))
@@ -2964,7 +2986,10 @@ void dm_internal_resume(struct mapped_device *md)
 	 */
 	(void) __dm_resume(md, map, false);
 
+done_clear_bit:
 	clear_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
+	smp_mb__after_atomic();
+	wake_up_bit(&md->flags, DMF_SUSPENDED_INTERNALLY);
 
 done:
 	mutex_unlock(&md->suspend_lock);
-- 
1.9.3
