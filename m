From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/7] dm: use __GFP_HIGH instead PF_MEMALLOC
Date: Wed, 18 Nov 2009 15:17:54 +0900 (JST)
Message-ID: <20091118145621.3E1A.A69D9226__36152.6700122797$1259241155$gmane$org@jp.fujitsu.com>
References: <20091117161616.3DD7.A69D9226@jp.fujitsu.com>
	<20091117131527.GB6644@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091117131527.GB6644@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com
Cc: kosaki.motohiro@jp.fujitsu.com
List-Id: dm-devel.ids

Hi,

Thank you for give me comment.

> On Tue, Nov 17, 2009 at 04:17:07PM +0900, KOSAKI Motohiro wrote:
> > Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> > memory, anyone must not prevent it. Otherwise the system cause
> > mysterious hang-up and/or OOM Killer invokation.
>  
> This code is also on the critical path, for example, if you are swapping
> onto a dm device.  (There are ways we could reduce its use further as
> not every dm ioctl needs to be on the critical path and the buffer size
> could be limited for the ioctls that do.)

May I ask one additional question?
Original code is here.

	-------------------------------------------------------
        /*
         * Trying to avoid low memory issues when a device is
         * suspended.
         */
        current->flags |= PF_MEMALLOC;

        /*
         * Copy the parameters into kernel space.
         */
        r = copy_params(user, &param);

        current->flags &= ~PF_MEMALLOC;
	-------------------------------------------------------

but PF_MEMALLOC doesn't gurantee allocation successfull. In your case,
mempoll seems better to me. copy_params seems enough small function 
and we can rewrite it. Why didn't you use mempool?

Am I missing something?


> But what situations have been causing you trouble?  The OOM killer must
> generally avoid killing userspace processes that suspend & resume dm
> devices, and there are tight restrictions on what those processes
> can do safely between suspending and resuming.

No. This is theorical issue. but I really want to avoid stress weakness
kernel.
