From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Re: [PATCH] scripts/checkpatch.pl: Change long line
	warning to 105 chars
Date: Fri, 18 Dec 2009 08:58:58 -0800
Message-ID: <20091218085858.029c5660.randy.dunlap@oracle.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	<20091217061229.GD3946@linux-sh.org>
	<m3tyvqgfs4.fsf@intrepid.localdomain>
	<Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	<24653.1261110557@localhost>
	<1261113144.13734.317.camel@Joe-Laptop.home>
	<m3iqc41h83.fsf@intrepid.localdomain>
	<20091218151241.GD9334@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091218151241.GD9334@agk-dp.fab.redhat.com>
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
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>, device-mapper development <dm-devel@redhat.com>, Paul Mundt <lethal@linux-sh.org>, Mikulas Patocka <mpatocka@redhat.com>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Fri, 18 Dec 2009 15:12:41 +0000 Alasdair G Kergon wrote:

> On Fri, Dec 18, 2009 at 03:37:00PM +0100, Krzysztof Halasa wrote:
> > Not sure if that's long enough (maybe it is).
> > 132 looks like the next "natural" number.
> 
> Well it's good that this thread has produced more examples where it's
> reasonable and acceptable to exceed 80 characters.
> 
> What do people feel about files where the policy is to place all the
> parameters passed into a function on the same line, regardless of its
> consequent length?  

Not good IMO.  It's much easier to read something that is restricted in
width than to have to scroll/pan side to side.
(e.g., newspaper columns.  Oops, what's a newspaper?)


> (What kicked this all off was a patch Mikulas submitted containing many
> long lines, one of which hits column 264.  Personally, I dislike reading
> code with lines that wrap, but using a 132-column terminal width is
> fine.)


---
~Randy
