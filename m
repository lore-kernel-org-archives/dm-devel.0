From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Implement barrier support for single
	device DM devices
Date: Fri, 15 Feb 2008 14:12:29 +0000
Message-ID: <20080215141229.GB1788@agk.fab.redhat.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
	<20080215142010.GA29552@one.firstfloor.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080215142010.GA29552@one.firstfloor.org>
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

On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
> On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> > I wonder if it's worth the effort to try to implement this.

My personal view (which seems to be in the minority) is that it's a
waste of our development time *except* in the (rare?) cases similar to
the ones Andi is talking about.

But the decision has already been made for us in the block layer: 
dm is now pretty much required to support (zero-length) barriers.
Unfortunately we didn't get this finished in time for 2.6.25, but we
intend to get it done for 2.6.26:  Woe betide any callers today that
don't handle EOPNOTSUPP!

Alasdair
-- 
agk@redhat.com
