From: malahal@us.ibm.com
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Mon, 9 Nov 2009 09:57:30 -0800
Message-ID: <20091109175730.GA12556@us.ibm.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
	<20091109085142.GA4432@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091109085142.GA4432@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mike Anderson [andmike@linux.vnet.ibm.com] wrote:
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Hi
> > 
> > This is the patch that uses two locks to avoid the deadlock.
> 
> Thanks for doing the patch. 
> 
> I had previously started trying to address this issue using rcu and moving
> dm_copy_name_and_uuid back to being called during dm_build_path_uevent, but
> that patch still had a couple of cases to be addressed.
> 
> In testing your patch without moving where dm_copy_name_and_uuid is called
> I run into a issue during test runs where I receive a BUG_ON for the
> dm_put in dm_copy_name_and_uuid as DMF_FREEING was able to progress (Note:
> this failure case occurs without your path). If the proper dm_get / dm_put
> is added to the dm_uevent functions then there are cases where
> dm_uevent_free becomes the last dm_put resulting in recursion.

Why do we need dm_get() and dm_put() in dm_copy_name_and_uuid()?
dm_copy_name_and_uuid() already has access to md and there shouldn't be
any need to hold a reference. The caller of dm_copy_name_and_uuid()
should have placed a hold. This is just some unnecessary code and should
not cause a BUG_ON though.

Can you send the BUG_ON stack?

dm_get_from_kobject() seems to be a culprit though. It checks
DMF_FREEING without a lock and then calls dm_get. Here is an untested
patch. Made on top of _name_read_lock patch.


Signed-off-by: malahal@us.ibm.com

diff -r ce6e81a22554 -r 1106e5e3dabc drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c	Thu Nov 05 21:35:30 2009 -0800
+++ b/drivers/md/dm-ioctl.c	Mon Nov 09 09:32:03 2009 -0800
@@ -1595,7 +1595,6 @@
 	if (!md)
 		return -ENXIO;
 
-	dm_get(md);
 	mutex_lock(&_name_read_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
@@ -1610,7 +1609,6 @@
 
 out:
 	mutex_unlock(&_name_read_lock);
-	dm_put(md);
 
 	return r;
 }
diff -r ce6e81a22554 -r 1106e5e3dabc drivers/md/dm.c
--- a/drivers/md/dm.c	Thu Nov 05 21:35:30 2009 -0800
+++ b/drivers/md/dm.c	Mon Nov 09 09:32:03 2009 -0800
@@ -2584,11 +2584,18 @@
 	if (&md->kobj != kobj)
 		return NULL;
 
+	spin_lock(&_minor_lock);
 	if (test_bit(DMF_FREEING, &md->flags) ||
-	    test_bit(DMF_DELETING, &md->flags))
-		return NULL;
+	    test_bit(DMF_DELETING, &md->flags)) {
+		md = NULL;
+		goto out;
+	}
 
 	dm_get(md);
+
+out:
+	spin_unlock(&_minor_lock);
+
 	return md;
 }
 
