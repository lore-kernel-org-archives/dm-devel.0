From: Ed Wilts <ewilts@ewilts.org>
Subject: Re: Req: Details on Multipath-i/o FX-HBA
Date: Mon, 21 Nov 2005 13:12:32 -0600
Message-ID: <20051121191232.GA21618@www.ewilts.org>
References: <20051115060411.13318.qmail@web8609.mail.in.yahoo.com>
	<200511191234.28207.bernd@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200511191234.28207.bernd@bzed.de>
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
List-Id: dm-devel.ids

On Sat, Nov 19, 2005 at 12:34:27PM +0100, Bernd Zeimetz wrote:
> > 1. Linux 2.6 supporting multpath  i/o  but why different companies
> > release their own products like (powepath- from EMC.).
> 
> afaik EMC doesn't develope powerpath for 2.6. The companies usually support 
> their own stuff, something that you usually won't get from them for 
> multipath. But afaik you'll get the support from Redhat and Novell/Suse for 
> their Enterprise server edition.
> 
> > 2. What is main difference between these two?
> 
> multipath is open source (which means it is free), the others not - you'll 
> have to pay money for them usually.

Historically, Red Hat (and others) have not had a solution for
active/passive controllers.  Arrays like the EMC Clariion and HP EVA
fall into this category.  The mddriver only supported active/active
controllers like the EMC Symmetrix.

Companies like EMC and HP have not had a choice but to develop their own
products.  Even looking at products like Veritas DMP, active/passive
wasn't an option there either.  It wasn't until 4.1 that DMP supported
active/passive arrays (and we'll be testing this soon).  Windows had no
options whatsoever.

One dm-multipath stabilizes, I expect that 3rd party vendors like HP and
EMC will very happily throw away their multipathing solution - it's not
one of their core competencies and frankly makes them uncompetitive (a
pair of HBAs and SecurePath can cost more than the server itself).

I've got experience with both PowerPath (EMC) and SecurePath (HP) and
both suck (in different ways at different times in their product
cycles).  Everybody will be much happier when products like these go
away.

-- 
Ed Wilts, RHCE
Mounds View, MN, USA
mailto:ewilts@ewilts.org
Member #1, Red Hat Community Ambassador Program
