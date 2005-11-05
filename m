From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH resubmit] do_mount: reduce stack consumption
Date: Fri, 4 Nov 2005 17:37:21 -0800
Message-ID: <20051104173721.597bd223.akpm@osdl.org>
References: <20051104105026.GA12476@osiris.boeblingen.de.ibm.com>
	<20051104084829.714c5dbb.akpm@osdl.org>
	<20051104212742.GC9222@osiris.ibm.com>
	<20051104235500.GE5368@stusta.de>
	<20051104160851.3a7463ff.akpm@osdl.org>
	<Pine.GSO.4.60.0511051108070.2449@mango.itee.uq.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.GSO.4.60.0511051108070.2449@mango.itee.uq.edu.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: cplk@itee.uq.edu.au, Neil Brown <neilb@cse.unsw.edu.au>
Cc: dm-devel@redhat.com, aherrman@de.ibm.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, bunk@stusta.de
List-Id: dm-devel.ids

cplk@itee.uq.edu.au wrote:
>
> > > > This part of the call trace is actually good for >1500 bytes of stack
> > > > usage and is what kills us and should be fixed.
> > > > I'm surprised that there are no other bug reports regarding DM and
> > > > stack overflow with 4k stacks.
> > > >...
> > > 
> > > There were some reports of dm+xfs overflows with 4k stacks on i386.
> > > 
> > > The xfs side was sorted out, but I son't know the state of the dm part.
> > > 
> > 
> > The state is Very Bad, IMO.  At the very least, DM should struggle to the
> > utmost to reduce the stack utilisation around that recursion point.
> 
> Neil Brown suggested a change to generic_make_request to convert recursion 
> through it into iteration (see http://lkml.org/lkml/2005/9/2/34 ), but 
> there was no discussion at the time.  Would this help with this case?

It certainly would.  That looks like a good thing to do some more work on.
