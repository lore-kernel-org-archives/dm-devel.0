From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm ioctl: Restore __GFP_HIGH in copy_params()
Date: Sat, 20 May 2017 15:00:53 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1705201458500.1841@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170518185040.108293-1-junaids@google.com>
	<alpine.LRH.2.02.1705191949340.17646@file01.intranet.prod.int.rdu2.redhat.com>
	<20170520083412.GD11925@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170520083412.GD11925@dhcp22.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michal Hocko <mhocko@kernel.org>, Mike Snitzer <msnitzer@redhat.com>
Cc: Junaid Shahid <junaids@google.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, andreslc@google.com, rientjes@google.com, gthelen@google.com, akpm@linux-foundation.org, vbabka@suse.cz
List-Id: dm-devel.ids



On Sat, 20 May 2017, Michal Hocko wrote:

> On Fri 19-05-17 19:50:24, Mikulas Patocka wrote:
> > 
> > 
> > On Thu, 18 May 2017, Junaid Shahid wrote:
> > 
> > > d224e9381897 (drivers/md/dm-ioctl.c: use kvmalloc rather than opencoded
> > > variant) left out the __GFP_HIGH flag when converting from __vmalloc to
> > > kvmalloc. This can cause the IOCTL to fail in some low memory situations
> > > where it wouldn't have failed earlier. This patch adds it back to avoid
> > > any potential regression.
> > > 
> > > Signed-off-by: Junaid Shahid <junaids@google.com>
> > 
> > Acked-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Can we have a comment explaning why we need memory reserves in this case
> please?

Here I'm sending the patch with the comment:


d224e9381897 (drivers/md/dm-ioctl.c: use kvmalloc rather than opencoded
variant) left out the __GFP_HIGH flag when converting from __vmalloc to
kvmalloc. This can cause the IOCTL to fail in some low memory situations
where it wouldn't have failed earlier. This patch adds it back to avoid
any potential regression.

Signed-off-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-ioctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1710,12 +1710,13 @@ static int copy_params(struct dm_ioctl _
 	}
 
 	/*
-	 * Try to avoid low memory issues when a device is suspended.
+	 * Use __GFP_HIGH to avoid low memory issues when a device is suspended
+	 * and the ioctl is needed to resume it.
 	 * Use kmalloc() rather than vmalloc() when we can.
 	 */
 	dmi = NULL;
 	noio_flag = memalloc_noio_save();
-	dmi = kvmalloc(param_kernel->data_size, GFP_KERNEL);
+	dmi = kvmalloc(param_kernel->data_size, GFP_KERNEL | __GFP_HIGH);
 	memalloc_noio_restore(noio_flag);
 
 	if (!dmi) {
