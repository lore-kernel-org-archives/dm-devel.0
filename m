From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH resubmit] do_mount: reduce stack consumption
Date: Fri, 4 Nov 2005 16:08:51 -0800
Message-ID: <20051104160851.3a7463ff.akpm@osdl.org>
References: <20051104105026.GA12476@osiris.boeblingen.de.ibm.com>
	<20051104084829.714c5dbb.akpm@osdl.org>
	<20051104212742.GC9222@osiris.ibm.com>
	<20051104235500.GE5368@stusta.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051104235500.GE5368@stusta.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adrian Bunk <bunk@stusta.de>
Cc: dm-devel@redhat.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, aherrman@de.ibm.com
List-Id: dm-devel.ids

Adrian Bunk <bunk@stusta.de> wrote:
>
> On Fri, Nov 04, 2005 at 10:27:42PM +0100, Heiko Carstens wrote:
> > > > See original stack back trace below and Andreas' patch and analysis
> > > > here:
> > > > http://www.ussg.iu.edu/hypermail/linux/kernel/0410.3/1844.html
> > 
> > I probably should add that with "original" stack back trace a trace of
> > a 2.6.10 kernel was meant, if that wasn't clear, but the DM code is
> > still the same in 2.6.14.
> > 
> > > >     <4>Call Trace:
> > ...
> > > >     <4> [<0000000010831380>] __map_bio+0x70/0x160 [dm_mod]
> > > >     <4> [<000000001083173e>] __split_bio+0x1e6/0x538 [dm_mod]
> > > >     <4> [<0000000010831ba8>] dm_request+0x118/0x25c [dm_mod]
> > > >     <4> [<0000000000241074>] generic_make_request+0xf0/0x21c
> > > >     <4> [<0000000010831380>] __map_bio+0x70/0x160 [dm_mod]
> > > >     <4> [<000000001083173e>] __split_bio+0x1e6/0x538 [dm_mod]
> > > >     <4> [<0000000010831ba8>] dm_request+0x118/0x25c [dm_mod]
> > > >     <4> [<0000000000241074>] generic_make_request+0xf0/0x21c
> > > >     <4> [<0000000010831380>] __map_bio+0x70/0x160 [dm_mod]
> > > >     <4> [<000000001083173e>] __split_bio+0x1e6/0x538 [dm_mod]
> > > >     <4> [<0000000010831ba8>] dm_request+0x118/0x25c [dm_mod]
> > > >     <4> [<0000000000241074>] generic_make_request+0xf0/0x21c
> > ...
> > 
> > This part of the call trace is actually good for >1500 bytes of stack
> > usage and is what kills us and should be fixed.
> > I'm surprised that there are no other bug reports regarding DM and
> > stack overflow with 4k stacks.
> >...
> 
> There were some reports of dm+xfs overflows with 4k stacks on i386.
> 
> The xfs side was sorted out, but I son't know the state of the dm part.
> 

The state is Very Bad, IMO.  At the very least, DM should struggle to the
utmost to reduce the stack utilisation around that recursion point.
