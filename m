From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 18/20] dm: clean up GFP_NIO usage
Date: Thu, 28 Apr 2016 16:41:15 +0200
Message-ID: <20160428144115.GJ31489@dhcp22.suse.cz>
References: <1461849846-27209-1-git-send-email-mhocko@kernel.org>
 <1461849846-27209-19-git-send-email-mhocko@kernel.org>
 <alpine.LRH.2.02.1604281016520.14065@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1604281016520.14065@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu 28-04-16 10:20:09, Mikulas Patocka wrote:
> 
> 
> On Thu, 28 Apr 2016, Michal Hocko wrote:
> 
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > copy_params uses GFP_NOIO for explicit allocation requests because this
> > might be called from the suspend path. To quote Mikulas:
> > : The LVM tool calls suspend and resume ioctls on device mapper block
> > : devices.
> > :
> > : When a device is suspended, any bio sent to the device is held. If the
> > : resume ioctl did GFP_KERNEL allocation, the allocation could get stuck
> > : trying to write some dirty cached pages to the suspended device.
> > :
> > : The LVM tool and the dmeventd daemon use mlock to lock its address space,
> > : so the copy_from_user/copy_to_user call cannot trigger a page fault.
> > 
> > Relying on the mlock is quite fragile and we have a better way in kernel
> > to enfore NOIO which is already used for the vmalloc fallback. Just use
> > memalloc_noio_{save,restore} around the whole copy_params function which
> > will force the same also to the page fult paths via copy_{from,to}_user.
> 
> The userspace memory is locked, so we don't need to use memalloc_noio_save 
> around copy_from_user. If the memory weren't locked, memalloc_noio_save 
> wouldn't help us to prevent the IO.

OK, you are right. Got your point. You would have to read from disk to
fault memory in so this is not just about not performing IO during the
reclaim.

So scratch this patch then.

Thanks!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
