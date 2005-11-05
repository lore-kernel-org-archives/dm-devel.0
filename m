From: cplk@itee.uq.edu.au
Subject: Re: [PATCH resubmit] do_mount: reduce stack consumption
Date: Sat, 5 Nov 2005 11:15:56 +1000 (EST)
Message-ID: <Pine.GSO.4.60.0511051108070.2449@mango.itee.uq.edu.au>
References: <20051104105026.GA12476@osiris.boeblingen.de.ibm.com>
 <20051104084829.714c5dbb.akpm@osdl.org> <20051104212742.GC9222@osiris.ibm.com>
 <20051104235500.GE5368@stusta.de> <20051104160851.3a7463ff.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751424AbVKEBUn@vger.kernel.org>
In-Reply-To: <20051104160851.3a7463ff.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Adrian Bunk <bunk@stusta.de>, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, aherrman@de.ibm.com, dm-devel@redhat.com
List-Id: dm-devel.ids

> > > This part of the call trace is actually good for >1500 bytes of stack
> > > usage and is what kills us and should be fixed.
> > > I'm surprised that there are no other bug reports regarding DM and
> > > stack overflow with 4k stacks.
> > >...
> > 
> > There were some reports of dm+xfs overflows with 4k stacks on i386.
> > 
> > The xfs side was sorted out, but I son't know the state of the dm part.
> > 
> 
> The state is Very Bad, IMO.  At the very least, DM should struggle to the
> utmost to reduce the stack utilisation around that recursion point.

Neil Brown suggested a change to generic_make_request to convert recursion 
through it into iteration (see http://lkml.org/lkml/2005/9/2/34 ), but 
there was no discussion at the time.  Would this help with this case?

Chris
