From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: possible regression by the barrier patch in
	2.6.30-rc2
Date: Mon, 20 Apr 2009 02:20:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200217230.22707@hs20-bc2-1.build.redhat.com>
References: <49E80C1E.1040905@ct.jp.nec.com>
	<20090417132252.GA7843@agk.fab.redhat.com>
	<49EBF994.90801@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49EBF994.90801@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, 20 Apr 2009, Kiyoshi Ueda wrote:

> Hi Alasdair, Mikulas,
> 
> On 2009/04/17 22:22 +0900, Alasdair G Kergon wrote:
> > On Fri, Apr 17, 2009 at 01:57:02PM +0900, Kiyoshi Ueda wrote:
> >> 1. The semantics of flush suspend has been changed.
> > 
> > We absolutely must complete any I/O issued as a result of the lock_fs()
> > call in dm_suspend().
> 
> I think that lock_fs() waits for I/O to complete, so no semantics change
> in case of LOCKFS && FLUSH. (All I/O issued from lock_fs() are flushed.)

True. It waits, so there's no problem with it.

> But in case of NO_LOCKFS && FLUSH, the semantics is changed:
>   from: I/Os submitted before the suspend invocation are flushed
>   to:   I/Os submitted even before the suspend invocation may not be flushed
> 
> I have no idea whether someone gets real damage by this semantics change.

I have no idea whether it hurts too. I think it doesn't hurt because 
suspend may come only from ioctl and that ioctl syscall doesn't submit any 
requests prior to suspend.

It would be trivial to fix, but I don't know about any case where it could 
cause a bug.

Mikulas
