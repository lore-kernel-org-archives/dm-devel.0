From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/md/kcopyd.c: #if 0 kcopyd_cancel()
Date: Tue, 8 Nov 2005 17:53:24 +0100
Message-ID: <20051108165324.GY3847@stusta.de>
References: <20051108134419.GR3847@stusta.de>
	<20051108154828.GX26394@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051108154828.GX26394@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 08, 2005 at 03:48:28PM +0000, Alasdair G Kergon wrote:
> On Tue, Nov 08, 2005 at 02:44:19PM +0100, Adrian Bunk wrote:
> > A function that is
> > - not used
> > - empty
> > - without a prototype in any header file
> > should be removed.
>  
> I'd rather you submitted a patch to complete the function and invoke it
> in the appropriate place:-)  But please don't remove comments indicating 
> missing functionality: commenting it out till it's written would be better.

Updated patch below.

> Alasdair

cu
Adrian


<--  snip  -->


This patch #if 0's the not yet implemented global function 
kcopyd_cancel().


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/md/kcopyd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.14-mm1-full/drivers/md/kcopyd.c.old	2005-11-08 17:41:31.000000000 +0100
+++ linux-2.6.14-mm1-full/drivers/md/kcopyd.c	2005-11-08 17:41:59.000000000 +0100
@@ -562,11 +562,13 @@
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
  */
+#if 0
 int kcopyd_cancel(struct kcopyd_job *job, int block)
 {
 	/* FIXME: finish */
 	return -1;
 }
+#endif  /*  0  */
 
 /*-----------------------------------------------------------------
  * Unit setup
@@ -685,4 +687,3 @@
 EXPORT_SYMBOL(kcopyd_client_create);
 EXPORT_SYMBOL(kcopyd_client_destroy);
 EXPORT_SYMBOL(kcopyd_copy);
-EXPORT_SYMBOL(kcopyd_cancel);
