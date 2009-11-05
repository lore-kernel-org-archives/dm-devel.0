From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: possible regression by the barrier patch in
	2.6.30-rc2
Date: Wed, 4 Nov 2009 21:02:01 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911042057050.27821@hs20-bc2-1.build.redhat.com>
References: <49E80C1E.1040905@ct.jp.nec.com>
	<20090417132252.GA7843@agk.fab.redhat.com>
	<49EBF994.90801@ct.jp.nec.com>
	<Pine.LNX.4.64.0904200217230.22707@hs20-bc2-1.build.redhat.com>
	<20091028152139.GP25303@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911042042350.22545@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911042042350.22545@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 4 Nov 2009, Mikulas Patocka wrote:

> On Wed, 28 Oct 2009, Alasdair G Kergon wrote:
> 
> > Well let's go back to first principles.
> > 
> > There are two types of suspend.
> > 
> > (1) I don't care about the ordering of the I/O on the disk relative to
> > the suspend.  This one is easy: it's --noflush --nolockfs.
> > 
> > (2) I do want some control over the state of the device at the point
> > of the suspend.
> > 
> > Break this second case down.
> > If I have a filesystem, I require it to be consistent, so I require lockfs.
> > 
> > If the device belongs to a userspace database, I require it to be consistent,
> > so I must pause the database, at which point there is no further I/O being
> > issued to the device, then I suspend (and everything prior to this must be
> > flushed) and resume etc.  This can be either a "suspend with flush" OR the
> > flush could have been issued prior to the suspend (and any decent database
> > would have done that).
> 
> In this database case, you have to pause the database, the pause procedure 
> will wait until all I/O finishes and won't submit new I/O. When the pause 
> procedure finishes, the database has no I/O in flight, so it doesn't 
> matter if you use flush or noflush suspend.
> 
> The reason is that there may be another I/O midlayers between the database 
> and the device mapper. So, if the database submits I/O, it doesn't have to 
> immediatelly arrive to the device mapper. If you paused the database 
> (without waiting for complete I/Os) and then issued "flush" suspend, the 
> I/O may still be pending somewhere above the suspended device, then the 
> device finishes flush suspend, then the I/O arrives and waits until 
> unsuspend.
> 
> I'm somehow starting to think that "flush" suspend is not needed at all 
> and all suspends may be "noflush". Do you have any counterexamples?
> 
> Mikulas

Anyway, suspend unconditionally purges all I/Os from target drivers. All 
that this "noflush" flag does is that it allows the I/O to be held and 
requeued for new dm table incarnation, if the target requests it with 
DM_MAPIO_REQUEUE (dm-raid1 and dm-multipath do it). If no target returns 
DM_MAPIO_REQUEUE, then "flush" and "noflush" suspend is equivalent.

Question: could "noflush" be the default behavior and could the "flush" 
flag be dropped? I think yes.

Mikulas
