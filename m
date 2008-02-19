From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Implement barrier support for single device
	DM devices
Date: Tue, 19 Feb 2008 02:39:00 +0000
Message-ID: <20080219023900.GB4066@agk.fab.redhat.com>
References: <20080215120821.GA8267@basil.nowhere.org>
	<20080215122002.GM29914@agk.fab.redhat.com>
	<47B58EAA.8040405@msgid.tls.msk.ru>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <47B58EAA.8040405@msgid.tls.msk.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> Alasdair G Kergon wrote:
> > On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> >> Implement barrier support for single device DM devices
> > Thanks.  We've got some (more-invasive) dm patches in the works that
> > attempt to use flushing to emulate barriers where we can't just
> > pass them down like that.
> I wonder if it's worth the effort to try to implement this.

The decision got taken to allocate barrier bios to implement the basic
flush so dm has little choice in this matter now.  (If you're going to
implement barriers for flush, you might as well implement them more
generally.)

Maybe I should spell this out more clearly for those who weren't
tracking this block layer change:  AFAIK You cannot currently flush a
device-mapper block device without doing some jiggery-pokery.

> For example, how safe
> xfs is if barriers are not supported or turned off?  

The last time we tried xfs with dm it didn't seem to notice -EOPNOTSUPP
everywhere it should => recovery may find corruption.

Alasdair
-- 
agk@redhat.com
