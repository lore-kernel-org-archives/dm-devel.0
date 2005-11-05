From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH resubmit] do_mount: reduce stack consumption
Date: Sat, 5 Nov 2005 16:37:01 +1100
Message-ID: <17260.17661.523593.420313@cse.unsw.edu.au>
References: <20051104105026.GA12476@osiris.boeblingen.de.ibm.com>
	<20051104084829.714c5dbb.akpm@osdl.org>
	<20051104212742.GC9222@osiris.ibm.com>
	<20051104235500.GE5368@stusta.de>
	<20051104160851.3a7463ff.akpm@osdl.org>
	<Pine.GSO.4.60.0511051108070.2449@mango.itee.uq.edu.au>
	<20051104173721.597bd223.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Andrew Morton on Friday November 4
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, aherrman@de.ibm.com, dm-devel@redhat.com, bunk@stusta.de, cplk@itee.uq.edu.au
List-Id: dm-devel.ids

On Friday November 4, akpm@osdl.org wrote:
> cplk@itee.uq.edu.au wrote:
> >
> > > > > This part of the call trace is actually good for >1500 bytes of stack
> > > > > usage and is what kills us and should be fixed.
> > > > > I'm surprised that there are no other bug reports regarding DM and
> > > > > stack overflow with 4k stacks.
> > > > >...
> > > > 
> > > > There were some reports of dm+xfs overflows with 4k stacks on i386.
> > > > 
> > > > The xfs side was sorted out, but I son't know the state of the dm part.
> > > > 
> > > 
> > > The state is Very Bad, IMO.  At the very least, DM should struggle to the
> > > utmost to reduce the stack utilisation around that recursion point.
> > 
> > Neil Brown suggested a change to generic_make_request to convert recursion 
> > through it into iteration (see http://lkml.org/lkml/2005/9/2/34 ), but 
> > there was no discussion at the time.  Would this help with this case?
> 
> It certainly would.  That looks like a good thing to do some more work on.

Ok, I'll dust it off, make sure it seems to work (at the time I first
wrote it, I think it caused 'md' to deadlock) and submit it.

NeilBrown
