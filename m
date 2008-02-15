From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Re: [PATCH] Implement barrier support for single
	device DM devices
Date: Fri, 15 Feb 2008 16:34:39 +0100
Message-ID: <20080215153439.GB30504@one.firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
	<20080215141229.GB1788@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080215141229.GB1788@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 15, 2008 at 02:12:29PM +0000, Alasdair G Kergon wrote:
> On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
> > On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> > > I wonder if it's worth the effort to try to implement this.
> 
> My personal view (which seems to be in the minority) is that it's a
> waste of our development time *except* in the (rare?) cases similar to

At least for my machines it is the standard case; it is not rare.

And don't RH distributions install with LVM by default these days?
For those it should be the standard case too on all systems with
only a single disk.

The other relatively simple case I plan to look into (in fact
I already wrote something, but it's not postable yet) is dm-crypt
on single device. But it's a little more complicated than the
simple dm-linear case.

-Andi 
