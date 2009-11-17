From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/7] dm: use __GFP_HIGH instead PF_MEMALLOC
Date: Tue, 17 Nov 2009 13:15:28 +0000
Message-ID: <20091117131527.GB6644@agk-dp.fab.redhat.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	<20091117161616.3DD7.A69D9226@jp.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091117161616.3DD7.A69D9226@jp.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Nov 17, 2009 at 04:17:07PM +0900, KOSAKI Motohiro wrote:
> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
> memory, anyone must not prevent it. Otherwise the system cause
> mysterious hang-up and/or OOM Killer invokation.
 
This code is also on the critical path, for example, if you are swapping
onto a dm device.  (There are ways we could reduce its use further as
not every dm ioctl needs to be on the critical path and the buffer size
could be limited for the ioctls that do.)

But what situations have been causing you trouble?  The OOM killer must
generally avoid killing userspace processes that suspend & resume dm
devices, and there are tight restrictions on what those processes
can do safely between suspending and resuming.

Alasdair
