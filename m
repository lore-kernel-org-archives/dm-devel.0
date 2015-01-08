From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: handle multiple internal suspends correctly
 (was: staged dm_internal_{suspend, resume} related changes for wider review)
Date: Thu, 8 Jan 2015 18:52:26 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1501081848440.7624@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
	<alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
	<20141107183321.GA31022@redhat.com>
	<alpine.LRH.2.02.1501021741470.23294@file01.intranet.prod.int.rdu2.redhat.com>
	<20150105155043.GA2260@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150105155043.GA2260@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Mon, 5 Jan 2015, Mike Snitzer wrote:

> On Fri, Jan 02 2015 at  5:56pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi, I'm back.
> > 
> > I looked at current internal suspend code in 3.19.
> > 
> > One thing that seems strange is this:
> > 
> > static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_flags)
> > {
> >         struct dm_table *map = NULL;
> > 
> >         if (dm_suspended_internally_md(md))
> >                 return; /* nested internal suspend */
> > ....
> > static void __dm_internal_resume(struct mapped_device *md)
> > {
> >         if (!dm_suspended_internally_md(md))
> >                 return; /* resume from nested internal suspend */
> > 
> > - the comments imply that the code supports nested internal suspend, while 
> > in fact it doesn't. If the caller calls:
> > * dm_internal_suspend_noflush
> > * dm_internal_suspend_noflush
> > * dm_internal_resume
> > the device is not suspended while it should be.
> 
> Yes, very true, it should.  But IIRC in practice it doesn't hurt us to
> not be bothered about being so precise given the current caller.

If the device is not suspended while it should be, it could lead to 
various subtle bugs. We should either disallow multiple internal suspends 
(print warning when that happens) or handle it correctly. Here I'm sending 
a patch to fix it.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

The current code attempts to handle multiple internal suspends on the same
device, but it does that incorrectly. When these functions are called in
this order on the same device
	dm_internal_suspend_noflush
	dm_internal_suspend_noflush
	dm_internal_resume
the device is not suspended, while it should be. This patch fixes the bug
by maintaining a counter of suspends, and resuming the device when the
counter drops to zero.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-3.19-rc3/drivers/md/dm.c
===================================================================
--- linux-3.19-rc3.orig/drivers/md/dm.c	2015-01-08 22:04:23.000000000 +0100
+++ linux-3.19-rc3/drivers/md/dm.c	2015-01-08 22:22:14.000000000 +0100
@@ -206,6 +206,9 @@ struct mapped_device {
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
 
+	/* the number of internal suspends */
+	unsigned internal_suspend_count;
+
 	struct dm_stats stats;
 };
 
@@ -3023,7 +3026,7 @@ static void __dm_internal_suspend(struct
 {
 	struct dm_table *map = NULL;
 
-	if (dm_suspended_internally_md(md))
+	if (md->internal_suspend_count++)
 		return; /* nested internal suspend */
 
 	if (dm_suspended_md(md)) {
@@ -3048,7 +3051,9 @@ static void __dm_internal_suspend(struct
 
 static void __dm_internal_resume(struct mapped_device *md)
 {
-	if (!dm_suspended_internally_md(md))
+	BUG_ON(!md->internal_suspend_count);
+
+	if (--md->internal_suspend_count)
 		return; /* resume from nested internal suspend */
 
 	if (dm_suspended_md(md))
