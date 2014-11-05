From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: staged dm_internal_{suspend,
 resume} related changes for wider review
Date: Wed, 5 Nov 2014 11:56:11 -0500
Message-ID: <20141105165611.GA19885@redhat.com>
References: <20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105161015.GD14285@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141105161015.GD14285@redhat.com>
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

On Wed, Nov 05 2014 at 11:10am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Nov 05 2014 at  9:37am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Wed, 5 Nov 2014, Mike Snitzer wrote:
> > 
> > > On Wed, Nov 05 2014 at  8:05am -0500,
> > > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > > 
> > > > On Wed, 5 Nov 2014, Mikulas Patocka wrote:
> > > > 
> > > > > You can for example set the flag in the prison meaning that the prison is 
> > > > > suspended and then call dm_internal_suspend immediatelly followed by 
> > > > > dm_internal_resume - that will clear in-progress bios and prevent new bios 
> > > > > from coming in (and we don't need to change dm_internal_suspend and 
> > > > > dm_internal_resume to become so big).
> > > 
> > > It may _seem_ like they have gotten big given the code was refactored to
> > > share code with dm_suspend and dm_resume.  BUT I know you see that the
> > > actual code complexity isn't big.  I especially wanted you (and/or Bryn)
> > > to evaluate the performance implications that my changes had on
> > > dm-stats.  I'm pretty confident there won't be much if any performance
> > > difference (given the code is identical to what you had, except some
> > > extra checks are made but ultimately not used, e.g. lockfs/unlockfs).
> > 
> > This is not about performance, it is about unclear behavior.
> > 
> > If someone does internal_suspend followed by remove, what should be the 
> > correct behavior? The current code deadlocks in this case.
> 
> You need to be specific, if internal suspend was used by the thin-pool
> suspend to suspend thin devices you'll need the thin-pool resumed before
> you can remove any thin device!
> 
> Like any interface there is a right way and a wrong way to use it.
> dm_internal_suspend must always be followed by dm_internal_resume.
> I cannot yet see a hole where properly written code is exposed here.

But thinking further about what you said, you're correctly concerned
about the potential for dm-stats to have used dm_internal_suspend and
then someone attempting to remove that device while it is internally
suspended.

We just need a patch like this:

 drivers/md/dm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ac0dcad..ffa6763 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -448,6 +448,17 @@ int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only
 {
 	int r = 0;
 
+retry:
+	mutex_lock(&md->suspend_lock);
+	if (dm_suspended_internally_md(md)) {
+		/* already internally suspended, wait for internal resume */
+		mutex_unlock(&md->suspend_lock);
+		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		if (r)
+			return r;
+		goto retry;
+	}
+
 	spin_lock(&_minor_lock);
 
 	if (dm_open_count(md)) {
@@ -461,6 +472,8 @@ int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only
 
 	spin_unlock(&_minor_lock);
 
+	mutex_unlock(&md->suspend_lock);
+
 	return r;
 }
 
