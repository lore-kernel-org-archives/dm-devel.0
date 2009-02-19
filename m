From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH] dm: Fix lock dependency warning for request
	based dm
Date: Thu, 19 Feb 2009 11:12:20 +0100
Message-ID: <20090219101220.GA5600@schmichrtp.de.ibm.com>
References: <20090218142154.GA1782@schmichrtp.de.ibm.com>
	<499CCBBF.4090602@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <499CCBBF.4090602@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

On Thu, Feb 19, 2009 at 12:02:23PM +0900, Kiyoshi Ueda wrote:
> Hi Christof,
> 
> On 2009/02/18 23:21 +0900, Christof Schmitt wrote:
> > > From: Christof Schmitt <christof.schmitt@de.ibm.com>
> > > 
> > > Testing with request based dm multipathing and lock dependency checking
> > > revealed this problem. Fix this by disabling interrupts when acquiring the
> > > map_lock from the ioctl call in __bind and __unbind.
> > > 
> > > It seems that the problem has been introduced with this patch:
> > > http://lkml.indiana.edu/hypermail/linux/kernel/0810.0/1067.html
> 
> Thank you for your testing request-based dm-multipath and the patch.
> 
> Attached is a patch to fix it.
> Since request-based dm gets map_lock after taking queue_lock with
> interrupt disabled, we have to use save/restore variant.
> (By the way, although lockdep warns the deadlock possibility, currently
>  there should be no such code path in request-based dm where request_fn
>  is called from the interrupt context.)

I was checking for other locking problems when this warning from
lockdep showed up. While i agree that it is only a problem in theory,
it deserves fixing to continue using lockdep.

> I have done simple build and boot testings, but haven't done other
> testings (e.g. stress testing) yet.
> I will include this patch to the next update after such testings.

Thanks for the updated patch. I will include this one in future tests.

--
Christof Schmitt
