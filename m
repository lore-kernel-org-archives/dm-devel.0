From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: Re: [PATCH] Implement barrier support for single
	device DM devices
Date: Mon, 18 Feb 2008 23:19:48 -0800
Message-ID: <20080219071948.GA244758@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
	<47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru>
	<20080218221644.GN155407@sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080218221644.GN155407@sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 19, 2008 at 09:16:44AM +1100, David Chinner wrote:
> On Mon, Feb 18, 2008 at 04:24:27PM +0300, Michael Tokarev wrote:
> > First, I still don't understand why in God's sake barriers are "working"
> > while regular cache flushes are not.  Almost no consumer-grade hard drive
> > supports write barriers, but they all support regular cache flushes, and
> > the latter should be enough (while not the most speed-optimal) to ensure
> > data safety.  Why to require write cache disable (like in XFS FAQ) instead
> > of going the flush-cache-when-appropriate (as opposed to write-barrier-
> > when-appropriate) way?
> 
> Devil's advocate:
> 
> Why should we need to support multiple different block layer APIs
> to do the same thing? Surely any hardware that doesn't support barrier
> operations can emulate them with cache flushes when they receive a
> barrier I/O from the filesystem....
> 
> Also, given that disabling the write cache still allows CTQ/NCQ to
> operate effectively and that in most cases WCD+CTQ is as fast as
> WCE+barriers, the simplest thing to do is turn off volatile write
> caches and not require any extra software kludges for safe
> operation.


I'll put it even more strongly.  My experience is that disabling write
cache plus disabling barriers is often much faster than enabling both
barriers and write cache enabled, when doing metadata intensive
operations, as long as you have a drive that is good at CTQ/NCQ.

The only time write cache + barriers is significantly faster is when
doing single threaded data writes, such as direct I/O, or if CTQ/NCQ
is not enabled, or the drive does a poor job at it.

jeremy
