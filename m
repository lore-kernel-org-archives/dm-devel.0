From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: [PATCH] scripts/checkpatch.pl: Change long line
	warning to 105 chars
Date: Fri, 18 Dec 2009 12:12:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912181210130.3223@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<m3iqc41h83.fsf@intrepid.localdomain>
	<20091218151241.GD9334@agk-dp.fab.redhat.com>
	<20091218085858.029c5660.randy.dunlap@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091218085858.029c5660.randy.dunlap@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>, device-mapper development <dm-devel@redhat.com>, Paul Mundt <lethal@linux-sh.org>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Fri, 18 Dec 2009, Randy Dunlap wrote:

> On Fri, 18 Dec 2009 15:12:41 +0000 Alasdair G Kergon wrote:
> 
> > On Fri, Dec 18, 2009 at 03:37:00PM +0100, Krzysztof Halasa wrote:
> > > Not sure if that's long enough (maybe it is).
> > > 132 looks like the next "natural" number.
> > 
> > Well it's good that this thread has produced more examples where it's
> > reasonable and acceptable to exceed 80 characters.
> > 
> > What do people feel about files where the policy is to place all the
> > parameters passed into a function on the same line, regardless of its
> > consequent length?  
> 
> Not good IMO.  It's much easier to read something that is restricted in
> width than to have to scroll/pan side to side.
> (e.g., newspaper columns.  Oops, what's a newspaper?)

I don't like scrolling too but most viewers and editors wrap it 
automatically to screen width. For example, restrict your terminal to 50 
columnts and try using "less".

Mikulas
