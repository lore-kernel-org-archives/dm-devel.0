From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 17/19] dm: get rid of superfluous gfp flags
Date: Wed, 27 Apr 2016 10:35:30 +0200
Message-ID: <20160427083530.GD2179@dhcp22.suse.cz>
References: <1460372892-8157-1-git-send-email-mhocko@kernel.org>
 <1460372892-8157-18-git-send-email-mhocko@kernel.org>
 <alpine.LRH.2.02.1604150826280.16981@file01.intranet.prod.int.rdu2.redhat.com>
 <20160415130839.GJ32377@dhcp22.suse.cz>
 <alpine.LRH.2.02.1604151437500.3288@file01.intranet.prod.int.rdu2.redhat.com>
 <20160416203135.GC15128@dhcp22.suse.cz>
 <20160422124730.GA11733@dhcp22.suse.cz>
 <alpine.LRH.2.02.1604261307520.12205@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1604261307520.12205@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

[Adding dm-devel@redhat.com to CC]

On Tue 26-04-16 13:20:04, Mikulas Patocka wrote:
> On Fri, 22 Apr 2016, Michal Hocko wrote:
[...]
> > copy_params seems to be called only from the ioctl context which doesn't
> > hold any locks which would lockup during the direct reclaim AFAICS. The
> > git log shows that the code has used PF_MEMALLOC before which is even
> > bigger mystery to me. Could you please clarify why this is GFP_NOIO
> > restricted context? Maybe it needed to be in the past but I do not see
> > any reason for it to be now so unless I am missing something the
> > GFP_KERNEL should be perfectly OK. Also note that GFP_NOIO wouldn't work
> > properly because there are copy_from_user calls in the same path which
> > could page fault and do GFP_KERNEL allocations anyway. I can send follow
> > up cleanups unless I am missing something subtle here.
> 
> The LVM tool calls suspend and resume ioctls on device mapper block 
> devices.
>
> When a device is suspended, any bio sent to the device is held. If the 
> resume ioctl did GFP_KERNEL allocation, the allocation could get stuck 
> trying to write some dirty cached pages to the suspended device.
> 
> The LVM tool and the dmeventd daemon use mlock to lock its address space, 
> so the copy_from_user/copy_to_user call cannot trigger a page fault.

OK, I see, thanks for the clarification! This sounds fragile to me
though. Wouldn't it be better to use the memalloc_noio_save for the
whole copy_params instead? That would force all possible allocations to
not trigger any IO. Something like the following.
---
From dbb2338bb88d2da1ff24cee59cbffd120b119e3b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Wed, 27 Apr 2016 10:26:13 +0200
Subject: [PATCH] dm: clean up GFP_NIO usage

copy_params uses GFP_NOIO for explicit allocation requests because this
might be called from the suspend path. To quote Mikulas:
: The LVM tool calls suspend and resume ioctls on device mapper block
: devices.
:
: When a device is suspended, any bio sent to the device is held. If the
: resume ioctl did GFP_KERNEL allocation, the allocation could get stuck
: trying to write some dirty cached pages to the suspended device.
:
: The LVM tool and the dmeventd daemon use mlock to lock its address space,
: so the copy_from_user/copy_to_user call cannot trigger a page fault.

Relying on the mlock is quite fragile and we have a better way in kernel
to enfore NOIO which is already used for the vmalloc fallback. Just use
memalloc_noio_{save,restore} around the whole copy_params function which
will force the same also to the page fult paths via copy_{from,to}_user.

While we are there we can also remove __GFP_NOMEMALLOC because copy_params
is never called from MEMALLOC context (e.g. during the reclaim).

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 drivers/md/dm-ioctl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2c7ca258c4e4..fe0b57d7573c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1715,16 +1715,13 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 	 */
 	dmi = NULL;
 	if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
-		dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		dmi = kmalloc(param_kernel->data_size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
 		if (dmi)
 			*param_flags |= DM_PARAMS_KMALLOC;
 	}
 
 	if (!dmi) {
-		unsigned noio_flag;
-		noio_flag = memalloc_noio_save();
-		dmi = __vmalloc(param_kernel->data_size, GFP_NOIO | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
-		memalloc_noio_restore(noio_flag);
+		dmi = __vmalloc(param_kernel->data_size, GFP_KERNEL | __GFP_HIGH | __GFP_HIGHMEM, PAGE_KERNEL);
 		if (dmi)
 			*param_flags |= DM_PARAMS_VMALLOC;
 	}
@@ -1801,6 +1798,7 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
 	struct dm_ioctl param_kernel;
+	unsigned noio_flag;
 
 	/* only root can play with this */
 	if (!capable(CAP_SYS_ADMIN))
@@ -1832,9 +1830,12 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	}
 
 	/*
-	 * Copy the parameters into kernel space.
+	 * Copy the parameters into kernel space. Make sure that no IO is triggered
+	 * from the allocation paths because this might be called during the suspend.
 	 */
+	noio_flag = memalloc_noio_save();
 	r = copy_params(user, &param_kernel, ioctl_flags, &param, &param_flags);
+	memalloc_noio_restore(noio_flag);
 
 	if (r)
 		return r;
-- 
2.8.0.rc3

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
